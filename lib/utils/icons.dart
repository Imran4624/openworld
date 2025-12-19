// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';

IconData? getEntityActionIcon(EntityAction? entityAction) {
  switch (entityAction) {
    case EntityAction.edit:
      return MdiIcons.circleEditOutline;
    case EntityAction.viewPdf:
    case EntityAction.bulkDownload:
      return Icons.picture_as_pdf;
    case EntityAction.viewDocument:
      return Icons.photo;
    case EntityAction.bulkPrint:
    case EntityAction.printPdf:
      return Icons.print;
    case EntityAction.download:
    case EntityAction.documents:
      return Icons.download;
    case EntityAction.clone:
    case EntityAction.cloneToOther:
    case EntityAction.cloneToInvoice:
    case EntityAction.cloneToExpense:
    case EntityAction.cloneToQuote:
    case EntityAction.cloneToCredit:
    case EntityAction.cloneToRecurring:
    case EntityAction.cloneToPurchaseOrder:
      return Icons.control_point_duplicate;
    case EntityAction.sendEmail:
    case EntityAction.bulkSendEmail:
    case EntityAction.resendInvite:
    case EntityAction.sendNow:
      return Icons.send;
    case EntityAction.archive:
      return Icons.archive;
    case EntityAction.delete:
      return Icons.delete;
    case EntityAction.remove:
      return Icons.remove_circle_outline;
    case EntityAction.restore:
      return Icons.restore;
    case EntityAction.approve:
    case EntityAction.accept:
      return Icons.check_circle_outline;
    case EntityAction.newTask:
    case EntityAction.resume:
    case EntityAction.start:
      return Icons.play_arrow;
    case EntityAction.stop:
      return Icons.stop;
    case EntityAction.settings:
      return Icons.settings;
    case EntityAction.cancelInvoice:
      return Icons.remove_circle_outline;
    case EntityAction.reverse:
      return Icons.undo;
    case EntityAction.copy:
      return Icons.content_copy;
    case EntityAction.disconnect:
      return MdiIcons.lanDisconnect;
    case EntityAction.reconnect:
      return MdiIcons.connection;
    case EntityAction.purge:
      return Icons.delete_forever;
    case EntityAction.changeStatus:
      return Icons.adjust;
    case EntityAction.back:
      return Icons.cancel_outlined;
    case EntityAction.save:
      return Icons.cloud_upload;
    case EntityAction.merge:
      return MdiIcons.merge;
    case EntityAction.unlink:
      return MdiIcons.pipeDisconnected;
    case EntityAction.runTemplate:
      return MdiIcons.arrowRightCircleOutline;
    case EntityAction.bulkUpdate:
      return MdiIcons.squareEditOutline;
    case EntityAction.addComment:
      return MdiIcons.comment;
    default:
      return null;
  }
}

IconData getEntityIcon(EntityType? entityType) {
  switch (entityType) {
    case EntityType.dashboard:
      return MdiIcons.viewDashboard;
    case EntityType.settings:
      return Icons.settings_outlined; //MdiIcons.cog;
    case EntityType.user:
      return Icons.person;
    case EntityType.design:
      return MdiIcons.stamper;
    case EntityType.payment:
      return MdiIcons.creditCard;
    case EntityType.paymentTerm:
      return MdiIcons.calendarCheck;
    case EntityType.taskStatus:
      return MdiIcons.label;
    case EntityType.company:
      return Icons.business;
    case EntityType.chat:
      return Icons.chat_bubble_outline; // Icons.chat;
    case EntityType.event:
      return Icons.event;
    case EntityType.profile:
      return ProjectConfig.profileEntityDrawerIcon;
    case EntityType.profileOperation:
      return Icons.people_outline; //Icons.public;
    case EntityType.workout:
      return MdiIcons.run;
    case EntityType.notification:
      return MdiIcons.bellOutline;
    case EntityType.photo:
      return MdiIcons.imageMultipleOutline;
    case EntityType.social:
      return MdiIcons.forumOutline;
    case EntityType.product:
      return MdiIcons.shoppingOutline;
    default:
      return MdiIcons.crosshairsQuestion;
  }
}

IconData? getFileTypeIcon(String type) {
  switch (type) {
    case 'pdf':
      return MdiIcons.filePdfBox;
    case 'psd':
      return MdiIcons.fileImage;
    case 'txt':
      return MdiIcons.file;
    case 'doc':
    case 'docx':
      return MdiIcons.fileWord;
    case 'xls':
    case 'xlsx':
      return MdiIcons.fileExcel;
    case 'ppt':
    case 'pptt':
      return MdiIcons.filePowerpoint;
    default:
      return null;
  }
}

IconData? getSettingIcon(String section) {
  switch (section) {
    case kSettingsCompanyDetails:
      return Icons.business;
    case kSettingsUserDetails:
      return Icons.person;
    case kSettingsLocalization:
      return Icons.language;
    case kSettingsPaymentSettings:
    case kSettingsCompanyGateways:
      return MdiIcons.creditCard;
    case kSettingsTaxSettings:
    case kSettingsTaxRates:
      return MdiIcons.percent;
    case kSettingsImportExport:
      return Icons.import_export;
    case kSettingsDeviceSettings:
      return Icons.settings;
    case kSettingsGeneratedNumbers:
      return MdiIcons.formatListNumbered;
    case kSettingsCustomFields:
      return MdiIcons.formatText;
    case kSettingsCustomDesigns:
      return MdiIcons.stamper;
    case kSettingsInvoiceDesign:
      return MdiIcons.brush;
    case kSettingsWorkflowSettings:
      return MdiIcons.sourceBranch;
    case kSettingsClientPortal:
      return MdiIcons.cloud;
    case kSettingsEmailSettings:
      return Icons.mail;
    case kSettingsTemplatesAndReminders:
      return MdiIcons.reminder;
    case kSettingsDataVisualizations:
      return MdiIcons.link;
    case kSettingsUserManagement:
      return Icons.people;
    case kSettingsAccountManagement:
      return MdiIcons.shieldAccount;
    default:
      return null;
  }
}

IconData getActivityIcon(int categoryId) {
  switch (categoryId) {
    // case SystemLogEntity.CATEGORY_EMAIL:
    //   return Icons.email;
    default:
      return MdiIcons.crosshairsQuestion;
  }
}

IconData getIconByType(String type) {
  switch (type) {
    case 'map':
      return MdiIcons.mapMarkerPath;
    default:
      return MdiIcons.informationOutline;
  }
}
