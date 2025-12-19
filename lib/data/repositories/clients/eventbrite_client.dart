import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:redux/redux.dart';
import 'dart:async';
import 'package:built_collection/built_collection.dart';

class EventBriteClient {
  static const String baseUrl = 'https://www.eventbriteapi.com/v3';
  static const int pageLimit = 20;

  final String apiKey;
  final String organizationId;
  final String companyName;
  final Store<AppState> store;
  Function(String) updateStatus;

  EventBriteClient({
    required this.apiKey,
    required this.organizationId,
    required this.companyName,
    required this.store,
    required this.updateStatus,
  });

  String getEventsUrl(String? nextPageUrl) {
    if (nextPageUrl != null) {
      return nextPageUrl;
    }
    return '/organizations/$organizationId/events/?status=live,started,ended&expand=venue,ticket_classes,organizer&page_size=$pageLimit';
  }

  String getEventOrdersUrl(String eventId, String? nextPageUrl) {
    if (nextPageUrl != null) {
      return nextPageUrl;
    }
    return '/events/$eventId/orders/?expand=attendees&page_size=$pageLimit';
  }

  Future<void> fetchEvents() async {
    try {
      updateStatus('Starting to fetch events from EventBrite...');

      if (apiKey.trim().isEmpty) {
        const errorMessage = 'ERROR: EventBrite API key is empty';
        updateStatus(errorMessage);
        logError(errorMessage);
        return;
      }

      await testAPIConnection();
      final events = await fetchAllEventDetails();
      
      if (events.isEmpty) {
        updateStatus('No events found in EventBrite');
        return;
      }

      updateStatus('Fetching orders for each EventBrite event...');
      List<EventEntity> eventsWithOrders = [];
      int processedCount = 0;

      for (var event in events) {
        processedCount++;
        updateStatus('Processing event ${processedCount}/${events.length}: ${event.name}');

        final orders = await fetchOrdersForEvent(event.id, event.name);
        final eventWithOrders = event.rebuild((b) => b
          ..orders.replace(orders)
          ..totalOrders = orders.length);
        eventsWithOrders.add(eventWithOrders);
      }

      updateStatus('Saving EventBrite events to Firebase...');
      await saveEventsToFirebase(eventsWithOrders);

      updateStatus('Assigning companies to ticket buyers...');
      await assignCompaniesToUsers(eventsWithOrders);

      updateStatus('Successfully fetched and saved ${eventsWithOrders.length} EventBrite events with all their orders and assigned companies to users');
    } catch (e) {
      logError('Error fetching EventBrite events: $e');
      updateStatus('Error fetching EventBrite events: $e');
      throw e;
    }
  }

