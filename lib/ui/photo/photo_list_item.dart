import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entity_state_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dismissible_entity.dart';

class PhotoListItem extends StatelessWidget {
  const PhotoListItem({
    required this.user,
    required this.photo,
    required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
  });

  final UserEntity? user;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final PhotoEntity photo;
  final String? filter;
  final Function(bool?)? onCheckboxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final photoUIState = uiState.photoUIState;
    final listUIState = photoUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;

    final filterMatch =
        filter?.isNotEmpty == true ? photo.matchesFilterValue(filter!) : null;

    return DismissibleEntity(
      userCompany: state.userCompany,
      entity: photo,
      isSelected: photo.id ==
          (uiState.isEditing
              ? photoUIState.editing?.id
              : photoUIState.selectedId),
      child: ListTile(
        onTap: () => onTap != null ? onTap!() : selectEntity(entity: photo),
        onLongPress: () => onLongPress != null
            ? onLongPress!()
            : selectEntity(entity: photo, longPress: true),
        leading: showCheckbox
            ? IgnorePointer(
                ignoring: listUIState.isInMultiselect(),
                child: Checkbox(
                  value: isChecked,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) => onCheckboxChanged?.call(value),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            : photo.url.isNotEmpty
                ? Hero(
                    tag: 'photo-${photo.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        photo.url,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: Colors.grey[400]),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[400]),
                  ),
        title: Text(
          photo.category.isEmpty ? 'Unnamed Photo' : photo.category,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              photo.tags.isEmpty ? 'No tags' : photo.tags,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
            if (filterMatch != null && filterMatch.isNotEmpty)
              Text(
                filterMatch,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            EntityStateLabel(photo),
          ],
        ),
        trailing: photo.isProcessed
            ? Icon(Icons.check_circle, color: Colors.green, size: 18)
            : null,
      ),
    );
  }
}
