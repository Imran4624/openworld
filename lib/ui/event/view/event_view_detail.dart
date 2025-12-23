// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_html/flutter_html.dart';

class EventViewDetails extends StatefulWidget {
  const EventViewDetails({this.event});

  final EventEntity? event;

  @override
  _EventViewDetailsState createState() => _EventViewDetailsState();
}

class _EventViewDetailsState extends State<EventViewDetails> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return ScrollableListView(
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            event!.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16.0),
        if (event.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Html(data: event.description),
              ],
            ),
          ),
      ],
    );
  }
}
