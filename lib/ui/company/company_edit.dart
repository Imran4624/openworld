// Flutter imports:
import 'package:flutter/material.dart';
import 'dart:typed_data';

// Project imports:
import 'package:flutter_boilerplate/ui/app/forms/app_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/forms/decorated_form_field.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/company/company_edit_vm.dart';

class CompanyEdit extends StatefulWidget {
  const CompanyEdit({
    super.key,
    required this.viewModel,
  });

  final CompanyEditVM viewModel;

  @override
  _CompanyEditState createState() => _CompanyEditState();
}

class _CompanyEditState extends State<CompanyEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _apiKeyController;

  String? _selectedFrom;
  Map<String, dynamic>? _selectedLogo;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
        text: widget.viewModel.nameController?.text ?? '');
    _apiKeyController = TextEditingController(
        text: widget.viewModel.apiKeyController?.text ?? '');
    _selectedFrom = widget.viewModel.selectedFrom;
  }

  @override
  void didUpdateWidget(CompanyEdit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel.nameController?.text !=
        oldWidget.viewModel.nameController?.text) {
      _nameController.text = widget.viewModel.nameController?.text ?? '';
    }

    if (widget.viewModel.apiKeyController?.text !=
        oldWidget.viewModel.apiKeyController?.text) {
      _apiKeyController.text = widget.viewModel.apiKeyController?.text ?? '';
    }

    if (widget.viewModel.selectedFrom != oldWidget.viewModel.selectedFrom) {
      setState(() {
        _selectedFrom = widget.viewModel.selectedFrom;
      });
    }

    if (widget.viewModel.existingLogoUrl !=
            oldWidget.viewModel.existingLogoUrl &&
        widget.viewModel.existingLogoUrl != null &&
        _selectedLogo == null) {
      setState(() {
        _selectedLogo = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      final logoFile = await widget.viewModel.onPickLogo();
      if (logoFile != null) {
        setState(() {
          _selectedLogo = logoFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.viewModel.onSavePressed(
      context,
      companyName: _nameController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      from: _selectedFrom,
      logoFile: _selectedLogo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditScaffold(
      entity: widget.viewModel.company,
      title: widget.viewModel.company.isNew ? 'Add Company' : 'Edit Company',
      onSavePressed:
          widget.viewModel.isSaving ? null : (context) => _onSavePressed(),
      onCancelPressed: widget.viewModel.onCancelPressed,
      isFullscreen: true,
      body: Form(
        key: _formKey,
        child: ScrollableListView(
          children: [
            FormCard(
              children: [
                DecoratedFormField(
                  controller: _nameController,
                  label: 'Company Name *',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Company name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Company Logo (Optional)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Text(
                        'Upload a company logo (this can be added later)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedLogo != null ||
                          widget.viewModel.existingLogoUrl != null) ...[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _selectedLogo != null
                                ? Image.memory(
                                    _selectedLogo!['bytes'] as Uint8List,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    widget.viewModel.existingLogoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.business,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton(
                        onPressed: _pickLogo,
                        child: Text(_selectedLogo == null &&
                                widget.viewModel.existingLogoUrl == null
                            ? 'Select Logo'
                            : 'Change Logo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormCard(
              children: [
                Text(
                  'Import Data Configuration (Optional)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text(
                  'Configure import data settings if needed (can be added later)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                AppDropdownButton<String>(
                  labelText: 'From',
                  value: _selectedFrom,
                  onChanged: (value) {
                    setState(() {
                      _selectedFrom = value;
                    });
                  },
                  items: widget.viewModel.fromOptions
                      .map((option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  showBlank: true,
                  blankValue: null,
                ),
                const SizedBox(height: 16),
                DecoratedFormField(
                  controller: _apiKeyController,
                  label: 'API Key',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _selectedFrom != null
                      ? (value) {
                          if (value.isEmpty) {
                            return 'API Key is required when From is selected';
                          }
                          return null;
                        }
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (widget.viewModel.isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
