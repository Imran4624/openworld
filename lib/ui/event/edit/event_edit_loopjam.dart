import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/data/models/event_theme_model.dart';
import 'package:flutter_boilerplate/data/models/photo_model.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/event/event_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/location_service.dart';
import 'package:flutter_boilerplate/services/location_suggestion_widget.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_builder/document_field_builder.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/ui/auth/welcome_event_screen.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/utils/font_utils.dart';

class EventEditLoopjam extends StatefulWidget {
  const EventEditLoopjam({
    super.key,
    required this.viewModel,
  });

  final EventEditVM viewModel;

  @override
  _EventEditLoopjamState createState() => _EventEditLoopjamState();
}

class _EventEditLoopjamState extends State<EventEditLoopjam> {
  String? _selectedTheme;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_EventEditLoopjam');
  final _debouncer = Debouncer();

  // Basic event controllers - only what we need for loopjam
  final _nameController = TextEditingController();
  final _callToActionController = TextEditingController();
  final _currencyController = TextEditingController();
  final _descriptionController = TextEditingController();
  // Date controllers for display
  final _endController = TextEditingController();
  final _startController = TextEditingController();
  final _eventSeriesIdController = TextEditingController();
  bool _hiddenValue = false;
  bool _onlineEventValue = false;
  bool _privateEventValue = false;
  final _statusController = TextEditingController();
  bool _ticketsAvailableValue = false;
  final _totalHoldsController = TextEditingController();
  final _totalIssuedTicketsController = TextEditingController();
  final _totalOrdersController = TextEditingController();
  bool _unavailableValue = false;
  final _unavailableStatusController = TextEditingController();

  final _venueNameController = TextEditingController();
  final _venuePostalCodeController = TextEditingController();
  final _headerImageController = TextEditingController();

  List<Map<String, dynamic>> _headerImages = [];
  final List<Map<String, dynamic>> _eventPhotos = [];
  final List<Map<String, dynamic>> _existingPhotos = [];

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  List<TextEditingController> _controllers = [];