  Future<void> testAPIConnection() async {
    updateStatus('Testing EventBrite API connection...');
    
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/me/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final userInfo = jsonDecode(response.body);
        updateStatus('API Connection successful. User: ${userInfo['name'] ?? 'Unknown'}');
      } else if (response.statusCode == 401) {
        const errorMessage = 'ERROR: Invalid EventBrite API key';
        updateStatus(errorMessage);
        throw HttpException(errorMessage, uri: Uri.parse('$baseUrl/users/me/'));
      } else {
        final errorMessage = 'API Connection failed: ${response.statusCode}';
        updateStatus(errorMessage);
        throw HttpException('EventBrite API connection test failed: ${response.statusCode}', uri: Uri.parse('$baseUrl/users/me/'));
      }
    } catch (e) {
      updateStatus('API Connection error: $e');
      throw e;
    }
  }

  Future<List<OrderEntity>> fetchOrdersForEvent(String eventId, String eventName) async {
    List<OrderEntity> allOrders = [];
    String? nextPageUrl;
    bool hasMore = true;

    while (hasMore) {
      final url = getEventOrdersUrl(eventId, nextPageUrl);
      final response = await fetchEventOrdersPage(url);
      allOrders.addAll(response.items);
      nextPageUrl = response.nextPageUrl;
      hasMore = nextPageUrl != null;
    }

    return allOrders;
  }

  Future<List<EventEntity>> fetchAllEventDetails() async {
    List<EventEntity> allEvents = [];
    String? nextPageUrl;
    bool hasMore = true;

    while (hasMore) {
      final url = getEventsUrl(nextPageUrl);
      final response = await fetchEventDetailsPage(url);
      allEvents.addAll(response.items);
      nextPageUrl = response.nextPageUrl;
      hasMore = nextPageUrl != null;
    }

    return allEvents;
  }

  Future<PaginatedResponse<EventEntity>> fetchEventDetailsPage(String url) async {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl$url'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final events = (json['events'] as List)
          .map((eventJson) => _convertEventBriteJsonToEventEntity(eventJson))
          .toList();

      events.forEach((event) {
        updateStatus('Fetched EventBrite event: ${event.name}');
      });

      final pagination = json['pagination'];
      String? nextPageUrl;
      if (pagination['has_more_items'] == true && pagination['continuation'] != null) {
        // EventBrite uses continuation tokens for pagination
        nextPageUrl = '/organizations/$organizationId/events/?status=live,started,ended&expand=venue,ticket_classes,organizer&page_size=$pageLimit&continuation=${pagination['continuation']}';
      }

      return PaginatedResponse<EventEntity>(
        items: events,
        nextPageUrl: nextPageUrl,
      );
    } else {
      updateStatus('HTTP error when fetching EventBrite events: ${response.statusCode}');
      throw HttpException(
        'Failed to fetch EventBrite events: ${response.statusCode} - ${response.body}',
        uri: Uri.parse('$baseUrl$url'),
      );
    }
  }

  Future<PaginatedResponse<OrderEntity>> fetchEventOrdersPage(String url) async {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$baseUrl$url'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final orders = (json['orders'] as List)
          .expand((orderJson) => _convertEventBriteOrderJson(orderJson))
          .toList();

      final pagination = json['pagination'];
      String? nextPageUrl;
      if (pagination['has_more_items'] == true && pagination['continuation'] != null) {
        final eventIdMatch = RegExp(r'/events/(\d+)/').firstMatch(url);
        final eventId = eventIdMatch?.group(1);
        if (eventId != null) {
          nextPageUrl = '/events/$eventId/orders/?expand=attendees&page_size=$pageLimit&continuation=${pagination['continuation']}';
        }
      }

      return PaginatedResponse<OrderEntity>(
        items: orders,
        nextPageUrl: nextPageUrl,
      );
    } else {
      updateStatus('HTTP error when fetching EventBrite orders: ${response.statusCode}');
      throw HttpException(
        'Failed to fetch EventBrite event orders: ${response.statusCode} - ${response.body}',
        uri: Uri.parse('$baseUrl$url'),
      );
    }
  }

  List<OrderEntity> _convertEventBriteOrderJson(Map<String, dynamic> json) {
    final attendees = json['attendees'] as List? ?? [];
    
    if (attendees.isEmpty) {
      return [];
    }
    
    List<OrderEntity> orders = [];
    
    for (int i = 0; i < attendees.length; i++) {
      final attendee = attendees[i];
      final profile = attendee['profile'] ?? {};
      
      final buyerDetails = BuyerDetails((b) => b
        ..email = profile['email']?.toString() ?? ''
        ..firstName = profile['first_name']?.toString() ?? ''
        ..lastName = profile['last_name']?.toString() ?? ''
        ..name = profile['name']?.toString() ?? ''
        ..phone = profile['cell_phone']?.toString() ?? '');

      if (buyerDetails.email.isEmpty) {
        continue;
      }

      final orderBuilder = OrderEntityBuilder()
        ..id = '${json['id']?.toString() ?? ''}_attendee_$i' 
        ..status = json['status']?.toString() ?? ''
        ..createdAt = _parseEventBriteDateTime(json['created'])
        ..total = _parseEventBriteAmount(json['costs']?['gross']?['value'])
        ..currency = json['costs']?['gross']?['currency']?.toString() ?? '';

      orderBuilder.buyerDetails = buyerDetails.toBuilder();

      orderBuilder.issuedTickets.replace([
        IssuedTicket().rebuild((t) => t
          ..id = attendee['id']?.toString() ?? ''
          ..barcode = attendee['barcodes']?.isNotEmpty == true
              ? attendee['barcodes'][0]['barcode']?.toString() ?? ''
              : ''
          ..qrCodeUrl = '' 
          ..status = attendee['status']?.toString() ?? '')
      ]);

      orderBuilder.lineItems.replace([
        LineItem().rebuild((l) => l
          ..id = attendee['id']?.toString() ?? ''
          ..description = 'EventBrite Event Order - ${profile['name'] ?? 'Attendee'}'
          ..quantity = 1
          ..total = _parseEventBriteAmount(json['costs']?['gross']?['value']) ~/ attendees.length
          ..type = 'ticket')
      ]);

      orders.add(orderBuilder.build());
    }
    
    return orders;
  }

  EventEntity _convertEventBriteJsonToEventEntity(Map<String, dynamic> json) {
    return EventEntity(id: json['id']?.toString() ?? '').rebuild((b) {
      final organizerId = json['organizer_id']?.toString() ?? '';
      
      String? organizerName;
      
      if (json['organizer'] != null) {
        final organizer = json['organizer'];
        organizerName = organizer['name']?.toString();
      }
      
      if (organizerName == null || organizerName.isEmpty) {
        if (json['organizer_name'] != null) {
          organizerName = json['organizer_name']?.toString();
        }
      }
      
      if (organizerName == null || organizerName.isEmpty) {
        organizerName = companyName;
      }
      
      Map<String, dynamic> dynamicFields = {};
      if (organizerName.isNotEmpty) {
        dynamicFields['organizerName'] = organizerName;
      }
      if (organizerId.isNotEmpty) {
        dynamicFields['organizerId'] = organizerId;
      }
      
      return b
        ..name = json['name']?['text']?.toString() ?? ''
        ..accessCode = ''
        ..callToAction = ''
        ..chk = ''
        ..currency = json['currency']?.toString() ?? 'USD'
        ..description = json['description']?['text']?.toString() ?? ''
        ..end = _parseEventBriteDateTime(json['end']?['utc'])
        ..start = _parseEventBriteDateTime(json['start']?['utc'])
        ..eventSeriesId = json['series_id']?.toString() ?? ''
        ..hidden = json['listed'] == false
        ..onlineEvent = json['online_event'] == true
        ..privateEvent = json['listed'] == false
        ..status = json['status']?.toString() ?? ''
        ..ticketsAvailable = json['ticket_availability']?['has_available_tickets'] == true
        ..totalHolds = 0 
        ..totalIssuedTickets = _parseEventBriteInt(json['capacity'])
        ..totalOrders = 0 
        ..unavailable = json['status'] == 'canceled'
        ..unavailableStatus = json['status'] == 'canceled' ? 'canceled' : ''
        ..createdAt = _parseEventBriteDateTime(json['created'])
        ..updatedAt = _parseEventBriteDateTime(json['changed'])
        ..createdUserId = organizerId
        ..assignedUserId = organizerId
        ..archivedAt = 0
        ..url = json['url']?.toString() ?? ''
        ..dynamicFields = MapBuilder<String, dynamic>(dynamicFields)
        ..images = (b.images
          ..replace(Images((i) => i
            ..header = json['logo']?['url']?.toString() ?? ''
            ..thumbnail = json['logo']?['url']?.toString() ?? '')))
        ..venue = (b.venue
          ..replace(Venue((v) => v
            ..name = json['venue']?['name']?.toString() ?? ''
            ..postalCode = json['venue']?['address']?['postal_code']?.toString() ?? '')))
        ..ticketTypes = ListBuilder<TicketType>(_convertEventBriteTicketClasses(json['ticket_classes'] ?? []))
        ..ticketGroups = ListBuilder<TicketGroup>([]) 
        ..isDeleted = false;
    });
  }

  List<TicketType> _convertEventBriteTicketClasses(List ticketClasses) {
    return ticketClasses.map((ticketClass) {
      return TicketType((t) => t
        ..id = ticketClass['id']?.toString() ?? ''
        ..object = 'ticket_type'
        ..accessCode = ''
        ..bookingFee = _parseEventBriteAmount(ticketClass['fee']?['value'])
        ..description = ticketClass['description']?.toString() ?? ''
        ..groupId = ''
        ..maxPerOrder = _parseEventBriteInt(ticketClass['maximum_quantity_per_order'])
        ..minPerOrder = _parseEventBriteInt(ticketClass['minimum_quantity']).toString()
        ..name = ticketClass['name']?.toString() ?? ''
        ..price = _parseEventBriteAmount(ticketClass['cost']?['value'])
        ..quantity = _parseEventBriteInt(ticketClass['quantity_total'])
        ..quantityHeld = 0
        ..quantityIssued = _parseEventBriteInt(ticketClass['quantity_sold'])
        ..quantityTotal = _parseEventBriteInt(ticketClass['quantity_total'])
        ..sortOrder = _parseEventBriteInt(ticketClass['sorting'])
        ..status = ticketClass['on_sale_status']?.toString() ?? ''
        ..type = ticketClass['type']?.toString() ?? '');
    }).toList();
  }

  int _parseEventBriteDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 0;
    try {
      return DateTime.parse(dateTimeString).millisecondsSinceEpoch ~/ 1000;
    } catch (e) {
      return 0;
    }
  }

  int _parseEventBriteAmount(dynamic amount) {
    if (amount == null) return 0;
    if (amount is int) return amount;
    if (amount is double) return amount.toInt();
    if (amount is String) return int.tryParse(amount) ?? 0;
    return 0;
  }

  int _parseEventBriteInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> saveEventsToFirebase(List<EventEntity> events) async {
    List<Future> completers = [];
    int savedCount = 0;

    for (final event in events) {
      updateStatus('Saving EventBrite event: ${event.name} (${++savedCount}/${events.length})');

      final completer = Completer<EventEntity>();
      completers.add(completer.future);
      store.dispatch(
        SaveEventRequest(
          event: event,
          completer: completer,
          isViewEvent: false,
        ),
      );
    }

    await Future.wait(completers).catchError((error) {
      final errorMessage = 'Error saving EventBrite events to database: $error';
      logError(errorMessage);
      updateStatus(errorMessage);
      throw error;
    });
  }
  
  Future<void> assignCompaniesToUsers(List<EventEntity> events) async {
    try {
      updateStatus('Loading companies from Firebase...');
      
      final companiesCompleter = Completer<Map<String, String>>();
      store.dispatch(LoadAllCompanies(completer: companiesCompleter));
      
      final companies = await companiesCompleter.future;
      
      if (companies.isEmpty) {
        updateStatus('No companies found in Firebase. Skipping company assignment.');
        return;
      }
      
      updateStatus('Found ${companies.length} companies. Processing ${events.length} events...');
      
      int processedEvents = 0;
      int assignmentsCompleted = 0;
      
      for (final event in events) {
        processedEvents++;
        updateStatus('Processing company assignment for event ${processedEvents}/${events.length}: ${event.name}');
        
        await _processEventForCompanyAssignment(event, companies);
        
        if (event.orders.isNotEmpty) {
          assignmentsCompleted++;
        }
      }
      
      updateStatus('Completed company assignment process for ${processedEvents} events. ${assignmentsCompleted} events had attendees to process.');
      
    } catch (e) {
      final errorMessage = 'Error in assignCompaniesToUsers: $e';
      logError(errorMessage);
      updateStatus(errorMessage);
      throw e;
    }
  }
  
  Future<void> _processEventForCompanyAssignment(
    EventEntity event, 
    Map<String, String> companies
  ) async {
    try {
      String? organizerName;
      
      if (event.dynamicFields.containsKey('organizerName')) {
        organizerName = event.dynamicFields['organizerName']?.toString();
      } else if (event.dynamicFields.containsKey('organizerOrg')) {
        organizerName = event.dynamicFields['organizerOrg']?.toString();
      } else if (event.dynamicFields.containsKey('companyName')) {
        organizerName = event.dynamicFields['companyName']?.toString();
      } else if (event.dynamicFields.containsKey('organizer')) {
        organizerName = event.dynamicFields['organizer']?.toString();
      }
      
      if (organizerName == null || organizerName.isEmpty) {
        return;
      }
      
      final organizerNameLower = organizerName.toLowerCase();
      String? matchedCompanyId;
      for (final entry in companies.entries) {
        final companyNameLower = entry.key.toLowerCase();
        
        if (companyNameLower == organizerNameLower) {
          matchedCompanyId = entry.value;
          break;
        }
        
        if (companyNameLower.contains(organizerNameLower) || 
            organizerNameLower.contains(companyNameLower)) {
          matchedCompanyId = entry.value;
          break;
        }
        
        final distance = _calculateLevenshteinDistance(companyNameLower, organizerNameLower);
        final maxLength = math.max(companyNameLower.length, organizerNameLower.length);
        final similarity = (maxLength - distance) / maxLength;
        
        if (similarity > 0.6) {
          matchedCompanyId = entry.value;
          break;
        }
      }
      
      if (matchedCompanyId == null) {
        logInfo('No matching company found for organizer: $organizerName');
        return;
      }
      
      final companyName = companies.keys.firstWhere(
        (name) => companies[name] == matchedCompanyId,
        orElse: () => organizerName ?? 'Unknown Company',
      );
      
      final userCompany = UserCompany(
        companyId: matchedCompanyId,
        companyName: companyName,
      );
      
      final attendeesMap = <String, BuyerDetails>{};
      
      for (final order in event.orders) {
        if (order.buyerDetails.email.isNotEmpty) {
          final email = order.buyerDetails.email.toLowerCase();
          if (!attendeesMap.containsKey(email)) {
            attendeesMap[email] = order.buyerDetails;
          }
        }
      }
      
      final uniqueAttendees = attendeesMap.values.toList();
      
      if (uniqueAttendees.isEmpty) {
        return;
      }
      
      
      final assignmentCompleter = Completer();
      store.dispatch(AddCompaniesToAttendees(
        attendees: uniqueAttendees,
        company: userCompany,
        completer: assignmentCompleter,
      ));
      
      await assignmentCompleter.future;
      
    } catch (e) {
      logError('Error processing event ${event.name} for company assignment: $e');
    }
  }

  int _calculateLevenshteinDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final List<List<int>> matrix = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => 0),
    );

    for (int i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = math.min(
          math.min(
            matrix[i - 1][j] + 1,      
            matrix[i][j - 1] + 1,      
          ),
          matrix[i - 1][j - 1] + cost, 
        );
      }
    }

    return matrix[a.length][b.length];
  }
}

class PaginatedResponse<T> {
  final List<T> items;
  final String? nextPageUrl;

  PaginatedResponse({
    required this.items,
    this.nextPageUrl,
  });
}
