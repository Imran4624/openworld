// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:charts_common/common.dart';
import 'package:memoize/memoize.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_state.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';

class ChartDataGroup {
  ChartDataGroup(this.name);

  final String name;
  final List<ChartMoneyData> rawSeries = [];
  Map<String, List<String>> entityMap = {};
  late List<Series<dynamic, DateTime>> chartSeries;

  double periodTotal = 0.0;
  double previousTotal = 0.0;
  double total = 0.0;

  int periodCount = 0;
  int totalCount = 0;

  double get periodAverage =>
      periodCount == 0 ? 0 : round(periodTotal / periodCount, 2);

  double get totalAverage => totalCount == 0 ? 0 : round(total / totalCount, 2);

  bool get isDuration => name.endsWith('_duration');
}

class ChartMoneyData {
  ChartMoneyData(this.date, this.amount);

  final DateTime date;
  final double? amount;
}

var memoizedChartInvoices = memo3((
  BuiltMap<String, CurrencyEntity> currencyMap,
  CompanyEntity? company,
  DashboardUISettings settings,
) =>
    _chartInvoices(
        currencyMap: currencyMap, company: company!, settings: settings));

var memoizedChartOverviewInvoices = memo3(
    (BuiltMap<String, CurrencyEntity> currencyMap, CompanyEntity? company,
            DashboardUISettings settings) =>
        _chartInvoices(
            currencyMap: currencyMap, company: company!, settings: settings));

var memoizedPreviousChartInvoices = memo3(
    (BuiltMap<String, CurrencyEntity> currencyMap, CompanyEntity? company,
            DashboardUISettings settings) =>
        _chartInvoices(
            currencyMap: currencyMap, company: company!, settings: settings));

List<ChartDataGroup> _chartInvoices({
  BuiltMap<String, CurrencyEntity>? currencyMap,
  required CompanyEntity company,
  required DashboardUISettings settings,
}) {
  const STATUS_ACTIVE = 'active';
  const STATUS_OUTSTANDING = 'outstanding';

  final ChartDataGroup activeData = ChartDataGroup(STATUS_ACTIVE);
  final ChartDataGroup outstandingData = ChartDataGroup(STATUS_OUTSTANDING);

  final Map<String, Map<String, double>> totals = {
    STATUS_ACTIVE: {},
    STATUS_OUTSTANDING: {},
  };

  var date = convertSqlDateToDateTime(settings.startDate(company));
  final endDate = convertSqlDateToDateTime(settings.endDate(company));

  while (!date.isAfter(endDate)) {
    final key = convertDateTimeToSqlDate(date);
    if (totals[STATUS_ACTIVE]!.containsKey(key)) {
      activeData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_ACTIVE]![key]));
      outstandingData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_OUTSTANDING]![key]));
    } else {
      activeData.rawSeries.add(ChartMoneyData(date, 0.0));
      outstandingData.rawSeries.add(ChartMoneyData(date, 0.0));
    }

    if (settings.groupBy == kReportGroupDay) {
      date = date.add(Duration(days: 1));
    } else if (settings.groupBy == kReportGroupMonth) {
      date = DateTime(date.year, date.month + 1);
    } else if (settings.groupBy == kReportGroupYear) {
      date = DateTime(date.year + 1);
    }
  }

  final List<ChartDataGroup> data = [
    activeData,
    outstandingData,
  ];

  return data;
}

var memoizedChartQuotes = memo3((
  BuiltMap<String, CurrencyEntity> currencyMap,
  CompanyEntity? company,
  DashboardUISettings settings,
) =>
    chartQuotes(
        currencyMap: currencyMap, company: company!, settings: settings));

var memoizedPreviousChartQuotes = memo3(
    (BuiltMap<String, CurrencyEntity> currencyMap, CompanyEntity? company,
            DashboardUISettings settings) =>
        chartQuotes(
            currencyMap: currencyMap, company: company!, settings: settings));

