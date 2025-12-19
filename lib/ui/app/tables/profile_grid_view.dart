import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/tables/profile_grid_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_actions.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class ProfileGridView extends StatelessWidget {
  const ProfileGridView({
    super.key,
    required this.entityList,
    required this.entityMap,
    required this.scrollController,
    required this.onSelectEntity,
    this.isProfileOperation = false,
  });

  final List<String?> entityList;
  final dynamic entityMap; 
  final ScrollController scrollController;
  final Function(dynamic) onSelectEntity; 
  final bool isProfileOperation;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final localization = AppLocalization.of(context);

    final listUIState = isProfileOperation
        ? state.profileOperationListState
        : state.profileListState;
    final isInMultiselect = listUIState.isInMultiselect();

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > kTabletLayoutWidth
        ? 4
        : screenWidth > kMobileLayoutWidth
            ? 3
            : 2;

    if (entityList.isEmpty) {
      return Center(
        child: Text(
          state.userCompany.canCreate(EntityType.profile)
              ? localization!.clickPlusToCreateRecord
              : localization!.noRecordsFound,
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: entityList.length,
      itemBuilder: (context, index) {
        final entityId = entityList[index];
        if (entityId == null) return const SizedBox.shrink();

        dynamic entity;
        ProfileEntity? profileToShow;

        try {
          if (isProfileOperation) {
            if (entityMap is BuiltMap<String, ProfileOperationEntity>) {
              entity = entityMap[entityId];
            } else {
              entity = entityMap[entityId];
            }

            if (entity == null) {
              logError('ProfileOperation not found for ID: $entityId');
              return const SizedBox.shrink();
            }

            try {
              profileToShow = entity.profileEntity;
              if (profileToShow == null) {
                logError('ProfileEntity is null in ProfileOperation');
                profileToShow = ProfileEntity(id: entityId);
              }
            } catch (e) {
              logError('Error accessing profileEntity: $e');
              profileToShow = ProfileEntity(id: entityId);
            }
          } else {
            if (entityMap is BuiltMap<String?, ProfileEntity?>) {
              profileToShow = entityMap[entityId];
            } else {
              profileToShow = entityMap[entityId];
            }

            if (profileToShow == null) {
              logError('Profile not found for ID: $entityId');
              return const SizedBox.shrink();
            }

            entity =
                profileToShow; 
          }
        } catch (e) {
          logError('Error looking up entity: $e');
          return const SizedBox.shrink();
        }

        final isSelected = isInMultiselect &&
            listUIState.selectedIds != null &&
            listUIState.selectedIds!.contains(entity.id);

        return ProfileGridItem(
          profile: profileToShow,
          isChecked: isSelected,
          isInMultiselect: isInMultiselect,
          onTap: () {
            if (isInMultiselect) {
              if (isSelected) {
                if (isProfileOperation) {
                  store.dispatch(
                      RemoveFromProfileOperationMultiselect(entity: entity));
                } else {
                  store.dispatch(RemoveFromProfileMultiselect(entity: entity));
                }
              } else {
                if (isProfileOperation) {
                  store.dispatch(
                      AddToProfileOperationMultiselect(entity: entity));
                } else {
                  store.dispatch(AddToProfileMultiselect(entity: entity));
                }
              }
            } else {
              onSelectEntity(entity);
            }
          },
          onLongPress: isInMultiselect
              ? null
              : () {
                  if (isProfileOperation) {
                    store.dispatch(StartProfileOperationMultiselect());
                    store.dispatch(
                        AddToProfileOperationMultiselect(entity: entity));
                  } else {
                    store.dispatch(StartProfileMultiselect());
                    store.dispatch(AddToProfileMultiselect(entity: entity));
                  }
                },
        );
      },
    );
  }
}
