import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/ui/photo/edit/photo_edit.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/ui/photo/photo_screen.dart';

class PhotoEditScreen extends StatelessWidget {
  const PhotoEditScreen({Key? key}) : super(key: key);
  static const String route = '/photo/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PhotoEditVM>(
      converter: (Store<AppState> store) {
        return PhotoEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return PhotoEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.photo.updatedAt),
        );
      },
    );
  }
}

class PhotoEditVM {
  PhotoEditVM({
    required this.state,
    required this.photo,
    this.company,
    required this.onChanged,
    required this.isSaving,
    this.origPhoto,
    required this.onSavePressed,
    required this.onUploadMultiplePhotos,
    required this.onCancelPressed,
    required this.onRemoveImagePressed,
    required this.isLoading,
    required this.onSingleImageSelected,
  });

  factory PhotoEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final photo = state.photoUIState.editing;

    return PhotoEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origPhoto: state.photoState.map[photo!.id],
      photo: photo,
      company: state.company,
      onChanged: (PhotoEntity photo) {
        store.dispatch(UpdatePhoto(photo));
      },
      onSingleImageSelected: (Map<String, dynamic> imageData) {
        store.dispatch(SetTempPhotoImage(imageData));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(entity: PhotoEntity(), force: true);
        if (state.photoUIState.cancelCompleter != null) {
          state.photoUIState.cancelCompleter!.complete();
        } else {
          store.dispatch(UpdateCurrentRoute(PhotoScreen.route));
          if (state.prefState.isMobile) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                PhotoScreen.route, (Route<dynamic> route) => false);
          }
        }
      },
      onSavePressed: (BuildContext context, Map<String, dynamic>? imageData) {
        Debouncer.runOnComplete(() {
          final photo = store.state.photoUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer<PhotoEntity> completer = Completer<PhotoEntity>();

          final imageToUse =
              imageData ?? store.state.photoUIState.defaultImageData;

          store.dispatch(SavePhotoRequest(
            completer: completer,
            photo: photo,
            imageData: imageToUse,
          ));

          return completer.future.then((savedPhoto) {
            showToast(photo.isNew
                ? localization.createdPhoto
                : localization.updatedPhoto);
          }).catchError((Object error) {
            showDialog<ErrorDialog>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(error);
                });
          });
        });
      },
      onRemoveImagePressed: (BuildContext context) {
        Debouncer.runOnComplete(() {
          final photo = store.state.photoUIState.editing!;
          final localization = AppLocalization.of(context)!;
          final Completer completer = Completer();

          final navigator = Navigator.of(context);

          showDialog<bool>(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Remove Photo'),
                content: const Text(
                    'Are you sure you want to permanently delete this photo? This action cannot be undone.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          ).then((confirmed) {
            if (confirmed == true) {
              store.dispatch(PurgePhotosRequest(
                completer,
                [photo.id],
              ));

              completer.future.then((_) {
                showToast(localization.deletedPhoto);
                store.dispatch(UpdateCurrentRoute(PhotoScreen.route));
                navigator.pushNamedAndRemoveUntil(
                    PhotoScreen.route, (route) => false);
              }).catchError((Object error) {
                showDialog<ErrorDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(error);
                    });
              });
            }
          });
        });
      },
      onUploadMultiplePhotos: (BuildContext context, String category,
          String tags, List<Map<String, dynamic>> images) async {
        final completer = Completer<List<PhotoEntity>>();
        store.dispatch(UploadMultiplePhotosRequest(
          completer: completer,
          category: category,
          tags: tags,
          imagesData: images,
        ));
        try {
          final savedPhotos = await completer.future;
          showToast('Uploaded ${savedPhotos.length} photos successfully');
          store.dispatch(UpdateCurrentRoute(PhotoScreen.route));
          Navigator.of(context).pushNamedAndRemoveUntil(
              PhotoScreen.route, (route) => false);
        } catch (error) {
          showDialog<ErrorDialog>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(error);
              });
        }
      },
    );
  }

  final PhotoEntity photo;
  final CompanyEntity? company;
  final Function(PhotoEntity) onChanged;
  final Function(BuildContext, Map<String, dynamic>?) onSavePressed;
  final Function(BuildContext, String, String, List<Map<String, dynamic>>)
      onUploadMultiplePhotos;
  final Function(BuildContext) onCancelPressed;
  final Function(BuildContext) onRemoveImagePressed;
  final Function(Map<String, dynamic>) onSingleImageSelected;
  final bool isLoading;
  final bool isSaving;
  final PhotoEntity? origPhoto;
  final AppState state;
}