List<ChartDataGroup> chartQuotes({
  BuiltMap<String, CurrencyEntity>? currencyMap,
  required CompanyEntity company,
  required DashboardUISettings settings,
}) {
  const STATUS_ACTIVE = 'active';
  const STATUS_APPROVED = 'approved';
  const STATUS_UNAPPROVED = 'unapproved';
  const STATUS_INVOICED = 'invoiced';
  const STATUS_PAID = 'invoice_paid';

  final Map<String, Map<String, double>> totals = {
    STATUS_ACTIVE: {},
    STATUS_APPROVED: {},
    STATUS_UNAPPROVED: {},
    STATUS_INVOICED: {},
    STATUS_PAID: {},
  };

  final ChartDataGroup activeData = ChartDataGroup(STATUS_ACTIVE);
  final ChartDataGroup approvedData = ChartDataGroup(STATUS_APPROVED);
  final ChartDataGroup unapprovedData = ChartDataGroup(STATUS_UNAPPROVED);
  final ChartDataGroup invoicedData = ChartDataGroup(STATUS_INVOICED);
  final ChartDataGroup paidData = ChartDataGroup(STATUS_PAID);

  var date = convertSqlDateToDateTime(settings.startDate(company));
  final endDate = convertSqlDateToDateTime(settings.endDate(company));

  while (!date.isAfter(endDate)) {
    final key = convertDateTimeToSqlDate(date);
    if (totals[STATUS_ACTIVE]!.containsKey(key)) {
      activeData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_ACTIVE]![key]));
      approvedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_APPROVED]![key]));
      unapprovedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_UNAPPROVED]![key]));
      invoicedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_INVOICED]![key]));
      paidData.rawSeries.add(ChartMoneyData(date, totals[STATUS_PAID]![key]));
    } else {
      activeData.rawSeries.add(ChartMoneyData(date, 0.0));
      approvedData.rawSeries.add(ChartMoneyData(date, 0.0));
      unapprovedData.rawSeries.add(ChartMoneyData(date, 0.0));
      invoicedData.rawSeries.add(ChartMoneyData(date, 0.0));
      paidData.rawSeries.add(ChartMoneyData(date, 0.0));
    }

    if (settings.groupBy == kReportGroupDay) {
      date = date.add(Duration(days: 1));
    } else if (settings.groupBy == kReportGroupMonth) {
      date = DateTime(date.year, date.month + 1);
    } else if (settings.groupBy == kReportGroupYear) {
      date = DateTime(date.year + 1);
    }
  }

  final List<ChartDataGroup> data = [
    activeData,
    approvedData,
    unapprovedData,
    invoicedData,
    paidData,
  ];

  return data;
}

var memoizedChartPayments = memo3((BuiltMap<String, CurrencyEntity> currencyMap,
        CompanyEntity? company, DashboardUISettings settings) =>
    chartPayments(currencyMap, company!, settings));

var memoizedPreviousChartPayments = memo3((
  BuiltMap<String, CurrencyEntity> currencyMap,
  CompanyEntity? company,
  DashboardUISettings settings,
) =>
    chartPayments(currencyMap, company!, settings));

List<ChartDataGroup> chartPayments(BuiltMap<String, CurrencyEntity> currencyMap,
    CompanyEntity company, DashboardUISettings settings) {
  const STATUS_COMPLETED = 'completed';
  const STATUS_REFUNDED = 'refunded';

  final Map<String, Map<String, double>> totals = {
    STATUS_COMPLETED: {},
    STATUS_REFUNDED: {},
  };

  final ChartDataGroup activeData = ChartDataGroup(STATUS_COMPLETED);
  final ChartDataGroup refundedData = ChartDataGroup(STATUS_REFUNDED);

  var date = convertSqlDateToDateTime(settings.startDate(company));
  final endDate = convertSqlDateToDateTime(settings.endDate(company));

  while (!date.isAfter(endDate)) {
    final key = convertDateTimeToSqlDate(date);
    if (totals[STATUS_COMPLETED]!.containsKey(key)) {
      activeData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_COMPLETED]![key]));
      refundedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_REFUNDED]![key]));
    } else {
      activeData.rawSeries.add(ChartMoneyData(date, 0.0));
      refundedData.rawSeries.add(ChartMoneyData(date, 0.0));
    }

    if (settings.groupBy == kReportGroupDay) {
      date = date.add(Duration(days: 1));
    } else if (settings.groupBy == kReportGroupMonth) {
      date = DateTime(date.year, date.month + 1);
    } else if (settings.groupBy == kReportGroupYear) {
      date = DateTime(date.year + 1);
    }
  }

  final List<ChartDataGroup> data = [
    activeData,
    refundedData,
  ];

  return data;
}

var memoizedChartTasks = memo3((BuiltMap<String, CurrencyEntity> currencyMap,
        CompanyEntity? company, DashboardUISettings settings) =>
    chartTasks(currencyMap, company!, settings));

var memoizedPreviousChartTasks = memo3(
    (BuiltMap<String, CurrencyEntity> currencyMap, CompanyEntity? company,
            DashboardUISettings settings) =>
        chartTasks(currencyMap, company!, settings));

