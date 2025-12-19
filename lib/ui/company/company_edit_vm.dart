// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/ui/company/company_edit.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';

class CompanyEditScreen extends StatefulWidget {
  const CompanyEditScreen({super.key});
  static const String route = '/company_edit';

  @override
  State<CompanyEditScreen> createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends State<CompanyEditScreen> {
  Map<String, dynamic>? loadedCompanyData;
  bool isLoadingCompanyData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final UserCompany? companyToEdit =
        ModalRoute.of(context)?.settings.arguments as UserCompany?;

    if (companyToEdit != null &&
        loadedCompanyData == null &&
        !isLoadingCompanyData) {
      _loadCompanyData(companyToEdit.companyId);
    }
  }

  Future<void> _loadCompanyData(String companyId) async {
    setState(() {
      isLoadingCompanyData = true;
    });

    try {
      final completer = Completer<Map<String, dynamic>>();
      StoreProvider.of<AppState>(context).dispatch(
          LoadCompanyForEdit(companyId: companyId, completer: completer));

      final data = await completer.future;
      setState(() {
        loadedCompanyData = data;
        isLoadingCompanyData = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCompanyData = false;
      });
      if (mounted) {
        showToast(
          'Failed to load company data: $e',
          context: context,
          backgroundColor: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserCompany? companyToEdit =
        ModalRoute.of(context)?.settings.arguments as UserCompany?;

    if (companyToEdit != null && isLoadingCompanyData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Company...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return StoreConnector<AppState, CompanyEditVM>(
      distinct: true,
      converter: (Store<AppState> store) {
        return CompanyEditVM.fromStore(store, companyToEdit, loadedCompanyData);
      },
      builder: (context, viewModel) {
        return CompanyEdit(
          viewModel: viewModel,
          key: ValueKey(companyToEdit?.companyId ?? 'new_company'),
        );
      },
    );
  }
}

class CompanyEditVM {
  CompanyEditVM({
    required this.state,
    required this.company,
    required this.isLoading,
    required this.isSaving,
    required this.onPickLogo,
    required this.onSavePressed,
    required this.onCancelPressed,
    this.selectedLogo,
    this.selectedFrom,
    this.nameController,
    this.apiKeyController,
    this.existingLogoUrl,
  });

  factory CompanyEditVM.fromStore(Store<AppState> store,
      [UserCompany? companyToEdit, Map<String, dynamic>? loadedCompanyData]) {
    final state = store.state;

    final company = companyToEdit != null
        ? CompanyEntity().rebuild((b) => b
          ..id = companyToEdit.companyId
          ..settings.name = companyToEdit.companyName)
        : CompanyEntity().rebuild((b) => b
          ..id = ''
          ..settings.name = '');

    final nameController = TextEditingController(
        text: companyToEdit?.companyName ??
            '' 
        );
    final apiKeyController = TextEditingController(
        text: loadedCompanyData?['apiKey'] ??
            '' 
        );

    String? selectedFrom;
    if (loadedCompanyData != null &&
        loadedCompanyData['importFrom'] != null &&
        loadedCompanyData['importFrom'].isNotEmpty) {
      selectedFrom = loadedCompanyData['importFrom'];
    }

    String? existingLogoUrl;
    if (loadedCompanyData != null && loadedCompanyData['companyLogo'] != null) {
      existingLogoUrl = loadedCompanyData['companyLogo'];
    }

    return CompanyEditVM(
      state: state,
      company: company,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      nameController: nameController,
      apiKeyController: apiKeyController,
      selectedFrom: selectedFrom,
      existingLogoUrl: existingLogoUrl,
      onPickLogo: () async {
        try {
          final images =
              await PhotoUploadHelper.pickImages(allowMultiple: false);

          if (images.isNotEmpty) {
            final image = images.first;
            return {
              'name': image['name'],
              'bytes': image['bytes'],
              'size': image['size'],
              'type': image['type'],
            };
          }
        } catch (e) {
          rethrow;
        }
        return null;
      },
      onSavePressed: (
        BuildContext context, {
        required String companyName,
        required String? apiKey,
        required String? from,
        Map<String, dynamic>? logoFile,
      }) async {
        Debouncer.runOnComplete(() async {
          try {
            if (companyName.trim().isEmpty) {
              if (context.mounted) {
                showToast(
                  'Company name is required',
                  context: context,
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                );
              }
              return;
            }

            final completer = Completer<void>();

            final companyData = {
              'name': companyName.trim(),
              'apiKey': apiKey?.trim(),
              'importFrom': from,
              'logoFile': logoFile,
              'createdUserId': store.state.authState.currentUserId,
            };

            store.dispatch(AddCompany(
              context: context,
              completer: completer,
              companyData: companyData,
              company: companyToEdit != null
                  ? CompanyEntity()
                      .rebuild((b) => b..id = companyToEdit.companyId)
                  : null, 
            ));

            await completer.future;

            if (context.mounted) {
              showToast(
                companyToEdit != null
                    ? 'Company updated successfully!'
                    : 'Company created successfully!',
                context: context,
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
              );

              if (isMobile(context)) {
                Navigator.of(context).pop();
              } else {
                final store = StoreProvider.of<AppState>(context);
                viewEntitiesByType(entityType: EntityType.event);
                store.dispatch(ViewMainScreen());
              }
            }
          } catch (e) {
            if (context.mounted) {
              showToast(
                companyToEdit != null
                    ? 'Error updating company: $e'
                    : 'Error creating company: $e',
                context: context,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(color: Colors.white),
              );
            }
          }
        });
      },
      onCancelPressed: (BuildContext context) {
        if (isMobile(context)) {
          Navigator.of(context).pop();
        } else {
          final store = StoreProvider.of<AppState>(context);
          viewEntitiesByType(entityType: EntityType.event);
          store.dispatch(ViewMainScreen());
        }
      },
    );
  }

  final AppState state;
  final CompanyEntity company;
  final bool isLoading;
  final bool isSaving;
  final Map<String, dynamic>? selectedLogo;
  final String? selectedFrom;
  final String? existingLogoUrl;
  final TextEditingController? nameController;
  final TextEditingController? apiKeyController;
  final Future<Map<String, dynamic>?> Function() onPickLogo;
  final Function(
    BuildContext context, {
    required String companyName,
    required String? apiKey,
    required String? from,
    Map<String, dynamic>? logoFile,
  }) onSavePressed;
  final Function(BuildContext context) onCancelPressed;

  List<String> get fromOptions => [
        'eventBrite',
        'ticketTailer',
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyEditVM &&
          runtimeType == other.runtimeType &&
          company.id == other.company.id &&
          isLoading == other.isLoading &&
          isSaving == other.isSaving &&
          selectedFrom == other.selectedFrom &&
          existingLogoUrl == other.existingLogoUrl &&
          nameController?.text == other.nameController?.text &&
          apiKeyController?.text == other.apiKeyController?.text;

  @override
  int get hashCode =>
      company.id.hashCode ^
      isLoading.hashCode ^
      isSaving.hashCode ^
      selectedFrom.hashCode ^
      existingLogoUrl.hashCode ^
      (nameController?.text.hashCode ?? 0) ^
      (apiKeyController?.text.hashCode ?? 0);
}
