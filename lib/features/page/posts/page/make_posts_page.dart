import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // Thư viện chọn ảnh
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo; // Thư viện đổi tọa độ
import 'package:travel_torum_app/common/widgets/post/buil_image_grid_view.dart';
import 'package:travel_torum_app/common/widgets/post/buil_location_display.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/data/services/auth_local_service.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';

class MakePostsPage extends StatefulWidget {
  const MakePostsPage({Key? key}) : super(key: key);

  @override
  State<MakePostsPage> createState() => _MakePostsPage();
}

class _MakePostsPage extends State<MakePostsPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentPreview = TextEditingController();

  bool _isLoading = false;
  String? _error;
  MemberModel? _currentUser;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  // State cho vị trí
  LatLng? _selectedCoordinates;
  String? _locationAddress;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Lấy thông tin người dùng đang đăng nhập
  Future<void> _loadCurrentUser() async {
    final user = await AuthLocalService().getLoginInfo();
    setState(() {
      _currentUser = user;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      setState(() {
        _selectedImages.addAll(images);
      });
    } catch (e) {
      print("Lỗi khi chọn ảnh: $e");
    }
  }

  Future<void> _pickLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationAddress = null;
      _error = null; // Xóa lỗi cũ
    });

    try {
      // 1. Mở Map Picker
      final result = await Navigator.push<LatLng>(
        context,
        MaterialPageRoute(builder: (context) => const MapPickerView()),
      );

      // 2. Kiểm tra nếu người dùng nhấn "Cancel"
      if (result == null) {
        setState(() {
          _isFetchingLocation = false;
        });
        return;
      }

      // 3. Nếu có kết quả (người dùng đã CHỌN)
      _selectedCoordinates = result; // LƯU TỌA ĐỘ

      // 4. (Cố gắng) lấy tên địa chỉ
      try {
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
          _selectedCoordinates!.latitude,
          _selectedCoordinates!.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final address = [
            p.street,
            p.subLocality,
            p.subAdministrativeArea,
            p.administrativeArea,
            p.country,
          ].where((s) => s != null && s.isNotEmpty).join(', ');

          // Nếu geocoding trả về trống rỗng, coi như lỗi
          if (address.isEmpty) {
            throw Exception("Geocoding trả về địa chỉ rỗng");
          }

          setState(() {
            // 4a. Thành công: Lưu tên địa chỉ
            _locationAddress = address;
          });
        } else {
          // Trường hợp geocoding trả về list rỗng
          throw Exception("Geocoding không tìm thấy placemarks");
        }
      } catch (e) {
        // 5. (THẤT BẠI) Bị lỗi ở CATCH
        print("Lỗi geocoding: $e");
        // ---- GIẢI PHÁP MỚI ----
        // Không báo lỗi, mà dùng tọa độ làm tên
        setState(() {
          _locationAddress =
              "Vị trí: ${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}";
        });
      }
    } catch (e) {
      // 6. Bắt lỗi (từ Navigator hoặc lỗi khác)
      print("Lỗi _pickLocation: $e");
      setState(() {
        _error = "Đã xảy ra lỗi khi chọn vị trí.";
      });
    } finally {
      // 7. Luôn luôn tắt loading
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  Future<void> _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      setState(() {
        _error = "Tiêu đề và nội dung không được để trống.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 100,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: TextButton(
              onPressed: () => context.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ),

        centerTitle: false,

        actions: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: _submitPost,
                    child: Text(
                      "Submit Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị lỗi
            if (_error != null)
              Text(_error!, style: TextStyle(color: AppColors.red)),

            // Hiển thị thông tin người đăng
            if (_currentUser != null)
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser!.avata_url),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${_currentUser!.firts_name} ${_currentUser!.last_name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

            SizedBox(height: 16),

            // Tiêu đề
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Nhập tiêu đề...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              minLines: 1,
              maxLines: 2,
            ),

            SizedBox(height: 16),

            TextField(
              controller: _contentPreview,
              decoration: const InputDecoration(
                hintText:
                    "Nhập nội dung review đây là thứ mà mọi người sẽ thấy đầu tiên...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              minLines: 1,
              maxLines: 3,
            ),

            SizedBox(height: 16),

            // Nội dung
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: "Bạn đang nghĩ gì về chuyến đi này?",
                border: InputBorder.none,
              ),
              maxLines: null, // Cho phép nhập nhiều dòng
              keyboardType: TextInputType.multiline,
            ),

            SizedBox(height: 16),

            _locationAddress != null
                ? Text(_locationAddress!)
                : Text('chưa gắn vị trí'),

            SizedBox(height: 16),

            if (_locationAddress != null) Chip(label: Text(_locationAddress!)),
            if (_isFetchingLocation) CircularProgressIndicator(),

            // Hiển thị các ảnh đã chọn
            ImageGridView(images: _selectedImages, onRemoveImage: _removeImage),
          ],
        ),
      ),
      // Thanh công cụ ở dưới
      bottomNavigationBar: _buildToolbar(),
    );
  }

  // Widget thanh công cụ (chọn ảnh, vị trí)
  Widget _buildToolbar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.photo_library, color: Colors.green),
            onPressed: _pickImages,
            tooltip: "Chọn ảnh",
          ),
          IconButton(
            icon: Icon(Icons.location_on, color: AppColors.blue),
            onPressed: _pickLocation,
            tooltip: "Gắn vị trí hiện tại",
          ),
          IconButton(
            icon: Icon(Icons.tag_faces, color: Colors.orange),
            onPressed: () {
              /* TODO: Thêm emoji */
            },
            tooltip: "Cảm xúc",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
