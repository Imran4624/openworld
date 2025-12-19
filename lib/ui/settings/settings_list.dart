// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/utils/colors.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/lists/list_filter.dart';
import 'package:flutter_boilerplate/ui/app/lists/selected_indicator.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/settings/settings_list_vm.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SettingsListVM viewModel;

  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = widget.viewModel.state;
    final settingsUIState = state.uiState.settingsUIState;
    final showAll = settingsUIState.entityType == EntityType.company;

    if (state.credentials.token.isEmpty) {
      return const SizedBox();
    }

    if (settingsUIState.filter != null || settingsUIState.showNewSettings) {
      return SettingsSearch(
        viewModel: widget.viewModel,
        filter: settingsUIState.filter,
      );
    }

    if (!state.userCompany.isAdmin) {
      return Stack(
        children: [
          ScrollableListView(
            children: <Widget>[
              if (ProjectConfig.settingsShowUserDetailsSetting)
                SettingsListTile(
                  section: kSettingsUserDetails,
                  viewModel: widget.viewModel,
                ),
              SettingsListTile(
                section: kSettingsDeviceSettings,
                viewModel: widget.viewModel,
              ),
            ],
          ),
          if (state.isLoading) const LinearProgressIndicator(),
        ],
      );
    }

    return FormCard(
      children: [
        ScrollableListView(
          scrollController: _scrollController,
          children: <Widget>[
            if (settingsUIState.isFiltered)
              Container(
                color: Colors.orangeAccent,
                child: ListFilterMessage(
                  filterEntityType: settingsUIState.entityType,
                  filterEntityId: 'enter entity id here',
                  onPressed: settingsUIState.entityType == EntityType.user
                      ? widget.viewModel.onViewClientPressed
                      : widget.viewModel.onViewGroupPressed,
                  onClearPressed: widget.viewModel.onClearSettingsFilterPressed,
                  isSettings: true,
                ),
              ),
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.only(left: 19, top: 16, bottom: 16),
              child: Text(
                localization!.basicSettings,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // SettingsListTile(
            //   section: kSettingsCompanyDetails,
            //   viewModel: widget.viewModel,
            // ),
            if (showAll)
              if (ProjectConfig.settingsShowUserDetailsSetting)
                SettingsListTile(
                  section: kSettingsUserDetails,
                  viewModel: widget.viewModel,
                ),
            if (showAll)
              SettingsListTile(
                section: kSettingsDeviceSettings,
                viewModel: widget.viewModel,
              ),
            // if (showAll && state.userCompany.isAdmin)
            if (ProjectConfig.accountManagementEnabled &&
                isAuthenticated(state))
              SettingsListTile(
                section: kSettingsAccountManagement,
                viewModel: widget.viewModel,
              ),
            // Container(
            //   color: Theme.of(context).colorScheme.surface,
            //   padding: const EdgeInsets.only(left: 19, top: 16, bottom: 16),
            //   child: Text(
            //     localization.advancedSettings,
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),
            // if (showAll) ...[
            //   SettingsListTile(
            //     section: kSettingsUserManagement,
            //     viewModel: widget.viewModel,
            //   ),
            // ],
          ],
        ),
        if (state.isLoading) const LinearProgressIndicator(),
      ],
    );
  }
}

class SettingsListTile extends StatefulWidget {
  const SettingsListTile({
    required this.section,
    required this.viewModel,
  });

  final String section;
  final SettingsListVM viewModel;

  @override
  State<SettingsListTile> createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    IconData? icon;
    if (widget.section == kSettingsDeviceSettings) {
      icon = isMobile(context) ? Icons.phone_android : MdiIcons.desktopClassic;
    } else {
      icon = getSettingIcon(widget.section);
    }

    final isSelected =
        widget.viewModel.state.uiState.containsRoute('/${widget.section}') &&
            isDesktop(context);

    final hoverColor = convertHexStringToColor(state.prefState.enableDarkMode
        ? kDefaultDarkSelectedColorMenu
        : kDefaultLightSelectedColorMenu);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: Theme.of(context).cardColor,
        child: SelectedIndicator(
          isSelected: isSelected,
          child: ListTile(
            tileColor: _isHovered && !isSelected ? hoverColor : null,
            dense: isDesktop(context),
            leading: Padding(
              padding: const EdgeInsets.only(left: 6, top: 2),
              child: Icon(icon ?? icon, size: 22),
            ),
            title: Text(
              localization.lookup(widget.section),
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            ),
            onTap: () =>
                widget.viewModel.loadSection(context, widget.section, 0),
          ),
        ),
      ),
    );
  }
}

class SettingsSearch extends StatelessWidget {
  const SettingsSearch({this.filter, this.viewModel});

