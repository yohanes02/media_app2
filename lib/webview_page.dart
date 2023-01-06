import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'component/toggle_line.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleLine(),
        Expanded(
          child: WebView(
            initialUrl: 'https://google.com',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
          ),
        ),
      ],
    );
  }
}
