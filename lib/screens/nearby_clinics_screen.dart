// import 'dart:convert';
// import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// class NearbyClinicsScreen extends StatefulWidget {
//   const NearbyClinicsScreen({super.key});

//   @override
//   State<NearbyClinicsScreen> createState() => _NearbyClinicsScreenState();
// }

// class _NearbyClinicsScreenState extends State<NearbyClinicsScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   final Set<Marker> _markers = {};
//   final String _apiKey = "YOUR_GOOGLE_MAPS_API_KEY";

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;

//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) return;

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _currentPosition = position;
//     });

//     _mapController?.animateCamera(
//       CameraUpdate.newLatLngZoom(
//         LatLng(position.latitude, position.longitude),
//         14,
//       ),
//     );

//     _getNearbyClinics(position.latitude, position.longitude);
//   }

//   Future<void> _getNearbyClinics(double lat, double lng) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=3000&type=hospital&key=$_apiKey";

//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final List clinics = data["results"];

//       setState(() {
//         _markers.clear();
//         for (var clinic in clinics) {
//           final marker = Marker(
//             markerId: MarkerId(clinic["place_id"]),
//             position: LatLng(
//               clinic["geometry"]["location"]["lat"],
//               clinic["geometry"]["location"]["lng"],
//             ),
//             infoWindow: InfoWindow(
//               title: clinic["name"],
//               snippet: clinic["vicinity"],
//             ),
//             icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueRed,
//             ),
//           );
//           _markers.add(marker);
//         }
//       });
//     } else {
//       throw Exception("Failed to load nearby clinics");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Nearby Clinics & Hospitals")),
//       body: _currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (controller) => _mapController = controller,
//               myLocationEnabled: true,
//               markers: _markers,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   _currentPosition!.latitude,
//                   _currentPosition!.longitude,
//                 ),
//                 zoom: 14,
//               ),
//             ),
//     );
//   }
// }
