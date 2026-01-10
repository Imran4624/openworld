import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/data/models/event_model.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/event/edit/event_edit_vm.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/data/models/event_model_helper.dart';
import 'package:built_collection/built_collection.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/auth/login_dialog_view.dart';
import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
import 'package:flutter_boilerplate/redux/photo/photo_actions.dart';
import 'package:flutter_boilerplate/data/models/photo_model.dart';
import 'package:redux/redux.dart';
import 'dart:ui';
import 'package:flutter_boilerplate/services/location_suggestion_widget.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:hugeicons/hugeicons.dart';

class EventEditOpw extends StatefulWidget {
  const EventEditOpw({
    super.key,
    required this.viewModel,
  });

  final EventEditVM viewModel;

  @override
  _EventEditOpwState createState() => _EventEditOpwState();
}

class _EventEditOpwState extends State<EventEditOpw> {

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_EventEditOpw');
  final _debouncer = Debouncer();

  final _nameController = TextEditingController();
  final _callToActionController = TextEditingController();
  final _currencyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endController = TextEditingController();
  final _startController = TextEditingController();
  final _eventSeriesIdController = TextEditingController();
  
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _priceController = TextEditingController();
  final _ageRestrictionController = TextEditingController();
  
  bool _isSelectingLocationSuggestion = false; 
  
  String? _selectedEventType;
  String _selectedTicketType = 'free';
  String _selectedGenderRestriction = 'none';
  
  List<Map<String, dynamic>> _headerImages = [];
  EventLocationData? _locationData;

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

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  final List<String> _defaultImages = [
    'assets/opw/create_event/default1.jpg',
    'assets/opw/create_event/default2.jpg',
    'assets/opw/create_event/default3.jpg',
    'assets/opw/create_event/default4.jpg',
  ];
  int _currentDefaultImageIndex = 0;
  bool _isUsingDefaultImage = false;
  bool _isCreatingEvent = false;

  List<TextEditingController> _controllers = [];

  final _nameFocusNode = FocusNode();
  final _venueFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();

