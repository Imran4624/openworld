import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_presenter.dart';
import 'package:flutter_boilerplate/constants.dart';

class SwipeCard extends StatefulWidget {
  final ProfileEntity profile;
  final VoidCallback? onLike;
  final VoidCallback? onPass;
  final VoidCallback? onTap;
  final bool isDragging;
  final Offset dragOffset;

  const SwipeCard({
    super.key,
    required this.profile,
    this.onLike,
    this.onPass,
    this.onTap,
    this.isDragging = false,
    this.dragOffset = Offset.zero,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final imageUrls = profile.dynamicFields.getImages(DynamicFieldsConstants.images);
    final fullName = profile.dynamicFields.getValue(DynamicFieldsConstants.name);
    final age = _calculateAge(profile);

    double rotation = widget.dragOffset.dx / 800;
    rotation = rotation.clamp(-0.4, 0.4);

    double opacity = (widget.dragOffset.dx.abs() / 120).clamp(0.0, 0.9);

    return Transform.translate(
      offset: widget.dragOffset,
      child: Transform.rotate(
        angle: rotation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  if (imageUrls.isNotEmpty)
                    Positioned.fill(
                      child: DynamicFieldsViewImages(
                        viewType: ImageViewType.detail,
                        images: imageUrls,
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade300,
                            Colors.purple.shade300,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (age != null)
                          Text(
                            'Age: $age',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (widget.isDragging && opacity > 0.2)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.dragOffset.dx > 0
                              ? Colors.green.withOpacity(opacity)
                              : Colors.red.withOpacity(opacity),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.dragOffset.dx > 0 
                                      ? Icons.favorite 
                                      : Icons.close,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.dragOffset.dx > 0 ? 'LIKE' : 'PASS',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int? _calculateAge(ProfileEntity profile) {
      final dateOfBirth = profile.dynamicFields.getValue(DynamicFieldsConstants.dob);
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
   
  }
}
