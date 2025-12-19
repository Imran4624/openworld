// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_boilerplate/utils/images/photo_upload_helper.dart';
// import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:flutter_boilerplate/redux/app/app_state.dart';
// // Only import dart:html for web
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// class PhotoDragDropUpload extends StatefulWidget {
//   final Function(List<Map<String, dynamic>> files) onFilesPicked;
//   final bool allowMultiple;
//   final List<Map<String, dynamic>>? initialFiles;

//   const PhotoDragDropUpload({
//     Key? key,
//     required this.onFilesPicked,
//     this.allowMultiple = true,
//     this.initialFiles,
//   }) : super(key: key);

//   @override
//   State<PhotoDragDropUpload> createState() => _PhotoDragDropUploadState();
// }

// class _PhotoDragDropUploadState extends State<PhotoDragDropUpload> {
//   List<Map<String, dynamic>> _files = [];
//   bool _isDragging = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialFiles != null) {
//       _files = List.from(widget.initialFiles!);
//     }
//     // Only set up drag-and-drop listeners on web
//     if (kIsWeb) {
//       _setupWebDropListener();
//     }
//   }

//   void _setupWebDropListener() {
//     html.document.body?.addEventListener('dragover', _onDragOver);
//     html.document.body?.addEventListener('drop', _onDrop);
//   }

//   void _onDragOver(html.Event event) {
//     event.preventDefault();
//     setState(() => _isDragging = true);
//   }

//   void _onDrop(html.Event event) async {
//     event.preventDefault();
//     setState(() => _isDragging = false);
//     final html.DataTransfer? dt = (event as html.MouseEvent).dataTransfer;
//     if (dt != null && dt.files != null && dt.files!.isNotEmpty) {
//       setState(() => _isLoading = true);
//       final List<Map<String, dynamic>> picked = [];
//       for (final file in dt.files!) {
//         final reader = html.FileReader();
//         reader.readAsArrayBuffer(file);
//         await reader.onLoad.first;
//         final bytes = reader.result as List<int>;
//         picked.add({
//           'name': file.name,
//           'bytes': bytes,
//           'size': bytes.length,
//           'type': file.type,
//         });
//       }
//       setState(() {
//         _files = picked;
//         _isLoading = false;
//       });
//       widget.onFilesPicked(_files);
//     }
//   }

//   Future<void> _pickImages() async {
//     setState(() => _isLoading = true);
//     final images = await PhotoUploadHelper.pickImages(allowMultiple: widget.allowMultiple);
//     setState(() {
//       _files = images;
//       _isLoading = false;
//     });
//     widget.onFilesPicked(_files);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ThemeColors>(
//       converter: (store) => AppTheme.getThemeColors(store.state.prefState.enableDarkMode),
//       builder: (context, themeColors) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final isMobile = screenWidth < 500;
//         final boxWidth = screenWidth < 750 ? screenWidth * 0.95 : 700.0;
//         return Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 900),
//             margin: const EdgeInsets.all(0),
//             padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 32, vertical: isMobile ? 8 : 32),
//             decoration: BoxDecoration(
//               color: themeColors.secondary,
//               borderRadius: BorderRadius.circular(isMobile ? 18 : 32),
//             ),
//             child: Stack(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Add Photos and Videos',
//                               style: TextStyle(
//                                 fontSize: isMobile ? 22 : 32,
//                                 fontWeight: FontWeight.w800,
//                                 color: themeColors.text,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Share your photos and videos directly to [event]',
//                               style: TextStyle(
//                                 fontSize: isMobile ? 13 : 16,
//                                 color: themeColors.textSecondary,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, size: isMobile ? 24 : 32, color: themeColors.defaultColor.withOpacity(0.3)),
//                           onPressed: () => Navigator.of(context).maybePop(),
//                           splashRadius: 24,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: isMobile ? 18 : 32),
//                     // Upload Box
//                     Center(
//                       child: Container(
//                         width: boxWidth,
//                         padding: EdgeInsets.symmetric(
//                           vertical: isMobile ? 18 : 36,
//                           horizontal: isMobile ? 8 : 24,
//                         ),
//                         decoration: BoxDecoration(
//                           color: themeColors.emptyStateBackground,
//                           borderRadius: BorderRadius.circular(isMobile ? 16 : 32),
//                           border: Border.all(
//                             color: themeColors.defaultColor.withOpacity(0.18),
//                             width: 1.2,
//                             style: BorderStyle.solid,
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Dashed icon box
//                             Container(
//                               width: isMobile ? 60 : 80,
//                               height: isMobile ? 48 : 64,
//                               alignment: Alignment.center,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: themeColors.defaultColor.withOpacity(0.35),
//                                   width: 1.5,
//                                   style: BorderStyle.solid,
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(Icons.image_outlined, size: isMobile ? 36 : 48, color: themeColors.defaultColor.withOpacity(0.35)),
//                             ),
//                             SizedBox(height: isMobile ? 12 : 18),
//                             Text(
//                               'Share Your Photos & Videos',
//                               style: TextStyle(
//                                 fontSize: isMobile ? 16 : 20,
//                                 fontWeight: FontWeight.w700,
//                                 color: themeColors.text,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               'Drag and drop files here',
//                               style: TextStyle(
//                                 fontSize: isMobile ? 13 : 16,
//                                 color: themeColors.textSecondary,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: isMobile ? 18 : 32),
//                             SizedBox(
//                               width: isMobile ? double.infinity : 320,
//                               child: OutlinedButton.icon(
//                                 onPressed: _isLoading ? null : _pickImages,
//                                 icon: _isLoading
//                                     ? SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: themeColors.primary,
//                                         ),
//                                       )
//                                     : Icon(Icons.upload, color: themeColors.primary),
//                                 label: Text(
//                                   'Choose Files',
//                                   style: TextStyle(
//                                     color: themeColors.primary,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isMobile ? 15 : 18,
//                                   ),
//                                 ),
//                                 style: OutlinedButton.styleFrom(
//                                   side: BorderSide(color: themeColors.defaultColor.withOpacity(0.18), width: 1.5),
//                                   backgroundColor: themeColors.secondary,
//                                   padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 18),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// } 