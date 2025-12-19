// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/entity_state_config.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';

class EntityStateLabel extends StatelessWidget {
  const EntityStateLabel(this.entity);

  final BaseEntity? entity;

  @override
  Widget build(BuildContext context) {

    return entity!.isDeleted!
        ? Text(EntityStateManager.getStateLabel(entity!.entityType!, EntityState.deleted),
            style: TextStyle(color: Colors.red, fontSize: 14.0))
        : entity!.isArchived
            ? Text(EntityStateManager.getStateLabel(entity!.entityType!, EntityState.archived),
                style: TextStyle(color: Colors.orange, fontSize: 14.0))
            : Container();
  }
}
