import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class EntityGridView extends StatelessWidget {
  const EntityGridView({
    Key? key,
    required this.entityList,
    required this.entityMap,
    required this.scrollController,
    required this.crossAxisCount,
    required this.selectEntity,
    required this.entityPresenter,
    required this.tableColumns,
  }) : super(key: key);

  final List<dynamic> entityList;
  final BuiltMap<String?, SelectableEntity?>? entityMap;
  final ScrollController scrollController;
  final int crossAxisCount;
  final EntityPresenter? entityPresenter;
  final List<String>? tableColumns;
  final Function(dynamic) selectEntity;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: entityList.length,
      itemBuilder: (context, index) {
        final entity = entityMap![entityList[index]]!;
        entityPresenter!.initialize(entity as BaseEntity, context);
        return GestureDetector(
          onTap: () => selectEntity(entity),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      'https://picsum.photos/id/0/300/300',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ...tableColumns!.map((field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('${field.toUpperCase()} : '),
                                entityPresenter!
                                    .getField(field: field, context: context),
                              ],
                            ),
                          ),
                        ])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => printL('Clicked '),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

String? formatNumber(dynamic value, BuildContext context) {
  // Replace with your number formatting logic
  return value.toString();
}
