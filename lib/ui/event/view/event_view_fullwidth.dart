import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/event/view/event_view_vm.dart';

class EventViewFullwidth extends StatefulWidget {
  const EventViewFullwidth({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final EventViewVM viewModel;

  @override
  State<EventViewFullwidth> createState() => _EventViewFullwidthState();
}

class _EventViewFullwidthState extends State<EventViewFullwidth> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.viewModel.event;

    logInfo('EventViewFullwidth is shown');
    return LayoutBuilder(
      builder: (context, layout) {
        final minHeight = layout.maxHeight - 32.0 - 43.0;
        return FormCard(
          isLast: true,
          constraints: BoxConstraints(minHeight: minHeight),
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: _scrollController,
            children: [
              Text(
                event.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${formatDateTime(event.start)} - ${formatDateTime(event.end)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (event.venue != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.venue!.name ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if ((event.venue!.postalCode ?? '').isNotEmpty)
                  Text(
                    event.venue!.postalCode ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
