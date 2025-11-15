import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';
import 'package:travel_torum_app/features/page/auth/services/auth_service.dart';


class ReportPostPage extends StatefulWidget {
  final PostModel post;
  const ReportPostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<ReportPostPage> createState() => _ReportPostPageState();
}

class _ReportPostPageState extends State<ReportPostPage> {
  // Danh sách các lý do báo cáo
  final List<String> _reportReasons = [
    "Spam hoặc quảng cáo",
    "Nội dung nhạy cảm hoặc 18+",
    "Nội dung bạo lực hoặc thù hận",
    "Thông tin sai lệch, lừa đảo",
    "Vi phạm bản quyền",
    "Quấy rối hoặc bắt nạt",
    "Khác (Ghi rõ ở dưới)"
  ];
  
  String? _selectedReason; // Lý do được chọn
  final _detailsController = TextEditingController(); // Ô nhập chi tiết
  bool _isLoading = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  // Hàm gửi báo cáo
  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng chọn một lý do báo cáo."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() { _isLoading = true; });

    final reporterId = context.read<AuthService>().member?.id ?? "unknown";
    
    await Future.delayed(const Duration(seconds: 2));

    setState(() { _isLoading = false; });
  
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét."),
          backgroundColor: Colors.green,
        ),
      );
      
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Báo cáo bài viết"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tại sao bạn báo cáo bài viết này?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Báo cáo của bạn là ẩn danh. Nếu bạn thấy ai đó đang gặp nguy hiểm, đừng chần chừ mà hãy gọi dịch vụ cấp cứu tại địa phương.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const Divider(height: 24),

            // Danh sách các lý do (dùng RadioListTile)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reportReasons.length,
              itemBuilder: (context, index) {
                final reason = _reportReasons[index];
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),

            // Ô nhập chi tiết
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: "Chi tiết bổ sung (không bắt buộc)",
                hintText: "Cung cấp thêm thông tin...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            
            const SizedBox(height: 24),
            
            // Nút Gửi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.red, // Màu đỏ cho báo cáo
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Gửi Báo Cáo",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }