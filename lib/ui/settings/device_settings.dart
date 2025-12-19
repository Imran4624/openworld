// Flutter imports:
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/forms/decorated_form_field.dart';
import 'package:flutter_boilerplate/utils/files.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_builder.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_form.dart';
import 'package:flutter_boilerplate/ui/app/forms/bool_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/settings/device_settings_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class DeviceSettings extends StatefulWidget {
  const DeviceSettings({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DeviceSettingsVM viewModel;

  @override
  _DeviceSettingsState createState() => _DeviceSettingsState();
}

class _DeviceSettingsState extends State<DeviceSettings>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_deviceSettings');

  TabController? _controller;
  FocusScopeNode? _focusNode;
  String _defaultDownloadsFolder = '';

  final _downloadsFolderController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    final settingsUIState = widget.viewModel.state.settingsUIState;
    _focusNode = FocusScopeNode();
    _controller = TabController(
        vsync: this, length: 2, initialIndex: settingsUIState.tabIndex);
    _controller!.addListener(_onTabChanged);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    _controllers = [
      _downloadsFolderController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final prefState = widget.viewModel.state.prefState;
    _downloadsFolderController.text = prefState.donwloadsFolder;

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    _defaultDownloadsFolder = prefState.donwloadsFolder.isEmpty
        ? await getAppDownloadDirectory() ?? ''
        : prefState.donwloadsFolder;
  }

  void _onChanged() async {
    widget.viewModel
        .onDownloadsFolderChanged(context, _downloadsFolderController.text);

    _defaultDownloadsFolder = _downloadsFolderController.text.isEmpty
        ? await getAppDownloadDirectory() ?? ''
        : _downloadsFolderController.text;
  }

  void _onTabChanged() {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(UpdateSettingsTab(tabIndex: _controller!.index));
  }

  @override
  void dispose() {
    _controller!.removeListener(_onTabChanged);
    _controller!.dispose();
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final prefState = state.prefState;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: isMobile(context),
        title: Text(localization.deviceSettings),
      ),
      body: AppForm(
        formKey: _formKey,
        focusNode: _focusNode,
        children: [
          ScrollableListView(
            primary: true,
            children: <Widget>[
              FormCard(children: [
                AppDropdownButton<String>(
                    labelText: localization.lightDarkMode,
                    value: prefState.darkModeType,
                    onChanged: (dynamic brightness) {
                      viewModel.onDarkModeChanged(context, brightness);
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          '${localization.system} (${prefState.enableDarkModeSystem ? localization.dark : localization.light})',
                        ),
                        value: kBrightnessSytem,
                      ),
                      DropdownMenuItem(
                        child: Text(localization.light),
                        value: kBrightnessLight,
                      ),
                      DropdownMenuItem(
                        child: Text(localization.dark),
                        value: kBrightnessDark,
                      ),
                    ]),
              ]),
              if (ProjectConfig.showlayoutSetting)
                FormCard(
                  children: <Widget>[
                    BoolDropdownButton(
                      label: localization.layout,
                      value: prefState.appLayout == AppLayout.mobile,
                      onChanged: (value) {
                        viewModel.onLayoutChanged(
                            context,
                            value == true
                                ? AppLayout.mobile
                                : AppLayout.desktop);
                      },
                      enabledLabel: localization.mobile,
                      disabledLabel: localization.desktop,
                    ),
                    if (state.prefState.isDesktop) ...[
                      BoolDropdownButton(
                        label: localization.menuSidebar,
                        value:
                            prefState.menuSidebarMode == AppSidebarMode.float,
                        onChanged: (value) {
                          viewModel.onMenuModeChanged(
                            context,
                            value == true
                                ? AppSidebarMode.float
                                : AppSidebarMode.collapse,
                          );
                        },
                        enabledLabel: localization.float,
                        disabledLabel: localization.collapse,
                      ),
                      BoolDropdownButton(
                        label: localization.historySidebar,
                        value: prefState.historySidebarMode ==
                            AppSidebarMode.float,
                        onChanged: (value) {
                          viewModel.onHistoryModeChanged(
                            context,
                            value == true
                                ? AppSidebarMode.float
                                : AppSidebarMode.visible,
                          );
                        },
                        enabledLabel: localization.float,
                        disabledLabel: localization.showOrHide,
                      ),
                    ],
                    if (isMobile(context)) ...[
                      BoolDropdownButton(
                        label: localization.listLongPress,
                        value: !prefState.longPressSelectionIsDefault,
                        onChanged: (value) {
                          viewModel.onLongPressSelectionIsDefault(
                              context, value == false);
                        },
                        enabledLabel: localization.showActions,
                        disabledLabel: localization.startMultiselect,
                      ),
                    ]
                  ],
                ),
              FormCard(
                children: <Widget>[
                  if (!isWeb() && ProjectConfig.showDownloadForm)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: DecoratedFormField(
                            label: localization.downloadsFolder,
                            keyboardType: TextInputType.text,
                            hint: _defaultDownloadsFolder,
                            controller: _downloadsFolderController,
                          ),
                        ),
                        SizedBox(width: 20),
                        OutlinedButton(
                          onPressed: () async {
                            final folder = await FilesystemPicker.open(
                              context: context,
                              fsType: FilesystemType.folder,
                              rootDirectory: Directory(Platform.pathSeparator),
                              directory: Directory(_defaultDownloadsFolder),
                              title: localization.downloadsFolder,
                              pickText: localization.saveFilesToThisFolder,
                            );

                            if ((folder ?? '').isNotEmpty) {
                              _downloadsFolderController.text = folder!;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(localization.select),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppDropdownButton<double>(
                        labelText: localization.fontSize,
                        value: prefState.textScaleFactor,
                        onChanged: (dynamic value) {
                          viewModel.onTextScaleFactorChanged(context, value);
                          AppBuilder.of(context)!.rebuild();
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text(localization.small),
                            value: PrefState.TEXT_SCALING_SMALL,
                          ),
                          DropdownMenuItem(
                            child: Text(localization.normal),
                            value: PrefState.TEXT_SCALING_NORMAL,
                          ),
                          DropdownMenuItem(
                            child: Text(localization.large),
                            value: PrefState.TEXT_SCALING_LARGE,
                          ),
                          DropdownMenuItem(
                            child: Text(localization.extraLarge),
                            value: PrefState.TEXT_SCALING_EXTRA_LARGE,
                          ),
                        ]),
                  ),
                  if (isDesktop(context)) ...[
                    SwitchListTile(
                      title: Text(localization.enableTouchEvents),
                      subtitle: Text(localization.enableTouchEventsHelp),
                      value: prefState.enableTouchEvents,
                      onChanged: (value) =>
                          viewModel.onEnableTouchEventsChanged(context, value),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      secondary: Icon(Icons.touch_app),
                    ),
                    SwitchListTile(
                      title: Text(localization.enableTooltips),
                      subtitle: Text(localization.enableTooltipsHelp),
                      value: prefState.enableTooltips,
                      onChanged: (value) =>
                          viewModel.onEnableTooltipsChanged(context, value),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      secondary: Icon(MdiIcons.tooltip),
                    ),
                  ],
                ],
              ),
              //   FormCard(
              //     isLast: true,
              //     children: <Widget>[
              //       Builder(builder: (BuildContext context) {
              //         return ListTile(
              //           leading: Icon(Icons.refresh),
              //           title: Text(localization.refreshData),
              //           subtitle: LiveText(() {
              //             if (state.userCompanyState.lastUpdated == 0) {
              //               return '';
              //             }

              //             return localization.lastUpdated +
              //                 ': ' +
              //                 timeago.format(
              //                     convertTimestampToDate(
              //                         (state.userCompanyState.lastUpdated / 1000)
              //                             .round()),
              //                     locale: localeSelector(state, twoLetter: true));
              //           }),
              //           onTap: () {
              //             viewModel.onRefreshTap(context);
              //           },
              //         );
              //       }),
              //       ListTile(
              //         leading: Icon(Icons.logout),
              //         title: Text(localization.endAllSessions),
              //         /*
              //         subtitle: Text(countSessions == 1
              //             ? localization.countSession
              //             : localization.countSession
              //                 .replaceFirst(':count', '$countSessions')),
              //                 */
              //         onTap: () {
              //           confirmCallback(
              //               context: context,
              //               callback: (_) {
              //                 viewModel.onLogoutTap(context);
              //               });
              //         },
              //       ),
              //     ],
              //   )
            ],
          ),
        ],
      ),
    );
  }
}
