// Project imports:
import 'package:flutter_boilerplate/data/models/serializers.dart';

class SerializationUtils {
  static dynamic deserializeWith(dynamic list) {
    return serializers.deserializeWith<dynamic>(list[0], list[1]);
  }

  static dynamic serializeWith(dynamic list) {
    return serializers.serializeWith<dynamic>(list[0], list[1]);
  }
}