List<ChartDataGroup> chartTasks(BuiltMap<String, CurrencyEntity> currencyMap,
    CompanyEntity company, DashboardUISettings settings) {
  const STATUS_LOGGED = 'logged';
  const STATUS_INVOICED = 'invoiced';
  const STATUS_PAID = 'invoice_paid';
  const STATUS_LOGGED_DURATION = 'logged_duration';
  const STATUS_INVOICED_DURATION = 'invoiced_duration';
  const STATUS_PAID_DURATION = 'invoice_paid_duration';

  final Map<String, Map<String, double>> totals = {
    STATUS_LOGGED: {},
    STATUS_INVOICED: {},
    STATUS_PAID: {},
    STATUS_LOGGED_DURATION: {},
    STATUS_INVOICED_DURATION: {},
    STATUS_PAID_DURATION: {},
  };

  final ChartDataGroup loggedData = ChartDataGroup(STATUS_LOGGED);
  final ChartDataGroup invoicedData = ChartDataGroup(STATUS_INVOICED);
  final ChartDataGroup paidData = ChartDataGroup(STATUS_PAID);

  final ChartDataGroup loggedDataDuration =
      ChartDataGroup(STATUS_LOGGED_DURATION);
  final ChartDataGroup invoicedDataDuration =
      ChartDataGroup(STATUS_INVOICED_DURATION);
  final ChartDataGroup paidDataDuration = ChartDataGroup(STATUS_PAID_DURATION);

  var date = convertSqlDateToDateTime(settings.startDate(company));
  final endDate = convertSqlDateToDateTime(settings.endDate(company));

  while (!date.isAfter(endDate)) {
    final key = convertDateTimeToSqlDate(date);
    if (totals[STATUS_LOGGED]!.containsKey(key)) {
      loggedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_LOGGED]![key]));
      invoicedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_INVOICED]![key]));
      paidData.rawSeries.add(ChartMoneyData(date, totals[STATUS_PAID]![key]));
    } else {
      loggedData.rawSeries.add(ChartMoneyData(date, 0.0));
      invoicedData.rawSeries.add(ChartMoneyData(date, 0.0));
      paidData.rawSeries.add(ChartMoneyData(date, 0.0));
    }

    if (settings.groupBy == kReportGroupDay) {
      date = date.add(Duration(days: 1));
    } else if (settings.groupBy == kReportGroupMonth) {
      date = DateTime(date.year, date.month + 1);
    } else if (settings.groupBy == kReportGroupYear) {
      date = DateTime(date.year + 1);
    }
  }

  final List<ChartDataGroup> data = [
    loggedData,
    invoicedData,
    paidData,
    loggedDataDuration,
    invoicedDataDuration,
    paidDataDuration,
  ];

  return data;
}

List<ChartDataGroup> chartExpenses(BuiltMap<String, CurrencyEntity> currencyMap,
    CompanyEntity company, DashboardUISettings settings) {
  const STATUS_LOGGED = 'logged';
  const STATUS_PENDING = 'pending';
  const STATUS_INVOICED = 'invoiced';
  const STATUS_PAID = 'invoice_paid';

  final Map<String, Map<String, double>> totals = {
    STATUS_LOGGED: {},
    STATUS_PENDING: {},
    STATUS_INVOICED: {},
    STATUS_PAID: {},
  };

  final ChartDataGroup loggedData = ChartDataGroup(STATUS_LOGGED);
  final ChartDataGroup pendingData = ChartDataGroup(STATUS_PENDING);
  final ChartDataGroup invoicedData = ChartDataGroup(STATUS_INVOICED);
  final ChartDataGroup paidData = ChartDataGroup(STATUS_PAID);

  var date = convertSqlDateToDateTime(settings.startDate(company));
  final endDate = convertSqlDateToDateTime(settings.endDate(company));

  while (!date.isAfter(endDate)) {
    final key = convertDateTimeToSqlDate(date);
    if (totals[STATUS_LOGGED]!.containsKey(key)) {
      loggedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_LOGGED]![key]));
      pendingData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_PENDING]![key]));
      invoicedData.rawSeries
          .add(ChartMoneyData(date, totals[STATUS_INVOICED]![key]));
      paidData.rawSeries.add(ChartMoneyData(date, totals[STATUS_PAID]![key]));
    } else {
      loggedData.rawSeries.add(ChartMoneyData(date, 0.0));
      pendingData.rawSeries.add(ChartMoneyData(date, 0.0));
      invoicedData.rawSeries.add(ChartMoneyData(date, 0.0));
      paidData.rawSeries.add(ChartMoneyData(date, 0.0));
    }

    if (settings.groupBy == kReportGroupDay) {
      date = date.add(Duration(days: 1));
    } else if (settings.groupBy == kReportGroupMonth) {
      date = DateTime(date.year, date.month + 1);
    } else if (settings.groupBy == kReportGroupYear) {
      date = DateTime(date.year + 1);
    }
  }

  final List<ChartDataGroup> data = [
    loggedData,
    pendingData,
    invoicedData,
    paidData,
  ];

  return data;
}

var memoizedChartExpenses = memo3((BuiltMap<String, CurrencyEntity> currencyMap,
        CompanyEntity? company, DashboardUISettings settings) =>
    chartExpenses(currencyMap, company!, settings));

var memoizedPreviousChartExpenses = memo3(
    (BuiltMap<String, CurrencyEntity> currencyMap, CompanyEntity? company,
            DashboardUISettings settings) =>
        chartExpenses(currencyMap, company!, settings));

// List<TaskEntity?> runningTasks(
//     BuiltMap<String, TaskEntity> taskMap, String userId) {
//   final tasks = <TaskEntity?>[];

//   taskMap.forEach((taskId, task) {
//     if (task.isRunning &&
//         !task.isDeleted! &&
//         (task.createdUserId == userId || task.assignedUserId == userId)) {
//       tasks.add(task);
//     }
//   });

//   return tasks;
// }
