// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/serializers.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/responsive_padding.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class StateInspector extends StatefulWidget {
  @override
  _StateInspectorState createState() => _StateInspectorState();
}

class _StateInspectorState extends State<StateInspector> {
  String _filter = '';

  dynamic filterJson({dynamic data, required String filter}) {
    filter.split('.')
      ..removeLast()
      ..forEach((part) {
        String pattern = '';
        part.split('').forEach((ch) => pattern += ch.toLowerCase() + '.*');

        final regExp = RegExp(pattern, caseSensitive: false);
        final dynamic index = (data as Map).keys.firstWhere(
            (dynamic key) => regExp.hasMatch(key),
            orElse: () => null);

        if (index != null) {
          data = data[index];
        }
      });

    if (data.runtimeType.toString() ==
        '_InternalLinkedHashMap<String, Object>') {
      return data;
    } else {
      return <String, dynamic>{'value': data};
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of<AppState>(context).state;
    final data = serializers.serializeWith(AppState.serializer, state);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Material(
        child: ResponsivePadding(
          child: ScrollableListView(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: AppLocalization.of(context)!.filter,
                ),
                onChanged: (value) {
                  setState(() {
                    _filter = value;
                  });
                },
              ),
              SizedBox(height: 25),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: JsonViewer(
                  filterJson(data: data, filter: _filter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
