// Flutter imports:
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/forms/app_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/forms/decorated_form_field.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';

class CompanyEditScreen extends StatefulWidget {
  const CompanyEditScreen({super.key});

  static const String route = '/company_edit';

  @override
  _CompanyEditScreenState createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends State<CompanyEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  String? _selectedFrom;
  File? _selectedLogo;
  bool _isLoading = false;

  final List<String> _fromOptions = [
    'eventBrite',
    'ticketTailer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedLogo = File(result.files.single.path!);
        });
      }
    } catch (e) {
      showToast(
        'Error picking image: $e',
        context: context,
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
      );
    }
  }

  Future<String?> _uploadLogo(String companyId) async {
    if (_selectedLogo == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('companies')
          .child(companyId)
          .child('logo.jpg');

      final uploadTask = await storageRef.putFile(_selectedLogo!);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      showToast(
        'Error uploading logo: $e',
        context: context,
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
      );
      return null;
    }
  }

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final docRef = FirebaseFirestore.instance.collection('companies').doc();
      final companyId = docRef.id;
      String? logoUrl;
      if (_selectedLogo != null) {
        logoUrl = await _uploadLogo(companyId);
      }

      final companyData = {
        'name': _nameController.text.trim(),
        'logo': logoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final importData = {
        'from': _selectedFrom,
        'apiKey': _apiKeyController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      final batch = FirebaseFirestore.instance.batch();
      batch.set(docRef, companyData);
      
      if (_selectedFrom != null && _apiKeyController.text.trim().isNotEmpty) {
        final importDocRef = docRef.collection('importData').doc();
        batch.set(importDocRef, importData);
      }

      await batch.commit();

      showToast(
        'Company created successfully!',
        context: context,
        backgroundColor: Colors.green,
        textStyle: const TextStyle(color: Colors.white),
      );

      // Navigate back
      Navigator.of(context).pop();
    } catch (e) {
      showToast(
        'Error saving company: $e',
        context: context,
        backgroundColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditScaffold(
      entity: null,
      title: 'Add Company',
      onSavePressed: _isLoading ? null : (context) => _saveCompany(),
      isFullscreen: true,
      body: Form(
        key: _formKey,
        child: ScrollableListView(
          children: [
            FormCard(
              children: [
                DecoratedFormField(
                  controller: _nameController,
                  label: 'Company Name',
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
                        'Company Logo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (_selectedLogo != null) ...[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedLogo!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton(
                        onPressed: _pickLogo,
                        child: Text(_selectedLogo == null ? 'Select Logo' : 'Change Logo'),
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
                  'Import Data Configuration',
                  style: Theme.of(context).textTheme.titleLarge,
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
                  items: _fromOptions
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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _saveCompany(),
                child: Text(_isLoading ? 'Saving...' : 'Save Company'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
