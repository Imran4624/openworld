import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/photo/view/photo_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/FieldGrid.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({
    super.key,
    required this.viewModel,
    required this.isFilter,
  });

  final PhotoViewVM viewModel;
  final bool isFilter;

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final photo = viewModel.photo;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final photoList = state.photoState.list;

    int currentIndex = photoList.indexOf(photo.id);
    if (currentIndex == -1) currentIndex = 0;

    bool canNavigateLeft = currentIndex > 0;
    bool canNavigateRight = currentIndex < photoList.length - 1;

    return ViewScaffold(
      isFilter: widget.isFilter,
      entity: photo,
      title: '${photo.category} (${currentIndex + 1}/${photoList.length})',
      onBackPressed: () => viewModel.onBackPressed(),
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0 && canNavigateLeft) {
                final previousId = photoList[currentIndex - 1];
                store.dispatch(ViewPhoto(photoId: previousId));
              } else if (details.primaryVelocity! < 0 && canNavigateRight) {
                final nextId = photoList[currentIndex + 1];
                store.dispatch(ViewPhoto(photoId: nextId));
              }
            },
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: canNavigateLeft
                            ? () {
                                final previousId = photoList[currentIndex - 1];
                                store.dispatch(ViewPhoto(photoId: previousId));
                              }
                            : null,
                        color: canNavigateLeft
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                      ),
                      Text(
                        '${currentIndex + 1} of ${photoList.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: canNavigateRight
                            ? () {
                                final nextId = photoList[currentIndex + 1];
                                store.dispatch(ViewPhoto(photoId: nextId));
                              }
                            : null,
                        color: canNavigateRight
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ScrollableListView(
                    children: <Widget>[
                      if (photo.url.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16.0),
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Center(
                                child: Hero(
                                  tag: 'photo-${photo.id}',
                                  child: Image.network(
                                    photo.url,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress.expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (canNavigateLeft)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      final previousId =
                                          photoList[currentIndex - 1];
                                      store
                                          .dispatch(ViewPhoto(photoId: previousId));
                                    },
                                    child: Container(
                                      width: 50,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.chevron_left,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (canNavigateRight)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      final nextId = photoList[currentIndex + 1];
                                      store.dispatch(ViewPhoto(photoId: nextId));
                                    },
                                    child: Container(
                                      width: 50,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.chevron_right,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FieldGrid(
                          {
                            'Category': photo.category,
                            'Tags': photo.tags,
                            'Storage Type': photo.storageType.toString(),
                            'URL': photo.url.isEmpty ? 'None' : 'Set',
                            'Processed': photo.isProcessed ? 'Yes' : 'No',
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStatusMessage(photo),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(PhotoEntity photo) {
    String statusText = '';

    if (photo.isDeleted! == true) {
      statusText = 'Photo is deleted';
    } else if (photo.isArchived) {
      statusText = 'Photo is pending approval';
    }

    if (statusText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Text(statusText),
      ),
    );
  }
}
