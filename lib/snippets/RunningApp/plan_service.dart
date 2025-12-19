import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plan_model.dart';

class PlanService {
  Future<List<Plan>> getPlans() async {
    // In a real app, this would fetch from an API or local storage
    final String response = await rootBundle.loadString('assets/lm/plans.json');
    final data = await json.decode(response);
    return (data['plans'] as List).map((plan) => Plan.fromJson(plan)).toList();
  }
}
