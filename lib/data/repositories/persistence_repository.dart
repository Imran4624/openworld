// Dart imports:
import 'dart:convert';
import 'dart:core';
import 'dart:io';

// Project imports:
import 'package:flutter_boilerplate/data/file_storage.dart';
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/redux/auth/auth_state.dart';
import 'package:flutter_boilerplate/redux/company/company_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_state.dart';
import 'package:flutter_boilerplate/redux/static/static_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_state.dart';

// ignore: unused_import
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';

class PersistenceRepository {
  const PersistenceRepository({
    required this.fileStorage,
  });

  final FileStorage fileStorage;

  /*
  Future<File> saveCompanyState(UserCompanyState state) async {
    final dynamic data = await compute<dynamic, dynamic>(
        SerializationUtils.computeEncode,
        <dynamic>[UserCompanyState.serializer, state]);

    return await fileStorage.save(json.encode(data));
  }

  Future<UserCompanyState> loadCompanyState(int index) async {
    final String data = await fileStorage.load();

    final UserCompanyState companyState = await compute<dynamic, dynamic>(
        SerializationUtils.computeDecode,
        <dynamic>[UserCompanyState.serializer, json.decode(data)]);

    return companyState;
  }
   */

  Future<File?> saveCompanyState(UserCompanyState state) async {
    final data = serializers.serializeWith(UserCompanyState.serializer, state);

    return await fileStorage.save(json.encode(data));
  }

  Future<UserCompanyState?> loadCompanyState(int index) async {
    final String data = await fileStorage.load();
    final companyState = serializers.deserializeWith(
        UserCompanyState.serializer, json.decode(data));

    return companyState;

    //return compute(_deserialize, data);
  }

  Future<File?> saveAuthState(AuthState state) async {
    final data = serializers.serializeWith(AuthState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<AuthState?> loadAuthState() async {
    if (await fileStorage.exists()) {
      final String data = await fileStorage.load();
      return serializers.deserializeWith(
          AuthState.serializer, json.decode(data));
    } else {
      throw 'State does not exist on file';
    }
  }

  Future<File?> saveStaticState(StaticState state) async {
    final data = serializers.serializeWith(StaticState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<StaticState?> loadStaticState() async {
    final String data = await fileStorage.load();
    return serializers.deserializeWith(
        StaticState.serializer, json.decode(data));
  }

  Future<File?> saveUIState(UIState state) async {
    final data = serializers.serializeWith(UIState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<UIState?> loadUIState() async {
    final String data = await fileStorage.load();
    return serializers.deserializeWith(UIState.serializer, json.decode(data));
  }

  Future<File?> saveProfileState(ProfileState state) async {
    final data = serializers.serializeWith(ProfileState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<ProfileState?> loadProfileState() async {
    if (await fileStorage.exists()) {
      final String data = await fileStorage.load();
      return serializers.deserializeWith(
          ProfileState.serializer, json.decode(data));
    } else {
      throw 'Profile state does not exist on file';
    }
  }

  void delete() async {
    if (await fileStorage.exists()) {
      fileStorage.delete();
    }
  }

  Future<bool> exists() async {
    return await fileStorage.exists();
  }
}

/*
AppState _deserialize(String data) {
  return serializers.deserializeWith(AppState.serializer, json.decode(data));
}
*/
