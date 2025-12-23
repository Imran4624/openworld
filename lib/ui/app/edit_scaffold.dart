// Flutter imports:
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/settings/user_details_vm.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/ui/app/forms/save_cancel_buttons.dart';
import 'package:flutter_boilerplate/ui/app/icon_text.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';
import 'package:overflow_view/overflow_view.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_status_chip.dart';
import 'package:flutter_boilerplate/ui/app/icon_message.dart';
import 'package:flutter_boilerplate/ui/app/menu_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/settings/account_management_vm.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class EditScaffold extends StatelessWidget {
  const EditScaffold({
    Key? key,
    required this.title,
    required this.onSavePressed,
    required this.body,
    this.entity,
    this.onCancelPressed,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.appBarBottom,
    this.saveLabel,
    this.isFullscreen = false,
    this.onActionPressed,
    this.actions,
  }) : super(key: key);

  final BaseEntity? entity;
  final String? title;
  final Function(BuildContext)? onSavePressed;
  final Function(BuildContext)? onCancelPressed;
  final Function(BuildContext, EntityAction)? onActionPressed;
  final List<EntityAction?>? actions;
  final Widget? appBarBottom;
  final Widget? floatingActionButton;
  final Widget body;
  final Widget? bottomNavigationBar;
  final String? saveLabel;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final account = state.account;
    final localization = AppLocalization.of(context);
    Function? bannerClick;

    final shouldHideCancelButton = entity != null &&
        entity!.entityType == EntityType.profile &&
        entity!.isNew;

    bool showUpgradeBanner = false;
    bool isEnabled = !state.isSaving && (entity?.isEditable ?? true);
    bool isCancelEnabled = false;
    String? upgradeMessage = state.userCompany.isOwner
        ? (state.account.isEligibleForTrial && !supportsInAppPurchase()
            ? localization!.startFreeTrialMessage
            : localization!.upgradeToPaidPlan)
        : localization!.ownerUpgradeToPaidPlan;
    if (account.isTrial) {
      if (account.trialDaysLeft <= 1) {
        upgradeMessage = localization.freeTrialEndsToday;
      } else {
        upgradeMessage = localization.freeTrialEndsInDays
            .replaceFirst(':count', account.trialDaysLeft.toString());
      }
    }

    if (!state.isProPlan || state.account.isTrial) {
      if (kAdvancedSettings.contains(state.uiState.baseSubRoute)) {
        showUpgradeBanner = true;
        if (!state.isProPlan && !state.account.isTrial && isEnabled) {
          isCancelEnabled = true;
          isEnabled = false;
        }
      } else if (state.uiState.currentRoute == AccountManagementScreen.route ||
          state.uiState.currentRoute == UserDetailsScreen.route) {
        showUpgradeBanner = true;
      }
    } else if (kSettingsCompanyGatewaysEdit
        .contains(state.uiState.baseSubRoute)) {
      isCancelEnabled = true;
    }

    final entityActions = <EntityAction>[
      if (isDesktop(context) &&
          ((isEnabled && onSavePressed != null) || isCancelEnabled))
        EntityAction.back,
      EntityAction.save,
      ...(actions ?? []).whereNotNull(),
    ];

    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: state.headerTextColor);

    final showOverflow = isDesktop(context) && state.isFullScreen;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
            onSavePressed!(context),
      },
      child: FocusTraversalGroup(
        child: Scaffold(
          body: state.companies.isEmpty
              ? LoadingIndicator()
              : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        if (showUpgradeBanner && state.userCompany.isOwner)
                          InkWell(
                            child: IconMessage(
                              upgradeMessage,
                              color: Colors.orange.shade800,
                            ),
                            onTap: () async {
                              // if (bannerClick != null) {
                              bannerClick!();
                              // } else {
                              //   // initiatePurchase();
                              // }
                            },
                          ),
                        Expanded(
                          child: body,
                        ),
                      ],
                    ),
                    if (state.isSaving) LinearProgressIndicator(),
                  ],
                ),
          drawer: (isDesktop(context) && state.prefState.isMenuFloated)
              ? MenuDrawerBuilder()
              : null,
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: isMobile(context) &&
                (entity!.isNew
                    ? ProjectConfig.showBackArrowByEntityType(
                        entity!.entityType!)
                    : true),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showOverflow)
                  Text(title!)
                else
                  Flexible(child: Text(title!)),
                SizedBox(width: 16),
                if (isDesktop(context) &&
                    isFullscreen &&
                    entity != null &&
                    entity!.isOld) ...[
                  EntityStatusChip(
                      entity: state.getEntity(entity!.entityType, entity!.id)),
                  SizedBox(width: 8),
                ],
                if (showOverflow &&
                    ProjectConfig.showSaveButtonByEntityType(
                        entity!.entityType!))
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FocusTraversalGroup(
                        // TODO this is needed as a workaround to prevent
                        // breaking tab focus traversal
                        descendantsAreFocusable: false,
                        child: OverflowView.flexible(
                            spacing: 8,
                            children: entityActions.map(
                              (action) {
                                String? label;
                                if (action == EntityAction.save &&
                                    saveLabel != null) {
                                  label = saveLabel;
                                } else {
                                  label = localization.lookup('$action');
                                }

                                return OutlinedButton(
                                  style:
                                      action == EntityAction.save && isEnabled
                                          ? ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(state
                                                      .prefState
                                                      .colorThemeModel!
                                                      .colorSuccess))
                                          : null,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: isDesktop(context) ? 60 : 0),
                                    child: isDesktop(context)
                                        ? IconText(
                                            // icon: getEntityActionIcon(action),
                                            text: label,
                                            style: state.isSaving
                                                ? null
                                                : action == EntityAction.save
                                                    ? textStyle.copyWith(
                                                        color: AppTheme
                                                            .light.secondary)
                                                    : textStyle,
                                          )
                                        : Text(label!,
                                            style: state.isSaving
                                                ? null
                                                : textStyle),
                                  ),
                                  onPressed: state.isSaving
                                      ? null
                                      : () {
                                          if (action == EntityAction.back) {
                                            if (onCancelPressed != null) {
                                              onCancelPressed!(context);
                                            } else {
                                              store.dispatch(ResetSettings());
                                            }
                                          } else if (action ==
                                              EntityAction.save) {
                                            // Clear focus now to prevent un-focus after save from
                                            // marking the form as changed and to hide the keyboard
                                            FocusScope.of(context).unfocus(
                                                disposition: UnfocusDisposition
                                                    .previouslyFocusedChild);

                                            onSavePressed!(context);
                                          } else {
                                            onActionPressed!(context, action);
                                          }
                                        },
                                );
                              },
                            ).toList(),
                            builder: (context, remaining) {
                              return PopupMenuButton<EntityAction>(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: isDesktop(context)
                                      ? Row(
                                          children: [
                                            Text(
                                              localization.more,
                                              style: textStyle,
                                            ),
                                            SizedBox(width: 4),
                                            Icon(Icons.arrow_drop_down,
                                                color: state.headerTextColor),
                                          ],
                                        )
                                      : Icon(Icons.more_vert),
                                ),
                                onSelected: (EntityAction action) {
                                  onActionPressed!(context, action);
                                },
                                itemBuilder: (BuildContext context) {
                                  return entityActions
                                      .toList()
                                      .sublist(entityActions.length - remaining)
                                      .map((action) {
                                    return PopupMenuItem<EntityAction>(
                                      value: action,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(getEntityActionIcon(action),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                          SizedBox(width: 16.0),
                                          Text(AppLocalization.of(context)!
                                              .lookup(action.toString())),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                              );
                            }),
                      ),
                    ),
                  ),
              ],
            ),
            actions: showOverflow
                ? []
                : [
                    if (state.isSaving && isMobile(context))
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Center(
                            child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                              color: AppTheme.light.secondary),
                        )),
                      )
                    else if (isDesktop(context))
                      Row(
                        children: [
                          if (!shouldHideCancelButton)
                            OutlinedButton(
                              onPressed: state.isSaving
                                  ? null
                                  : () {
                                      if (onCancelPressed != null) {
                                        onCancelPressed!(context);
                                      } else {
                                        store.dispatch(ResetSettings());
                                      }
                                    },
                              child: Text(
                                (entity != null &&
                                        entity!.entityType!.isSetting)
                                    ? localization.back
                                    : localization.cancel,
                              ),
                            ),
                          if (!shouldHideCancelButton) SizedBox(width: 8),
                          if (entity != null &&
                              ProjectConfig.showSaveButtonByEntityType(
                                  entity!.entityType!))
                            OutlinedButton(
                              style: isEnabled
                                  ? ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          AppTheme.light.primary),
                                      alignment: Alignment.center,
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      ))
                                  : null,
                              onPressed: !isEnabled ||
                                      state.isSaving ||
                                      onSavePressed == null
                                  ? null
                                  : () {
                                      // Clear focus now to prevent un-focus after save from
                                      // marking the form as changed and to hide the keyboard
                                      FocusScope.of(context).unfocus(
                                          disposition: UnfocusDisposition
                                              .previouslyFocusedChild);

                                      onSavePressed!(context);
                                    },
                              child: Text(localization.save,
                                  style: state.isSaving
                                      ? null
                                      : TextStyle(
                                          color: AppTheme.dark.text,
                                        )),
                            ),
                          SizedBox(width: 16),
                        ],
                      )
                    else if (ProjectConfig.showSaveButtonByEntityType(
                        entity!.entityType!))
                      SaveCancelButtons(
                        isEnabled: isEnabled && onSavePressed != null,
                        isHeader: true,
                        isCancelEnabled:
                            !shouldHideCancelButton && isCancelEnabled,
                        saveLabel: saveLabel,
                        cancelLabel: localization.cancel,
                        onSavePressed: onSavePressed == null
                            ? null
                            : (context) {
                                // Clear focus now to prevent un-focus after save from
                                // marking the form as changed and to hide the keyboard
                                FocusScope.of(context).unfocus(
                                    disposition: UnfocusDisposition
                                        .previouslyFocusedChild);

                                onSavePressed!(context);
                              },
                        onCancelPressed:
                            !shouldHideCancelButton || isMobile(context)
                                ? null
                                : (context) {
                                    if (onCancelPressed != null) {
                                      onCancelPressed!(context);
                                    } else {
                                      store.dispatch(ResetSettings());
                                    }
                                  },
                      ),
                    if (actions != null &&
                        actions!.isNotEmpty &&
                        onActionPressed != null)
                      PopupMenuButton<EntityAction>(
                        icon: Icon(
                          Icons.more_vert,
                          //size: iconSize,
                          //color: color,
                        ),
                        itemBuilder: (BuildContext context) => [
                          ...actions!
                              .map((action) => action == null
                                  ? PopupMenuDivider()
                                  : PopupMenuItem<EntityAction>(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            getEntityActionIcon(action),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          SizedBox(width: 16.0),
                                          Text(AppLocalization.of(context)!
                                              .lookup(action.toString())),
                                        ],
                                      ),
                                      value: action,
                                    ))
                              .whereType<PopupMenuEntry<EntityAction>>()
                              .toList()
                        ],
                        onSelected: (action) =>
                            onActionPressed!(context, action),
                        enabled: isEnabled,
                      )
                  ],
            bottom: isFullscreen && isDesktop(context)
                ? null
                : appBarBottom as PreferredSizeWidget?,
          ),
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
