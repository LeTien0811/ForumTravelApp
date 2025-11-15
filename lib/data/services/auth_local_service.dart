import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:travel_torum_app/data/model/member_model.dart';

class AuthLocalService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _memberKey = 'login_member_info_encrypted';

  // chuyển thông tin người dùng thành string mã hóa lưu vào storage
  Future<bool> saveLoginInfo(MemberModel member) async {
    try {
      final memeberMap = member.toJson();
      final jsonString = jsonEncode(memeberMap);
      await _secureStorage.write(key: _memberKey, value: jsonString);
      return true;
    } catch (e) {
      print("Lỗi lưu thông tin người dùng: $e");
      return false;
    }
  }

  // lấy thông tin người dùng kiểm tra dã đăng nhaajo chauw
  Future<MemberModel?> getLoginInfo() async {
    try {
      final jsonString = await _secureStorage.read(key: _memberKey);

      if (jsonString == null) {
        return null;
      }

      final memberModel = MemberModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
      return memberModel;
    } catch (e) {
      print("Lỗi lấy thông tin người dùng: $e");
      return null;
    }
  }

  Future<bool> removeLoginInfo() async {
    try {
      await _secureStorage.delete(key: _memberKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
