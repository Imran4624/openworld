// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class EntityStateTitle extends StatelessWidget {
  const EntityStateTitle({required this.entity});

  final BaseEntity entity;

  @override
  Widget build(BuildContext context) {
    String? titleText = '';
    if (entity.isOld) {
      titleText = EntityPresenter().initialize(entity, context).title();
    }

    return Text(
      titleText!,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
