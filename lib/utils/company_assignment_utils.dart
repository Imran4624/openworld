import 'dart:async';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:redux/redux.dart';

class CompanyAssignmentUtils {
  
  static Future<void> addCompanyToUser({
    required Store<AppState> store,
    required String userEmail,
    required String companyId,
    required String companyName,
  }) async {
    final completer = Completer();
    
    final userCompany = UserCompany(
      companyId: companyId,
      companyName: companyName,
    );
    
    store.dispatch(AddCompanyToCurrentUser(
      email: userEmail,
      company: userCompany,
      completer: completer,
    ));
    
    await completer.future;
  }
  
  /// Adds a company to multiple attendees
  static Future<void> addCompanyToAttendees({
    required Store<AppState> store,
    required List<BuyerDetails> attendees,
    required String companyId,
    required String companyName,
  }) async {
    final completer = Completer();
    
    final userCompany = UserCompany(
      companyId: companyId,
      companyName: companyName,
    );
    
    store.dispatch(AddCompaniesToAttendees(
      attendees: attendees,
      company: userCompany,
      completer: completer,
    ));
    
    await completer.future;
  }
  
  static UserCompany? extractCompanyFromEvent(EventEntity event) {
    String? organizerName;
    String? organizerId;
    
    if (event.dynamicFields.containsKey('organizerName')) {
      organizerName = event.dynamicFields['organizerName']?.toString();
    } else if (event.dynamicFields.containsKey('organizerOrg')) {
      organizerName = event.dynamicFields['organizerOrg']?.toString();
    } else if (event.dynamicFields.containsKey('companyName')) {
      organizerName = event.dynamicFields['companyName']?.toString();
    } else if (event.dynamicFields.containsKey('organizer')) {
      organizerName = event.dynamicFields['organizer']?.toString();
    }
    
    if (event.dynamicFields.containsKey('organizerId')) {
      organizerId = event.dynamicFields['organizerId']?.toString();
    }
    
    if (organizerName != null && organizerName.isNotEmpty) {
      return UserCompany(
        companyId: organizerId ?? event.createdUserId,
        companyName: organizerName,
      );
    }
    
    return null;
  }
  
  static List<BuyerDetails> getAttendeesFromEvent(EventEntity event) {
    final attendees = <BuyerDetails>[];
    
    for (final order in event.orders) {
      if (order.buyerDetails.email.isNotEmpty) {
        attendees.add(order.buyerDetails);
      }
    }
    
    return attendees;
  }
  
  static Future<void> assignCompanyToEventAttendees({
    required Store<AppState> store,
    required EventEntity event,
    required String companyId,
    required String companyName,
  }) async {
    final attendees = getAttendeesFromEvent(event);
    
    if (attendees.isNotEmpty) {
      await addCompanyToAttendees(
        store: store,
        attendees: attendees,
        companyId: companyId,
        companyName: companyName,
      );
    }
  }
  
  static Future<void> assignEventOrganizerCompanyToAttendees({
    required Store<AppState> store,
    required EventEntity event,
  }) async {
    final company = extractCompanyFromEvent(event);
    if (company != null) {
      final attendees = getAttendeesFromEvent(event);
      
      if (attendees.isNotEmpty) {
        await addCompanyToAttendees(
          store: store,
          attendees: attendees,
          companyId: company.companyId,
          companyName: company.companyName,
        );
      }
    }
  }
}
