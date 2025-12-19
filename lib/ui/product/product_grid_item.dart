import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    this.onLongPress,
    this.isInMultiselect = false,
    this.isChecked = false,
  });

  final ProductEntity product;
  final Function() onTap;
  final Function()? onLongPress;
  final bool isInMultiselect;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final questionGroups = state.dynamicFieldState.questionGroups;
    List<String> imageUrls =
        product.dynamicFields.getImages(DynamicFieldsConstants.images);
    String? fullName =
        product.dynamicFields.getValue(DynamicFieldsConstants.name) ?? product.name;
    final questionMap = <String, QuestionModel>{};
    for (var group in questionGroups) {
      for (var question in group.questions) {
        questionMap[question.id] = question;
      }
    }

    Map<String, String> displayFields = product.dynamicFields
        .getDisplayFields(ProjectConfig.displayFieldIds, questionMap);

    displayFields = Map.fromEntries(displayFields.entries
        .where((entry) => entry.value != null && entry.value.isNotEmpty));

    return Card(
      elevation: isChecked ? 6 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isChecked
            ? BorderSide(
                color: Theme.of(context).colorScheme.secondary, width: 2.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrls.isNotEmpty
                  ? DynamicFieldsViewImages(
                      viewType: ImageViewType.thumbnailBig,
                      images: imageUrls,
                    )
                  : _buildDefaultImage(),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
              if (!isInMultiselect)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isInMultiselect)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isChecked
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isChecked
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        size: 18,
                        color: isChecked ? Colors.white : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      ...displayFields.entries.take(2).map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage() {
    return Container(
      color: Colors.grey.shade300,
      child: Center(
        child: Icon(
          Icons.inventory_2,
          size: 64,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}