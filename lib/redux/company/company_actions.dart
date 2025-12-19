// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';

class ClearClientMultiselect {
  @override
  String toString() {
    return 'ClearClientMultiselect';
  }
}

class SelectCompany implements ClearClientMultiselect {
  SelectCompany({
    required this.companyIndex,
    this.clearSelection = true,
  });

  final int companyIndex;
  final bool clearSelection;

  @override
  String toString() {
    return 'SelectCompany';
  }
}

class SelectCompanyById {
  SelectCompanyById({
    required this.companyId,
  });

  final String companyId;

  @override
  String toString() {
    return 'SelectCompanyById{companyId: $companyId}';
  }
}

class LoadCompanySuccess {
  LoadCompanySuccess(this.userCompany);

  final UserCompanyEntity userCompany;

  @override
  String toString() {
    return 'LoadCompanySuccess';
  }
}

class UpdateCompany implements PersistUI {
  UpdateCompany({required this.company});

  final CompanyEntity company;

  @override
  String toString() {
    return 'UpdateCompany';
  }
}

class SaveCompanyRequest implements StartSaving {
  SaveCompanyRequest({
    this.completer,
    this.company,
  });

  final Completer? completer;
  final CompanyEntity? company;

  @override
  String toString() {
    return 'SaveCompanyRequest';
  }
}

class SaveCompanySuccess implements StopSaving, PersistData, PersistUI {
  SaveCompanySuccess(this.company);

  final CompanyEntity company;

  @override
  String toString() {
    return 'SaveCompanySuccess';
  }
}

class SaveCompanyFailure implements StopSaving {
  SaveCompanyFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveCompanyFailure{error: $error}';
  }
}

class SaveEInvoiceCertificateRequest implements StartSaving {
  SaveEInvoiceCertificateRequest({
    required this.completer,
    required this.company,
    required this.eInvoiceCertificate,
  });

  final Completer completer;
  final CompanyEntity company;
  final MultipartFile eInvoiceCertificate;

  @override
  String toString() {
    return 'SaveEInvoiceCertificateRequest';
  }
}

class SaveEInvoiceCertificateSuccess
    implements StopSaving, PersistData, PersistUI {
  SaveEInvoiceCertificateSuccess(this.company);

  final CompanyEntity company;

  @override
  String toString() {
    return 'SaveEInvoiceCertificateSuccess';
  }
}

class SaveEInvoiceCertificateFailure implements StopSaving {
  SaveEInvoiceCertificateFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveEInvoiceCertificateFailure{error: $error}';
  }
}

class AddCompany implements StartSaving {
  AddCompany({this.context, this.completer, this.companyData, this.company});

  final BuildContext? context;
  final Completer? completer;
  final Map<String, dynamic>? companyData;
  final CompanyEntity? company; 

  @override
  String toString() {
    return 'AddCompany';
  }
}

class AddCompanySuccess implements StopSaving {
  AddCompanySuccess({required this.company});

  final CompanyEntity company;

  @override
  String toString() {
    return 'AddCompanySuccess{companyId: ${company.id}}';
  }
}

class AddCompanyFailure implements StopSaving {
  AddCompanyFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'AddCompanyFailure{error: $error}';
  }
}

class LoadCompanyForEdit implements StartLoading {
  LoadCompanyForEdit({required this.companyId, this.completer});

  final String companyId;
  final Completer? completer;

  @override
  String toString() {
    return 'LoadCompanyForEdit{companyId: $companyId}';
  }
}

class LoadCompanyForEditSuccess implements StopLoading {
  LoadCompanyForEditSuccess({required this.companyData});

  final Map<String, dynamic> companyData;

  @override
  String toString() {
    return 'LoadCompanyForEditSuccess{companyId: ${companyData['companyId']}}';
  }
}

class LoadCompanyForEditFailure implements StopLoading {
  LoadCompanyForEditFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'LoadCompanyForEditFailure{error: $error}';
  }
}



class DeleteCompanyRequest implements StartSaving {
  DeleteCompanyRequest({
    required this.completer,
    required this.password,
    required this.idToken,
    required this.reason,
  });

  final Completer completer;
  final String password;
  final String idToken;
  final String reason;

  @override
  String toString() {
    return 'DeleteCompanyRequest';
  }
}

class DeleteCompanySuccess implements StopSaving, PersistData {
  @override
  String toString() {
    return 'DeleteCompanySuccess';
  }
}

