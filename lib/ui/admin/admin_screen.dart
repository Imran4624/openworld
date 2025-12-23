import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';

class AdminScreen extends StatefulWidget {
  static const String route = '/admin';

  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String statusMessage = 'Initializing...';
  bool isLoading = false;
  bool isInitialized = false;
  List<Map<String, dynamic>> importConfigurations = [];
  Store<AppState>? _store;
  int lastFetchedEventCount = 0;
  String? lastSuccessfulFetchType;

  @override
  void initState() {
    super.initState();
  }

 

  Future<void> _initializeConfigurations(Store<AppState> store) async {
    if (isInitialized || _store != null) return;

    _store = store;

    try {
      setState(() {
        statusMessage = 'Loading import configurations...';
      });

      final authState = store.state.authState;
      final currentUserId = authState.currentUserId;

      if (currentUserId.isEmpty) {
        setState(() {
          statusMessage = 'Error: User not authenticated';
          isInitialized = true;
        });
        return;
      }

      final companiesSnapshot = await _firestore
          .collection('companies')
          .where('created_user_id', isEqualTo: currentUserId)
          .get();

      if (companiesSnapshot.docs.isEmpty) {
        setState(() {
          statusMessage = 'No companies found for current user';
          isInitialized = true;
        });
        return;
      }

      final configurations = <Map<String, dynamic>>[];

      for (final companyDoc in companiesSnapshot.docs) {
        final companyId = companyDoc.id;
        final companyData = companyDoc.data();
        final companyName =
            companyData['name']?.toString() ?? 'Unknown Company';

        final importDataSnapshot = await _firestore
            .collection('companies')
            .doc(companyId)
            .collection('importData')
            .get();

        for (final doc in importDataSnapshot.docs) {
          final data = doc.data();
          if (data['importFrom'] != null) {
            configurations.add({
              'docId': doc.id,
              'importFrom': data['importFrom']?.toString() ?? '',
              'apiKey': data['apiKey']?.toString() ?? '',
              'name': data['name']?.toString() ??
                  data['importFrom']?.toString() ??
                  'Unknown',
              'companyName': companyName,
              'companyId': companyId,
            });
          }
        }
      }

      setState(() {
        importConfigurations = configurations;
        isInitialized = true;
        if (configurations.isNotEmpty) {
          statusMessage =
              'Found ${configurations.length} import configuration(s) across ${companiesSnapshot.docs.length} company(ies). Ready to fetch events.';
        } else {
          statusMessage =
              'No valid import configurations found. Please configure your import settings.';
        }
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Error loading import configurations: $e';
        isInitialized = true;
        importConfigurations = [];
      });
    }
  }

  Future<void> _fetchEventsForConfiguration(
      Store<AppState> store, Map<String, dynamic> config) async {
    final importFrom = config['importFrom'] as String;
    final apiKey = config['apiKey'] as String;
    final configName = config['name'] as String;
    final companyName = config['companyName'] as String;

    setState(() {
      statusMessage = 'Starting $configName import for $companyName...';
    });

    try {
      if (importFrom.toLowerCase() == 'eventbrite') {
        if (apiKey.isEmpty) {
          setState(() {
            isLoading = false;
            statusMessage = 'Error: EventBrite API key is missing';
          });
          return;
        }


        setState(() {
          statusMessage =
              'Starting EventBrite import with $configName for $companyName...';
        });

      } else if (importFrom.toLowerCase() == 'tickettailor') {
        setState(() {
          statusMessage =
              'Starting TicketTailor import with $configName for $companyName...';
        });

      } else {
        setState(() {
          isLoading = false;
          statusMessage = 'Unknown import type: $importFrom';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = 'Error during $configName import for $companyName: $e';
      });
    }
  }

 


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        return _buildEvents121UI(context, store);
      },
    );
  }

  

  Widget _buildEvents121UI(BuildContext context, Store<AppState> store) {
    final state = store.state;
    final enableDarkMode = state.prefState.enableDarkMode;
    final themeColors = enableDarkMode ? AppTheme.dark : AppTheme.light;

    if (!isInitialized && _store == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeConfigurations(store);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            store.dispatch(UpdateCurrentRoute(DashboardScreenBuilder.route));
            if (isMobile(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isInitialized) const CircularProgressIndicator(),
            if (isInitialized) ...[
              if (importConfigurations.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: themeColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: themeColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 48,
                        color: themeColors.warning,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Import Configurations Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please configure your import settings first to start fetching events.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'Select Import Source',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeColors.text,
                      ),
                ),
                const SizedBox(height: 24),
                ...importConfigurations.map((config) {
                  final importFrom = config['importFrom'] as String;
                  final configName = config['name'] as String;
                  final companyName = config['companyName'] as String;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _fetchEventsForConfiguration(store, config),
                        icon: Icon(_getIconForImportType(importFrom)),
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Fetch from $configName',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Company: $companyName',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor:
                              _getColorForImportType(importFrom, themeColors),
                          foregroundColor: themeColors.secondary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: themeColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: themeColors.outline),
              ),
              child: Column(
                children: [
                  Text(
                    statusMessage,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColors.text),
                    textAlign: TextAlign.center,
                  ),
                  if (lastFetchedEventCount > 0 &&
                      lastSuccessfulFetchType != null &&
                      !isLoading) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: themeColors.success.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: themeColors.success, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Last successful fetch: $lastFetchedEventCount events from $lastSuccessfulFetchType',
                            style: TextStyle(
                                fontSize: 14,
                                color: themeColors.success,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForImportType(String importFrom) {
    switch (importFrom.toLowerCase()) {
      case 'eventbrite':
        return Icons.event;
      case 'tickettailor':
        return Icons.confirmation_number;
      default:
        return Icons.cloud_download;
    }
  }

  Color _getColorForImportType(String importFrom, ThemeColors themeColors) {
    switch (importFrom.toLowerCase()) {
      case 'eventbrite':
        return themeColors.warning;
      case 'tickettailor':
        return themeColors.info;
      default:
        return themeColors.defaultColor;
    }
  }
}
