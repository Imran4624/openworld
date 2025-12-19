import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';

class ChatHeader extends StatelessWidget {
  final String? thumbnail;
  final String appBarTitle;

  const ChatHeader({
    required this.appBarTitle,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (thumbnail != null && thumbnail != '') ...[
          SizedBox(
            width: 48,
            height: 48,
            child: ClipOval(
              child: DynamicFieldsViewImages(
                viewType: ImageViewType.thumbnailBig,
                images: [thumbnail!],
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
        Expanded(
          child: Text(appBarTitle),
        ),
      ],
    );
  }
}
