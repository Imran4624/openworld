import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EventGridView extends StatelessWidget {
  const EventGridView({
    Key? key,
    required this.eventList,
    required this.eventMap,
    required this.crossAxisCount,
    required this.onTap,
    this.scrollController,
  }) : super(key: key);

  final List<dynamic> eventList;
  final BuiltMap<String?, SelectableEntity?>? eventMap;
  final int crossAxisCount;
  final Function(EventEntity) onTap;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = StoreProvider.of<AppState>(context);
    const cardRadius = 20.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GridView.builder(
              controller: scrollController,
              itemCount: eventList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final event = eventMap![eventList[index]] as EventEntity;
                final imageUrl = event.images?.header.isNotEmpty == true
                    ? event.images!.header
                    : ProjectConfig.defaultEntityImage(EntityType.event);
                return GestureDetector(
                  onTap: () => onTap(event),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Background image
                        Positioned.fill(
                          child: imageUrl.startsWith('http')
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'assets/boilerplate/images/defaultEventPhoto.png',
                                      fit: BoxFit.cover),
                                )
                              : Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // Overlay gradient for readability
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(cardRadius),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            backgroundImage:
                              (event.createdByObj != null && event.createdByObj!['thumbnail']?.isNotEmpty == true )
                                ? (event.createdByObj!['thumbnail']!.startsWith('http')
                                    ? NetworkImage(event.createdByObj!['thumbnail']!)
                                    : AssetImage(event.createdByObj!['thumbnail']!) as ImageProvider)
                                : AssetImage(ProjectConfig.defaultUserIcon),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'by ${event.createdByObj != null && event.createdByObj!['username']!.isNotEmpty == true ? event.createdByObj!['username']! : 'Unknown User'}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              shrinkWrap: false,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: IgnorePointer(
                ignoring: isGuestUser(store.state),
                child: Opacity(
                  opacity: isGuestUser(store.state) ? 0.0 : 1.0,
                  child: SizedBox(
                    width: 150,
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        createEntityByType(context: context, entityType: EntityType.event);
                      },
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      label: const Text(
                        'New event',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1746FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