class DeleteCompanyFailure implements StopSaving {
  DeleteCompanyFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'DeleteCompanyFailure{error: $error}';
  }
}

class PurgeDataRequest implements StartSaving {
  PurgeDataRequest({
    required this.completer,
    required this.password,
    required this.idToken,
  });

  final Completer completer;
  final String password;
  final String idToken;

  @override
  String toString() {
    return 'PurgeDataRequest';
  }
}

class PurgeDataSuccess implements StopSaving, PersistData {
  PurgeDataSuccess();

  @override
  String toString() {
    return 'PurgeDataSuccess';
  }
}

class PurgeDataFailure implements StopSaving {
  PurgeDataFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'PurgeDataFailure{error: $error}';
  }
}

class UpdateCompanyLanguage {
  UpdateCompanyLanguage({this.languageId});

  final String? languageId;

  @override
  String toString() {
    return 'UpdateCompanyLanguage';
  }
}

class SaveCompanyDocumentRequest implements StartSaving {
  SaveCompanyDocumentRequest({
    required this.isPrivate,
    required this.completer,
    required this.multipartFiles,
  });

  final bool isPrivate;
  final Completer completer;
  final List<MultipartFile> multipartFiles;

  @override
  String toString() {
    return 'SaveCompanyDocumentRequest';
  }
}

class SaveCompanyDocumentSuccess implements StopSaving, PersistData, PersistUI {
  // SaveCompanyDocumentSuccess(this.document);

  // final DocumentEntity document;

  @override
  String toString() {
    return 'SaveCompanyDocumentSuccess';
  }
}

class SaveCompanyDocumentFailure implements StopSaving {
  SaveCompanyDocumentFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SaveCompanyDocumentFailure{error: $error}';
  }
}

class SetDefaultCompanyRequest implements StartSaving {
  SetDefaultCompanyRequest({
    required this.completer,
  });

  final Completer completer;

  @override
  String toString() {
    return 'SetDefaultCompanyRequest';
  }
}

class SetDefaultCompanySuccess implements StopSaving {
  @override
  String toString() {
    return 'SetDefaultCompanySuccess';
  }
}

class SetDefaultCompanyFailure implements StopSaving {
  SetDefaultCompanyFailure(this.error);

  final Object error;

  @override
  String toString() {
    return 'SetDefaultCompanyFailure{error: $error}';
  }
}

class LoadAllCompanies implements StartLoading {
  LoadAllCompanies({this.completer});

  final Completer<Map<String, String>>? completer;

  @override
  String toString() {
    return 'LoadAllCompanies';
  }
}

class LoadCompaniesSuccess implements StopLoading {
  LoadCompaniesSuccess({required this.companies});

  final Map<String, String> companies; // company name -> company ID

  @override
  String toString() {
    return 'LoadCompaniesSuccess{companies: ${companies.length}}';
  }
}

class LoadCompaniesFailure implements StopLoading {
  LoadCompaniesFailure({required this.error});

  final Object error;

  @override
  String toString() {
    return 'LoadCompaniesFailure{error: $error}';
  }
}

class LoadUserCompaniesSuccess implements StopLoading {
  LoadUserCompaniesSuccess({
    required this.userId,
    required this.companies,
  });

  final String userId;
  final List<CompanyEntity> companies;

  @override
  String toString() {
    return 'LoadUserCompaniesSuccess{userId: $userId, companies: ${companies.length}}';
  }
}

class LoadUserCompaniesFailure implements StopLoading {
  LoadUserCompaniesFailure({required this.error});

  final Object error;

  @override
  String toString() {
    return 'LoadUserCompaniesFailure{error: $error}';
  }
}

class LoadCompaniesByIds  {
  LoadCompaniesByIds({
    required this.companyIds,
    this.completer,
  });

  final List<String> companyIds;
  final Completer<List<CompanyEntity>>? completer;

  @override
  String toString() {
    return 'LoadCompaniesByIds{companyIds: $companyIds}';
  }
}

class LoadCompaniesByIdsSuccess implements StopLoading {
  LoadCompaniesByIdsSuccess({required this.companies});

  final List<CompanyEntity> companies;

  @override
  String toString() {
    return 'LoadCompaniesByIdsSuccess{companies: ${companies.length}}';
  }
}

class LoadCompaniesByIdsFailure implements StopLoading {
  LoadCompaniesByIdsFailure({required this.error});

  final Object error;

  @override
  String toString() {
    return 'LoadCompaniesByIdsFailure{error: $error}';
  }
}
