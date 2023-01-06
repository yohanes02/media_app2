import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_app/webview_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'audio_page.dart';
import 'contact_page.dart';
import 'document_page.dart';
import 'gallery_page.dart';
import 'location_page.dart';

final pageOpened = StateProvider((ref) => 0);

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  PanelController navigationBottomController = PanelController();
  double bottomBarSize = 0;

  List<Map<String, dynamic>> navigationItem = [
    {
      "icon": const Icon(Icons.image),
      "label": "Gallery",
    },
    {
      "icon": const Icon(Icons.file_copy),
      "label": "Document",
    },
    {
      "icon": const Icon(Icons.place),
      "label": "Location",
    },
    {
      "icon": const Icon(Icons.person),
      "label": "Contact",
    },
    {
      "icon": const Icon(Icons.play_arrow),
      "label": "Audio",
    },
    {
      "icon": const Icon(Icons.javascript),
      "label": "WebView",
    },
  ];

  Widget _panelDisplayed(int navigationIdx) {
    if (navigationIdx == 0) {
      return const GalleryPage();
    } else if (navigationIdx == 1) {
      return const DocumentPage();
    } else if (navigationIdx == 2) {
      return const LocationPage();
    } else if (navigationIdx == 3) {
      return const ContactPage();
    } else if (navigationIdx == 4) {
      return const AudioPage();
    } else {
      return const WebViewPage();
    }
  }

  Widget _bodyDisplayed(int navigationIdx) {
    if (navigationIdx == 0) return const GalleryPageBack();
    if (navigationIdx == 1) return const DocumentPageBack();
    // if (navigationIdx == 2) return const LocationBodyPage();
    if (navigationIdx == 3) return const ContactPageBack();
    if (navigationIdx == 4) return const AudioPageBack();
    // if (navigationIdx == 5) return WebViewBodyPage();
    return Text("PAGE $navigationIdx");
  }

  @override
  void initState() {
    super.initState();
    bottomBarSize = Platform.isAndroid ? 140 : 100;
  }

  @override
  Widget build(BuildContext context) {
    final tabViewed = ref.watch(pageOpened);
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back_ios),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.arrow_back_ios),
            SizedBox(width: 8.0),
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Arif Yusuf",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Last seen yesterday",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          SizedBox(width: 30, child: Icon(Icons.phone)),
          SizedBox(width: 30, child: Icon(Icons.more_vert)),
        ],
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        minHeight: 380,
        maxHeight: MediaQuery.of(context).size.height - 140,
        panelBuilder: (sc) {
          return _panelDisplayed(tabViewed);
        },
        controller: navigationBottomController,
        body: _bodyDisplayed(tabViewed),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green.shade300,
        selectedItemColor: Colors.amber.shade300,
        currentIndex: tabViewed,
        items: [
          for (int i = 0; i < navigationItem.length; i++)
            BottomNavigationBarItem(
              backgroundColor: Colors.amber,
              icon: navigationItem[i]['icon'],
              label: navigationItem[i]['label'],
            ),
        ],
        onTap: (value) {
          log("Click tab $value (${navigationItem[value]['label']})");
          ref.read(pageOpened.notifier).update((state) => value);
        },
      ),
    );
  }
}