  final SettingsListVM? viewModel;
  final String? filter;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final map = {
      // kSettingsCompanyDetails: [
      //   [
      //     'name',
      //     'id_number',
      //     'vat_number',
      //     'website',
      //     'email',
      //     'phone',
      //     'size',
      //     'industry',
      //     if (company.hasCustomField(CustomFieldType.company1))
      //       company.getCustomFieldLabel(CustomFieldType.company1),
      //     if (company.hasCustomField(CustomFieldType.company2))
      //       company.getCustomFieldLabel(CustomFieldType.company2),
      //     if (company.hasCustomField(CustomFieldType.company3))
      //       company.getCustomFieldLabel(CustomFieldType.company3),
      //     if (company.hasCustomField(CustomFieldType.company4))
      //       company.getCustomFieldLabel(CustomFieldType.company4)
      //   ],
      //   [
      //     'address',
      //     'postal_code',
      //     'country',
      //   ],
      //   [
      //     'logo',
      //   ]
      // ],
      kSettingsUserDetails: [
        if (ProjectConfig.settingsShowUserDetailsSetting)
          [
            'first_name',
            'last_name',
            'email',
            'phone',
            'password',
            // 'accent_color',
            // 'connect_google',
            // 'connect_gmail',
            // 'enable_two_factor',
          ],
        if (ProjectConfig.settingsShowUserDetailsSetting)
          [
            'notifications',
          ],
      ],
      kSettingsDeviceSettings: [
        [
          'enable_tooltips#2022-07-05',
        ],
        [
          'dark_mode',
        ],
      ],
      // kSettingsAccountManagement: [
      //   [
      //     'activate_company',
      //     'enable_markdown',
      //     'include_drafts',
      //     'include_deleted#2022-10-07',
      //     'api_tokens',
      //     'api_webhooks',
      //     'purge_data',
      //     'delete_company',
      //   ],
      //   [
      //     'enabled_modules',
      //   ],
      //   [
      //     'google_analytics',
      //     'matomo_id#2022-12-12',
      //   ],
      //   [
      //     'password_timeout',
      //     'web_session_timeout',
      //   ],
      //   [
      //     'referral_program#2024-06-21',
      //   ],
      // ],
      // kSettingsUserManagement: [
      //   [
      //     'users',
      //   ],
      // ]
    };

    final filteredMap = <String, List<List<String>>>{};
    for (var entry in map.entries) {
      final section = entry.key;
      final sectionData = entry.value;
      
      if (!state.userCompany.isAdmin) {
        if (section == kSettingsUserDetails || section == kSettingsDeviceSettings) {
          filteredMap[section] = sectionData;
        }
      } else {
        filteredMap[section] = sectionData;
      }
    }

    if (store.state.settingsUIState.showNewSettings) {
      final sections = <String>[];
      for (var section in filteredMap.keys) {
        for (var tab = 0; tab < filteredMap[section]!.length; tab++) {
          final fields = filteredMap[section]![tab];
          for (var field in fields) {
            final List<String> parts = field.split('#');
            final dateAdded =
                parts.length == 1 ? '' : convertSqlDateToDateTime(parts[1]);
            sections.add('$dateAdded#${parts[0]}#$section#$tab');
          }
        }
      }

      sections.sort((a, b) {
        if (a.startsWith('#') && b.startsWith('#')) {
          return a.compareTo(b);
        } else if (a.startsWith('#')) {
          return 1;
        } else if (b.startsWith('#')) {
          return -1;
        }

        return b.compareTo(a);
      });

      return ScrollableListView(children: [
        for (var parts
            in sections.map((section) => section.split('#').toList()))
          if ((filter ?? '').trim().isEmpty ||
              localization
                  .lookup(parts[1])
                  .toLowerCase()
                  .contains(filter!.toLowerCase()))
            ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localization.lookup(parts[1])),
                        Text(
                          localization.lookup(parts[2]),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  /*
                  SizedBox(width: 8),
                  if (parts[0].isNotEmpty)
                    Flexible(
                        child: Text(timeago.format(DateTime.parse(parts[0]),
                            locale:
                                localeSelector(store.state, twoLetter: true) +
                                    '_short'))),
                                    */
                ],
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 6, top: 10),
                child: Icon(getSettingIcon(parts[2]), size: 22),
              ),
              onTap: () =>
                  viewModel!.loadSection(context, parts[2], parseInt(parts[3])),
            ),
      ]);
    } else {
      return ScrollableListView(
        children: [
          for (var section in filteredMap.keys)
            for (int i = 0; i < filteredMap[section]!.length; i++)
              for (var field in filteredMap[section]![i])
                if (localization
                    .lookup(field.split('#')[0])
                    .toLowerCase()
                    .contains(filter!.toLowerCase()))
                  ListTile(
                    title: Text(localization.lookup(field.split('#')[0])),
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 6, top: 10),
                      child: Icon(getSettingIcon(section), size: 22),
                    ),
                    subtitle: Text(localization.lookup(section)),
                    onTap: () => viewModel!.loadSection(context, section, i),
                  ),
        ],
      );
    }
  }
}
