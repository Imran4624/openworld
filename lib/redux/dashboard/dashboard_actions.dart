// Project imports:
import 'package:flutter_boilerplate/data/models/dashboard_model.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';

class ViewDashboard implements PersistUI {
  ViewDashboard({
    this.force = false,
    this.filter,
  });

  final bool force;
  final String? filter;

  @override
  String toString() {
    return 'ViewDashboard';
  }
}

class UpdateDashboardSettings implements PersistUI {
  UpdateDashboardSettings({
    this.settings,
    this.offset,
    this.currencyId,
    this.includeTaxes,
    this.groupBy,
  });

  DashboardSettings? settings;
  int? offset;
  String? currencyId;
  bool? includeTaxes;
  String? groupBy;

  @override
  String toString() {
    return 'UpdateDashboardSettings';
  }
}

class UpdateDashboardSelection implements PersistUI {
  UpdateDashboardSelection({
    this.entityType,
    this.entityIds,
  });

  EntityType? entityType;
  List<String>? entityIds;

  @override
  String toString() {
    return 'UpdateDashboardSelection';
  }
}

class UpdateDashboardEntityType implements PersistUI {
  UpdateDashboardEntityType({this.entityType});

  EntityType? entityType;

  @override
  String toString() {
    return 'UpdateDashboardEntityType';
  }
}

class UpdateDashboardSidebar implements PersistUI {
  UpdateDashboardSidebar({this.showSidebar});

  bool? showSidebar;

  @override
  String toString() {
    return 'UpdateDashboardSidebar';
  }
}
