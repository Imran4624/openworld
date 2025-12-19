import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DynamicSearchPage(),
    );
  }
}

class DynamicSearchPage extends StatefulWidget {
  @override
  _DynamicSearchPageState createState() => _DynamicSearchPageState();
}

class _DynamicSearchPageState extends State<DynamicSearchPage> {
  // Data from the provided JSON
  final List<Map<String, dynamic>> groupedQuestions = [
    {
      'id': 'personal_details',
      'group': 'Personal Details',
      'description': "I'll ask some personal questions, hold tight!",
      'questions': [
        {
          'id': 'first_name',
          'type': 'text',
          'placeholder': 'Enter your first name',
          'label': 'First Name',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
        },
        {
          'id': 'ethnicity',
          'type': 'dropdown',
          'label': 'Ethnicity',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'options': ['Asian', 'African', 'Hispanic', 'Other']
        },
        {
          'id': 'age',
          'type': 'dropdown',
          'label': 'Age',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': true,
          'options': [18, 40],
          'searchOrder': 1
        },
        {
          'id': 'first_name1',
          'type': 'text',
          'placeholder': 'Enter your first name',
          'label': 'First Name',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': false,
          'isRangeSelect': false,
          'searchOrder': 5
        },
        {
          'id': 'countries',
          'type': 'searchable_dropdown',
          'label': 'Country',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'isSearchable': true,
          'selectedField': 'code',
          'showField': 'flagIcon, name',
          'options': [
            {'name': 'United States', 'code': 'USA', 'flagIcon': '🇺🇸'},
            {'name': 'India', 'code': 'IND', 'flagIcon': '🇮🇳'},
            {'name': 'China', 'code': 'CHN', 'flagIcon': '🇨🇳'},
            {'name': 'Germany', 'code': 'DEU', 'flagIcon': '🇩🇪'},
            {'name': 'France', 'code': 'FRA', 'flagIcon': '🇫🇷'},
            {'name': 'Brazil', 'code': 'BRA', 'flagIcon': '🇧🇷'},
            {'name': 'Australia', 'code': 'AUS', 'flagIcon': '🇦🇺'}
          ],
          'searchOrder': 3
        },
        {
          'id': 'gender',
          'type': 'radio',
          'label': 'Gender',
          'searchable': 'ShowInBasicSearch',
          'options': ['Male', 'Female', 'Other'],
          'isMultiSelect': false,
        },
        {
          'id': 'gender',
          'type': 'dropdown',
          'label': 'Gender',
          'searchable': 'ShowInBasicSearch',
          'options': ['Male', 'Female', 'Other'],
          'isMultiSelect': false,
        }
      ]
    },
    {
      'id': 'interests',
      'group': 'Interest',
      'description': 'Let us know about your interests!',
      'questions': [
        {
          'id': 'interest',
          'type': 'tags',
          'label': 'Interests',
          'searchable': 'ShowInBasicSearch',
          'isMultiSelect': true,
          'options': [
            {'label': 'Cycling', 'icon': Icons.directions_bike},
            {'label': 'Reading', 'icon': Icons.book},
            {'label': 'Travelling', 'icon': Icons.flight}
          ]
        }
      ]
    }
  ];

  // To store search results
  Map<String, dynamic> searchResults = {};

