// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/chat/view/chat_header.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/ui/profile/profile_screen.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';


// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/app/actions_menu_button.dart';
import 'package:flutter_boilerplate/ui/app/blank_screen.dart';
import 'package:flutter_boilerplate/ui/app/buttons/app_text_button.dart';
import 'package:flutter_boilerplate/ui/app/copy_to_clipboard.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class ViewScaffold extends StatelessWidget {
  const ViewScaffold({
    required this.body,
    required this.entity,
    this.appBarBottom,
    this.isFilter = false,
    this.onBackPressed,
    this.title,
    this.thumbnail,
    this.isEditable = true,
    this.isProfileOperation = false,
  });

  final bool isFilter;
  final BaseEntity entity;
  final Widget body;
  final Function? onBackPressed;
  final Widget? appBarBottom;
  final String? title;
  final String? thumbnail;
  final bool isEditable;
  final bool isProfileOperation;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final isSettings = entity.entityType!.isSetting;

    String? appBarTitle;
    if (title != null) {
      appBarTitle = title;
    } else if (entity.isNew) {
      appBarTitle = '';
    } else {
      final presenter = EntityPresenter().initialize(entity, context);
      appBarTitle = presenter.title(isNarrow: isMobile(context));
    }

    Widget? leading;
    if (isDesktop(context)) {
      if (isFilter == true &&
          entity.entityType == state.uiState.filterEntityType) {
        if (state.uiState.filterStack.length > 1 && !isFilter) {
          leading = IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => store.dispatch(PopFilterStack()),
          );
        } else {
          leading = IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              store.dispatch(UpdateUserPreferences(isFilterVisible: false));
            },
          );
        }
      } else if (state.uiState.previewStack.isNotEmpty) {
        leading = IconButton(
            tooltip: localization!.back,
            icon: Icon(Icons.arrow_back),
            onPressed: () => store.dispatch(PopPreviewStack()));
      } else if (isDesktop(context) &&
          !entity.entityType!.isSetting &&
          state.prefState.isModuleTable &&
          entity.entityType != EntityType.chat) {
        leading = IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if(entity.entityType!.hasFullWidthViewer) {
              if(state.uiState.currentRoute.contains(EventViewScreen.route)) {
                  viewEntitiesByType(entityType: EntityType.event);
              } else {
                store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
                store.dispatch(UpdateUserPreferences(isPreviewVisible: false));
              } 
            }else {
              store.dispatch(UpdateUserPreferences(isPreviewVisible: false));
            }},
        );
      }
    } else {
      leading = IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (entity.entityType == EntityType.profile && !isProfileOperation) {
            if (ProjectConfig.appType == AppType.cac) {
              Navigator.of(context).pop();
            } else {
              viewEntitiesByType(entityType: EntityType.profile);
            }
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    }

    void handleReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final reportController = TextEditingController();
        return AlertDialog(
          title: Text('Report ${entity.entityType?.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please describe why you are reporting this ${entity.entityType?.name}:'),
              const SizedBox(height: 16),
              TextField(
                controller: reportController,
                decoration: const InputDecoration(
                  hintText: 'Reason for reporting...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (reportController.text.trim().isNotEmpty) {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(ReportEntityRequest(
                    entityId: entity.id,
                    entityType:  entity.entityType!,
                    comment: reportController.text.trim(),
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

    return FocusTraversalGroup(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: !ProjectConfig.showEntityTopBar(
            state.uiState.currentRoute, isMobile(context)) ? null : AppBar(
          centerTitle: false,
          leading:  leading ,
          automaticallyImplyLeading: isMobile(context),
          title: entity.entityType == EntityType.chat
              ? ChatHeader(
                  appBarTitle: appBarTitle!,
                  thumbnail: thumbnail,
                )
              : CopyToClipboard(
                  value: appBarTitle,
                  child: Text(appBarTitle!),
                ),
          bottom: appBarBottom as PreferredSizeWidget?,
          actions: entity.isNew || !ProjectConfig.showActionButtonByEntityType(entity.entityType!) 
              ? []
              : [
                  if (isSettings && isDesktop(context) && !isFilter)
                    TextButton(
                        onPressed: () {
                          onBackPressed != null
                              ? onBackPressed!()
                              : store.dispatch(UpdateCurrentRoute(
                                  state.uiState.previousRoute));
                        },
                        child: Text(
                          localization!.back,
                          style: TextStyle(color: state.headerTextColor),
                        )),
                  if (entity.id != getLoggedInUserId(store) &&
                      ProjectConfig.showReportButtonByEntityType(
                          entity.entityType!))
                    Builder(builder: (context) {
                      return AppTextButton(
                        label: localization!.report,
                        isInHeader: false,
                        onPressed: () {
                          if (entity.entityType == EntityType.profile) {
                            ProfileEntity userProfile = entity as ProfileEntity;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                final commentController =
                                    TextEditingController();
                                final formKey = GlobalKey<FormState>(debugLabel: '_reportProfileDialog');
                                final focusNode = FocusNode();

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    // Request focus after the dialog is fully built
                                    Future.delayed(Duration.zero, () {
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);
                                    });
                                    return AlertDialog(
                                      title: const Text('Report Profile'),
                                      content: SingleChildScrollView(
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                'Please provide details about why you are reporting this profile.',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                focusNode: focusNode,
                                                controller: commentController,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      localization.comment ??
                                                          'Comment',
                                                  border: OutlineInputBorder(),
                                                ),
                                                maxLines: 4,
                                                minLines: 3,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                textInputAction:
                                                    TextInputAction.done,
                                                validator: (value) {
                                                  if (value?.trim().isEmpty ??
                                                      true) {
                                                    return 'Please enter a comment';
                                                  }
                                                  if ((value?.trim().length ??
                                                          0) <
                                                      10) {
                                                    return 'Comment must be at least 10 characters';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(dialogContext).pop(),
                                          child: Text(
                                              localization.cancel ?? 'Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              final comment =
                                                  commentController.text.trim();
                                              store.dispatch(
                                                  ReportProfileRequest(
                                                targetUserId: userProfile.id,
                                                comment: comment,
                                              ));
                                              Navigator.of(dialogContext).pop();
                                            }
                                          },
                                          child: Text(localization.report),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }else{
                            handleReport(context);
                          }
                        },
                      );
                    }),
                  if (isEditable && ProjectConfig.showEditButton &&
                      (entity.createdUserId == getLoggedInUserId(store)))
                    Builder(builder: (context) {
                      final isDisabled = state.uiState.isEditing &&
                          state.uiState.mainRoute ==
                              state.uiState.filterEntityType.toString();

                      return AppTextButton(
                        label: localization!.edit,
                        isInHeader: true,
                        onPressed: isDisabled
                            ? null
                            : () {
                                editEntity(entity: entity);
                              },
                      );
                    }),
                  ((!ProjectConfig.showActionButtonByEntityType(entity.entityType!)) || entityActions(userCompany, store).isEmpty)
                      ? SizedBox()
                      : ViewActionMenuButton(
                          isSaving: state.isSaving && !isFilter,
                          entity: entity,
                          onSelected: (context, action) =>
                              handleEntityAction(entity, action, autoPop: true),
                          entityActions: entityActions(userCompany, store),
                        ),
                ],
        ),
        body: SafeArea(
          child:
              entity.isNew ? BlankScreen(localization!.noRecordSelected) : body,
        ),
      ),
    );
  }

  List<EntityAction?> entityActions(UserCompanyEntity userCompany, Store<AppState> store) {

    final isAuthor = entity.createdUserId == getLoggedInUserId(store) ;
      
    return isAuthor || isAdmin(store.state) ? entity.getActions(
                          userCompany: userCompany,
                          isGuest: isGuestUser(store.state),
                          isAuthor: isAuthor,) : [];
  }
}