  @override
  void didChangeDependencies() {
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
      _locationController,
      _capacityController,
      _priceController,
      _ageRestrictionController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final event = widget.viewModel.event;
    _nameController.text = event.name.toString();
    _callToActionController.text = event.callToAction.toString();
    _currencyController.text = event.currency.toString();
    _descriptionController.text = event.description.toString();

    // Populate new fields from dynamicFields
    _selectedEventType = event.eventType;
    _locationController.text = event.location ?? '';
    _locationData = event.locationData;
    _capacityController.text = event.capacity?.toString() ?? '';
    _selectedTicketType = event.ticketType ?? 'free';
    _priceController.text = event.price?.toString() ?? '';
    _ageRestrictionController.text = event.ageRestriction?.toString() ?? '';
    _selectedGenderRestriction = event.genderRestriction ?? 'none';
    
    if (event.dynamicFields['headerImages'] != null) {
      _headerImages = List<Map<String, dynamic>>.from(
        event.dynamicFields['headerImages'] as List,
      );
      _isUsingDefaultImage = false;
    } else if (event.images?.header != null && event.images!.header.isNotEmpty) {
      _headerImages = _getImageListFromUrl(event.images!.header);
      _isUsingDefaultImage = false;
    } else {
      _setDefaultImage(0);
    }

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
    _locationFocusNode.dispose();
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

  Future<void> _selectStartDate() async {
    if (isMobile(context)) {
      await _showIOSDatePicker();
    } else {
      await _showAndroidDatePicker();
    }
  }

  Future<void> _showIOSDatePicker() async {
    DateTime tempSelectedDate = _startDate ?? DateTime.now();
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _startDate = tempSelectedDate;
                          if (_startTime != null) {
                            _startController.text = _formatDateTime(_startDate!, _startTime!);
                          } else {
                            _startTime = TimeOfDay.now();
                            _startController.text = _formatDateTime(_startDate!, _startTime!);
                          }
                        });
                        _onChanged();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempSelectedDate,
                  minimumDate: DateTime.now().subtract(const Duration(days: 365)),
                  maximumDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  onDateTimeChanged: (DateTime newDate) {
                    tempSelectedDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAndroidDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_startTime != null) {
          _startController.text = _formatDateTime(_startDate!, _startTime!);
        } else {
          _startTime = TimeOfDay.now();
          _startController.text = _formatDateTime(_startDate!, _startTime!);
        }
      });
      _onChanged();
    }
  }

  Future<void> _selectStartTime() async {
    if (isMobile(context)) {
      await _showIOSTimePicker(true);
    } else {
      await _showAndroidTimePicker(true);
    }
  }

  Future<void> _selectEndTime() async {
    if (isMobile(context)) {
      await _showIOSTimePicker(false);
    } else {
      await _showAndroidTimePicker(false);
    }
  }

  Future<void> _showIOSTimePicker(bool isStartTime) async {
    DateTime tempDateTime = DateTime.now();
    if (isStartTime && _startDate != null && _startTime != null) {
      tempDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
    } else if (!isStartTime && _endDate != null && _endTime != null) {
      tempDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }
    
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      isStartTime ? 'Select Start Time' : 'Select End Time',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final selectedTime = TimeOfDay.fromDateTime(tempDateTime);
                        setState(() {
                          if (isStartTime) {
                            _startTime = selectedTime;
                            if (_startDate != null) {
                              _startController.text = _formatDateTime(_startDate!, _startTime!);
                            }
                          } else {
                            _endTime = selectedTime;
                            if (_endDate != null) {
                              _endController.text = _formatDateTime(_endDate!, _endTime!);
                            }
                          }
                        });
                        _onChanged();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: tempDateTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    tempDateTime = newDateTime;
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAndroidTimePicker(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime 
        ? (_startTime ?? TimeOfDay.now())
        : (_endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          if (_startDate != null) {
            _startController.text = _formatDateTime(_startDate!, _startTime!);
          }
        } else {
          _endTime = picked;
          if (_endDate != null) {
            _endController.text = _formatDateTime(_endDate!, _endTime!);
          }
        }
      });
      _onChanged();
    }
  }

  void _onChanged() {
    _debouncer.run(() {
      var event = widget.viewModel.event.rebuild((b) => b
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
        ..eventType = _selectedEventType
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
        ..dynamicFields = MapBuilder({
          'headerImages': _headerImages,
          if (_selectedEventType != null) 'eventType': _selectedEventType!,
          if (_locationController.text.isNotEmpty) 'location': _locationController.text.trim(),
          if (_capacityController.text.isNotEmpty) 'capacity': int.tryParse(_capacityController.text.trim()),
          'ticketType': _selectedTicketType,
          if (_priceController.text.isNotEmpty) 'price': double.tryParse(_priceController.text.trim()),
          if (_ageRestrictionController.text.isNotEmpty) 'ageRestriction': int.tryParse(_ageRestrictionController.text.trim()),
          'genderRestriction': _selectedGenderRestriction,
        }));
      if (_locationData != null) {
        event = event.rebuild((b) => b.locationData.replace(_locationData!));
      }
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

  ImageProvider _getImageProvider(Map<String, dynamic> imageData) {
    if (imageData.containsKey('bytes')) {
      return MemoryImage(imageData['bytes']);
    } else if (imageData.containsKey('url')) {
      return NetworkImage(imageData['url']);
    } else if (imageData.containsKey('assetPath')) {
      return AssetImage(imageData['assetPath']);
    } else {
      throw Exception('Invalid image data');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 1.5,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/opw/images/edit_event_background.jpeg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        Container(
                          height: 230,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _headerImages.isNotEmpty
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: _getImageProvider(_headerImages.first),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                              child: Container(
                                                color: Colors.black.withOpacity(0.3),
                                              ),
                                            ),
                                          ),
                                          Image(
                                            image: _getImageProvider(_headerImages.first),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ],
                                      )
                                    : Container(
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage('assets/opw/images/create_event.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.15),
                                                Colors.black.withOpacity(0.25),
                                              ],
                                              stops: const [0.3, 1.0],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              width: 0.5,
                                              color: Colors.white.withOpacity(0.3),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.black.withOpacity(0.25),
                                                  Colors.black.withOpacity(0.08),
                                                  Colors.black.withOpacity(0.08),
                                                  Colors.black.withOpacity(0.15),
                                                ],
                                                stops: const [0.0, 0.4, 0.6, 1.0],
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            Colors.black.withOpacity(0.25),
                                                            Colors.black.withOpacity(0.08),
                                                            Colors.black.withOpacity(0.08),
                                                            Colors.black.withOpacity(0.15),
                                                          ],
                                                          stops: const [0.0, 0.4, 0.6, 1.0],
                                                        ),
                                                      ),
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: InkWell(
                                                          borderRadius: BorderRadius.circular(8),
                                                          onTap: _selectImage,
                                                          child: const HugeIcon(
                                                            icon: HugeIcons.strokeRoundedImageUpload,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      child: IgnorePointer(
                                                        child: CustomPaint(
                                                          painter: SelectiveBorderPainter(
                                                            color: Colors.white70,
                                                            width: 0.5,
                                                            borderRadius: 8.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 6),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [
                                                            Colors.black.withOpacity(0.25),
                                                            Colors.black.withOpacity(0.08),
                                                            Colors.black.withOpacity(0.08),
                                                            Colors.black.withOpacity(0.15),
                                                          ],
                                                          stops: const [0.0, 0.4, 0.6, 1.0],
                                                        ),
                                                      ),
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: InkWell(
                                                          borderRadius: BorderRadius.circular(8),
                                                          onTap: _cycleDefaultImages,
                                                          child: const Icon(
                                                            Icons.refresh_outlined,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      child: IgnorePointer(
                                                        child: CustomPaint(
                                                          painter: SelectiveBorderPainter(
                                                            color: Colors.white,
                                                            width: 0.5,
                                                            borderRadius: 8.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white38,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Event title',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(bottom: 8, top: 8),
                              filled: false,
                              fillColor: Colors.transparent,
                              hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 32,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an event title';
                              }
                              return null;
                            },
                          ),
                        ),

                      const SizedBox(height: 18),

                      const Text(
                        'Select type of the event',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEventTypeChips(),

                      const SizedBox(height: 18),

                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Event description ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '(optional)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSelectiveInputField(
                        controller: _descriptionController,
                        hintText: 'Description',
                        maxLines: 5,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      _buildSelectiveInputField(
                        controller: _startController,
                        hintText: 'Select date',
                        readOnly: true,
                        onTap: _selectStartDate,
                        suffixIcon: const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                        validator: (value) {
                          if (_startDate == null || _startTime == null) {
                            return 'Please select date and time';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildSelectiveInputField(
                              controller: TextEditingController(text: _startTime?.format(context) ?? ''),
                              hintText: 'From',
                              readOnly: true,
                              suffixIcon: const Icon(Icons.access_time, size: 16, color: Colors.black54),
                              onTap: _selectStartTime,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSelectiveInputField(
                              controller: TextEditingController(text: _endTime?.format(context) ?? ''),
                              hintText: 'To',
                              readOnly: true,
                              suffixIcon: const Icon(Icons.access_time, size: 16, color: Colors.black54),
                              onTap: _selectEndTime,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      if (ProjectConfig.searchLocationGiveSuggestionsEnabled()) ...[
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      inputDecorationTheme: InputDecorationTheme(
                                        fillColor: Colors.transparent,
                                        filled: false,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(16),
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    child: LocationSuggestionsField(
                                      controller: _locationController,
                                      focusNode: _locationFocusNode,
                                      labelText: '',
                                      hintText: "Enter event location",
                                      decoration: InputDecoration(
                                        hintText: "Enter event location",
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(16),
                                        filled: false,
                                        fillColor: Colors.transparent,
                                        hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        suffixIcon: const Icon(Icons.location_on, size: 16, color: Colors.black54),
                                      ),
                                      onLocationSelected: (locationText) {
                                      },
                                      onLocationSuggestionSelected: (suggestion) {
                                        _isSelectingLocationSuggestion = true;
                                        
                                        String displayText = suggestion.displayName;
                                        if (suggestion.name == 'Current Location') {
                                          displayText = suggestion.city.isNotEmpty ? suggestion.city : suggestion.fullAddress;
                                        }
                                        
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          _locationController.text = displayText;
                                        });
                                        
                                        setState(() {
                                          _locationData = EventLocationData((b) => b
                                            ..name = displayText
                                            ..lat = suggestion.latitude ?? 0.0
                                            ..lng = suggestion.longitude ?? 0.0
                                            ..placeId = null
                                            ..address = suggestion.fullAddress
                                            ..city = suggestion.city
                                            ..country = suggestion.country);
                                        });
                                        _onChanged();
                                        
                                        Future.delayed(const Duration(milliseconds: 500), () {
                                          if (mounted) {
                                            _isSelectingLocationSuggestion = false;
                                            if (_locationController.text.isEmpty && _locationData?.name != null) {
                                              _locationController.text = _locationData!.name!;
                                            }
                                          }
                                        });
                                      },
                                      onChanged: (value) {
                                        if (_isSelectingLocationSuggestion) {
                                          return;
                                        }
                                        
                                        if (value.isEmpty && _locationData != null && 
                                            (_locationData!.lat != 0.0 || _locationData!.lng != 0.0)) {
                                          return;
                                        }
                                        
                                        if (value.isEmpty) {
                                          setState(() {
                                            _locationData = null;
                                          });
                                          _onChanged();
                                        } else if (_locationData == null || _locationData!.name != value) {
                                          setState(() {
                                            _locationData = EventLocationData((b) => b
                                              ..name = value
                                              ..lat = 0.0
                                              ..lng = 0.0
                                              ..placeId = null
                                              ..address = null
                                              ..city = null
                                              ..country = null);
                                          });
                                          _onChanged();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: SelectiveBorderPainter(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.0,
                                    borderRadius: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!ProjectConfig.searchLocationGiveSuggestionsEnabled())
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildSelectiveInputField(
                              controller: _locationController,
                              hintText: 'Enter event location',
                              suffixIcon: const Icon(Icons.location_on, color: Color.fromARGB(255, 67, 65, 65)),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter an event location';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    _locationData = EventLocationData((b) => b
                                      ..name = value
                                      ..lat = 0.0
                                      ..lng = 0.0
                                      ..placeId = null
                                      ..address = null
                                      ..city = null
                                      ..country = null);
                                  });
                                } else {
                                  setState(() {
                                    _locationData = null;
                                  });
                                }
                                _onChanged();
                              },
                            ),
                          ],
                        ),

                      const SizedBox(height: 18),

                      const Text(
                        'Capacity of the event',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSelectiveInputField(
                        controller: _capacityController,
                        hintText: 'Enter',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Ticket Type',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTicketTypeSelector(),

                      if (_selectedTicketType == 'paid') ...[
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 4),
                                        child: Text(
                                          '\$',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _priceController,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                          decoration: const InputDecoration(
                                            hintText: '',
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                                            filled: false,
                                            fillColor: Colors.transparent,
                                            hintStyle: TextStyle(
                                              color: Color(0xFF757575),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: SelectiveBorderPainter(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.0,
                                    borderRadius: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 18),

                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Age Restriction ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '(optional)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSelectiveInputField(
                        controller: _ageRestrictionController,
                        hintText: 'Enter minimum age',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),

                      const SizedBox(height: 18),

                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gender Restriction ',
                              style: TextStyle(
                                fontSize: 15 ,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '(optional)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildGenderRestrictionSelector(),

                      const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const Text(
                        'Note: Fill the required fields',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 67, 65, 65),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isCreatingEvent ? null : () {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCreatingEvent ? Colors.grey[400] : Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isCreatingEvent 
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'CREATING...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'CREATE EVENT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.08),
                      Colors.black.withOpacity(0.15),
                    ],
                    stops: const [0.0, 0.4, 0.6, 1.0],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            if (_isCreatingEvent)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Creating your event...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSaveEventFromScaffold(BuildContext context) {
    final bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    
    if (_locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event location'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    _handleSaveEvent(context);
  }

  Future<void> _handleSaveEvent(BuildContext context) async {
    if (_isCreatingEvent) return; // Prevent multiple submissions
    
    setState(() {
      _isCreatingEvent = true;
    });

    try {
      await _processDefaultImageForUpload();
      
      final store = StoreProvider.of<AppState>(context);
      final hasPhotosToUpload = _headerImages.isNotEmpty;

      final headerImagesCopy = List<Map<String, dynamic>>.from(_headerImages);
      final eventName = _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'Event Photos';
      final eventDescription = _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'Event';

      EventEntity savedEvent;
      try {
        savedEvent = await widget.viewModel.onSavePressed(context).timeout(
          const Duration(minutes: 2),
        );
      } on TimeoutException {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event creation timed out. Please check your connection and try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 8),
            ),
          );
        }
        return;
      }

      if (hasPhotosToUpload) {
        _uploadPhotosInBackground(
          store,
          savedEvent.id,
          savedEvent,
          headerImagesCopy,
          eventName,
          eventDescription,
        ).catchError((error) {
          logError("Error uploading photos in background: $error");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Event saved, but image upload failed. Please try uploading the image again.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 5),
              ),
            );
          }
        });
      }
    } catch (error) {
      logError("Error in _handleSaveEvent: $error");
      if (mounted) {
        String errorMessage;
        if (error.toString().contains('network') || error.toString().contains('connection')) {
          errorMessage = 'Network error. Please check your internet connection and try again.';
        } else {
          errorMessage = 'Error creating event: ${error.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingEvent = false;
        });
      }
    }
  }

  Future<void> _uploadPhotosInBackground(
    Store<AppState> store,
    String? eventId,
    EventEntity? event,
    List<Map<String, dynamic>> headerImages,
    String eventName,
    String eventDescription,
  ) async {
    try {
      final photosToUpload = headerImages
          .where((image) => image['action'] == 'added')
          .toList();

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
          existingPhotos: []));

      try {
        await uploadCompleter.future.timeout(
          const Duration(minutes: 5),
        );
      } on TimeoutException {
        logError('Photo upload timed out after 5 minutes');
        return;
      }
    } catch (error) {
      logError("Error in background photo upload: $error");
    }
  }

  Future<void> _selectImage() async {
    _pickCoverImage();
  }

  Future<void> _pickCoverImage() async {
    final images = await PhotoUploadHelper.pickImages(allowMultiple: false);
    if (images.isNotEmpty) {
      final image = images.first;
      setState(() {
        _isUsingDefaultImage = false; 
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
  
  void _setDefaultImage(int index) {
    if (index < 0 || index >= _defaultImages.length) {
      logError('Invalid default image index: $index');
      index = 0;
    }
    
    setState(() {
      _currentDefaultImageIndex = index;
      _isUsingDefaultImage = true;
      _headerImages = [
        {
          'assetPath': _defaultImages[index],
          'name': 'default${index + 1}.jpg',
          'action': 'default',
        }
      ];
    });
    _onChanged();
  }
  
  Future<Uint8List> _loadAssetImageBytes(String assetPath) async {
    try {
      final ByteData byteData = await rootBundle.load(assetPath);
      final Uint8List bytes = byteData.buffer.asUint8List();
      
      final sizeInKB = bytes.length / 1024;
      if (sizeInKB > 5000) { 
        logInfo('Asset image is quite large: ${sizeInKB.toStringAsFixed(1)}KB. Consider optimizing.');
      }
      
      return bytes;
    } catch (e) {
      logError('Failed to load asset image: $assetPath, Error: $e');
      if (assetPath != _defaultImages[0]) {
        try {
          final ByteData fallbackData = await rootBundle.load(_defaultImages[0]);
          return fallbackData.buffer.asUint8List();
        } catch (fallbackError) {
          logError('Failed to load fallback asset image: $fallbackError');
          rethrow;
        }
      }
      rethrow;
    }
  }
  
  Future<void> _processDefaultImageForUpload() async {
    if (_isUsingDefaultImage && _headerImages.isNotEmpty) {
      final currentImage = _headerImages.first;
      if (currentImage['action'] == 'default' && currentImage.containsKey('assetPath')) {
        try {
          final bytes = await _loadAssetImageBytes(currentImage['assetPath']);
          setState(() {
            _headerImages = [
              {
                'name': currentImage['name'],
                'bytes': bytes,
                'action': 'added', 
              }
            ];
            _isUsingDefaultImage = false; 
          });
        } catch (e) {
          logError('Error loading asset image: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to load default image. Using fallback.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    }
  }
  
  void _cycleDefaultImages() {
    if (_isUsingDefaultImage) {
      final nextIndex = (_currentDefaultImageIndex + 1) % _defaultImages.length;
      _setDefaultImage(nextIndex);
    } else {
      _setDefaultImage(0);
    }
  }

  Widget _buildEventTypeChips() {
    final eventTypes = [
      {'name': 'Party', 'icon': Icons.celebration_outlined},
      {'name': 'Group', 'icon': Icons.groups_outlined},
      {'name': 'Birthday', 'icon': Icons.cake_outlined},
      {'name': 'Corporate', 'icon': Icons.business_center_outlined},
      {'name': 'Dinner', 'icon': Icons.restaurant_outlined},
      {'name': 'Shop Opening', 'icon': Icons.storefront_outlined},
      {'name': 'Couplesleave', 'icon': Icons.local_cafe_outlined},
      {'name': 'Festival', 'icon': Icons.festival_outlined},
      {'name': 'Concert', 'icon': Icons.music_note_outlined},
      {'name': 'Dance Party', 'icon': Icons.music_note_outlined},
      {'name': 'Farewell', 'icon': Icons.school_outlined},
    ];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: eventTypes.map((typeData) {
        final String type = typeData['name'] as String;
        final IconData icon = typeData['icon'] as IconData;
        final isSelected = _selectedEventType == type;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEventType = isSelected ? null : type;
            });
            _onChanged();
          },
          child: Stack(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 100),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected 
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.black54,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: SelectiveBorderPainter(
                      color: isSelected 
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.2),
                      width: 1.0,
                      borderRadius: 8.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTicketTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.5,
          child: GestureDetector(
            onTap: null,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedTicketType == 'paid' 
                      ? Colors.black
                      : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: _selectedTicketType == 'paid'
                      ? Border.all(
                          color: Colors.black,
                          width: 1,
                        )
                      : null,
                  ),
                  child: Text(
                    'Paid',
                    style: TextStyle(
                      color: _selectedTicketType == 'paid' 
                        ? Colors.white 
                        : Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (_selectedTicketType != 'paid')
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: SelectiveBorderPainter(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.0,
                          borderRadius: 10.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTicketType = 'free';
            });
            _onChanged();
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedTicketType == 'free' 
                    ? Colors.black
                    : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: _selectedTicketType == 'free'
                    ? Border.all(
                        color: Colors.black,
                        width: 1,
                      )
                    : null,
                ),
                child: Text(
                  'Free',
                  style: TextStyle(
                    color: _selectedTicketType == 'free' 
                      ? Colors.white 
                      : Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              if (_selectedTicketType != 'free')
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: SelectiveBorderPainter(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.0,
                        borderRadius: 10.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderRestrictionSelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 600;
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildGenderOption('male', 'Male', isMobile),
              SizedBox(width: isMobile ? 8 : 30),
              _buildGenderOption('female', 'Female', isMobile),
              SizedBox(width: isMobile ? 8 : 30),
              Flexible(
                child: _buildGenderOption('none', 'No Restrictions', isMobile),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(String value, String label, [bool isMobile = false]) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGenderRestriction = value;
        });
        _onChanged();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 13 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: isMobile ? 4 : 8),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _selectedGenderRestriction == value ? Colors.black : Colors.black54,
                width: _selectedGenderRestriction == value ? 2 : 1,
              ),
              color: _selectedGenderRestriction == value ? Colors.white : Colors.transparent,
            ),
            child: _selectedGenderRestriction == value
                ? Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectiveInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                readOnly: readOnly,
                onTap: onTap,
                maxLines: maxLines,
                validator: validator,
                onChanged: onChanged,
                textAlign: prefixIcon != null ? TextAlign.left : TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  filled: false,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: SelectiveBorderPainter(
                color: Colors.white.withOpacity(0.3),
                width: 1.0,
                borderRadius: 12.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectiveBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final double borderRadius;

  SelectiveBorderPainter({
    required this.color,
    required this.width,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(borderRadius, 0);
    path.arcToPoint(
      Offset(0, borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );

    path.lineTo(0, size.height - borderRadius);

    path.moveTo(borderRadius, size.height);

    path.lineTo(size.width - borderRadius, size.height);

    path.arcToPoint(
      Offset(size.width, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
      clockwise: false,
    );

    path.lineTo(size.width, borderRadius);

    path.moveTo(size.width - borderRadius, 0);

    path.lineTo(borderRadius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
