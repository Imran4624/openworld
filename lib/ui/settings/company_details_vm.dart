// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/company_model.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/settings_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/settings/company_details.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({Key? key}) : super(key: key);
  static const String route = '/$kSettings/$kSettingsCompanyDetails';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CompanyDetailsVM>(
      converter: CompanyDetailsVM.fromStore,
      builder: (context, viewModel) {
        return CompanyDetails(
            key: ValueKey(viewModel.state.settingsUIState.updatedAt),
            viewModel: viewModel);
      },
    );
  }
}

class CompanyDetailsVM {
  CompanyDetailsVM({
    required this.state,
    required this.settings,
    required this.company,
    required this.onCompanyChanged,
    required this.onSettingsChanged,
    required this.onSavePressed,
    required this.onUploadLogo,
    required this.onDeleteLogo,
    required this.onUploadDocuments,
  });

  static CompanyDetailsVM fromStore(Store<AppState> store) {
    final state = store.state;

    return CompanyDetailsVM(
      state: state,
      settings: state.uiState.settingsUIState.settings,
      company: state.uiState.settingsUIState.company,
      onSettingsChanged: (settings) =>
          store.dispatch(UpdateSettings(settings: settings)),
      onCompanyChanged: (company) =>
          store.dispatch(UpdateCompany(company: company)),
      onDeleteLogo: (context) {
        final settingsUIState = state.uiState.settingsUIState;
        switch (settingsUIState.entityType) {
          case EntityType.company:
            final completer = snackBarCompleter<Null>(
                AppLocalization.of(context)!.deletedLogo);
            store.dispatch(SaveCompanyRequest(
              completer: completer,
              company: settingsUIState.company
                  .rebuild((b) => b..settings.companyLogo = null),
            ));
            break;
        }
      },
      onSavePressed: (context) {
        Debouncer.runOnComplete(() {
          final settingsUIState = store.state.uiState.settingsUIState;
          if (settingsUIState.entityType == EntityType.company &&
              settingsUIState.company.settings.countryId == null) {
            showErrorDialog(
                message: AppLocalization.of(context)!.pleaseSelectACountry);
            return;
          }
          switch (settingsUIState.entityType) {
            case EntityType.company:
              final completer = snackBarCompleter<Null>(
                  AppLocalization.of(context)!.savedSettings);
              store.dispatch(SaveCompanyRequest(
                  completer: completer, company: settingsUIState.company));
              break;
          }
        });
      },
      onUploadLogo: (context, multipartFile) {
        final type = state.uiState.settingsUIState.entityType;
        final completer =
            snackBarCompleter<Null>(AppLocalization.of(context)!.uploadedLogo);
        store.dispatch(UploadLogoRequest(
            completer: completer, multipartFile: multipartFile, type: type));
      },
      onUploadDocuments: (BuildContext context,
          List<MultipartFile> multipartFile, bool isPrivate) {
        // final completer = Completer<List<DocumentEntity>>();
        // store.dispatch(SaveCompanyDocumentRequest(
        //     isPrivate: isPrivate,
        //     multipartFiles: multipartFile,
        //     completer: completer));
        // completer.future.then((client) {
        //   showToast(AppLocalization.of(context)!.uploadedDocument);
        // }).catchError((Object error) {
        //   showDialog<ErrorDialog>(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return ErrorDialog(error);
        //       });
        // });
      },
    );
  }

  final AppState state;
  final CompanyEntity company;
  final SettingsEntity settings;
  final Function(SettingsEntity) onSettingsChanged;
  final Function(CompanyEntity) onCompanyChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext, MultipartFile) onUploadLogo;
  final Function(BuildContext) onDeleteLogo;
  final Function(BuildContext, List<MultipartFile>, bool) onUploadDocuments;
}
