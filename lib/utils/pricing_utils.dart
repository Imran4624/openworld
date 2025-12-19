import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';

class PriceEvaluationResult {
  final bool success;
  final String message;

  PriceEvaluationResult({required this.success, required this.message});
}

class PricingRules {
  final List<RulePlan> rules;

  PricingRules({required this.rules});

  factory PricingRules.fromJson(Map<String, dynamic> json) {
    return PricingRules(
      rules: (json['pricingRules']['rules'] as List)
          .map((r) => RulePlan.fromJson(r))
          .toList(),
    );
  }

  RulePlan? getPlan(String planName) {
    try {
      return rules.firstWhere(
        (r) => r.planName.toLowerCase() == planName.toLowerCase(),
      );
    } catch (e) {
      throw Exception("Plan not found: $planName");
    }
  }
}

class RulePlan {
  final String planName;
  final String billingType;
  final DateTime startDate;
  final DateTime endDate;
  final List<EntityRule> entities;

  RulePlan({
    required this.planName,
    required this.billingType,
    required this.startDate,
    required this.endDate,
    required this.entities,
  });

  factory RulePlan.fromJson(Map<String, dynamic> json) {
    return RulePlan(
      planName: json['planName'],
      billingType: json['billingType'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      entities: (json['entities'] as List)
          .map((e) => EntityRule.fromJson(e))
          .toList(),
    );
  }

  EntityRule? getEntityRule(String entityType) {
    try {
      return entities.firstWhere(
        (e) => e.entityType.toLowerCase() == entityType.toLowerCase(),
      );
    } catch (e) {
      throw Exception("Entity not found: $entityType");
    }
  }
}

class EntityRule {
  final String entityType;
  final Map<String, dynamic> rules;

  EntityRule({
    required this.entityType,
    required this.rules,
  });

  factory EntityRule.fromJson(Map<String, dynamic> json) {
    return EntityRule(
      entityType: json['entityType'],
      rules: json['rules'],
    );
  }
}

class PricingEvaluator {
  final PricingRules pricingRules;
  final String currentPlan;

  PricingEvaluator({required this.pricingRules, required this.currentPlan});

  RulePlan get _plan => pricingRules.getPlan(currentPlan)!;

  PriceEvaluationResult canCreateEvent(int currentEventCount) {
    final entity = _plan.getEntityRule("event")!;
    final maxCreate = entity.rules["maxCreate"];

    if (currentEventCount >= maxCreate) {
      return PriceEvaluationResult(
        success: false,
        message: "You have reached your allowed event creation limit.",
      );
    }

    return PriceEvaluationResult(success: true, message: "Allowed");
  }

  PriceEvaluationResult canShareEvent() {
    final entity = _plan.getEntityRule("event")!;
    final caps = entity.rules["capabilities"];

    if (caps["shareEnabled"] == true) {
      return PriceEvaluationResult(success: true, message: "Allowed");
    }

    return PriceEvaluationResult(
      success: false,
      message: "Sharing is not enabled for your plan.",
    );
  }

  PriceEvaluationResult canGuestUpload() {
    final entity = _plan.getEntityRule("event")!;
    final caps = entity.rules["capabilities"];

    if (caps["guestUploads"] == true) {
      return PriceEvaluationResult(success: true, message: "Allowed");
    }

    return PriceEvaluationResult(
      success: false,
      message:
          "Guest uploads are not enabled for your plan. Upgrade to enable guest uploads.",
    );
  }

  PriceEvaluationResult canSendMatch(int matchesToday) {
    final entity = _plan.getEntityRule("dating")!;
    final limit = entity.rules["dailyMatchLimit"];

    if (matchesToday >= limit) {
      return PriceEvaluationResult(
        success: false,
        message: "You have reached your daily match limit.",
      );
    }

    return PriceEvaluationResult(success: true, message: "Allowed");
  }

  bool get isFreePlan => currentPlan.toLowerCase() == "free";
  bool get isPaidPlan => currentPlan.toLowerCase() == "paid";

  String getUpgradeMessage() {
    if (isFreePlan) {
      return "Upgrade to unlock guest uploads, sharing, and unlimited events for £${ProjectConfig.guestLandingPagePrice}.";
    }
    return "";
  }

