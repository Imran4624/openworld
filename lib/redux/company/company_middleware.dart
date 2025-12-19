// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/repositories/company_repository.dart';
import 'package:flutter_boilerplate/data/repositories/profile_repository.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

List<Middleware<AppState>> createStoreCompanyMiddleware([
  CompanyRepository repository = const CompanyRepository(),
  ProfileRepository profileRepository = const ProfileRepository(),
]) {
  final addCompany = _addCompany(repository);
  final loadCompanyForEdit = _loadCompanyForEdit(repository);
  final loadCompanies = _loadAllCompanies(profileRepository);
  final loadCompaniesByIds = _loadCompaniesByIds(profileRepository);

  return [
    TypedMiddleware<AppState, AddCompany>(addCompany),
    TypedMiddleware<AppState, LoadCompanyForEdit>(loadCompanyForEdit),
    TypedMiddleware<AppState, LoadAllCompanies>(loadCompanies),
    TypedMiddleware<AppState, LoadCompaniesByIds>(loadCompaniesByIds),
  ];
}

Middleware<AppState> _addCompany(CompanyRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) async {
    final action = dynamicAction as AddCompany;

    next(action);

    try {
      
      if (action.companyData == null) {
        throw Exception('Company data is required');
      }

      if (action.company != null && !action.company!.isNew) {
        final updatedCompany = await repository.updateCompany(
          companyId: action.company!.id,
          companyData: action.companyData!,
        );
        
        store.dispatch(SaveCompanySuccess(updatedCompany));
      } else {
        final createdCompany = await repository.createCompany(
          companyData: action.companyData!,
        );

        store.dispatch(AddCompanySuccess(company: createdCompany));
      }
      
      if (action.completer != null) {
        action.completer!.complete();
      }
    } catch (e) {
      logError('Error in AddCompany middleware: $e');
      
      store.dispatch(AddCompanyFailure(e));
      
      if (action.completer != null) {
        action.completer!.completeError(e);
      }
    }
  };
}

Middleware<AppState> _loadCompanyForEdit(CompanyRepository repository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) async {
    final action = dynamicAction as LoadCompanyForEdit;

    next(action);

    try {
      
      final companyData = await repository.getCompanyWithImportData(
        companyId: action.companyId,
      );

      store.dispatch(LoadCompanyForEditSuccess(companyData: companyData));
      
      if (action.completer != null) {
        action.completer!.complete(companyData);
      }
    } catch (e) {
      logError('Error in LoadCompanyForEdit middleware: $e');
      
      store.dispatch(LoadCompanyForEditFailure(e));
      
      if (action.completer != null) {
        action.completer!.completeError(e);
      }
    }
  };
}

Middleware<AppState> _loadAllCompanies(ProfileRepository profileRepository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadAllCompanies;

    profileRepository
        .loadAllCompanies()
        .then((companyEntities) {
      final Map<String, String> companies = {};
      for (final company in companyEntities) {
        final companyName = company.settings.name ?? 'Unknown Company';
        companies[companyName] = company.id;
      }
      
      store.dispatch(LoadCompaniesSuccess(companies: companies));
      if (action.completer != null) {
        action.completer!.complete(companies);
      }
    }).catchError((Object error) {
      logError('Error in loadCompanies middleware: $error');
      store.dispatch(LoadCompaniesFailure(error: error));
      if (action.completer != null) {
        action.completer!.completeError(error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _loadCompaniesByIds(ProfileRepository profileRepository) {
  return (Store<AppState> store, dynamic dynamicAction, NextDispatcher next) {
    final action = dynamicAction as LoadCompaniesByIds;

    profileRepository
        .loadCompaniesByIds(action.companyIds)
        .then((companies) {
      store.dispatch(LoadCompaniesByIdsSuccess(
        companies: companies,
      ));
      if (action.completer != null) {
        action.completer!.complete(companies);
      }
    }).catchError((Object error) {
      logError('Error in loadCompaniesByIds middleware: $error');
      store.dispatch(LoadCompaniesByIdsFailure(error: error));
      if (action.completer != null) {
        action.completer!.completeError(error);
      }
    });

    next(action);
  };
}
