import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_builder.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class SearchDetailScreen extends StatefulWidget {
  final QuestionModel question;
  final dynamic initialValue;

  const SearchDetailScreen({
    Key? key,
    required this.question,
    this.initialValue,
  }) : super(key: key);

  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late TextEditingController _controller;
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue is String || widget.initialValue == null) {
      _controller = TextEditingController(
        text: widget.initialValue?.toString() ?? '',
      );
    } else {
      _controller = TextEditingController();
    }

    _currentValue = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildInputField() {
    return buildSearchInputField(
      context,
      widget.question,
      _currentValue,
      (value) => setState(() => _currentValue = value),
      controller: _controller,
    );
  }

  void _handleSave() {
    Navigator.pop(context, _currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInputField(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('Apply Filter'),
        ),
      ],
    );

    if (!isMobile(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Filter: ${widget.question.label}',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Filter: ${widget.question.label}')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      );
    }
  }
}
