import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:location/location.dart'
    as mobile_location; // Đổi tên để tránh xung đột
import 'package:flutter/foundation.dart' show kIsWeb;

// Import 2 thư viện này
// import 'dart:html' as html; // Chỉ dùng cho Web
import 'package:geocoding/geocoding.dart' as geo;
import 'package:travel_torum_app/core/config/theme/app_colors.dart'; // Dùng cho Search

class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  // Vị trí mặc định (ví dụ: trung tâm TP.HCM)
  LatLng _initialPosition = const LatLng(10.7769, 106.7009);
  LatLng? _selectedPosition;
  bool _isLoading = true;

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      setState(() {
        _isLoading = false;
        _selectedPosition = _initialPosition;
      });
    } else {
      _getCurentLocation();
    }
  }

  Future<void> _getCurentLocation() async {
    LatLng? newPos;

    if (kIsWeb) {
      // try {
      //   final pos = await html.window.navigator.geolocation
      //       .getCurrentPosition();
      //   newPos = LatLng(
      //     pos.coords!.latitude!.toDouble(),
      //     pos.coords!.longitude!.toDouble(),
      //   );
      // } catch (e) {
      //   print("Lỗi geocoding khi tìm kiếm: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Lỗi tìm kiếm. Vui lòng thử lại.")),
      //   );
      //   newPos = _initialPosition;
      // }
      print("Đang chạy trên Web, bỏ qua lấy vị trí GPS.");
      newPos = _initialPosition;
    } else {
      bool serviceEnabled;

      mobile_location.PermissionStatus permissionGranted;

      mobile_location.Location location = mobile_location.Location();

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final locationData = await location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _initialPosition = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
          _selectedPosition = _initialPosition;
          _isLoading = false;
          _mapController.move(_initialPosition, 15.0);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchAddress() async {
    if (_searchController.text.isEmpty) return;

    //Ẩn bàn phím
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      // timf vị trí từ input người dùng nhập
      List<geo.Location> Locations = await geo.locationFromAddress(
        _searchController.text,
      );

      if (Locations.isNotEmpty) {
        final loc = Locations.first;

        // lấy vị trí mới tìm đuọc
        final newPost = LatLng(loc.latitude, loc.longitude);

        //di chuyển bản đồ tới vị trí mới tìm được
        _mapController.move(newPost, 15.0);

        setState(() {
          _selectedPosition = newPost;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Không tìm thấy địa chỉ: ${_searchController.text}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi tìm kiếm: $e")));
    }
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    if (hasGesture) {
      _selectedPosition = position.center;
    }
  }

  // Khi người dùng nhấn "Chọn", trả kết quả về
  void _selectLocation() {
    if (_selectedPosition != null) {
      Navigator.pop(context, _selectedPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn Vị Trí"),
        actions: [
          TextButton(
            onPressed: _selectLocation,
            child: const Text(
              "CHỌN",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialPosition,
                    initialZoom: 15,
                    onPositionChanged: _onPositionChanged,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.app', // Thay bằng tên package của bạn
                    ),
                  ],
                ),

                Center(
                  child: Icon(Icons.location_pin, color: Colors.red, size: 50),
                ),

                // Nút quay về vị trí của tôi
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    child: Icon(Icons.my_location),
                    onPressed: () {
                      _mapController.move(_initialPosition, 15.0);
                    },
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Tìm Kiếm Địa Chỉ...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            onSubmitted: (value) => _searchAddress(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchAddress,
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
