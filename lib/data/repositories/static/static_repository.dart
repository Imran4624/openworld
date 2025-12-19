// Dart imports:
import 'dart:async';
import 'dart:core';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/data/models/static/static_data_model.dart';
import 'package:flutter_boilerplate/data/web_client.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class StaticRepository {
  const StaticRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<StaticDataEntity> loadList(Credentials credentials) async {
    final dynamic response =
        await webClient.get(credentials.url + '/static', credentials.token);

    final StaticDataItemResponse staticDataResponse = serializers
        .deserializeWith(StaticDataItemResponse.serializer, response)!;

    return staticDataResponse.data;
  }
}
