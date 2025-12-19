import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:redux/redux.dart';
import 'package:built_collection/built_collection.dart';

class TicketTailorAPI {
  static const String baseUrl = 'https://api.tickettailor.com/v1';
  static const int pageLimit = 100;

  static const String apiKey = Config.TICKET_TAILOR_API_KEY;

  final Store<AppState> store;
  final String companyName;
  Function(String) updateStatus;

  TicketTailorAPI({
    required this.store, 
    required this.updateStatus,
    required this.companyName,
  });

  String getEventsUrl(String? nextPageUrl) {
    if (nextPageUrl == null) {
      return 'events?limit=1000';
    }

    if (nextPageUrl.startsWith('/')) {
      return nextPageUrl.substring(1); // Remove leading slash
    }

    return nextPageUrl;
  }

  String getOrdersUrl(String? nextPageUrl) {
    if (nextPageUrl == null) {
      return 'orders?limit=1000';
    }

    if (nextPageUrl.startsWith('/')) {
      return nextPageUrl.substring(1); // Remove leading slash
    }

    return nextPageUrl;
  }

  String getEventOrdersUrl(String eventId, String? nextPageUrl) {
    if (nextPageUrl == null) {
      return 'orders?event_id=$eventId&limit=1000';
    }

    if (nextPageUrl.startsWith('/')) {
      return nextPageUrl.substring(1); // Remove leading slash
    }

    return nextPageUrl;
  }

// Fetch orders for a specific event with pagination
  Future<List<OrderEntity>> fetchOrdersForEvent(
      String eventId, String eventName) async {
    List<OrderEntity> allOrders = [];
    String? nextPageUrl;
    bool hasMore = true;
    int pageCount = 0;

    while (hasMore) {
      pageCount++;
      updateStatus('Fetching orders page $pageCount for event: $eventName...');

      final url = getEventOrdersUrl(eventId, nextPageUrl);
      final response = await fetchEventOrdersPage(url);

      // Process and collect orders from this response
      for (var eventWithOrders in response.items) {
        // We should only get orders for this event, but let's double-check
        if (eventWithOrders.id == eventId) {
          allOrders.addAll(eventWithOrders.orders);
        }
      }

      nextPageUrl = response.nextPageUrl;
      hasMore = nextPageUrl != null;

      updateStatus(
          'Fetched ${allOrders.length} orders for event: $eventName so far...');
    }

    return allOrders;
  }

// Update the main method to fetch orders on a per-event basis
  Future<void> fetchEvents() async {
    try {
      const message = 'Starting to fetch events from TicketTailor...';
      logInfo(message);
      updateStatus(message);

      // Fetch all events with pagination
      final events = await fetchAllEventDetails();
      final detailsMessage =
          'Successfully fetched ${events.length} event details';
      logInfo(detailsMessage);
      updateStatus(detailsMessage);

      const ordersStartMessage = 'Fetching orders for each event...';
      logInfo(ordersStartMessage);
      updateStatus(ordersStartMessage);

      // Process each event one by one to fetch its orders
      List<EventEntity> eventsWithOrders = [];
      int processedCount = 0;

      for (var event in events) {
        processedCount++;
        updateStatus(
            'Processing event ${processedCount}/${events.length}: ${event.name}');

        // Fetch all orders for this specific event
        final orders = await fetchOrdersForEvent(event.id, event.name);

        // Create a new event entity with the orders
        final eventWithOrders = event.rebuild((b) => b
          ..orders.replace(orders)
          ..totalOrders = orders.length);

        eventsWithOrders.add(eventWithOrders);

        final eventOrdersMessage =
            'Fetched ${orders.length} orders for event: ${event.name}';
        logInfo(eventOrdersMessage);
        updateStatus(eventOrdersMessage);
      }

      const saveMessage = 'Saving events with their orders to Firebase...';
      logInfo(saveMessage);
      updateStatus(saveMessage);

      await saveEventsToFirebase(eventsWithOrders);

      updateStatus('Assigning companies to ticket buyers...');
      await assignCompaniesToUsers(eventsWithOrders);

      final successMessage =
          'Successfully fetched and saved ${eventsWithOrders.length} TicketTailor events with all their orders and assigned companies to users';
      logInfo(successMessage);
      updateStatus(successMessage);
    } catch (e) {
      final errorMessage = 'Error fetching events: $e';
      logError(errorMessage);
      updateStatus(errorMessage);
      throw e;
    }
  }