  String getGuestEventMessage() {
    if (isFreePlan) {
      return "This event is not paid. Guest features are limited.";
    }
    return "";
  }

  static PricingEvaluator forLoopjam(String userPlan) {
    final rules = PricingRules.fromJson(ProjectConfig.pricingRulesJson);
    return PricingEvaluator(pricingRules: rules, currentPlan: userPlan);
  }
}

class PricingUtils {
  static String getUserPlan(AppState? state) {
    if (state == null || !isAuthenticated(state)) {
      return "free";
    }

    final paymentStatus = state.profileState.loggedInUserProfile.paymentStatus;
    if (paymentStatus == null || paymentStatus.isEmpty) {
      return "free";
    }

    return paymentStatus.toLowerCase();
  }

  static String? getAdminStripeAccountId(AppState? state) {
    if (state == null) {
      return null;
    }

    // Hardcoded Stripe Connect account ID for Loopjam (temporary)
    // TODO: Replace with dynamic admin account lookup when admin access is available
    return 'acct_1ScV8jIcmtG2wz4C';
  }  
  static PricingEvaluator? getEvaluatorForCurrentApp(String userPlan) {
    return PricingEvaluator.forLoopjam(userPlan);
  }

  static PriceEvaluationResult canUserCreateEvent(
      AppState? state, int currentEventCount) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return PriceEvaluationResult(success: true, message: "No restrictions");
    }
    return evaluator.canCreateEvent(currentEventCount);
  }

  static PriceEvaluationResult canUserEnableGuestUploads(AppState? state) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return PriceEvaluationResult(success: true, message: "No restrictions");
    }
    return evaluator.canGuestUpload();
  }

  static PriceEvaluationResult canUserShareEvent(AppState? state) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return PriceEvaluationResult(success: true, message: "No restrictions");
    }
    return evaluator.canShareEvent();
  }

  static String getUpgradeMessage(AppState? state) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return "";
    }
    return evaluator.getUpgradeMessage();
  }

  static String getGuestEventMessage(AppState? state) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return "";
    }
    return evaluator.getGuestEventMessage();
  }

  static bool isUserOnFreePlan(AppState? state) {
    final evaluator = getEvaluatorForCurrentApp(getUserPlan(state));
    if (evaluator == null) {
      return false;
    }
    return evaluator.isFreePlan;
  }

  static String get stripeGuestLandingPagePriceId =>
      ProjectConfig.stripeGuestLandingPagePriceId;

  static double get guestLandingPagePrice =>
      ProjectConfig.guestLandingPagePrice;

  static bool shouldTriggerPaymentForShare(AppState? state) {
    return isUserOnFreePlan(state);
  }

  static bool shouldTriggerPaymentForGuestUploads(AppState? state) {
    return isUserOnFreePlan(state);
  }

  static bool shouldTriggerPaymentForEventCreation(AppState? state, int currentEventCount) {
    final result = canUserCreateEvent(state, currentEventCount);
    return !result.success;
  }

  static String getPaymentButtonText(String feature) {
    switch (feature.toLowerCase()) {
      case 'share':
        return 'Unlock Sharing for £${guestLandingPagePrice.toStringAsFixed(0)}';
      case 'guest_uploads':
      case 'photos':
        return 'Unlock Guest Uploads for £${guestLandingPagePrice.toStringAsFixed(0)}';
      case 'event_creation':
        return 'Unlock Unlimited Events for £${guestLandingPagePrice.toStringAsFixed(0)}';
      default:
        return 'Upgrade for £${guestLandingPagePrice.toStringAsFixed(0)}';
    }
  }

  static String getPaymentDescription(String feature) {
    switch (feature.toLowerCase()) {
      case 'share':
        return 'Unlock sharing, guest uploads, and unlimited events';
      case 'guest_uploads':
      case 'photos':
        return 'Unlock guest uploads, sharing, and unlimited events';
      case 'event_creation':
        return 'Unlock unlimited events, guest uploads, and sharing';
      default:
        return 'Unlock all premium features';
    }
  }
}
