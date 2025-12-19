import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationField extends StatefulWidget {
  const LocationField({
    Key? key,
    required this.question,
    required this.initialValue,
    required this.updateAnswer,
    this.controller,
    this.showBorder,
    this.customHint,
    this.customLabel,
    this.textStyle,
  }) : super(key: key);

  final QuestionModel question;
  final dynamic initialValue;
  final void Function(dynamic) updateAnswer;
  final TextEditingController? controller;
  final bool? showBorder;
  final String? customHint;
  final String? customLabel;
  final TextStyle? textStyle;

  @override
  _LocationFieldState createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  late TextEditingController _controller;
  final ValueNotifier<List<Map<String, dynamic>>> _suggestions =
      ValueNotifier([]);
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(
            text: widget.initialValue?['name']?.toString() ?? '');
  }

  Future<void> _getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      _suggestions.value = [];
      return;
    }

    setState(() => _isLoading = true);

    try {
      const apiKey = kGoogleApiKey;
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['predictions'] != null) {
        _suggestions.value = (data['predictions'] as List).map((prediction) {
          return {
            'placeId': prediction['place_id'],
            'description': prediction['description'],
          };
        }).toList();

        printL('Suggestions updated: ${_suggestions.value.length}');
      }
    } catch (e) {
      debugPrint('Error getting suggestions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      const apiKey = kGoogleApiKey;
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry,formatted_address&key=$apiKey');

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['result'] != null) {
        final result = {
          'name': data['result']['formatted_address'],
          'lat': data['result']['geometry']['location']['lat'],
          'lng': data['result']['geometry']['location']['lng'],
        };
        _controller.text = result['name'].toString();
        widget.updateAnswer(result);
        _suggestions.value = [];
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.customLabel != null || widget.question.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.customLabel ?? widget.question.label,
                style: widget.textStyle,
              ),
            ),
          CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: widget.showBorder == true
                    ? Border.all(color: appTheme.defaultColor)
                    : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        hintText: widget.customHint ?? 'Search location',
                        suffixIcon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (value == _controller.text) {
                            _getPlaceSuggestions(value);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: _suggestions,
            builder: (context, suggestions, _) {
              if (suggestions.isEmpty) return const SizedBox();

              return Container(
                margin: const EdgeInsets.only(top: 4),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: appTheme.transparent,
                  border: Border.all(color: appTheme.defaultColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Material(
                  color: appTheme.transparent,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return InkWell(
                        onTap: () {
                          _getPlaceDetails(
                              suggestion['placeId']?.toString() ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            suggestion['description']?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