  // Range slider values
  RangeValues _currentRangeValues = const RangeValues(18, 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Search'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._buildSearchFields(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitSearch,
              child: Text('Submit Search'),
            ),
            SizedBox(height: 20),
            _buildSearchResultsDisplay(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchFields() {
    List<Widget> searchFields = [];

    for (var group in groupedQuestions) {
      for (var question in group['questions']) {
        // Only include fields marked for basic search
        if (question['searchable'] == 'ShowInBasicSearch') {
          searchFields.add(_renderSearchField(question));
          searchFields.add(SizedBox(height: 16));
        }
      }
    }

    return searchFields;
  }

  Widget _renderSearchField(Map<String, dynamic> question) {
    // Handle Range Slider first (highest priority)
    if (question['isRangeSelect'] == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['label'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          StatefulBuilder(
            builder: (context, setState) {
              return RangeSlider(
                values: _currentRangeValues,
                min: question['options'][0].toDouble(),
                max: question['options'][1].toDouble(),
                divisions: question['options'][1] - question['options'][0],
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                    this.setState(() {
                      searchResults[question['id']] = {
                        'min': values.start.toInt(),
                        'max': values.end.toInt()
                      };
                    });
                  });
                },
              );
            },
          ),
        ],
      );
    }

    // Multi-select tags
    if (question['isMultiSelect'] == true && question['type'] == 'tags') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['label'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: (question['options'] as List).map((option) {
              bool isSelected = (searchResults[question['id']] ?? [])
                  .contains(option['label']);
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(option['icon']),
                    SizedBox(width: 4),
                    Text(option['label']),
                  ],
                ),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    List<String> currentSelection =
                        List.from(searchResults[question['id']] ?? []);

                    if (selected) {
                      currentSelection.add(option['label']);
                    } else {
                      currentSelection.remove(option['label']);
                    }

                    searchResults[question['id']] = currentSelection;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }

    // Multi-select dropdown
    if (question['isMultiSelect'] == true &&
        (question['type'] == 'dropdown' ||
            question['type'] == 'searchable_dropdown')) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['label'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          SearchableDropdown(
            items: question['options'],
            isMultiSelect: true,
            label: question['label'],
            selectedField: question['selectedField'] ?? 'name',
            showField: question['showField'] ?? 'name',
            onChanged: (value) {
              setState(() {
                searchResults[question['id']] = value;
              });
            },
          ),
        ],
      );
    }

    // Single select based on type
    switch (question['type']) {
      case 'text':
        return TextField(
          decoration: InputDecoration(
            labelText: question['label'],
            hintText: question['placeholder'] ?? '',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            searchResults[question['id']] = value;
          },
        );

      case 'dropdown_tags': // use this code when you want to show tags for input type dropdown
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['label'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: (question['options'] as List<String>).map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: searchResults[question['id']] == option,
                  onSelected: (bool selected) {
                    setState(() {
                      searchResults[question['id']] = selected ? option : null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 'dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['label'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              isExpanded: true,
              value: searchResults[question['id']],
              hint: Text('Select ${question['label']}'),
              onChanged: (String? newValue) {
                setState(() {
                  searchResults[question['id']] = newValue;
                });
              },
              items: (question['options'] as List<String>)
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      case 'radio':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['label'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: (question['options'] as List<String>).map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: searchResults[question['id']] == option,
                  onSelected: (bool selected) {
                    setState(() {
                      searchResults[question['id']] = selected ? option : null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        );

      case 'searchable_dropdown':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['label'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            SearchableDropdown(
              items: question['options'],
              isMultiSelect: false,
              label: question['label'],
              selectedField: question['selectedField'] ?? 'name',
              showField: question['showField'] ?? 'name',
              onChanged: (value) {
                setState(() {
                  searchResults[question['id']] = value;
                });
              },
            ),
          ],
        );

      default:
        return SizedBox.shrink();
    }
  }

  void _submitSearch() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Results'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: searchResults.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('${entry.key}: ${entry.value}'),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResultsDisplay() {
    return Text(
      'Tap Submit Search to view selected search criteria',
      style: TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }
}

class SearchableDropdown extends StatefulWidget {
  final List<dynamic> items;
  final bool isMultiSelect;
  final String label;
  final String selectedField;
  final String showField;
  final Function(dynamic) onChanged;
  final bool isSearchable;

  const SearchableDropdown({
    Key? key,
    required this.items,
    this.isMultiSelect = false,
    required this.label,
    this.selectedField = 'name',
    this.showField = 'name',
    required this.onChanged,
    this.isSearchable = true,
  }) : super(key: key);

  @override
  _SearchableDropdownState createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  List<dynamic> _filteredItems = [];
  List<dynamic> _selectedItems = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  bool _isItemSelected(dynamic item) {
    return _selectedItems.any((selected) =>
        selected[widget.selectedField] == item[widget.selectedField]);
  }

  void _selectItem(dynamic item) {
    setState(() {
      if (widget.isMultiSelect) {
        // Toggle selection for multi-select
        if (_isItemSelected(item)) {
          _selectedItems.removeWhere((selected) =>
              selected[widget.selectedField] == item[widget.selectedField]);
        } else {
          _selectedItems.add(item);
        }
        widget.onChanged(
            _selectedItems.map((i) => i[widget.selectedField]).toList());
      } else {
        // Single select
        _selectedItems = [item];
        widget.onChanged(item[widget.selectedField]);
        Navigator.of(context).pop();
      }
    });
  }

  void _showDropdownDialog() {
    // Reset filtered items and search controller when opening dialog
    setState(() {
      _filteredItems = widget.items;
      _searchController.clear();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: widget.isSearchable
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          _filteredItems = widget.items.where((item) {
                            return item[widget.showField]
                                .toLowerCase()
                                .contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                    )
                  : Text(widget.label),
              content: SingleChildScrollView(
                child: ListBody(
                  children: _filteredItems.map((item) {
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          if (item['icon'] != null) Icon(item['icon']),
                          SizedBox(width: 8),
                          Text(item[widget.showField]),
                        ],
                      ),
                      value: _isItemSelected(item),
                      onChanged: (_) {
                        _selectItem(item);
                        setDialogState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show selected items
        if (_selectedItems.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _selectedItems.map((item) {
              return Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item['icon'] != null) Icon(item['icon'], size: 16),
                    SizedBox(width: 4),
                    Text(item[widget.showField]),
                  ],
                ),
                onDeleted:
                    widget.isMultiSelect ? () => _selectItem(item) : null,
              );
            }).toList(),
          ),

        // Select button
        ElevatedButton(
          onPressed: _showDropdownDialog,
          child: Text('Select ${widget.label.pluralize()}'),
        ),
      ],
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String pluralize() {
    if (isEmpty) return this;

    // Special cases for words ending in 'y'
    if (endsWith('y')) {
      return '${substring(0, length - 1)}ies';
    }

    // Default pluralization
    return '${this}s';
  }
}
