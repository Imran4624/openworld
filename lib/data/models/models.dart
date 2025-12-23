// Package imports:
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

export 'package:flutter_boilerplate/data/models/company_model.dart';
export 'package:flutter_boilerplate/data/models/settings_model.dart';
export 'package:flutter_boilerplate/data/models/entities.dart';
export 'package:flutter_boilerplate/data/models/design_model.dart';
export 'package:flutter_boilerplate/data/models/static/country_model.dart';
export 'package:flutter_boilerplate/data/models/static/currency_model.dart';
export 'package:flutter_boilerplate/data/models/static/date_format_model.dart';
export 'package:flutter_boilerplate/data/models/static/datetime_format_model.dart';
export 'package:flutter_boilerplate/data/models/static/industry_model.dart';
export 'package:flutter_boilerplate/data/models/static/invoice_status_model.dart';
export 'package:flutter_boilerplate/data/models/static/language_model.dart';
export 'package:flutter_boilerplate/data/models/static/size_model.dart';
export 'package:flutter_boilerplate/data/models/static/static_data_model.dart';
export 'package:flutter_boilerplate/data/models/static/timezone_model.dart';
export 'package:flutter_boilerplate/data/models/user_model.dart';
// STARTER: export - do not remove comment
export 'package:flutter_boilerplate/data/models/payment_model.dart';
export 'package:flutter_boilerplate/data/models/product_model.dart';
export 'package:flutter_boilerplate/data/models/auth_model.dart';
export 'package:flutter_boilerplate/data/models/auth_response_model.dart';
export 'package:flutter_boilerplate/data/models/auth_models.dart';
export 'package:flutter_boilerplate/data/models/photo_model.dart';
export 'package:flutter_boilerplate/data/models/notification_model.dart';
export 'package:flutter_boilerplate/data/models/profile_operation_model.dart';
export 'package:flutter_boilerplate/data/models/profile_model.dart';
export 'package:flutter_boilerplate/data/models/event_model.dart';
export 'package:flutter_boilerplate/data/models/event_theme_model.dart';
export 'package:flutter_boilerplate/data/models/chat_model.dart';

part 'models.g.dart';

class EntityAction extends EnumClass {
  const EntityAction._(String name) : super(name);

  static Serializer<EntityAction> get serializer => _$entityActionSerializer;

  static const EntityAction edit = _$edit;
  static const EntityAction newPhoto = _$newPhoto;
  static const EntityAction archive = _$archive;
  static const EntityAction delete = _$delete;
  static const EntityAction reported = _$reported;
  static const EntityAction purge = _$purge;
  static const EntityAction restore = _$restore;
  static const EntityAction remove = _$remove;
  static const EntityAction clone = _$clone;
  static const EntityAction cloneToOther = _$cloneToOther;
  static const EntityAction cloneToCredit = _$cloneToCredit;
  static const EntityAction cloneToInvoice = _$cloneToInvoice;
  static const EntityAction cloneToQuote = _$cloneToQuote;
  static const EntityAction cloneToExpense = _$cloneToExpense;
  static const EntityAction cloneToRecurring = _$cloneToRecurring;
  static const EntityAction cloneToPurchaseOrder = _$cloneToPurchaseOrder;
  static const EntityAction approve = _$approve;
  static const EntityAction download = _$download;
  static const EntityAction documents = _$documents;
  static const EntityAction bulkDownload = _$bulkDownload;
  static const EntityAction sendEmail = _$sendEmail;
  static const EntityAction sendNow = _$sendNow;
  static const EntityAction bulkSendEmail = _$bulkSendEmail;
  static const EntityAction newProject = _$newProject;
  static const EntityAction newTask = _$newTask;
  static const EntityAction settings = _$settings;
  static const EntityAction viewPdf = _$viewPdf;
  static const EntityAction viewDocument = _$viewDocument;
  static const EntityAction more = _$more;
  static const EntityAction printPdf = _$printPdf;
  static const EntityAction start = _$start;
  static const EntityAction resume = _$resume;
  static const EntityAction stop = _$stop;
  static const EntityAction toggleMultiselect = _$toggleMultiselect;
  static const EntityAction reverse = _$reverse;
  static const EntityAction cancelInvoice = _$cancelInvoice;
  static const EntityAction copy = _$copy;
  static const EntityAction resendInvite = _$resendInvite;
  static const EntityAction disconnect = _$disconnect;
  static const EntityAction changeStatus = _$changeStatus;
  static const EntityAction back = _$back;
  static const EntityAction save = _$save;
  static const EntityAction accept = _$accept;
  static const EntityAction merge = _$merge;
  static const EntityAction bulkPrint = _$bulkPrint;
  static const EntityAction unlink = _$unlink;
  static const EntityAction runTemplate = _$runTemplate;
  static const EntityAction bulkUpdate = _$bulkUpdate;
  static const EntityAction reconnect = _$reconnect;
  static const EntityAction addComment = _$addComment;

  @override
  String toString() {
    if (this == EntityAction.viewDocument) {
      return 'view';
    }

    return toSnakeCase(super.toString());
  }

  bool get applyMaxLimit => ![
        EntityAction.bulkDownload,
      ].contains(this);

  bool get isServerSide => [
        EntityAction.start,
        EntityAction.stop,
        EntityAction.approve,
        EntityAction.cancelInvoice,
        EntityAction.resume,
        EntityAction.archive,
        EntityAction.delete,
        EntityAction.reported,
        EntityAction.restore,
        EntityAction.purge,
        EntityAction.sendNow,
      ].contains(this);

  bool get requiresSecondRequest => [
        EntityAction.archive,
        EntityAction.delete,
        EntityAction.reported,
        EntityAction.restore,
      ].contains(this);

  bool get isClientSide => !isServerSide;

  String toApiParam() {
    final value = toString();

    if (this == EntityAction.runTemplate) {
      return 'template';
    }
    if (this == EntityAction.sendEmail || this == EntityAction.bulkSendEmail) {
      return 'email';
    } else if (this == EntityAction.cancelInvoice) {
      return 'cancel';
    } else if (this == EntityAction.resume) {
      return 'start';
    }
    return value;
  }

  static EntityAction? newEntityType(EntityType? entityType) {
    switch (entityType) {
      // case EntityType.transaction:
      //   return EntityAction.newTransaction;
      case EntityType.photo:
        return EntityAction
            .newPhoto; // newPhoto action is required when PhotoEntity is a child/related entity
      default:
        logError(
            'entityType $entityType not defined in EntityAction.newEntityType');
        return null;
    }
  }

  static BuiltSet<EntityAction> get values => _$values;

  static EntityAction valueOf(String name) => _$valueOf(name);
}
