import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    Key? key,
    required this.url,
    this.title = 'Web Content',
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    
    String validUrl = widget.url;
    if (!widget.url.startsWith('http://') && !widget.url.startsWith('https://')) {
      validUrl = 'https://${widget.url}';
    }
    
      controller.loadRequest(Uri.parse(validUrl));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

bool isWeb() {
  return kIsWeb;
}

void openUrl(BuildContext context, String url, String title) {
  if (isWeb()) {
    String validUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      validUrl = 'https://$url';
    }
    try {
      launchUrl(Uri.parse(validUrl));
    } catch (e) {
      logError('Error launching URL: $e');
    }
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: url,
          title: title,
        ),
      ),
    );
  }
}