  Future<List<EventEntity>> fetchAllEventDetails() async {
    List<EventEntity> allEvents = [];
    String? nextPageUrl;
    bool hasMore = true;
    int pageCount = 0;

    while (hasMore) {
      pageCount++;
      updateStatus('Fetching events page $pageCount...');

      final url = getEventsUrl(nextPageUrl);
      final response = await fetchEventDetailsPage(url);

      allEvents.addAll(response.items);
      nextPageUrl = response.nextPageUrl;
      hasMore = nextPageUrl != null;

      if (response.items.isNotEmpty) {
        updateStatus('Fetched ${allEvents.length} events so far...');
      }
    }

    return allEvents;
  }

  Future<PaginatedResponse<EventEntity>> fetchEventDetailsPage(
      String url) async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/$url'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final events = (json['data'] as List)
          .map((eventJson) => _convertJsonToEventEntity(eventJson))
          .toList();

      events.forEach((event) {
        updateStatus('Fetched event: ${event.name}');
      });

      // Check for next page URL
      final nextPageUrl = json['links']['next'];

      return PaginatedResponse<EventEntity>(
        items: events,
        nextPageUrl: nextPageUrl,
      );
    } else {
      updateStatus('HTTP error when fetching events: ${response.statusCode}');
      throw HttpException(
        'Failed to fetch events: ${response.statusCode}',
        uri: Uri.parse('$baseUrl/$url'),
      );
    }
  }

  Future<PaginatedResponse<EventEntity>> fetchEventOrdersPage(
      String url) async {
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/$url'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // Group orders by event ID
      Map<String, List<OrderEntity>> ordersByEventId = {};

      for (var orderJson in json['data'] as List) {
        final eventId = orderJson['event_summary']['id'];
        final order = _convertOrderJson(
            orderJson); // Create a helper method for just the order

        if (!ordersByEventId.containsKey(eventId)) {
          ordersByEventId[eventId] = [];
        }
        ordersByEventId[eventId]!.add(order);
      }

      // Create EventEntity objects with all orders for each event
      List<EventEntity> eventEntities = [];

      ordersByEventId.forEach((eventId, orders) {
        // Use the first order's event_summary data for the event details
        final firstOrderJson = (json['data'] as List).firstWhere(
            (orderJson) => orderJson['event_summary']['id'] == eventId);

        final startUnix =
            firstOrderJson['event_summary']['start_date']?['unix'];
        final endUnix = firstOrderJson['event_summary']['end_date']?['unix'];

        final int startTime = startUnix == null
            ? 0
            : startUnix is int
                ? startUnix
                : (startUnix as num).toInt();

        final int endTime = endUnix == null
            ? 0
            : endUnix is int
                ? endUnix
                : (endUnix as num).toInt();

        final eventEntity = EventEntity(id: eventId).rebuild((b) {
          b.name = firstOrderJson['event_summary']['name'] ?? '';
          b.start = startTime;
          b.end = endTime;
          b.venue.replace(Venue((v) {
            v.name = firstOrderJson['event_summary']['venue']?['name'] ?? '';
            v.postalCode =
                firstOrderJson['event_summary']['venue']?['postal_code'] ?? '';
          }));
          b.totalOrders = orders.length;
          b.orders.replace(orders);
        });

        eventEntities.add(eventEntity);
        updateStatus(
            'Fetched ${orders.length} orders for event: ${eventEntity.name}');
      });

      // Check for next page URL
      final nextPageUrl = json['links']['next'];

      return PaginatedResponse<EventEntity>(
        items: eventEntities,
        nextPageUrl: nextPageUrl,
      );
    } else {
      updateStatus('HTTP error when fetching orders: ${response.statusCode}');
      throw HttpException(
        'Failed to fetch event orders: ${response.statusCode}',
        uri: Uri.parse('$baseUrl/$url'),
      );
    }
  }

  OrderEntity _convertOrderJson(Map<String, dynamic> json) {
    final buyerDetailsJson = json['buyer_details'] as Map<String, dynamic>;
    final buyerDetails = BuyerDetails((b) => b
      ..email = buyerDetailsJson['email'] as String
      ..firstName = buyerDetailsJson['first_name'] as String
      ..lastName = buyerDetailsJson['last_name'] as String
      ..name = buyerDetailsJson['name'] as String
      ..phone = buyerDetailsJson['phone']?.toString() ?? '');

    final orderBuilder = OrderEntityBuilder()
      ..id = json['id'] ?? ''
      ..status = json['status'] ?? ''
      ..createdAt = json['created_at'] == null
          ? 0
          : json['created_at'] is int
              ? json['created_at'] as int
              : (json['created_at'] as num).toInt()
      ..total = json['total'] == null
          ? 0
          : json['total'] is int
              ? json['total'] as int
              : (json['total'] as num).toInt()
      ..currency = json['currency']?['code'] ?? '';

    orderBuilder.buyerDetails = buyerDetails.toBuilder();

    orderBuilder.issuedTickets.replace((json['issued_tickets'] ?? [])
        .map((ticket) => IssuedTicket().rebuild((t) => t
          ..id = ticket['id']?.toString() ?? ''
          ..barcode = ticket['barcode']?.toString() ?? ''
          ..qrCodeUrl = ticket['qr_code_url']?.toString() ?? ''
          ..status = ticket['status']?.toString() ?? '')));

    orderBuilder.lineItems.replace(
        (json['line_items'] ?? []).map((item) => LineItem().rebuild((l) => l
          ..id = item['id']?.toString() ?? ''
          ..description = item['description']?.toString() ?? ''
          ..quantity = item['quantity'] == null
              ? 0
              : item['quantity'] is int
                  ? item['quantity'] as int
                  : (item['quantity'] as num).toInt()
          ..total = item['total'] == null
              ? 0
              : item['total'] is int
                  ? item['total'] as int
                  : (item['total'] as num).toInt()
          ..type = item['type']?.toString() ?? '')));

    return orderBuilder.build();
  }

  Future<void> saveEventsToFirebase(List<EventEntity> mergedEvents) async {
    List<Future> completers = [];
    int savedCount = 0;

    for (final event in mergedEvents) {
      final saveMessage =
          'Saving event: ${event.name} (${++savedCount}/${mergedEvents.length})';
      logInfo(saveMessage);
      updateStatus(saveMessage);

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
      final errorMessage = 'Error saving events to database: $error';
      logError(errorMessage);
      updateStatus(errorMessage);
      throw error;
    });
  }

  static Future<void> saveBuyerDetails(
      List<BuyerDetails> buyerDetailsList) async {
    try {
      final directory =
          await getApplicationDocumentsDirectory(); 
      final file = File('${directory.path}/cac_buyer_details.json');

      final jsonData = jsonEncode(
          buyerDetailsList.map((details) => details.toJson()).toList());

      await file.writeAsString(jsonData);
      logInfo('Buyer details saved successfully at ${file.path}');
    } catch (e) {
      logError('Error saving buyer details: $e');
      throw e;
    }
  }

  EventEntity _convertJsonToEventEntity(Map<String, dynamic> json) {
    return EventEntity(id: json['id']).rebuild((b) {
      return b
        ..name = json['name']
        ..accessCode = json['access_code'] ?? ''
        ..callToAction = json['call_to_action']
        ..chk = json['chk']
        ..currency = json['currency']
        ..description = json['description']
        ..end = (json['end'] as Map<String, dynamic>)['unix'] is int
            ? (json['end'] as Map<String, dynamic>)['unix'] as int
            : ((json['end'] as Map<String, dynamic>)['unix'] as double).toInt()
        ..start = (json['start'] as Map<String, dynamic>)['unix'] is int
            ? (json['start'] as Map<String, dynamic>)['unix'] as int
            : ((json['start'] as Map<String, dynamic>)['unix'] as double)
                .toInt()
        ..eventSeriesId = json['event_series_id']
        ..hidden = json['hidden'].toString() == 'true'
        ..onlineEvent = json['online_event'].toString() == 'true'
        ..privateEvent = json['private'].toString() == 'true'
        ..status = json['status']
        ..ticketsAvailable = json['tickets_available'].toString() == 'true'
        ..totalHolds = json['total_holds'] == null
            ? 0
            : json['total_holds'] is int
                ? json['total_holds'] as int
                : (json['total_holds'] as num).toInt()
        ..totalIssuedTickets = json['total_issued_tickets'] == null
            ? 0
            : json['total_issued_tickets'] is int
                ? json['total_issued_tickets'] as int
                : (json['total_issued_tickets'] as num).toInt()
        ..totalOrders = json['total_orders'] == null
            ? 0
            : json['total_orders'] is int
                ? json['total_orders'] as int
                : (json['total_orders'] as num).toInt()
        ..unavailable = json['unavailable'].toString() == 'true'
        ..unavailableStatus = json['unavailable_status'] ?? ''
        ..createdAt = json['created_at'] == null
            ? 0
            : json['created_at'] is int
                ? json['created_at'] as int
                : (json['created_at'] as num).toInt()
        ..updatedAt = json['updated_at'] == null
            ? 0
            : json['updated_at'] is int
                ? json['updated_at'] as int
                : (json['updated_at'] as num).toInt()
        ..createdUserId = json['created_user_id'] ?? ''
        ..assignedUserId = json['assigned_user_id'] ?? ''
        ..archivedAt = json['archived_at'] == null
            ? 0
            : json['archived_at'] is int
                ? json['archived_at'] as int
                : (json['archived_at'] as num).toInt()
        ..url = json['url'] ?? ''
        // ..paymentMethods = ListBuilder<String>((json['payment_methods'] as List)
        //     .map((method) => method.toString()))
        ..images = (b.images
          ..replace(Images((i) => i
            ..header = (json['images'] as Map<String, dynamic>)['header'] ?? ''
            ..thumbnail =
                (json['images'] as Map<String, dynamic>)['thumbnail'] ?? '')))
        ..venue = (b.venue
          ..replace(Venue((v) => v
            ..name = (json['venue'] as Map<String, dynamic>)['name'] ?? ''
            ..postalCode =
                (json['venue'] as Map<String, dynamic>)['postal_code'] ?? '')))
        ..ticketTypes = ListBuilder<TicketType>(
            (json['ticket_types'] as List).map((type) => TicketType((t) => t
              ..id = type['id'] as String
              ..object = type['object'] as String
              ..accessCode = type['access_code'] ?? ''
              ..bookingFee = type['booking_fee'] == null
                  ? 0
                  : type['booking_fee'] is int
                      ? type['booking_fee'] as int
                      : (type['booking_fee'] as num).toInt()
              ..description = type['description'] ?? ''
              ..groupId = type['group_id'] ?? ''
              ..maxPerOrder = type['max_per_order'] == null
                  ? 0
                  : type['max_per_order'] is int
                      ? type['max_per_order'] as int
                      : (type['max_per_order'] as num).toInt()
              ..minPerOrder = type['min_per_order'].toString()
              ..name = type['name'] as String
              ..price = type['price'] == null
                  ? 0
                  : type['price'] is int
                      ? type['price'] as int
                      : (type['price'] as num).toInt()
              ..quantity = type['quantity'] == null
                  ? 0
                  : type['quantity'] is int
                      ? type['quantity'] as int
                      : (type['quantity'] as num).toInt()
              ..quantityHeld = type['quantity_held'] == null
                  ? 0
                  : type['quantity_held'] is int
                      ? type['quantity_held'] as int
                      : (type['quantity_held'] as num).toInt()
              ..quantityIssued = type['quantity_issued'] == null
                  ? 0
                  : type['quantity_issued'] is int
                      ? type['quantity_issued'] as int
                      : (type['quantity_issued'] as num).toInt()
              ..quantityTotal = type['quantity_total'] == null
                  ? 0
                  : type['quantity_total'] is int
                      ? type['quantity_total'] as int
                      : (type['quantity_total'] as num).toInt()
              ..sortOrder = type['sort_order'] == null
                  ? 0
                  : type['sort_order'] is int
                      ? type['sort_order'] as int
                      : (type['sort_order'] as num).toInt()
              ..status = type['status'] as String
              ..type = type['type'] as String)))
        ..ticketGroups = ListBuilder<TicketGroup>(
            (json['ticket_groups'] as List).map((group) => TicketGroup((g) => g
              ..id = group['id'] as String
              ..maxPerOrder = group['max_per_order'] == null
                  ? 0
                  : group['max_per_order'] is int
                      ? group['max_per_order'] as int
                      : (group['max_per_order'] as num).toInt()
              ..name = group['name'] as String
              ..sortOrder = group['sort_order'] == null
                  ? 0
                  : group['sort_order'] is int
                      ? group['sort_order'] as int
                      : (group['sort_order'] as num).toInt()
              ..ticketIds = ListBuilder<String>(
                  (group['ticket_ids'] as List).map((id) => id.toString())))))
        ..isChanged = false
        ..isDeleted = false;
    });
  }

  List<EventEntity> mergeEventData(
      List<EventEntity> events, List<EventEntity> orders) {
    final Map<String, EventEntity> eventMap = {
      for (var event in events) event.id: event
    };

    // Create a map to accumulate all orders by event ID
    final Map<String, List<OrderEntity>> allOrdersByEventId = {};

    // Collect all orders from all fetched order pages
    for (var orderEvent in orders) {
      if (!allOrdersByEventId.containsKey(orderEvent.id)) {
        allOrdersByEventId[orderEvent.id] = [];
      }
      // Add all orders from this batch to the accumulated list
      allOrdersByEventId[orderEvent.id]!.addAll(orderEvent.orders);
    }

    // Now merge the accumulated orders with the events
    for (var eventId in allOrdersByEventId.keys) {
      if (eventMap.containsKey(eventId)) {
        final allOrders = allOrdersByEventId[eventId]!;
        updateStatus(
            'Merging ${allOrders.length} orders for event: ${eventMap[eventId]?.name}');

        eventMap[eventId] = eventMap[eventId]!.rebuild((b) => b
          ..orders.replace(allOrders)
          ..totalOrders = allOrders.length);
      }
    }

    return eventMap.values.toList();
  }

  Future<Map<String, List<OrderEntity>>> fetchAllEventOrders() async {
    Map<String, List<OrderEntity>> allOrdersByEventId = {};
    String? nextPageUrl;
    bool hasMore = true;
    int pageCount = 0;

    while (hasMore) {
      pageCount++;
      updateStatus('Fetching orders page $pageCount...');

      final url = getOrdersUrl(nextPageUrl);
      final response = await fetchEventOrdersPage(url);

      // Process the orders from this page
      for (var eventWithOrders in response.items) {
        final eventId = eventWithOrders.id;

        if (!allOrdersByEventId.containsKey(eventId)) {
          allOrdersByEventId[eventId] = [];
        }
        // Add all orders from this batch to the accumulated list
        allOrdersByEventId[eventId]!.addAll(eventWithOrders.orders);
      }

      nextPageUrl = response.nextPageUrl;
      hasMore = nextPageUrl != null;

      updateStatus(
          'Fetched orders for ${allOrdersByEventId.keys.length} events so far...');
    }

    return allOrdersByEventId;
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
      final organizerName = companyName;
      
      if (organizerName.isEmpty) {
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
      }
      if (matchedCompanyId == null) {
        for (final entry in companies.entries) {
          final companyNameLower = entry.key.toLowerCase();
          
          if (companyNameLower.contains(organizerNameLower) || 
              organizerNameLower.contains(companyNameLower)) {
            matchedCompanyId = entry.value;
            break;
          }
        }
      }
      if (matchedCompanyId == null) {
        for (final entry in companies.entries) {
          final companyNameLower = entry.key.toLowerCase();
          final distance = _calculateLevenshteinDistance(companyNameLower, organizerNameLower);
          final maxLength = math.max(companyNameLower.length, organizerNameLower.length);
          final similarity = (maxLength - distance) / maxLength;
          
          if (similarity > 0.6) {
            matchedCompanyId = entry.value;
            break;
          }
        }
      }
      
      if (matchedCompanyId == null) {
        return;
      }
      
      final companyNameToUse = companies.keys.firstWhere(
        (name) => companies[name] == matchedCompanyId,
        orElse: () => organizerName,
      );
      
      final userCompany = UserCompany(
        companyId: matchedCompanyId,
        companyName: companyNameToUse,
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
