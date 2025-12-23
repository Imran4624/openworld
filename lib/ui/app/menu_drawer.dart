// Dart imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/company/company_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/admin/admin_screen.dart';
import 'package:flutter_boilerplate/ui/app/about_us.dart';
import 'package:flutter_boilerplate/ui/app/app_webview_url.dart' as appView;
import 'package:flutter_boilerplate/ui/app/system/update_dialog.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/company/company_edit_screen.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/forms/user_dropdown_button.dart';
import 'package:flutter_boilerplate/ui/app/sms_verification.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dashboard/dashboard_actions.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/app_border.dart';
import 'package:flutter_boilerplate/ui/app/dialogs/error_dialog.dart';
import 'package:flutter_boilerplate/ui/app/icon_text.dart';
import 'package:flutter_boilerplate/ui/app/menu_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/utils/icons.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/strings.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    super.key,
    required this.viewModel,
  });

  final MenuDrawerVM viewModel;
  static const LOGO_WIDTH = 38.0;

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MenuDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldCompanyIds = oldWidget.viewModel.userProfile?.companyIds.toSet();
    final newCompanyIds = widget.viewModel.userProfile?.companyIds.toSet();

    if (oldCompanyIds != newCompanyIds) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadUserCompanies();
        _handleAutoCompanySelection();
      });
    }
  }

  void _loadUserCompanies() {}

  void _handleAutoCompanySelection() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final state = store.state;

    if (state.isLoading || state.isSaving) {
      return;
    }

    if (!isAuthenticated(state)) {
      return;
    }

    final userProfile = widget.viewModel.userProfile;
    if (userProfile == null || userProfile.companyIds.isEmpty) {
      return;
    }

    final userCompanies = state.companies
        .where((company) => userProfile.companyIds.contains(company.id))
        .toList();

    if (userCompanies.isEmpty) {
      _loadUserCompanies();
      return;
    }

    final currentSelectedCompanyId = state.userCompanyState.selectedCompanyId;

    if (currentSelectedCompanyId.isEmpty && userCompanies.isNotEmpty) {
      final targetCompanyId = userCompanies.first.id;
      store.dispatch(SelectCompanyById(companyId: targetCompanyId));
    }
  }

  String? _getValidDropdownValue(List<CompanyEntity> userCompanies,
      bool isUserAdmin, String currentCompanyId) {
    final hasCurrentCompany =
        userCompanies.any((c) => c.id == currentCompanyId);
    if (hasCurrentCompany) {
      return currentCompanyId;
    }
    if (userCompanies.isNotEmpty) {
      return userCompanies.first.id;
    }

    if (isUserAdmin) {
      return 'add_company';
    }

    return null;
  }

  String? _getValidDropdownValueForEvents121(List<CompanyEntity> userCompanies,
      bool isUserAdmin, String selectedCompanyId) {
    if (selectedCompanyId.isNotEmpty) {
      final hasSelectedCompany =
          userCompanies.any((c) => c.id == selectedCompanyId);
      if (hasSelectedCompany) {
        return selectedCompanyId;
      }
    }

    if (userCompanies.isNotEmpty) {
      return userCompanies.first.id;
    }

    if (isUserAdmin) {
      return 'add_company';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final enableDarkMode = state.prefState.enableDarkMode;
    final localization = AppLocalization.of(context)!;
    final company = widget.viewModel.selectedCompany;
    final themeColors = enableDarkMode ? AppTheme.dark : AppTheme.light;
    final inactiveColor = state.prefState.activeCustomColors[
            PrefState.THEME_SIDEBAR_INACTIVE_BACKGROUND_COLOR] ??
        themeColors.background.toString();

    if (company == null) {
      return Container();
    }

    final collapsedUserSelector = PopupMenuButton<String>(
      tooltip: isAuthenticated(state)
          ? state.authState.currentUserName.isNotEmpty
              ? state.authState.currentUserName
              : state.user.firstName
          : 'My Account',
      color: Theme.of(context).cardColor,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: isAuthenticated(state)
              ? state.authState.currentUserName.isNotEmpty
                  ? state.authState.currentUserName
                  : state.user.firstName
              : 'My Account',
          child: Row(
            children: [
              const Icon(Icons.person, size: 32),
              const SizedBox(width: 10),
              Text(
                isAuthenticated(state)
                    ? state.authState.currentUserName.isNotEmpty
                        ? state.authState.currentUserName
                        : state.user.firstName
                    : 'My Account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        if (!isAuthenticated(state))
          PopupMenuItem<String>(
            value: DrawerActions.login,
            child: const Row(
              children: [
                Icon(Icons.login, size: 32),
                SizedBox(width: 15),
                Text('Login'),
              ],
            ),
          ),
        if (isAuthenticated(state)) ...[
          if (state.user.oauthProvider == '' &&
              !state.authState.isEmailLinkAuth)
            PopupMenuItem<String>(
              value: DrawerActions.changePassword,
              child: Row(
                children: [
                  const Icon(Icons.lock, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          if (ProjectConfig.showEditProfileInUserMenu)
            PopupMenuItem(
              value: DrawerActions.editProfile,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 2),
                  const Icon(Icons.person, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          if (ProjectConfig.showMyProfileInUserMenu)
            PopupMenuItem(
              value: DrawerActions.myProfile,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 2),
                  const Icon(Icons.person, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          PopupMenuItem<String>(
            value: DrawerActions.logout,
            child: Row(
              children: [
                const Icon(Icons.logout, size: 32),
                const SizedBox(width: 15),
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ]
      ],
      onSelected: (String value) {
        if (value == DrawerActions.login) {
          store.dispatch(UpdateCurrentRoute(LoginScreen.route));
          navigatorKey.currentState!.pushNamedAndRemoveUntil(
              LoginScreen.route, (Route<dynamic> route) => false);
        } else if (value == DrawerActions.logout) {
          widget.viewModel.onLogoutTap(context);
        } else if (value == DrawerActions.changePassword) {
          widget.viewModel.changePassword(context);
        } else if (value == DrawerActions.editProfile) {
          store.dispatch(EditProfile(
            profile: widget.viewModel.state.profileState.loggedInUserProfile,
            force: true,
          ));
        } else if (value == DrawerActions.myProfile) {
          selectEntity(
              entity: widget.viewModel.state.profileState.loggedInUserProfile);
        }
      },
      child: const Row(
        children: [
          Icon(Icons.person, size: 32),
        ],
      ),
    );

    Widget companyListItem(
      CompanyEntity company, {
      bool showAccentColor = true,
    }) {
      final selectedCompany = widget.viewModel.selectedCompany;
      final isSelected =
          selectedCompany != null && selectedCompany.id == company.id;
      final isUserAdmin = isAdmin(state);

      return Container(
        decoration: isSelected && showAccentColor
            ? BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: _buildCompanyIcon(company),
            ),
            const SizedBox(width: 10, height: kTopBottomBarHeight),
            Expanded(
              child: Text(
                company.displayName.isEmpty
                    ? 'New Company'
                    : company.displayName,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isUserAdmin)
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                tooltip: 'Edit Company',
                onPressed: () => _navigateToCompanyEdit(context, company),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
              ),
            if (showAccentColor && isSelected)
              Container(
                padding: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
                width: 10,
                height: 10,
              ),
          ],
        ),
      );
    }

    Widget? companyDropdown() {
      if (!isAuthenticated(state)) {
        return null;
      }

      final userProfile = widget.viewModel.userProfile;
      if (userProfile == null || userProfile.companyIds.isEmpty) {
        return null;
      }

      final isUserAdmin = isAdmin(state);

      final userCompanies = state.companies
          .where((company) => userProfile.companyIds.contains(company.id))
          .toList();

      if (userCompanies.isEmpty) {
        _loadUserCompanies();
        return null;
      }

      final collapsedCompanySelector = PopupMenuButton<String>(
        tooltip: 'Select Company',
        color: Theme.of(context).cardColor,
        itemBuilder: (BuildContext context) => [
          ...userCompanies.map((company) => PopupMenuItem<String>(
                value: company.id,
                child: companyListItem(company),
              )),
          if (isUserAdmin)
            PopupMenuItem<String>(
              value: 'add_company',
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 2),
                  const Icon(Icons.add_circle, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Add Company',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
        ],
        onSelected: (String? value) {
          if (value == 'add_company') {
            _navigateToCompanyEdit(context, null);
          } else if (value?.isNotEmpty == true) {
            final companyIndex = widget.viewModel.state.companies
                .indexWhere((c) => c.id == value);
            if (companyIndex >= 0) {
              widget.viewModel.onCompanyChanged(
                context,
                companyIndex,
                widget.viewModel.state.companies[companyIndex],
              );
            }
          }
        },
        child: const SizedBox(
          height: kTopBottomBarHeight,
          width: MenuDrawer.LOGO_WIDTH,
          child: Icon(Icons.business, size: 32),
        ),
      );

      final expandedCompanySelector = SizedBox(
        height: kTopBottomBarHeight,
        child: AppDropdownButton<String>(
          value: _getValidDropdownValue(userCompanies, isUserAdmin, company.id),
          selectedItemBuilder: (context) => [
            if (userCompanies.isNotEmpty)
              ...userCompanies.map((company) =>
                  companyListItem(company, showAccentColor: false)),
            if (isUserAdmin)
              Row(
                children: <Widget>[
                  const SizedBox(width: 2),
                  const Icon(Icons.add_circle, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Add Company',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
          ],
          items: [
            ...userCompanies.map((company) => DropdownMenuItem<String>(
                value: company.id, child: companyListItem(company))),
            if (isUserAdmin)
              DropdownMenuItem<String>(
                value: 'add_company',
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 2),
                    const Icon(Icons.add_circle, size: 32),
                    const SizedBox(width: 15),
                    Text(
                      'Add Company',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
          ],
          onChanged: (dynamic value) {
            if (value == 'add_company') {
              _navigateToCompanyEdit(context, null);
            } else if (value?.isNotEmpty == true) {
              final companyIndex = widget.viewModel.state.companies
                  .indexWhere((c) => c.id == value);
              if (companyIndex >= 0) {
                widget.viewModel.onCompanyChanged(
                  context,
                  companyIndex,
                  widget.viewModel.state.companies[companyIndex],
                );
              }
            }
          },
        ),
      );

      if (userCompanies.isEmpty && !isUserAdmin) {
        return null;
      }

      return state.prefState.isMenuCollapsed
          ? collapsedCompanySelector
          : expandedCompanySelector;
    }

    final expandedUserSelector = UserDropdownButton<String>(
      value: isAuthenticated(state)
          ? state.authState.currentUserName.isNotEmpty
              ? state.authState.currentUserName
              : state.user.firstName
          : 'My Account',
      selectedItemBuilder: (context) => [
        Row(
          children: [
            const Icon(Icons.person, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isAuthenticated(state)
                    ? state.authState.currentUserName.isNotEmpty
                        ? state.authState.currentUserName
                        : state.user.firstName
                    : 'My Account',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
      items: [
        if (!isAuthenticated(state))
          DropdownMenuItem<String>(
            value: DrawerActions.login,
            child: const Row(
              children: [
                Icon(Icons.login, size: 32),
                SizedBox(width: 15),
                Text('Login'),
              ],
            ),
          ),
        if (isAuthenticated(state)) ...[
          if (state.user.oauthProvider == '')
            DropdownMenuItem<String>(
              value: state.authState.currentUserName.isNotEmpty
                  ? state.authState.currentUserName
                  : state.user.firstName,
              child: Row(
                children: [
                  const Icon(Icons.person, size: 32),
                  const SizedBox(width: 10),
                  Text(
                    state.authState.currentUserName.isNotEmpty
                        ? state.authState.currentUserName
                        : state.user.firstName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          if (state.user.oauthProvider == '' &&
              !state.authState.isEmailLinkAuth)
            DropdownMenuItem<String>(
              value: DrawerActions.changePassword,
              child: Row(
                children: [
                  const Icon(Icons.lock, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Change Password',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          if (ProjectConfig.showEditProfileInUserMenu)
            DropdownMenuItem<String>(
              value: DrawerActions.editProfile,
              child: Row(
                children: [
                  const Icon(Icons.person, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          if (ProjectConfig.showMyProfileInUserMenu)
            DropdownMenuItem<String>(
              value: DrawerActions.myProfile,
              child: Row(
                children: [
                  const Icon(Icons.person, size: 32),
                  const SizedBox(width: 15),
                  Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          DropdownMenuItem<String>(
            value: DrawerActions.logout,
            child: Row(
              children: [
                const Icon(Icons.logout, size: 32),
                const SizedBox(width: 15),
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ]
      ],
      onChanged: (dynamic value) {
        if (value == DrawerActions.login) {
          store.dispatch(UpdateCurrentRoute(LoginScreen.route));
          if (isMobile(context)) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                LoginScreen.route, (Route<dynamic> route) => false);
          }
        } else if (value == DrawerActions.logout) {
          widget.viewModel.onLogoutTap(context);
        } else if (value == DrawerActions.changePassword) {
          widget.viewModel.changePassword(context);
        } else if (value == DrawerActions.editProfile) {
          store.dispatch(EditProfile(
            profile: widget.viewModel.state.profileState.loggedInUserProfile,
            force: true,
          ));
        } else if (value == DrawerActions.myProfile) {
          fetchAndViewEntity(
              store: store,
              entityType: EntityType.profile,
              entityId: getLoggedInUserId(store));
        }
      },
    );

    return FocusTraversalGroup(
      child: SizedBox(
        width: state.isMenuCollapsed
            ? 65
            : isDesktop(context)
                ? kDrawerWidthDesktop
                : kDrawerWidthMobile,
        child: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                state.credentials.token.isEmpty
                    ? const Expanded(child: SizedBox())
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 3),
                        color: themeColors.secondary,
                        child: state.isMenuCollapsed
                            ? collapsedUserSelector
                            : Column(
                                children: [
                                  if (companyDropdown() != null)
                                    companyDropdown()!,
                                  if (companyDropdown() != null)
                                    const SizedBox(height: 8),
                                  expandedUserSelector,
                                ],
                              )),
                state.credentials.token.isEmpty
                    ? const SizedBox()
                    : Theme(
                        data: enableDarkMode || inactiveColor.isNotEmpty
                            ? ThemeData.dark().copyWith(
                                cardColor: themeColors.secondary,
                                textTheme: TextTheme(
                                  bodyLarge: TextStyle(color: themeColors.text),
                                  bodyMedium: TextStyle(
                                      color: themeColors.textSecondary),
                                ),
                              )
                            : ThemeData.light().copyWith(
                                cardColor: themeColors.secondary,
                                textTheme: TextTheme(
                                  bodyLarge: TextStyle(color: themeColors.text),
                                  bodyMedium: TextStyle(
                                      color: themeColors.textSecondary),
                                ),
                              ),
                        child: Expanded(
                          child: Container(
                            color: themeColors.secondary,
                            child: ScrollableListView(
                              children: <Widget>[
                                if (state.account.debugEnabled && kReleaseMode)
                                  if (state.isMenuCollapsed)
                                    Tooltip(
                                      message: localization.debugModeIsEnabled,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 20),
                                        onTap: () =>
                                            launchUrl(Uri.parse(kDebugModeUrl)),
                                        leading: Icon(Icons.warning,
                                            color: themeColors.danger),
                                      ),
                                    )
                                  else
                                    Material(
                                      child: ListTile(
                                        tileColor: Colors.red.shade800,
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: IconText(
                                            icon: Icons.warning,
                                            text:
                                                localization.debugModeIsEnabled,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        subtitle: Text(
                                          localization.debugModeIsEnabledHelp,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () =>
                                            launchUrl(Uri.parse(kDebugModeUrl)),
                                      ),
                                    ),
                                if (!state.authState.phoneVerified &&
                                    isAuthenticated(state))
                                  if (ProjectConfig.showBecomeAMemberBanner())
                                    if (state.isMenuCollapsed)
                                      Tooltip(
                                        message: localization.becomeMember,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12),
                                          leading: IconButton(
                                            onPressed: () {
                                              appView.openUrl(
                                                  context,
                                                  kCacBecomeMember,
                                                  localization.becomeMember);
                                            },
                                            icon: const Icon(Icons.warning,
                                                color: Colors.lightGreen),
                                          ),
                                        ),
                                      )
                                    else
                                      Material(
                                        color: Colors.lightGreen.shade800,
                                        child: InkWell(
                                          onTap: () {
                                            appView.openUrl(
                                                context,
                                                kCacBecomeMember,
                                                localization.becomeMember);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Text(
                                              localization.becomeMember,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                  else if (state.isMenuCollapsed &&
                                      ProjectConfig
                                          .showVerifyPhoneNumberBanner())
                                    Tooltip(
                                      message:
                                          localization.verifyPhoneNumberHelp,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.only(left: 12),
                                        leading: IconButton(
                                          onPressed: () {
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  const AccountSmsVerification(),
                                            );
                                          },
                                          icon: const Icon(Icons.warning,
                                              color: Colors.orange),
                                        ),
                                      ),
                                    )
                                  else if (ProjectConfig
                                      .showVerifyPhoneNumberBanner())
                                    Material(
                                      child: ListTile(
                                        tileColor: Colors.orange.shade800,
                                        subtitle: Text(
                                          localization.verifyPhoneNumberHelp,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                const AccountSmsVerification(),
                                          );
                                        },
                                      ),
                                    )
                                  else if (state.user.isTwoFactorEnabled &&
                                      !state.user.phoneVerified &&
                                      state.isHosted)
                                    if (state.isMenuCollapsed)
                                      Tooltip(
                                        message: localization
                                            .verifyPhoneNumber2faHelp,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12),
                                          leading: IconButton(
                                            onPressed: () {
                                              showDialog<void>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    const UserSmsVerification(
                                                  showChangeNumber: true,
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.warning,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      )
                                    else
                                      Material(
                                        child: ListTile(
                                          tileColor: Colors.orange.shade800,
                                          subtitle: Text(
                                            localization
                                                .verifyPhoneNumber2faHelp,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  const UserSmsVerification(),
                                            );
                                          },
                                        ),
                                      )
                                  else if (state.company.isDisabled &&
                                      state.userCompany.isAdmin)
                                    if (state.isMenuCollapsed)
                                      Tooltip(
                                        message:
                                            localization.companyDisabledWarning,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 12),
                                          leading: IconButton(
                                            onPressed: () =>
                                                store.dispatch(ViewSettings(
                                              section:
                                                  kSettingsAccountManagement,
                                              company: company,
                                            )),
                                            icon: const Icon(Icons.warning,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      )
                                    else
                                      Material(
                                        child: ListTile(
                                          tileColor: Colors.orange.shade800,
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: IconText(
                                              icon: Icons.warning,
                                              text: localization.warning,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          subtitle: Text(
                                            localization.companyDisabledWarning,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            store.dispatch(ViewSettings(
                                              section:
                                                  kSettingsAccountManagement,
                                              company: company,
                                            ));
                                          },
                                        ),
                                      ),
                                // if (state.userCompany.isOwner &&
                                //     state.isHosted &&
                                //     !state.isProPlan &&
                                //     (!isApple() || supportsInAppPurchase()))
                                if (ProjectConfig.showBuyBanner)
                                  Material(
                                    child: Tooltip(
                                      message: state.isMenuCollapsed
                                          ? localization.upgrade
                                          : '',
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.only(left: 12),
                                        tileColor: Colors.green,
                                        leading: IconButton(
                                          onPressed: () => launchUrl(
                                              Uri.parse(kContactUsUrl)),
                                          icon: const Icon(
                                            Icons.rocket_launch,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: state.isMenuCollapsed
                                            ? const SizedBox()
                                            : Text(
                                                localization.upgrade,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                        onTap: () {
                                          launchUrl(Uri.parse(kContactUsUrl));
                                        },
                                      ),
                                    ),
                                  ),

                                if (isAuthenticated(state)) ...[
                                  if (state.userCompany.canViewDashboard &&
                                      ProjectConfig.showDashboard)
                                    DrawerTile(
                                      company: company,
                                      entityType: EntityType.dashboard,
                                      icon: getEntityIcon(EntityType.dashboard),
                                      title: localization.dashboard,
                                      onLongPress: () => store
                                          .dispatch(ViewDashboard(filter: '')),
                                    ),
                                  // STARTER: menu - do not remove comment
                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.payment,
                                    icon: getEntityIcon(EntityType.payment),
                                    title: localization.payments,
                                  ),

                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.workout,
                                    icon: getEntityIcon(EntityType.workout),
                                    title: localization.workouts,
                                  ),
                                  if (isAdmin(state) ||
                                      ProjectConfig
                                          .showEntityDrawerTabByEntityType(
                                              EntityType.photo))
                                    DrawerTile(
                                      company: company,
                                      entityType: EntityType.photo,
                                      icon: getEntityIcon(EntityType.photo),
                                      title: localization.photos,
                                    ),
                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.social,
                                    icon: getEntityIcon(EntityType.social),
                                    title: localization.socials,
                                  ),
                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.product,
                                    icon: getEntityIcon(EntityType.product),
                                    title: localization.shop,
                                  ),
                                  if (ProjectConfig
                                      .showEntityDrawerTabByEntityType(
                                          EntityType.notification))
                                    DrawerTile(
                                      company: company,
                                      entityType: EntityType.notification,
                                      icon: getEntityIcon(
                                          EntityType.notification),
                                      title: localization.notifications,
                                    ),
                                  if (isAdmin(state) ||
                                      ProjectConfig
                                          .showEntityDrawerTabByEntityType(
                                              EntityType.profile))
                                    DrawerTile(
                                      company: company,
                                      entityType: EntityType.profile,
                                      icon: getEntityIcon(EntityType.profile),
                                      title: ProjectConfig
                                          .profileModuleDisplayName,
                                    ),

                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.chat,
                                    icon: getEntityIcon(EntityType.chat),
                                    title: localization.chats,
                                  ),

                                  DrawerTile(
                                      company: company,
                                      entityType: EntityType.profileOperation,
                                      icon: getEntityIcon(
                                          EntityType.profileOperation),
                                      title:
                                          ProjectConfig.matchesOrConnections),
                                ],
                                if (ProjectConfig
                                    .showEntityDrawerTabByEntityType(
                                        EntityType.event))
                                  DrawerTile(
                                    company: company,
                                    entityType: EntityType.event,
                                    icon: getEntityIcon(EntityType.event),
                                    title: localization.events,
                                  ),

                                if (ProjectConfig.appType != AppType.opw)
                                  DrawerTile(
                                    company: company,
                                    icon: getEntityIcon(EntityType.settings),
                                    title: localization.settings,
                                    onTap: () => viewEntitiesByType(
                                        entityType: EntityType.settings),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: kTopBottomBarHeight,
                  child: AppBorder(
                    isTop: true,
                    child: Container(
                      color: themeColors.secondary,
                      child: Align(
                        alignment: const Alignment(0, 1),
                        child: state.isMenuCollapsed
                            ? const SidebarFooterCollapsed()
                            : SidebarFooter(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCompanyEdit(BuildContext context, [CompanyEntity? company]) {
    Navigator.of(context).pop();

    UserCompany? userCompany;
    if (company != null) {
      userCompany = UserCompany(
        companyId: company.id,
        companyName: company.displayName,
      );
    }

    Navigator.of(context).pushNamed(
      CompanyEditScreen.route,
      arguments: userCompany,
    );
  }

  Widget _buildCompanyIcon(CompanyEntity? company) {
    if (company != null && company.settings.hasLogo) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            company.settings.companyLogo!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.business,
                  size: 20,
                  color: Colors.grey,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.business,
                  size: 20,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      );
    }

    return const Icon(Icons.business, size: 32);
  }
}

class DrawerTile extends StatefulWidget {
  const DrawerTile({
    required this.company,
    required this.icon,
    required this.title,
    this.onTap,
    this.entityType,
    this.onLongPress,
    this.onCreateTap,
    this.iconTooltip,
  });

  final CompanyEntity company;
  final EntityType? entityType;
  final IconData icon;
  final String? title;
  final Function? onTap;
  final Function? onLongPress;
  final Function? onCreateTap;
  final String? iconTooltip;

  @override
  _DrawerTileState createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final prefState = state.prefState;
    final userCompany = state.userCompany;
    final NavigatorState navigator = Navigator.of(context);
    if (!Config.DEMO_MODE) {
      if (isAuthenticated(state)) {
        if (widget.entityType != null &&
            !userCompany.canView(widget.entityType)) {
          return Container();
        }
      } else {
        if (widget.entityType != null &&
            !userCompany.canGuestViewEntity(widget.entityType)) {
          return Container();
        }
      }
    }

    final enableDarkMode = state.prefState.enableDarkMode;
    final localization = AppLocalization.of(context)!;
    final themeColors = enableDarkMode ? AppTheme.dark : AppTheme.light;

    String route;
    if (widget.title == localization.dashboard) {
      route = kDashboard;
    } else if (widget.title == localization.settings) {
      route = kSettings;
    } else if (widget.title == localization.reports) {
      route = kReports;
    } else if (widget.title == localization.kanban) {
      route = kKanban;
    } else if (widget.title == localization.marathonMap) {
      route = kMarathonMap;
    } else if (widget.title == localization.aboutUs) {
      route = kAboutUs;
    } else {
      route = widget.entityType!.name;
    }

    // Workaround to show clients/vendors as selected when
    // viewing their sub-entities
    final String currentRoute = '/${toSnakeCase(route)}';
    final bool isDashboardTab = widget.title == localization.dashboard;
    final bool isSettingsTab = widget.title == localization.settings;
    final bool isMarathonMapTab = widget.title == localization.marathonMap;

    bool isSelected = false;

    if (isDashboardTab) {
      isSelected = uiState.currentRoute.startsWith(currentRoute);
    } else if (isSettingsTab) {
      isSelected = uiState.currentRoute.startsWith(currentRoute);
    } else if (widget.entityType != null) {
      if (uiState.currentRoute == currentRoute) {
        isSelected = true;
      } else if (uiState.currentRoute.startsWith(currentRoute + '/')) {
        isSelected = true;
      } else if (uiState.filterEntityType != null &&
          prefState.isViewerFullScreen(uiState.filterEntityType) &&
          !uiState.isEditing &&
          (prefState.isPreviewVisible || uiState.isList) &&
          widget.entityType == uiState.filterEntityType) {
        isSelected = true;
      } else if (!isAuthenticated(state) &&
          widget.entityType == EntityType.event) {
        isSelected = true;
      }
    } else {
      isSelected = uiState.currentRoute == currentRoute;
    }

    final inactiveColor = prefState.activeCustomColors[
            PrefState.THEME_SIDEBAR_INACTIVE_BACKGROUND_COLOR] ??
        '';
    final inactiveFontColor = prefState
            .activeCustomColors[PrefState.THEME_SIDEBAR_INACTIVE_FONT_COLOR] ??
        '';
    final activeFontColor = prefState
            .activeCustomColors[PrefState.THEME_SIDEBAR_ACTIVE_FONT_COLOR] ??
        '';

    Color? color = themeColors.secondary;
    Color? textColor = Theme.of(context)
        .textTheme
        .bodyLarge!
        .color!
        .withOpacity(isSelected ? 1 : .7);

    if (isSelected) {
      color = themeColors.background;
      if (activeFontColor.isNotEmpty) {
        textColor = themeColors.text;
      }
    } else {
      if (_isHovered) {
        color = themeColors.background;
      } else if (inactiveColor.isNotEmpty) {
        color = themeColors.secondary;
      }
      if (inactiveFontColor.isNotEmpty) {
        textColor = themeColors.text;
      }
    }

    onTap() {
      if (widget.entityType != null) {
        viewEntitiesByType(
          entityType: widget.entityType,
        );
      } else {
        widget.onTap!();
      }
    }

    onLongPress() {
      if (widget.onLongPress != null) {
        widget.onLongPress!();
      } else if (widget.entityType != null) {
        createEntityByType(
          context: context,
          entityType: widget.entityType,
          applyFilter: false,
        );
      }
    }

    if (state.isMenuCollapsed) {
      return Tooltip(
        message: prefState.enableTooltips ? widget.title : '',
        child: ColoredBox(
          color: color,
          child: Opacity(
            opacity: isSelected ? 1 : .8,
            child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: SizedBox(
                  height: 40,
                  child: Icon(
                    widget.icon,
                    color: textColor,
                  ),
                )),
          ),
        ),
      );
    }

    Widget? iconWidget;
    if ([
          localization.dashboard,
          localization.settings,
        ].contains(widget.title) &&
        ProjectConfig.showSearchInputFieldByEntityType(EntityType.settings)) {
      iconWidget = IconButton(
        icon: Icon(
          Icons.search,
          color: textColor,
        ),
        onPressed: () {
          if (isMobile(context)) {
            navigator.pop();
          }
          if (widget.title == localization.dashboard) {
            store.dispatch(ViewDashboard(
                filter: uiState.mainRoute == 'dashboard' && uiState.filter == ''
                    ? null
                    : ''));
          } else if (widget.title == localization.settings) {
            store.dispatch(ViewSettings(company: state.company));
            store.dispatch(FilterSettings(''));
          }
        },
      );
    } else if (userCompany.canCreate(widget.entityType) &&
        ProjectConfig.showPlusCreateButton(widget.entityType!) &&
        isAuthenticated(state)) {
      iconWidget = IconButton(
        tooltip: prefState.enableTooltips ? widget.iconTooltip : null,
        icon: Icon(
          Icons.add_circle_outline,
          color: textColor,
        ),
        onPressed: () {
          if (isMobile(context)) {
            navigator.pop();
          }
          createEntityByType(
            context: context,
            entityType: widget.entityType,
            applyFilter: false,
          );
        },
      );
    }

    bool isLoading = false;
    if (widget.entityType != null &&
        state.company.isLarge &&
        state.uiState.loadingEntityType == widget.entityType) {
      isLoading = true;
    }

    Widget child = Material(
      color: color,
      child: Opacity(
        opacity: isSelected ? 1 : .8,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 12),
          dense: true,
          leading: _isHovered && isDesktop(context) && iconWidget != null
              ? iconWidget
              : isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 8,
                      ),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: state.accentColor,
                        ),
                      ),
                    )
                  : FocusTraversalGroup(
                      descendantsAreFocusable: false,
                      child: IconButton(
                        icon: Icon(widget.icon),
                        color: textColor,
                        onPressed: onTap,
                      ),
                    ),
          title: Text(
            widget.title!,
            key: ValueKey('menu_${widget.title}'),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 14,
                  color: textColor,
                ),
          ),
          onTap: onTap,
          onLongPress: onLongPress,
          trailing: isMobile(context)
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: iconWidget,
                )
              : null,
        ),
      ),
    );

    if (isSelected) {
      child = Stack(
        children: [
          child,
          SizedBox(
            width: 6,
            height: 40,
            child: ColoredBox(color: AppTheme.light.primary),
          ),
        ],
      );
    }

    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: child,
    );
  }
}

class SidebarFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final prefState = state.prefState;
    final localization = AppLocalization.of(context)!;

    return Material(
      color: Theme.of(context).bottomAppBarTheme.color,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (state.isMenuCollapsed) ...[
            const Expanded(child: SizedBox())
          ] else ...[
            if (!kReleaseMode && state.lastError.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                tooltip: prefState.enableTooltips ? localization.error : '',
                onPressed: () => showDialog<ErrorDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        state.lastError,
                        clearErrorOnDismiss: true,
                      );
                    }),
              ),
            if (state.userCompany.account.isUpdateAvailable)
              IconButton(
                tooltip: prefState.enableTooltips
                    ? localization.updateAvailable
                    : '',
                icon: Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => _showUpdate(context),
              ),
            if (isAdmin(state) && ProjectConfig.showAdminPanelFooter())
              IconButton(
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.orange,
                  ),
                  tooltip: prefState.enableTooltips
                      ? localization.administrator
                      : '',
                  onPressed: () => {
                        store.dispatch(UpdateCurrentRoute(AdminScreen.route)),
                        if (store.state.prefState.isMobile)
                          {
                            navigatorKey.currentState!
                                .pushNamed(AdminScreen.route)
                          }
                      }),
            if (ProjectConfig.showAboutMe())
              IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    // color: Colors.orange,
                  ),
                  tooltip: prefState.enableTooltips ? 'About Us' : '',
                  onPressed: () {
                    if (isNotMobile(context)) {
                      store.dispatch(UpdateCurrentRoute(AboutUs.route));
                    } else {
                      navigatorKey.currentState!.pushNamed(AboutUs.route);
                    }
                  }),
            const Spacer(),
            if (isNotMobile(context) &&
                state.prefState.menuSidebarMode == AppSidebarMode.collapse)
              AppBorder(
                isLeft: true,
                child: Tooltip(
                  message:
                      prefState.enableTooltips ? localization.hideMenu : '',
                  child: InkWell(
                    onTap: () => {
                      store.dispatch(
                          UpdateUserPreferences(sidebar: AppSidebar.menu)),
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.chevron_left),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class SidebarFooterCollapsed extends StatelessWidget {
  const SidebarFooterCollapsed();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).cardColor,
      child: state.uiState.filterEntityType != null &&
              state.prefState.isFilterVisible
          ? PopupMenuButton<String>(
              icon: state.userCompany.account.isUpdateAvailable
                  ? Icon(Icons.warning,
                      color: Theme.of(context).colorScheme.secondary)
                  : const Icon(Icons.info_outline),
              onSelected: (value) {
                if (value == localization.updateAvailable) {
                  _showUpdate(context);
                } else if (value == localization.aboutUs) {
                  if (isNotMobile(context)) {
                    store.dispatch(UpdateCurrentRoute(AboutUs.route));
                  } else {
                    navigatorKey.currentState!.pushNamed(AboutUs.route);
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                if (state.userCompany.account.isUpdateAvailable)
                  PopupMenuItem<String>(
                    value: localization.updateAvailable,
                    child: ListTile(
                      leading: Icon(
                        Icons.warning,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(localization.updateAvailable),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: localization.aboutUs,
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(localization.aboutUs),
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: state.userCompany.account.isUpdateAvailable
                    ? Theme.of(context).colorScheme.secondary
                    : state.accentColor,
              ),
              tooltip:
                  state.prefState.enableTooltips ? localization.showMenu : null,
              onPressed: () {
                store.dispatch(UpdateUserPreferences(sidebar: AppSidebar.menu));
              },
            ),
    );
  }
}

void _showUpdate(BuildContext context) {
  showDialog<UpdateDialog>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => UpdateDialog(),
  );
}
