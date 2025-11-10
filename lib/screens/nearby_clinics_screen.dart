import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Screen to display nearby clinics on a map with real Firestore data
class NearbyClinicsScreen extends StatefulWidget {
  const NearbyClinicsScreen({super.key});

  @override
  State<NearbyClinicsScreen> createState() => _NearbyClinicsScreenState();
}

class _NearbyClinicsScreenState extends State<NearbyClinicsScreen> {
  bool _isLoading = true;
  Position? _currentPosition;
  List<Map<String, dynamic>> _clinics = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String? _errorMessage;
  // For debugging: sample of clinic documents that lack valid coordinates
  List<Map<String, dynamic>> _missingCoords = [];

  final MapController _mapController = MapController();
  LatLng _initialCenter = const LatLng(23.0225, 72.5714); // Default Ahmedabad
  // Internal retry counter for map move attempts when the map's internal
  // controller (_internalController) hasn't been attached yet.
  int _mapMoveAttempts = 0;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Initialize location services
  Future<void> _initializeLocation() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Location services are disabled. Please enable location.';
        });
        // Load clinics anyway with default center
        await _loadClinicsFromFirestore();
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _errorMessage =
                'Location permission denied. Showing default location.';
          });
          await _loadClinicsFromFirestore();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Location permissions are permanently denied. Please enable in settings.';
        });
        await _loadClinicsFromFirestore();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _initialCenter = LatLng(position.latitude, position.longitude);
      });

      // Load clinics from Firestore
      await _loadClinicsFromFirestore();

  // Center map on user location. The MapController's internal controller
      // is attached during the first frame when the map is built, so defer
      // moving the map until after the first frame to avoid a
      // LateInitializationError (internal controller not initialized).
      // Defer moving the map until after the first frame. If the map's
      // internal controller (`_internalController`) isn't ready yet we retry
      // a few times with a short delay. This avoids a LateInitializationError
      // while still centering the map shortly after it is available.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mapMoveAttempts = 0;
        _tryMoveMap(_initialCenter, 13.0);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error getting location: ${e.toString()}';
        });
      }
      await _loadClinicsFromFirestore();
    }
  }

  /// Load clinics from Firestore
  Future<void> _loadClinicsFromFirestore() async {
    try {
      debugPrint('Starting to load clinics from Firestore...');
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('all_clinics')
          .get();
      debugPrint(
        'Received snapshot from Firestore with ${snapshot.docs.length} documents',
      );

      List<Map<String, dynamic>> loadedClinics = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Helper to parse coordinate values which may be stored as
        // number (int/double) or string in Firestore
        double? parseDouble(dynamic v) {
          if (v == null) return null;
          if (v is num) return v.toDouble();
          if (v is String) return double.tryParse(v);
          return null;
        }

        // Try both lat/lng and latitude/longitude field names
        final double? lat =
            parseDouble(data['lat']) ?? parseDouble(data['latitude']);
        final double? lng =
            parseDouble(data['lng']) ?? parseDouble(data['longitude']);

        // Debug: print coordinate values to help diagnose parsing issues
        // ignore: avoid_print
        print(
          'Doc ${doc.id}: lat=$lat (${data['lat'] ?? data['latitude']}), lng=$lng (${data['lng'] ?? data['longitude']})',
        );

        // Calculate numeric distance (meters) if we have both user and clinic
        // locations. We store both numeric distance for sorting and a
        // human-friendly string for display.
        double? distanceMeters;
        String distanceStr = 'N/A';
        if (_currentPosition != null && lat != null && lng != null) {
          distanceMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            lat,
            lng,
          );
          distanceStr = distanceMeters < 1000
              ? '${distanceMeters.round()} m'
              : '${(distanceMeters / 1000).toStringAsFixed(1)} km';
        }

        loadedClinics.add({
          'id': doc.id,
          'name': data['name'] ?? 'Unknown Clinic',
          'address': data['address'] ?? 'No address',
          'distanceMeters': distanceMeters, // nullable
          'distanceStr': distanceStr,
          'rating': (data['rating'] is num)
              ? (data['rating'] as num).toDouble()
              : 0.0,
          'open': data['open'] ?? false,
          'phone': data['phone']?.toString() ?? '',
    'type': data['type'] ?? 'Clinic',
    'category': data['category']?.toString(),
    'types': (data['types'] as List?)?.map((e) => e.toString()).toList() ?? [],
    'place_id': data['place_id']?.toString(),
    'tagColor': data['tagColor']?.toString(),
    'userRatingsTotal': (data['userRatingsTotal'] is num) ? (data['userRatingsTotal'] as num).toInt() : null,
    'timestamp': data['timestamp'],
          'lat': lat, // nullable double
          'lng': lng, // nullable double
        });
      }

      // Sort clinics: if we have numeric distances, sort by them; otherwise
      // keep Firestore ordering. Clinics without distance (no lat/lng or user
      // location unavailable) are placed at the end.
      if (_currentPosition != null) {
        loadedClinics.sort((a, b) {
          final double? da = a['distanceMeters'] as double?;
          final double? db = b['distanceMeters'] as double?;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return da.compareTo(db);
        });
      }

      // Collect docs without coordinates for debugging/inspection.
    final missing = loadedClinics
          .where((c) => c['lat'] == null || c['lng'] == null)
          .map(
            (c) => {
              'id': c['id'],
              'name': c['name'],
              'lat': c['lat'],
              'lng': c['lng'],
            },
          )
          .toList();

      // Build category/type filter lists (unique values) for UI
      final cats = <String>{};
      for (var c in loadedClinics) {
        if (c['category'] != null) cats.add(c['category']);
      }

      setState(() {
        _categories = cats.toList()..sort();
      });

      // Print to console to help debug in developer mode.
      // ignore: avoid_print
      print(
        'Clinics loaded: ${loadedClinics.length}, missing coords: ${missing.length}',
      );

      debugPrint(
        'Processed clinics: ${loadedClinics.length} total, ${loadedClinics.where((c) => c['lat'] != null && c['lng'] != null).length} with valid coordinates',
      );
      if (!mounted) return;
      if (!mounted) return;
      setState(() {
        _clinics = loadedClinics;
        _missingCoords = missing;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading clinics: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading clinics: ${e.toString()}';
        });
      }
    }
  }

  /// Try to move the map controller to [center] at [zoom]. If the
  /// flutter_map internal controller (`_internalController`) isn't yet
  /// initialized this will catch the error and retry up to [maxAttempts]
  /// times with a short delay between attempts.
  Future<void> _tryMoveMap(
    LatLng center,
    double zoom, {
    int maxAttempts = 5,
  }) async {
    while (_mapMoveAttempts < maxAttempts) {
      try {
        if (!mounted) return;
        _mapController.move(center, zoom);
        return; // success
      } catch (e) {
        // The internal controller is not ready yet; wait and retry.
        _mapMoveAttempts++;
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }
    // If we reach here, moving the map failed several times. It's safe to
    // ignore; FlutterMap will still use `initialCenter` when it renders.
    // Optionally log in debug mode:
    // debugPrint('Unable to move map after $_mapMoveAttempts attempts.');
  }

  /// Open phone dialer
  Future<void> _makePhoneCall(String phone) async {
    if (phone.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number not available')),
        );
      }
      return;
    }

    // Clean the phone number to ensure proper format
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Preferred: use a simple tel: URI string to maximize platform compatibility
    final String telString = 'tel:$cleanPhone';
    final Uri launchUri = Uri.parse(telString);

    try {
      // Some devices/emulators may not return true for canLaunchUrl for tel: URIs
      // so attempt to launch directly and fall back to launchUrlString if needed.
      if (await canLaunchUrl(launchUri)) {
        debugPrint('Launching dialer via canLaunchUrl: $telString');
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
        return;
      }

      // Fallback: attempt to launch directly (sometimes canLaunchUrl returns false
      // on emulators even though a dialer is available).
      debugPrint('Attempting direct launch of dialer: $telString');
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open phone dialer')),
        );
      }
    }
  }

  /// Open maps with directions
  Future<void> _openMaps(double lat, double lng, String name) async {
    // Try opening in Google Maps app with navigation
    final Uri googleMapsAppUri = Uri.parse('google.navigation:q=$lat,$lng');

    try {
      if (await canLaunchUrl(googleMapsAppUri)) {
        await launchUrl(googleMapsAppUri);
        return;
      }
    } catch (e) {
      // If Google Maps app URI fails, fall back to web URL
    }

    // Fallback to Google Maps website
    final Uri webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );

    try {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  /// Get icon for clinic type
  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hospital':
        return Icons.local_hospital;
      case 'emergency':
        return Icons.emergency;
      case 'diagnostic':
        return Icons.biotech;
      default:
        return Icons.medical_services;
    }
  }

  

  /// Get color for clinic category (used for marker/icon coloring)
  Color _getCategoryColor(String? category) {
    if (category == null) return Colors.teal;
    switch (category.toLowerCase()) {
      case 'pharmacy':
        return Colors.green;
      case 'hospital':
        return Colors.red;
      case 'clinic':
        return Colors.teal;
      case 'doctor':
      case 'doctors':
        return Colors.indigo;
      case 'medical store':
      case 'medical_store':
        return Colors.brown;
      default:
        return Colors.teal;
    }
  }

  /// Capitalize first letter of a string (safe for empty strings)
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Returns true if [clinic] matches the currently selected filters.
  bool _matchesFilter(Map<String, dynamic> clinic) {
    if (_selectedCategory != null) {
      final String? cat = clinic['category']?.toString();
      if (cat != _selectedCategory) return false;
    }
    return true;
  }

  /// Build marker for clinic
  Marker _buildMarker(Map<String, dynamic> clinic) {
    return Marker(
      point: LatLng(clinic['lat'] as double, clinic['lng'] as double),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showClinicDetails(clinic),
        child: Icon(
          _getTypeIcon(clinic['type']),
          color: _getCategoryColor(clinic['category']?.toString() ?? clinic['type']),
          size: 40,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
      ),
    );
  }

  /// Show clinic details in bottom sheet
  void _showClinicDetails(Map<String, dynamic> clinic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(clinic['category']?.toString() ?? clinic['type']).withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getTypeIcon(clinic['type']),
                        color: _getCategoryColor(clinic['category']?.toString() ?? clinic['type']),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinic['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: clinic['open']
                                      ? Colors.green[100]
                                      : Colors.red[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  clinic['open'] ? 'Open' : 'Closed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: clinic['open']
                                        ? Colors.green[900]
                                        : Colors.red[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                clinic['rating'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                          const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Category & Types
                if (clinic['category'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.category, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          _capitalize(clinic['category'].toString()),
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),

                if ((clinic['types'] as List?) != null && (clinic['types'] as List).isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: (clinic['types'] as List)
                        .map<Widget>((t) => Chip(
                                  label: Text(_capitalize(t.toString())),
                              backgroundColor: Colors.grey[100],
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 12),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        clinic['address'],
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Distance
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      // Use the human-friendly distance string we stored.
                      (clinic['distanceStr'] as String?) ?? 'N/A',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _makePhoneCall(clinic['phone']),
                        icon: const Icon(Icons.phone, size: 18),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final lat = clinic['lat'] as double?;
                          final lng = clinic['lng'] as double?;
                          if (lat != null && lng != null) {
                            _openMaps(lat, lng, clinic['name']);
                          } else {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Location not available for this clinic',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.directions, size: 18),
                        label: const Text('Directions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Nearby Clinics'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_currentPosition != null) {
                _mapController.move(
                  LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  15.0,
                );
              }
            },
            tooltip: 'My Location',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeLocation,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Loading clinics...'),
                ],
              ),
            )
          : Stack(
              children: [
                // Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: 13.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    // NOTE: Using the public OpenStreetMap tile servers
                    // (tile.openstreetmap.org) from a mobile app may trigger
                    // "access blocked" responses because those servers are
                    // volunteer-run and have strict usage policies. For
                    // production apps you must use a proper tile provider
                    // (Mapbox/MapTiler/OpenMapTiles/your own server) and supply
                    // an API key or contact info in the User-Agent.
                    //
                    // Replace `YOUR_MAPTILER_KEY` with your MapTiler (or other)
                    // API key. If you prefer another provider, update the
                    // urlTemplate accordingly.
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      // Set a proper package name or contact string here. For
                      // OpenStreetMap tile usage policy it's recommended to
                      // include contact info in the User-Agent (e.g.
                      // "com.mycompany.myapp (myemail@example.com)").
                      userAgentPackageName: 'com.healthsymptomchecker.app',
                    ),
                    MarkerLayer(
                      markers: [
                        // User location marker
                        if (_currentPosition != null)
                          Marker(
                            point: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            width: 60,
                            height: 60,
                              child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha((0.3 * 255).round()),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
            // Clinic markers: only create markers for clinics with
            // valid latitude/longitude values and matching filters.
            ..._clinics
              .where(
                (clinic) =>
                  clinic['lat'] != null &&
                  clinic['lng'] != null &&
                  _matchesFilter(clinic),
              )
              .map((clinic) => _buildMarker(clinic)),
                      ],
                    ),
                  ],
                ),

                // Filter bar (category)
                if (_categories.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('All'),
                            selected: _selectedCategory == null,
                            onSelected: (sel) {
                              setState(() {
                                _selectedCategory = null;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ..._categories.map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ChoiceChip(
                                  label: Text(_capitalize(c)),
                                  selected: _selectedCategory == c,
                                  onSelected: (sel) {
                                    setState(() {
                                      _selectedCategory = sel ? c : null;
                                    });
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                // Error/Info Banner
                if (_errorMessage != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.orange[100],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange[900]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.orange[900]),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.orange[900]),
                            onPressed: () =>
                                setState(() => _errorMessage = null),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Clinic count badge
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.1 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_hospital,
                          size: 18,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          // Show visible clinics (with coords) and total count to help
                          // debugging if some docs lack location fields.
                          '${_clinics.where((c) => c['lat'] != null && c['lng'] != null).length}/${_clinics.length} Medical Help Centers',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Debug: show clinics missing coordinates (visible when present)
                if (_missingCoords.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha((0.9 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.1 * 255).round()),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_missingCoords.length} docs missing coords',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Show up to 3 sample doc ids/names
                          ..._missingCoords
                              .take(3)
                              .map(
                                (c) => Text(
                                  '${c['id']}: ${c['name']}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
