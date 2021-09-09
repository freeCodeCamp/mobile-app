import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browserview extends StatefulWidget {
  Browserview({Key? key, required this.url}) : super(key: key);


  late final String url;
  _BrowserviewState createState() => _BrowserviewState();
}

class _BrowserviewState extends State<Browserview> {
  WebViewController? controller;
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
