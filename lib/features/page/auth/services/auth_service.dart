import 'package:flutter/material.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/data/services/auth_local_service.dart';

class AuthService extends ChangeNotifier {
  MemberModel? _member;
  MemberModel? get member => _member;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AuthService() {
    _startSplashTimer();
  }

  // Đây là logic từ file MainApp cũ của bạn
  Future<void> _startSplashTimer() async {
    final minimumDelay = Future.delayed(const Duration(seconds: 2));
    final checkAuth = AuthLocalService().getLoginInfo();
    final result = await Future.wait([minimumDelay, checkAuth]);
    _member = result[1] as MemberModel?;
    _isLoading = false;
    notifyListeners(); // Thông báo cho GoRouter
  }

  // Loginva reigster sẽ gọi hàm này
  void authSuccess(MemberModel member) {
    _member = member;
    notifyListeners();
  }

  // Nút Logout trong Drawer sẽ gọi hàm này
  void logout() {
    _member = null;
    AuthLocalService().removeLoginInfo(); // Xóa local storage
    notifyListeners();
  }
}