  final _nameFocusNode = FocusNode();
  final _venueFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_selectedTheme == null) {
      final eventTheme = widget.viewModel.event.themeObject;
      _selectedTheme = eventTheme?.id ?? EventThemes.predefinedThemes.first.id;
    }

    _controllers = [
      _nameController,
      _callToActionController,
      _currencyController,
      _descriptionController,
      _eventSeriesIdController,
      _statusController,
      _totalHoldsController,
      _totalIssuedTicketsController,
      _totalOrdersController,
      _unavailableStatusController,
      _venueNameController,
      _venuePostalCodeController,
      _headerImageController,
      _startController,
      _endController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final event = widget.viewModel.event;
    _nameController.text = event.name.toString();
    _callToActionController.text = event.callToAction.toString();
    _currencyController.text = event.currency.toString();
    _descriptionController.text = event.description.toString();

    if (event.start > 0) {
      _startDate = DateTime.fromMillisecondsSinceEpoch(event.start * 1000);
      _startTime = TimeOfDay.fromDateTime(_startDate!);
      _startController.text = _formatDateTime(_startDate!, _startTime!);
    }

    if (event.end > 0) {
      _endDate = DateTime.fromMillisecondsSinceEpoch(event.end * 1000);
      _endTime = TimeOfDay.fromDateTime(_endDate!);
      _endController.text = _formatDateTime(_endDate!, _endTime!);
    }

    _eventSeriesIdController.text = event.eventSeriesId.toString();
    _hiddenValue = event.hidden;
    _onlineEventValue = event.onlineEvent;
    _privateEventValue = event.privateEvent;
    _statusController.text = event.status.toString();
    _ticketsAvailableValue = event.ticketsAvailable;
    _totalHoldsController.text = event.totalHolds.toString();
    _totalIssuedTicketsController.text = event.totalIssuedTickets.toString();
    _totalOrdersController.text = event.totalOrders.toString();
    _unavailableValue = event.unavailable;
    _unavailableStatusController.text = event.unavailableStatus.toString();

    if (event.venue != null) {
      _venueNameController.text = event.venue!.name ?? '';
      _venuePostalCodeController.text = event.venue!.postalCode ?? '';
    }

    if (event.images != null) {
      _headerImageController.text = event.images!.header;

      if (event.images!.header.isNotEmpty) {
        _headerImages = _getImageListFromUrl(event.images!.header);
      }
    }

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    _loadExistingPhotos();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });
    _nameFocusNode.dispose();
    _venueFocusNode.dispose();
    _dateFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    return '${date.day}/${date.month}/${date.year} at ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  int _dateTimeToTimestamp(DateTime date, TimeOfDay time) {
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return (dateTime.millisecondsSinceEpoch / 1000).floor();
  }

  Future<void> _selectStartDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _startTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _startDate = pickedDate;
          _startTime = pickedTime;
          _startController.text = _formatDateTime(pickedDate, pickedTime);
        });
        _onChanged();
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _endTime ?? _startTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _endDate = pickedDate;
          _endTime = pickedTime;
          _endController.text = _formatDateTime(pickedDate, pickedTime);
        });
        _onChanged();
      }
    }
  }

  void _onChanged() {
    _debouncer.run(() {
      final event = widget.viewModel.event.rebuild((b) => b
        ..name = _nameController.text.trim()
        ..accessCode = widget.viewModel.event.accessCode
        ..chk = widget.viewModel.event.chk
        ..callToAction = _callToActionController.text.trim()
        ..currency = _currencyController.text.trim()
        ..description = _descriptionController.text.trim()
        ..end = _endDate != null && _endTime != null
            ? _dateTimeToTimestamp(_endDate!, _endTime!)
            : widget.viewModel.event.end
        ..start = _startDate != null && _startTime != null
            ? _dateTimeToTimestamp(_startDate!, _startTime!)
            : widget.viewModel.event.start
        ..eventSeriesId = _eventSeriesIdController.text.trim()
        ..hidden = _hiddenValue
        ..onlineEvent = _onlineEventValue
        ..privateEvent = _privateEventValue
        ..status = _statusController.text.trim()
        ..ticketsAvailable = _ticketsAvailableValue
        ..totalHolds = int.tryParse(_totalHoldsController.text.trim()) ?? 0
        ..totalIssuedTickets =
            int.tryParse(_totalIssuedTicketsController.text.trim()) ?? 0
        ..totalOrders = int.tryParse(_totalOrdersController.text.trim()) ?? 0
        ..unavailable = _unavailableValue
        ..unavailableStatus = _unavailableStatusController.text.trim()
        ..venue = Venue((v) => v
          ..name = _venueNameController.text.trim()
          ..postalCode = _venuePostalCodeController.text.trim()).toBuilder()
        ..images = Images((i) => i
          ..header = widget.viewModel.event.images?.header ?? ''
          ..thumbnail = '').toBuilder()
        ..themeId = _selectedTheme ?? widget.viewModel.event.themeId
        ..themeName = _selectedTheme != null
            ? EventThemes.getThemeById(_selectedTheme!).name
            : widget.viewModel.event.themeName
        ..themeFontFamily = _selectedTheme != null
            ? EventThemes.getThemeById(_selectedTheme!).fontFamily
            : widget.viewModel.event.themeFontFamily
        ..themePrimaryColorHex = null
        ..themeSecondaryColorHex = null
        ..dynamicFields = MapBuilder({
          'headerImages': _headerImages,
        }));
      if (event != widget.viewModel.event) {
        widget.viewModel.onChanged(event);
      }
    });
  }

  String _getFileNameFromUrl(String url) {
    try {
      final Uri uri = Uri.parse(url);
      final String path = uri.path;
      final String fileName = path.split('/').last;

      if (fileName.contains('%')) {
        return Uri.decodeComponent(fileName).split('?').first;
      }

      return fileName.split('?').first;
    } catch (e) {
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  List<Map<String, dynamic>> _getImageListFromUrl(String url) {
    if (url.isEmpty) return [];
    return [
      {'url': url, 'name': _getFileNameFromUrl(url), 'action': 'existing'}
    ];
  }

  static bool shouldShowEventField(String fieldName) {
    return ProjectConfig.getEventEditFields().contains(fieldName);
  }

  void _showTicketTypeDialog({TicketType? ticketType}) {
    showDialog(
      context: context,
      builder: (context) => _TicketTypeDialog(
        ticketType: ticketType,
        onSave: (newTicketType) {
          final currentTypes =
              widget.viewModel.event.ticketTypes ?? BuiltList<TicketType>();
          BuiltList<TicketType> updatedTypes;

          if (ticketType == null) {
            updatedTypes = currentTypes.rebuild((b) => b.add(newTicketType));
          } else {
            updatedTypes = currentTypes.rebuild((b) {
              final index = b.build().indexWhere((t) => t.id == ticketType.id);
              if (index >= 0) {
                b[index] = newTicketType;
              }
            });
          }
          final event = widget.viewModel.event
              .rebuild((b) => b..ticketTypes = updatedTypes.toBuilder());
          widget.viewModel.onChanged(event);
        },
      ),
    );
  }

  void _showTicketGroupDialog({TicketGroup? ticketGroup}) {
    showDialog(
      context: context,
      builder: (context) => _TicketGroupDialog(
        ticketGroup: ticketGroup,
        availableTicketTypes:
            widget.viewModel.event.ticketTypes?.toList() ?? [],
        onSave: (newTicketGroup) {
          final currentGroups =
              widget.viewModel.event.ticketGroups ?? BuiltList<TicketGroup>();
          BuiltList<TicketGroup> updatedGroups;

          if (ticketGroup == null) {
            updatedGroups = currentGroups.rebuild((b) => b.add(newTicketGroup));
          } else {
            updatedGroups = currentGroups.rebuild((b) {
              final index = b.build().indexWhere((g) => g.id == ticketGroup.id);
              if (index >= 0) {
                b[index] = newTicketGroup;
              }
            });
          }
          final event = widget.viewModel.event
              .rebuild((b) => b..ticketGroups = updatedGroups.toBuilder());
          widget.viewModel.onChanged(event);
        },
      ),
    );
  }

  Widget _buildTicketTypesList() {
    final ticketTypes =
        widget.viewModel.event.ticketTypes ?? BuiltList<TicketType>();

    if (ticketTypes.isEmpty) {
      return Column(
        children: [
          const Text('No ticket types created yet.'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showTicketTypeDialog(),
            child: const Text('Add First Ticket Type'),
          ),
        ],
      );
    }

    return Column(
      children: [
        ...ticketTypes
            .map((ticketType) => Card(
                  child: ListTile(
                    title: Text(ticketType.name),
                    subtitle: Text(
                        '£${(ticketType.price / 100).toStringAsFixed(2)} - Qty: ${ticketType.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showTicketTypeDialog(ticketType: ticketType),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTicketType(ticketType),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showTicketTypeDialog(),
          child: const Text('Add Ticket Type'),
        ),
      ],
    );
  }

  Widget _buildTicketGroupsList() {
    final ticketGroups =
        widget.viewModel.event.ticketGroups ?? BuiltList<TicketGroup>();

    if (ticketGroups.isEmpty) {
      return Column(
        children: [
          const Text('No ticket groups created yet.'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showTicketGroupDialog(),
            child: const Text('Add First Ticket Group'),
          ),
        ],
      );
    }

    return Column(
      children: [
        ...ticketGroups
            .map((ticketGroup) => Card(
                  child: ListTile(
                    title: Text(ticketGroup.name),
                    subtitle:
                        Text('${ticketGroup.ticketIds.length} ticket types'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showTicketGroupDialog(ticketGroup: ticketGroup),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTicketGroup(ticketGroup),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showTicketGroupDialog(),
          child: const Text('Add Ticket Group'),
        ),
      ],
    );
  }

  void _deleteTicketType(TicketType ticketType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket Type'),
        content: Text('Are you sure you want to delete "${ticketType.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final currentTypes =
                  widget.viewModel.event.ticketTypes ?? BuiltList<TicketType>();
              final updatedTypes = currentTypes.rebuild((b) {
                b.removeWhere((t) => t.id == ticketType.id);
              });
              final event = widget.viewModel.event
                  .rebuild((b) => b..ticketTypes = updatedTypes.toBuilder());
              widget.viewModel.onChanged(event);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteTicketGroup(TicketGroup ticketGroup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Ticket Group'),
        content: Text('Are you sure you want to delete "${ticketGroup.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final currentGroups = widget.viewModel.event.ticketGroups ??
                  BuiltList<TicketGroup>();
              final updatedGroups = currentGroups.rebuild((b) {
                b.removeWhere((g) => g.id == ticketGroup.id);
              });
              final event = widget.viewModel.event
                  .rebuild((b) => b..ticketGroups = updatedGroups.toBuilder());
              widget.viewModel.onChanged(event);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCoverImage() async {
    final images = await PhotoUploadHelper.pickImages(allowMultiple: false);
    if (images.isNotEmpty) {
      final image = images.first;
      setState(() {
        _headerImages = [
          {
            'name': image['name'],
            'bytes': image['bytes'],
            'action': 'added',
          }
        ];
      });
      _onChanged();
    }
  }

  Future<void> _pickEventPhotos() async {
    try {
      final images = await PhotoUploadHelper.pickImages(
          allowMultiple: true); // Multiple images for event

      if (images.isNotEmpty) {
        setState(() {
          final newPhotos = images
              .map((image) => {
                    'name': image['name'],
                    'bytes': image['bytes'],
                    'action': 'added',
                  })
              .toList();

          _eventPhotos.addAll(newPhotos);
        });
        _onChanged();
      } else {
        logError('No photos selected');
      }
    } catch (error) {
      logError('Error selecting photos: $error');
    }
  }

  Future<void> _removeImage(int index) async {
    setState(() {
      _headerImages.removeAt(index);
    });
    _onChanged();
  }

  Future<void> _removeEventPhoto(int index) async {
    setState(() {
      _eventPhotos.removeAt(index);
    });
    _onChanged();
  }

  Future<void> _removeExistingPhoto(int index) async {
    final photo = _existingPhotos[index];
    if (photo['id'] != null) {
      setState(() {
        photo['action'] = 'deleted';
      });
      _onChanged();
    }
  }

  void _loadExistingPhotos() {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final allPhotos = state.photoState.map.values.toList();
    final eventPhotos = allPhotos
        .where((photo) =>
            photo.category == widget.viewModel.event.name &&
            photo.assignedUserId == widget.viewModel.event.id)
        .toList();
    if (eventPhotos.isNotEmpty) {
      setState(() {
        _existingPhotos.clear();
        for (final photo in eventPhotos) {
          _existingPhotos.add({
            'id': photo.id,
            'url': photo.url,
            'thumbnail': photo.url,
            'name': photo.category,
            'action': 'existing',
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final event = viewModel.event;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final themeColors = AppTheme.getThemeColors(state.prefState.enableDarkMode);

    if (ProjectConfig.showEditEventUIForFullScreen()) {
      final theme = Theme.of(context);
      final title = event.isNew ? "Let's get started" : "Let's Edit Event";
      final continueOrPublishText =
          isAuthenticated(state) ? "Publish Event" : "Continue";
      final publishButtonText = event.isNew ? continueOrPublishText : "Done";
      return Scaffold(
        backgroundColor: themeColors.background,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 34.0, vertical: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobileView = constraints.maxWidth < 800;
                Widget coverImageCard = _CoverImageCard(
                  themeColors: themeColors,
                  theme: theme,
                  headerImages: _headerImages,
                  onImageTap: _pickCoverImage,
                  onRemoveImage: _removeImage,
                );
                Widget uploadBox = _PhotoUploadBox(
                  themeColors: themeColors,
                  theme: theme,
                  onPhotoSelect: _pickEventPhotos,
                  eventPhotos: _eventPhotos,
                  existingPhotos: _existingPhotos,
                  onRemovePhoto: _removeEventPhoto,
                  onRemoveExistingPhoto: _removeExistingPhoto,
                );

                Widget textFields = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isWeb()) const SizedBox(height: 72),
                    Text(
                      title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: themeColors.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      autocorrect: false,
                      style: TextStyle(
                        color: themeColors.text,
                        fontWeight: _nameFocusNode.hasFocus
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "What is event called?",
                        labelStyle: TextStyle(
                          color: themeColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        hintText: 'Untitled',
                        hintStyle: TextStyle(
                          color: themeColors.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: _nameFocusNode.hasFocus
                            ? Colors.white
                            : const Color(0xFFE7ECF3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _nameFocusNode.hasFocus
                                  ? themeColors.defaultColor
                                  : Colors.transparent,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: themeColors.defaultColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      onTap: () => setState(() {}),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    if (ProjectConfig.searchLocationGiveSuggestionsEnabled())
                      LocationSuggestionsField(
                        controller: _venueNameController,
                        focusNode: _venueFocusNode,
                        labelText: 'Location',
                        hintText: "Enter location, address or post code",
                        onTap: () {
                          if (_venueNameController.text.isEmpty) {
                            _autoPopulateLocation();
                          }
                        },
                        onLocationSelected: (locationName) {
                          logInfo('Selected venue: $locationName');
                          _onChanged();
                        },
                        onChanged: (value) => _onChanged(),
                      ),
                    if (!ProjectConfig.searchLocationGiveSuggestionsEnabled())
                      TextFormField(
                        controller: _venueNameController,
                        focusNode: _venueFocusNode,
                        autocorrect: false,
                        style: TextStyle(
                          color: themeColors.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: "Location",
                          hintText: "Enter location, address or post code",
                          labelStyle: TextStyle(
                            color: themeColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: _venueFocusNode.hasFocus
                              ? Colors.white
                              : const Color(0xFFE7ECF3),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: _venueFocusNode.hasFocus
                                    ? themeColors.defaultColor
                                    : Colors.transparent,
                                width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: themeColors.defaultColor, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        onTap: () async {
                          setState(() {});
                          await _autoPopulateLocation();
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _startController,
                      focusNode: _dateFocusNode,
                      readOnly: true,
                      onTap: () {
                        setState(() {});
                        _selectStartDateTime();
                      },
                      style: TextStyle(
                        color: themeColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Date",
                        labelStyle: TextStyle(
                          color: themeColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: _dateFocusNode.hasFocus
                            ? Colors.white
                            : const Color(0xFFE7ECF3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _dateFocusNode.hasFocus
                                  ? themeColors.defaultColor
                                  : Colors.transparent,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: themeColors.defaultColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      focusNode: _descFocusNode,
                      autocorrect: false,
                      maxLines: 2,
                      style: TextStyle(
                        color: themeColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Add a short message",
                        labelStyle: TextStyle(
                          color: themeColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: _descFocusNode.hasFocus
                            ? Colors.white
                            : const Color(0xFFE7ECF3),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: _descFocusNode.hasFocus
                                  ? themeColors.defaultColor
                                  : Colors.transparent,
                              width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: themeColors.defaultColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      onTap: () => setState(() {}),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Theme',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 200,
                                child: _ThemeDropdownButton(
                                  selectedTheme: _selectedTheme,
                                  onThemeSelected: (themeId) {
                                    setState(() {
                                      _selectedTheme = themeId;
                                    });
                                    final selectedTheme =
                                        EventThemes.getThemeById(themeId);
                                    widget.viewModel.onChanged(
                                        widget.viewModel.event.rebuild((b) => b
                                          ..themeId = selectedTheme.id
                                          ..themeName = selectedTheme.name
                                          ..themeFontFamily =
                                              selectedTheme.fontFamily
                                          ..themePrimaryColorHex = null
                                          ..themeSecondaryColorHex = null));
                                  },
                                  themeColors: themeColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Privacy',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_privateEventValue) {
                                        setState(() {
                                          _privateEventValue = false;
                                        });
                                        _onChanged();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: !_privateEventValue
                                            ? themeColors.primary
                                            : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7),
                                        ),
                                      ),
                                      child: Text(
                                        'Public',
                                        style: TextStyle(
                                          color: !_privateEventValue
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (!_privateEventValue) {
                                        setState(() {
                                          _privateEventValue = true;
                                        });
                                        _onChanged();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _privateEventValue
                                            ? themeColors.primary
                                            : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7),
                                        ),
                                      ),
                                      child: Text(
                                        'Private',
                                        style: TextStyle(
                                          color: _privateEventValue
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isMobileView) ...[
                      const SizedBox(height: 24),
                      coverImageCard,
                      const SizedBox(height: 24),
                      uploadBox,
                      const SizedBox(height: 100),
                    ],
                  ],
                );
                Widget mainContent = isMobileView
                    ? SingleChildScrollView(child: textFields)
                    : SingleChildScrollView(
                        child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        textFields,
                                        const SizedBox(height: 100),
                                      ],
                                    ),
                                  )),
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 3,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      coverImageCard,
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          uploadBox,
                          const SizedBox(height: 200),
                        ],
                      ));
                return Stack(
                  children: [
                    mainContent,
                    Positioned(
                      left: 10,
                      bottom: isMobile(context) ? 15 : 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isAuthenticated(state)) {
                            viewEntitiesByType(entityType: EntityType.event);
                          } else {
                            if (isWeb()) {
                              store.dispatch(
                                  UpdateCurrentRoute(WelcomeEventScreen.route));
                            }
                            Navigator.of(context)
                                .pushReplacementNamed(WelcomeEventScreen.route);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(isMobile(context) ? 12 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                isMobile(context) ? 8 : 10),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black.withOpacity(0.07),
                        ),
                        child: Icon(Icons.arrow_back,
                            size: isMobile(context) ? 20 : 28),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: isMobile(context) ? 15 : 40,
                      child: Row(
                        children: [
                          if (!event.isNew)
                            ElevatedButton(
                              onPressed: () => {
                                if (isMobile(context))
                                  {
                                    Navigator.of(context).pop(),
                                  }
                                else
                                  {
                                    widget.viewModel.onCancelPressed(context),
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.viewModel.isSaving
                                    ? Colors.grey
                                    : themeColors.secondary,
                                foregroundColor: themeColors.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: isMobile(context) ? 5 : 32,
                                    vertical: isMobile(context) ? 5 : 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                'Cancel Update',
                                style: TextStyle(
                                    fontSize: isMobile(context) ? 10 : 14),
                              ),
                            ),
                          const SizedBox(width: 16),
                          if (event.name.isNotEmpty)
                            ElevatedButton(
                              onPressed: () async {
                                _onChanged();

                                await Future.delayed(
                                    const Duration(milliseconds: 200));

                                final completer = Completer<EventEntity>();
                                final currentEvent = widget.viewModel.event;

                                store.dispatch(SaveEventRequest(
                                  completer: completer,
                                  event: currentEvent,
                                  isPreview: true,
                                ));
                                logInfo('existingPhotos: $_existingPhotos');
                                completer.future.then((savedEvent) async {
                                  if (_eventPhotos.isNotEmpty ||
                                      _existingPhotos.isNotEmpty ||
                                      _existingPhotos.any((photo) =>
                                          photo['action'] == 'deleted')) {
                                    final eventName =
                                        _nameController.text.trim().isNotEmpty
                                            ? _nameController.text.trim()
                                            : 'Event Photos';
                                    final eventDescription =
                                        _descriptionController.text
                                                .trim()
                                                .isNotEmpty
                                            ? _descriptionController.text.trim()
                                            : 'Event';

                                    _uploadPhotosInBackground(
                                      store,
                                      savedEvent.id,
                                      savedEvent,
                                      List<Map<String, dynamic>>.from(
                                          _headerImages),
                                      List<Map<String, dynamic>>.from(
                                          _eventPhotos),
                                      List<Map<String, dynamic>>.from(
                                          _existingPhotos),
                                      eventName,
                                      eventDescription,
                                    ).catchError((error) {
                                      logError(
                                          "Error uploading photos for preview: $error");
                                    });
                                  }

                                  final url = ProjectConfig.getEntityDetailUrl(
                                    EntityType.event,
                                    savedEvent.id,
                                    originator: OriginatorType.guest,
                                  );

                                  final guestUrl = url.contains('?')
                                      ? '$url&hideTopBar=true&isGuest=true'
                                      : '$url?hideTopBar=true&isGuest=true';

                                  logInfo(
                                      'Opening guest preview URL: $guestUrl');

                                  try {
                                    await launchUrl(
                                      Uri.parse(guestUrl),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } catch (e) {
                                    try {
                                      await launchUrl(
                                        Uri.parse(guestUrl),
                                        mode: LaunchMode.inAppWebView,
                                      );
                                    } catch (e2) {
                                      logError("Failed to open guest URL: $e2");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to open preview: $e2'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }).catchError((error) {
                                  logError(
                                      "Error while saving event for guest: $error");
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.viewModel.isSaving
                                    ? Colors.grey
                                    : themeColors.secondary,
                                foregroundColor: themeColors.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: isMobile(context) ? 5 : 32,
                                    vertical: isMobile(context) ? 5 : 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.horizontal_split,
                                    size: 20.0,
                                    color: themeColors.text,
                                  ),
                                  const SizedBox(width: 8),
                                  if (!isMobile(context))
                                    Text(
                                      'Guest page preview',
                                      style: TextStyle(
                                          color: themeColors.text,
                                          fontWeight: FontWeight.bold),
                                    ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            width: 16,
                          ),
                          ElevatedButton(
                            onPressed: widget.viewModel.isSaving
                                ? null
                                : () async {
                                    final isValid = _validateForm();
                                    if (!isValid) {
                                      return;
                                    }
                                    final store =
                                        StoreProvider.of<AppState>(context);
                                    if (!isAuthenticated(store.state)) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return LoginDialogView(
                                            onClose: () {
                                              if (isWeb()) {
                                                Navigator.of(context).pop();
                                                store.dispatch(
                                                    UpdateCurrentRoute(store
                                                        .state
                                                        .uiState
                                                        .currentRoute));
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            onLoginSuccess: () {
                                              _handleSaveEvent(context);
                                            },
                                            isDialogLogin: isMobile(context),
                                          );
                                        },
                                      );
                                      return;
                                    }

                                    await _handleSaveEvent(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.viewModel.isSaving
                                  ? Colors.grey
                                  : themeColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: isMobile(context) ? 5 : 32,
                                  vertical: isMobile(context) ? 5 : 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: widget.viewModel.isSaving
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Saving...'),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Icon(Icons.post_add_outlined,
                                          size: 20.0),
                                      const SizedBox(width: 8),
                                      if (!isMobile(context) ||
                                          !isAuthenticated(state))
                                        Text(publishButtonText),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }

    return EditScaffold(
      title: event.isNew ? localization.newEvent : localization.editEvent,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      entity: event,
      onSavePressed: (context) {
        final store = StoreProvider.of<AppState>(context);
        if (!isAuthenticated(store.state)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return LoginDialogView(
                onClose: () {
                  Navigator.of(context).pop();
                },
                onLoginSuccess: () {
                  Navigator.of(context).pop();
                  _handleSaveEventFromScaffold(context);
                },
                isDialogLogin: false,
              );
            },
          );
          return;
        }

        _handleSaveEventFromScaffold(context);
      },
      body: Form(
        key: _formKey,
        child: ScrollableListView(
          children: <Widget>[
            FormCard(
              children: <Widget>[
                // Name field - always shown
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),

                if (shouldShowEventField('callToAction'))
                  TextFormField(
                    controller: _callToActionController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Call To Action',
                    ),
                  ),

                if (shouldShowEventField('currency'))
                  TextFormField(
                    controller: _currencyController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                    ),
                  ),

                if (shouldShowEventField('description'))
                  TextFormField(
                    controller: _descriptionController,
                    focusNode: _descFocusNode,
                    autocorrect: false,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),

                if (shouldShowEventField('start'))
                  TextFormField(
                    controller: _startController,
                    focusNode: _dateFocusNode,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Start Date & Time',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () {
                      setState(() {});
                      _selectStartDateTime();
                    },
                    validator: (value) {
                      if (_startDate == null || _startTime == null) {
                        return 'Please select start date and time';
                      }
                      return null;
                    },
                  ),

                if (shouldShowEventField('end'))
                  TextFormField(
                    controller: _endController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'End Date & Time',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _selectEndDateTime,
                    validator: (value) {
                      if (_endDate == null || _endTime == null) {
                        return 'Please select end date and time';
                      }
                      if (_startDate != null && _endDate != null) {
                        final startDateTime = DateTime(
                          _startDate!.year,
                          _startDate!.month,
                          _startDate!.day,
                          _startTime!.hour,
                          _startTime!.minute,
                        );
                        final endDateTime = DateTime(
                          _endDate!.year,
                          _endDate!.month,
                          _endDate!.day,
                          _endTime!.hour,
                          _endTime!.minute,
                        );
                        if (endDateTime.isBefore(startDateTime)) {
                          return 'End date must be after start date';
                        }
                      }
                      return null;
                    },
                  ),

                if (shouldShowEventField('eventSeriesId'))
                  TextFormField(
                    controller: _eventSeriesIdController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Event Series ID',
                    ),
                  ),

                if (shouldShowEventField('hidden'))
                  CheckboxListTile(
                    title: const Text('Hidden'),
                    value: _hiddenValue,
                    onChanged: (value) => setState(() {
                      _hiddenValue = value ?? false;
                      _onChanged();
                    }),
                  ),

                if (shouldShowEventField('onlineEvent'))
                  CheckboxListTile(
                    title: const Text('Online Event'),
                    value: _onlineEventValue,
                    onChanged: (value) => setState(() {
                      _onlineEventValue = value ?? false;
                      _onChanged();
                    }),
                  ),

                if (shouldShowEventField('privateEvent'))
                  CheckboxListTile(
                    title: const Text('Private Event'),
                    value: _privateEventValue,
                    onChanged: (value) => setState(() {
                      _privateEventValue = value ?? false;
                      _onChanged();
                    }),
                  ),

                if (shouldShowEventField('status'))
                  TextFormField(
                    controller: _statusController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                  ),

                if (shouldShowEventField('ticketsAvailable'))
                  CheckboxListTile(
                    title: const Text('Tickets Available'),
                    value: _ticketsAvailableValue,
                    onChanged: (value) => setState(() {
                      _ticketsAvailableValue = value ?? false;
                      _onChanged();
                    }),
                  ),

                if (shouldShowEventField('totalHolds'))
                  TextFormField(
                    controller: _totalHoldsController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Holds',
                    ),
                  ),

                if (shouldShowEventField('totalIssuedTickets'))
                  TextFormField(
                    controller: _totalIssuedTicketsController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Issued Tickets',
                    ),
                  ),

                if (shouldShowEventField('totalOrders'))
                  TextFormField(
                    controller: _totalOrdersController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Orders',
                    ),
                  ),

                if (shouldShowEventField('unavailable'))
                  CheckboxListTile(
                    title: const Text('Unavailable'),
                    value: _unavailableValue,
                    onChanged: (value) => setState(() {
                      _unavailableValue = value ?? false;
                      _onChanged();
                    }),
                  ),

                if (shouldShowEventField('unavailableStatus'))
                  TextFormField(
                    controller: _unavailableStatusController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Unavailable Status',
                    ),
                  ),

                if (shouldShowEventField('venue')) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Venue Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _venueNameController,
                    focusNode: _venueFocusNode,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Venue Name',
                    ),
                  ),
                  TextFormField(
                    controller: _venuePostalCodeController,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Venue Postal Code',
                    ),
                  ),
                ],

                if (shouldShowEventField('images')) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Event Images',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Cover Image'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: ProjectConfig.appType == AppType.loopjam
                          ? themeColors.defaultColor
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: buildDocumentField(
                      QuestionModel(
                        id: 'headerImage',
                        type: InputType.Document,
                        label: 'Upload Cover Image',
                        minValue: 0,
                        maxValue: 1,
                        allowedTypes: 'jpg,jpeg,png,gif,bmp,webp',
                        required: false,
                      ),
                      _headerImages,
                      (value) {
                        setState(() {
                          _headerImages =
                              List<Map<String, dynamic>>.from(value);
                        });
                        _onChanged();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                if (shouldShowEventField('ticketTypes')) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Ticket Types',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTicketTypesList(),
                ],

                if (shouldShowEventField('ticketGroups')) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Ticket Groups',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTicketGroupsList(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSaveEvent(BuildContext context) async {
    try {
      final store = StoreProvider.of<AppState>(context);
      final hasPhotosToUpload = _headerImages.isNotEmpty ||
          _eventPhotos.isNotEmpty ||
          _existingPhotos.any((photo) => photo['action'] == 'deleted');

      final headerImagesCopy = List<Map<String, dynamic>>.from(_headerImages);
      final eventPhotosCopy = List<Map<String, dynamic>>.from(_eventPhotos);
      final existingPhotosCopy =
          List<Map<String, dynamic>>.from(_existingPhotos);
      final eventName = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'Event Photos';
      final eventDescription = _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'Event';

      final savedEvent = await widget.viewModel.onSavePressed(context);

      if (hasPhotosToUpload) {
        _uploadPhotosInBackground(
          store,
          savedEvent.id,
          savedEvent,
          headerImagesCopy,
          eventPhotosCopy,
          existingPhotosCopy,
          eventName,
          eventDescription,
        ).catchError((error) {
          logError('Background photo upload failed: $error');
        });
      }
    } catch (error) {
      logError('Error saving event: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving event: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadPhotosInBackground(
    Store<AppState> store,
    String? eventId,
    EventEntity? event,
    List<Map<String, dynamic>> headerImages,
    List<Map<String, dynamic>> eventPhotos,
    List<Map<String, dynamic>> existingPhotos,
    String eventName,
    String eventDescription,
  ) async {
    try {
      final photosToDelete = existingPhotos
          .where((photo) => photo['action'] == 'deleted')
          .toList();

      if (photosToDelete.isNotEmpty) {
        final photoIdsToDelete = photosToDelete
            .map((photo) => photo['id'])
            .where((id) => id != null)
            .cast<String>()
            .toList();

        if (photoIdsToDelete.isNotEmpty) {
          final deleteCompleter = Completer<void>();
          store.dispatch(DeletePhotosRequest(
            deleteCompleter,
            photoIdsToDelete,
          ));

          try {
            await deleteCompleter.future;
            logInfo(
                'Successfully deleted ${photoIdsToDelete.length} photos in background');
          } catch (error) {
            logError('Error deleting photos in background: $error');
          }
        }
      }

      final photosToUpload =
          eventPhotos.isNotEmpty ? eventPhotos : headerImages;

      if (photosToUpload.isEmpty) {
        return;
      }

      final uploadCompleter = Completer<List<PhotoEntity>>();

      store.dispatch(UploadMultiplePhotosRequest(
          completer: uploadCompleter,
          category: eventName,
          eventId: eventId,
          selectEvent: event,
          tags: eventDescription,
          imagesData: photosToUpload,
          existingPhotos: existingPhotos));

      final savedPhotos = await uploadCompleter.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          throw TimeoutException('Photo upload timed out after 5 minutes');
        },
      );
      logInfo(
          'Successfully uploaded ${savedPhotos.length} photos in background');
    } catch (error) {
      logError('Error in background photo upload: $error');
    }
  }

  void _handleSaveEventFromScaffold(BuildContext context) {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    widget.viewModel.onSavePressed(context);
  }

  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event name'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    if (_startDate == null || _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start date and time'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _autoPopulateLocation() async {
    final currentLocation =
        await LocationService.getCurrentLocationAndAddress();
    if (currentLocation != null) {
      setState(() {
        _venueNameController.text = currentLocation;
      });
      _onChanged();
    }
  }
}

class _TicketTypeDialog extends StatefulWidget {
  const _TicketTypeDialog({
    this.ticketType,
    this.onSave,
  });

  final TicketType? ticketType;
  final Function(TicketType)? onSave;

  @override
  _TicketTypeDialogState createState() => _TicketTypeDialogState();
}

class _TicketTypeDialogState extends State<_TicketTypeDialog> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ticketTypeDialog');
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ticketType != null) {
      final ticket = widget.ticketType!;
      _nameController.text = ticket.name;
      _quantityController.text = ticket.quantity.toString();
      _priceController.text = (ticket.price / 100).toStringAsFixed(2);
      _descriptionController.text = ticket.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTicketType() {
    if (_formKey.currentState!.validate()) {
      final ticketType = TicketType((b) => b
        ..id = widget.ticketType?.id ?? BaseEntity.nextId
        ..object = 'ticket_type'
        ..name = _nameController.text.trim()
        ..quantity = int.tryParse(_quantityController.text) ?? 0
        ..price = ((double.tryParse(_priceController.text) ?? 0) * 100).round()
        ..description = _descriptionController.text.trim()
        ..minPerOrder = '1'
        ..maxPerOrder = 10
        ..status = 'On sale'
        ..bookingFee = 0
        ..quantityHeld = 0
        ..quantityIssued = 0
        ..quantityTotal = int.tryParse(_quantityController.text) ?? 0
        ..sortOrder = 0
        ..type = 'paid'
        ..accessCode = '');

      widget.onSave?.call(ticketType);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.ticketType == null ? 'Add Ticket Type' : 'Edit Ticket Type'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ticket Name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a ticket name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price (£)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTicketType,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _TicketGroupDialog extends StatefulWidget {
  const _TicketGroupDialog({
    this.ticketGroup,
    required this.availableTicketTypes,
    this.onSave,
  });

  final TicketGroup? ticketGroup;
  final List<TicketType> availableTicketTypes;
  final Function(TicketGroup)? onSave;

  @override
  _TicketGroupDialogState createState() => _TicketGroupDialogState();
}

class _TicketGroupDialogState extends State<_TicketGroupDialog> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ticketGroupDialog');
  final _titleController = TextEditingController();
  Set<String> _selectedTicketTypeIds = <String>{};

  @override
  void initState() {
    super.initState();
    if (widget.ticketGroup != null) {
      final group = widget.ticketGroup!;
      _titleController.text = group.name;
      _selectedTicketTypeIds = Set.from(group.ticketIds);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTicketGroup() {
    if (_formKey.currentState!.validate()) {
      final ticketGroup = TicketGroup((b) => b
        ..id = widget.ticketGroup?.id ?? BaseEntity.nextId
        ..name = _titleController.text.trim()
        ..maxPerOrder = 0
        ..sortOrder = 0
        ..ticketIds = ListBuilder(_selectedTicketTypeIds));

      widget.onSave?.call(ticketGroup);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ticketGroup == null
          ? 'Add Ticket Group'
          : 'Edit Ticket Group'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Group Title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a group title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Ticket Types:'),
            ...widget.availableTicketTypes.map((ticketType) {
              final isSelected = _selectedTicketTypeIds.contains(ticketType.id);
              return CheckboxListTile(
                title: Text(ticketType.name),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedTicketTypeIds.add(ticketType.id);
                    } else {
                      _selectedTicketTypeIds.remove(ticketType.id);
                    }
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTicketGroup,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _CoverImageCard extends StatelessWidget {
  final dynamic themeColors;
  final ThemeData theme;
  final List<Map<String, dynamic>> headerImages;
  final VoidCallback onImageTap;
  final Function(int)? onRemoveImage;

  const _CoverImageCard({
    required this.themeColors,
    required this.theme,
    required this.headerImages,
    required this.onImageTap,
    this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = headerImages.isNotEmpty &&
        (headerImages[0]['url'] != null && headerImages[0]['url'].isNotEmpty ||
            headerImages[0]['bytes'] != null);

    Widget? imageWidget;
    if (hasImage) {
      if (headerImages[0]['bytes'] != null) {
        imageWidget = Image.memory(
          headerImages[0]['bytes'],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } else if (headerImages[0]['url'] != null &&
          headerImages[0]['url'].isNotEmpty) {
        imageWidget = Image.network(
          headerImages[0]['url'],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.error, color: Colors.grey[600]),
            );
          },
        );
      }
    }

    return Container(
      width: double.infinity,
      height: isMobile(context) ? 380 : 480,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isMobile(context)
              ? const Radius.circular(24)
              : const Radius.circular(0),
          bottomLeft: isMobile(context)
              ? const Radius.circular(24)
              : const Radius.circular(0),
          topRight: const Radius.circular(24),
          bottomRight: const Radius.circular(24),
        ),
        gradient: hasImage
            ? null
            : const LinearGradient(
                colors: [
                  Color(0xFFB0D0F6),
                  Color(0xFFB6B6F6),
                  Color(0xFF8EC5FC),
                  Color(0xFFE0C3FC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: Stack(
        children: [
          if (hasImage && imageWidget != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: imageWidget,
            ),
          if (hasImage)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 32,
            bottom: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: onImageTap,
                  icon: Icon(hasImage ? Icons.edit : Icons.image_outlined,
                      color: hasImage ? Colors.white : Colors.black, size: 24),
                  label: Text(
                    hasImage ? 'Change cover' : 'Add a fixed cover',
                    style: TextStyle(
                      color: hasImage ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile(context) ? 12 : 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        hasImage ? Colors.black.withOpacity(0.7) : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 0,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 61, 60, 60).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.info_outline,
                            size: 14, color: Colors.black),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 180,
                        child: Text(
                          'Event covers rotate automatically to the latest shared photo.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  final dynamic themeColors;
  final ThemeData theme;
  final VoidCallback onPhotoSelect;
  final List<Map<String, dynamic>> eventPhotos;
  final List<Map<String, dynamic>> existingPhotos;
  final Function(int)? onRemovePhoto;
  final Function(int)? onRemoveExistingPhoto;

  const _PhotoUploadBox({
    required this.themeColors,
    required this.theme,
    required this.onPhotoSelect,
    required this.eventPhotos,
    required this.existingPhotos,
    this.onRemovePhoto,
    this.onRemoveExistingPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPhotos = eventPhotos.isNotEmpty || existingPhotos.isNotEmpty;

    return DottedBorder(
        color: themeColors.defaultColor,
        strokeWidth: 1,
        radius: const Radius.circular(16),
        borderType: BorderType.RRect,
        dashPattern: const [8, 4],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: themeColors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onPhotoSelect,
                child: Container(
                  width: double.infinity,
                  height: hasPhotos ? 120 : 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                      hasPhotos ? _buildPhotosPreview() : _buildUploadPrompt(),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUploadPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: themeColors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/loopjam/images/defaultDottedImage.png',
                width: isMobile(navigatorKey.currentContext!) ? 100 : 120,
                height: isMobile(navigatorKey.currentContext!) ? 100 : 120,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                Text('Share your Photos & Videos',
                    style: TextStyle(
                        color: themeColors.text,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            isMobile(navigatorKey.currentContext!) ? 10 : 14)),
                const SizedBox(
                  height: 10,
                ),
                Text('Drag and drop files here',
                    style: TextStyle(
                        color: themeColors.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            isMobile(navigatorKey.currentContext!) ? 8 : 10)),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile(navigatorKey.currentContext!) ? 200 : 250,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: themeColors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: themeColors.defaultColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_open_outlined,
                      size: 16, color: themeColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Choose files',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: themeColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 34,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosPreview() {
    final activeExistingPhotos =
        existingPhotos.where((photo) => photo['action'] != 'deleted').toList();
    final totalPhotoCount = eventPhotos.length + activeExistingPhotos.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$totalPhotoCount photo${totalPhotoCount > 1 ? 's' : ''} selected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton.icon(
              onPressed: onPhotoSelect,
              icon: const Icon(Icons.add_photo_alternate, size: 16),
              label: const Text('Add More'),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: isMobile(navigatorKey.currentContext!) ? 50 : 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: totalPhotoCount,
            itemBuilder: (context, index) {
              if (index < activeExistingPhotos.length) {
                final photo = activeExistingPhotos[index];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: photo['url'] != null
                            ? Image.network(
                                photo['url'],
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image,
                                        color: Colors.grey[600]),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.grey[300],
                                child:
                                    Icon(Icons.image, color: Colors.grey[600]),
                              ),
                      ),
                      if (onRemoveExistingPhoto != null)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => onRemoveExistingPhoto!(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                final newPhotoIndex = index - activeExistingPhotos.length;
                final photo = eventPhotos[newPhotoIndex];
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: photo['bytes'] != null
                            ? Image.memory(
                                photo['bytes'],
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              )
                            : Container(
                                color: Colors.grey[300],
                                child:
                                    Icon(Icons.image, color: Colors.grey[600]),
                              ),
                      ),
                      if (onRemovePhoto != null)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => onRemovePhoto!(newPhotoIndex),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap photos to remove • Tap "Add More" to select additional photos',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ThemeDropdownButton extends StatefulWidget {
  final String? selectedTheme;
  final Function(String) onThemeSelected;
  final dynamic themeColors;

  const _ThemeDropdownButton({
    required this.selectedTheme,
    required this.onThemeSelected,
    required this.themeColors,
  });

  @override
  _ThemeDropdownButtonState createState() => _ThemeDropdownButtonState();
}

class _ThemeDropdownButtonState extends State<_ThemeDropdownButton> {
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 280,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: EventThemes.predefinedThemes.length,
                itemBuilder: (context, index) {
                  final theme = EventThemes.predefinedThemes[index];
                  final isSelected = widget.selectedTheme == theme.id;

                  return GestureDetector(
                    onTap: () {
                      widget.onThemeSelected(theme.id);
                      _closeDropdown();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? widget.themeColors.defaultColor
                              : Colors.grey.shade300,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: LeftHalfCircleClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: RightHalfCircleClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.detailBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = widget.selectedTheme != null
        ? EventThemes.getThemeById(widget.selectedTheme!)
        : EventThemes.predefinedThemes.first;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _isOpen
                  ? widget.themeColors.defaultColor
                  : Colors.grey.shade300,
              width: _isOpen ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black12),
                ),
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: LeftHalfCircleClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTheme.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    ClipPath(
                      clipper: RightHalfCircleClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTheme.detailBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _isOpen ? 'Edit' : selectedTheme.name,
                  style: FontUtils.getTextStyleWithFont(
                    fontFamily: _isOpen ? null : selectedTheme.fontFamily,
                    baseStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeftHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRect(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RightHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
