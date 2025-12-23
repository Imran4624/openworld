// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/ui/app/entities/entity_list_tile.dart';

// Package imports:

// Project imports:
import 'package:flutter_boilerplate/ui/app/entity_header.dart';
import 'package:flutter_boilerplate/ui/app/lists/list_divider.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/user/view/user_view_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class UserView extends StatelessWidget {
  const UserView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final UserViewVM viewModel;
  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final user = viewModel.user;

    return ViewScaffold(
      isFilter: isFilter,
      entity: user,
      onBackPressed: () => viewModel.onBackPressed(),
      body: ScrollableListView(
        children: <Widget>[
          // if (user.emailVerifiedAt == null)
          // IconMessage(localization.emailSentToConfirmEmail,
          //     color: Colors.orange),
          EntityHeader(
            entity: user,
            value: user.email,
            label: localization.email,
            secondLabel: localization.phone,
          ),
          ListDivider(),
          // if (userCompany.canViewCreateOrEdit(EntityType.client))
          EntitiesListTile(
            entity: user,
            isFilter: isFilter,
            title: localization.users,
            entityType: EntityType.user,
            // subtitle:
            //     memoizedClientStatsForUser(user.id, state.clientState.map)
            //         .present(localization.active, localization.archived),
          ),
        ],
      ),
    );
  }
}
