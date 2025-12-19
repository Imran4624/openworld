import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/services/user_service.dart';
import 'package:flutter_boilerplate/ui/app/buttons/floating_action_buttons.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/photo/photo_list_vm.dart';
import 'package:flutter_boilerplate/ui/photo/photo_presenter.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/photo/photo_edit_dialog.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit_vm.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/barcode_dialog.dart';
import 'package:flutter_boilerplate/ui/event/dialogs/attendees_dialog.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/services/payment_handler.dart';

import 'photo_screen_vm.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/photo';

  final PhotoScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;

    return ListScaffold(
      entityType: EntityType.photo,
      onHamburgerLongPress: () => store.dispatch(StartPhotoMultiselect()),
      appBarTitle: Row(
        children: [
          Expanded(
            child: ListFilter(
              key: ValueKey('__filter_${state.photoListState.filterClearedAt}__'),
              entityType: EntityType.photo,
              entityIds: viewModel.photoList,
              filter: state.photoState.filter.searchTerm,
              isAuthor: false,
              onFilterChanged: (value) {
                store.dispatch(FilterPhotos(value!));
                store.dispatch(UpdatePhotoFilter(
                  state.photoState.filter.rebuild((b) => b..searchTerm = value),
                ));
              },
              onSelectedState: null,
              selectedStateFilter: null,
            ),
          ),
        ],
      ),
      onCheckboxPressed: null,
      body: const PhotoListBuilder(),
      bottomNavigationBar: ProjectConfig.showTopbarForPhotos(context, false) ?null: AppBottomBar(
        entityType: EntityType.photo,
        tableColumns: PhotoPresenter.getAllTableFields(userCompany),
        defaultTableColumns: PhotoPresenter.getDefaultTableFields(userCompany),
        onSelectedSortField: (field) {
          final ascending = state.photoState.filter.sortField == field
              ? !state.photoState.filter.sortAscending
              : true;
          store.dispatch(UpdatePhotoFilter(
            state.photoState.filter.rebuild((b) => b
              ..sortField = field
              ..sortAscending = ascending),
          ));
        },
        sortFields: [
          // STARTER: constant fields - do not remove comment
          PhotoFields.category,

          PhotoFields.storageType,

          PhotoFields.url,

          PhotoFields.isProcessed,

          PhotoFields.tags,
        ],
        onSelectedState: null,
        onCheckboxPressed: () {
          // No-op for non-authors in LoopJam
        },
        // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.photo1,
        // //     excludeBlank: true),
        // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.photo2,
        // //     excludeBlank: true),
        // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.photo3,
        // //     excludeBlank: true),
        // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.photo4,
        //     excludeBlank: true),
        // onSelectedCustom1: (value) =>
        //     store.dispatch(FilterPhotosByCustom1(value)),
        // onSelectedCustom2: (value) =>
        //     store.dispatch(FilterPhotosByCustom2(value)),
        // onSelectedCustom3: (value) =>
        //     store.dispatch(FilterPhotosByCustom3(value)),
        // onSelectedCustom4: (value) =>
        //     store.dispatch(FilterPhotosByCustom4(value)),
      ),
      floatingActionButton:
          (!ProjectConfig.showFloatingButtons(EntityType.photo) &&
                  userCompany.canCreate(EntityType.photo))
              ? FloatingActionButton(
                  heroTag: 'photo_fab',
                  backgroundColor: Theme.of(context).primaryColorDark,
                  onPressed: () {
                    if (!isAuthenticated(state)) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => LoginDialogView(
                          onClose: () {
                            if (isWeb()) {
                              Navigator.of(context).pop();
                              store.dispatch(UpdateCurrentRoute(
                                  store.state.uiState.currentRoute));
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          onLoginSuccess: () {
                            if (context.mounted && isMobile(context)) {
                              Navigator.of(context).pop();
                            } else {
                              store.dispatch(UpdateCurrentRoute(
                                  store.state.uiState.currentRoute));
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                      return;
                    }

                    PaymentHandler.handlePhotoUploadAction(
                      context,
                      onUpload: () {
                        if (ProjectConfig.showEditPhotoDialog()) {
                          final store = StoreProvider.of<AppState>(context);
                          final viewModel = PhotoEditVM.fromStore(store);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => PhotoEditDialog(
                              viewModel: viewModel,
                              isEditMode: false,
                              onClose: () => Navigator.of(context).pop(),
                            ),
                          );
                        } else {
                          createEntityByType(
                            context: context,
                            entityType: EntityType.photo,
                          );
                        }
                      },
                      onPaymentSuccess: () async {
                        try {
                          final result = await UserService.updateUserPaymentStatus(
                            plan: 'Paid',
                            metadata: {
                              'feature': 'photo_upload',
                              'upgrade_source': 'floating_action_button',
                              'upgrade_date': DateTime.now().toIso8601String(),
                            },
                          );
                          
                          if (result['success'] == true) {
                            debugPrint('User upgraded to Premium plan from floating action button - profile updated');
                          } else {
                            debugPrint('User upgraded to Premium plan from floating action button - profile update failed: ${result['error']}');
                          }
                        } catch (e) {
                          debugPrint('Error updating user profile after payment: $e');
                        }
                      },
                    );
                  },
                  tooltip: localization.newPhoto,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : null,
      floatingCenterButton: ProjectConfig.showFloatingButtons(
                  EntityType.photo) &&
              viewModel.selectedEvent?.id.contains('_isPreview') == false && !isMobile(context)
          ? FloatingActionButtons(
              entityType: EntityType.photo,
              backgroundColor: viewModel.selectedEvent?.themeObject?.accentColor ?? AppTheme.light.primary,
              showEditButton: viewModel.selectedEvent?.createdUserId ==
                  getLoggedInUserId(store),
              showLinkButton:
                  viewModel.selectedEvent != null && isAuthenticated(state),
              showBackButton: viewModel.selectedEvent != null,
              showAttendeesButton: false,
              onEdit: () {
                if (viewModel.selectedEvent != null) {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(EditEvent(event: viewModel.selectedEvent!));
                } else {
                  EditButtonHandler.handleEditButton(context, EntityType.photo);
                }
              },
              onLink: () {
                if (viewModel.selectedEvent != null) {
                  PaymentHandler.handleShareAction(
                    context,
                    onShare: () {
                      final eventLink = ProjectConfig.getEntityDetailUrl(
                          EntityType.event, viewModel.selectedEvent!.id,
                          originator: OriginatorType.guest);
                      BarcodeDialog.show(
                        context,
                        title: 'Share ${viewModel.selectedEvent!.name}',
                        url: eventLink,
                      );
                    },
                    onPaymentSuccess: () async {
                      try {
                        final result = await UserService.updateUserPaymentStatus(
                          plan: 'Paid',
                          metadata: {
                            'feature': 'event_sharing',
                            'upgrade_source': 'photo_screen_share',
                            'upgrade_date': DateTime.now().toIso8601String(),
                            'event_id': viewModel.selectedEvent?.id,
                          },
                        );
                        
                        if (result['success'] == true) {
                          debugPrint('User upgraded to Premium plan from photo screen - profile updated');
                        } else {
                          debugPrint('User upgraded to Premium plan from photo screen - profile update failed: ${result['error']}');
                        }
                      } catch (e) {
                        debugPrint('Error updating user profile after payment: $e');
                      }
                    },
                  );
                }
              },
              onBack: () {
                if (viewModel.selectedEvent != null && !isMobile(context)) {
                  viewEntitiesByType(entityType: EntityType.event);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    EventViewScreen.route,
                    (route) => false,
                    arguments: {'id': viewModel.selectedEvent!.id},
                  );
                }
              },
              onAttendees: () {
                if (viewModel.selectedEvent != null) {
                  final List<BuyerDetails> attendees = viewModel
                      .selectedEvent!.orders
                      .map((order) => order.buyerDetails)
                      .toList();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AttendeesDialog(
                        attendees: attendees,
                        eventId: viewModel.selectedEvent!.id,
                        eventName: viewModel.selectedEvent!.name,
                      );
                    },
                  );
                }
              },
              onPressed: () {
                if (ProjectConfig.showEditPhotoDialog()) {
                  final store = StoreProvider.of<AppState>(context);
                  final photoEditViewModel = PhotoEditVM.fromStore(store);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => PhotoEditDialog(
                      viewModel: photoEditViewModel,
                      selectedEvent: viewModel.selectedEvent,
                      isEditMode: false,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  );
                } else {
                  createEntityByType(
                    context: context,
                    entityType: EntityType.photo,
                  );
                }
              },
              tooltip: 'Add photos',
              heroTag: 'photo_fab',
            )
          : null,
    );
  }
}
