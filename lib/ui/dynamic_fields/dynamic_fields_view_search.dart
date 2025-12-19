import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/mock/cac.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_builder.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    Key? key,
  }) : super(key: key);

  static const String route = '/dynamicSearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _searchCriteria = {};
  late List<QuestionGroupModel> _questionGroups;

  @override
  void initState() {
    super.initState();
    _questionGroups = (cacQuestions['groups'] as List)
        .map((group) => QuestionGroupModel.fromJson(group))
        .toList();

    // Initialize controllers for searchable fields
    for (var group in _questionGroups) {
      for (var question in group.questions) {
        if (question.searchable == SearchableType.ShowInBasicSearch ||
            question.searchable == SearchableType.ShowInAdvanceSearch) {
          _controllers[question.id] = TextEditingController();
        }
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildSearchFields({
    required SearchableType type,
  }) {
    List<QuestionModel> searchableQuestions = _questionGroups
        .expand((group) => group.questions)
        .where((question) => question.searchable == type)
        .toList();

    if (searchableQuestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: searchableQuestions.map((question) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: buildInputField(
            context,
            question,
            _searchCriteria[question.id],
            (value) {
              setState(() {
                _searchCriteria[question.id] = value;
              });
            },
            controller: _controllers[question.id],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Search Section
            const Text(
              'Basic Search',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSearchFields(type: SearchableType.ShowInBasicSearch),
            const SizedBox(height: 24),

            // Advanced Search Section
            const Text(
              'Advanced Search',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildSearchFields(type: SearchableType.ShowInAdvanceSearch),

            // Search Button
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    // Logic to handle the search criteria
    printL('Search Criteria: $_searchCriteria');
    // Perform search based on `_searchCriteria`
    // You can add API calls or local filtering logic here
  }
}
