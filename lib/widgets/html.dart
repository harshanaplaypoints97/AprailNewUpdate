import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebView extends StatelessWidget {
  final String initialUrl;

  MyWebView({@required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              clearCache: true,
              allowFileAccessFromFileURLs: true,
            ),
          ),
          onLoadStart: (controller, url) {
            // Handle load start event
          },
          onLoadStop: (controller, url) {
            // Handle load stop event
          },
          onLoadError: (controller, url, code, message) {
            // Handle load error event
          },
          onProgressChanged: (controller, progress) {
            // Handle progress changed event
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            // Handle navigation request event
            return NavigationActionPolicy.ALLOW;
          },
        ),
        // Other widgets to overlay on top of the WebView
      ],
    );
  }
}
