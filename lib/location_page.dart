import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_app/component/search_widget.dart';
import 'package:media_app/component/toggle_line.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const GoogleMapWidget(),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
        ),
        child: const Text(
          "Lokasi sekitar anda",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({Key? key}) : super(key: key);

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ToggleLine(),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.grey),
              ),
              height: 160,
              child: const GoogleMapPreview(),
            ),
            InkWell(
              onTap: () {},
              child: const SizedBox(
                height: 160,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Icon(
                      Icons.location_on_sharp,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SearchWidget(),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.place_outlined)),
          title: Text("Current Location"),
          subtitle: Text("accuracy up to 15m"),
        ),
        const ListTile(
          leading: CircleAvatar(child: Icon(Icons.emergency_share_outlined)),
          title: Text("Share live location to.."),
          subtitle: Text("Jl. ABD HAMID"),
        ),
      ],
    );
  }
}

class GoogleMapPreview extends StatefulHookConsumerWidget {
  const GoogleMapPreview({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleMapPreviewState();
}

class _GoogleMapPreviewState extends ConsumerState<GoogleMapPreview> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-6.221465, 106.843724),
        zoom: 15,
      ),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      scrollGesturesEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _controller = controller;
        });
      },
    );
  }
}
