import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_torum_app/common/widgets/button/large_app_button_primary.dart';
import 'package:travel_torum_app/common/widgets/input/custom_input_icon.dart';
import 'package:travel_torum_app/common/widgets/input/custom_password_input.dart';
import 'package:travel_torum_app/core/config/assets/app_imgs.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';
import 'package:travel_torum_app/data/model/member_model.dart';
import 'package:travel_torum_app/data/services/auth_local_service.dart';
import 'package:validators/validators.dart';

class RegisterPage extends StatefulWidget {
  final void Function(MemberModel) onRegisterSucces;

  const RegisterPage({
    super.key,
    required this.onRegisterSucces,
  });

  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String _LastName = '';
  String _firtsName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';
  bool _isLoading = false;

  void _changedFirtsName(String value) {
    _firtsName = value;
  }

  void _changedLastName(String value) {
    _LastName = value;
  }

  void _changedEmail(String value) {
    _email = value;
  }

  void _changedPassword(String value) {
    _password = value;
  }

  void _changedConfirmPassword(String value) {
    _confirmPassword = value;
  }

  bool _isEmailValid(String email) {
    return isEmail(email);
  }

  Future<void> _submitRegister() async {
    setState(() {
      _isLoading = true;
    });
    if (!_isEmailValid(_email) || _password.length < 12) {
      setState(() {
        _isLoading = false;
        _error = "Please Enter True type Field";
      });
      return;
    }

    final minimumDelay = Future.delayed(const Duration(seconds: 2));
    final Loggedin = MemberModel(
      id: "m1",
      firts_name: "Lê Việt",
      last_name: "Tiến",
      avata_url:
          "https://res.cloudinary.com/dsrrik0wb/image/upload/v1747806615/gx8b7qdbife2bunei2l4.jpg",
      auth_token: 'abc123',
    );
    final SaveMemebr = AuthLocalService().saveLoginInfo(Loggedin);
    final result = await Future.wait([minimumDelay, SaveMemebr]);
    bool checkSucces = result[1];

    if (checkSucces) {
      setState(() {
        _isLoading = false;
      });
      widget.onRegisterSucces(Loggedin);
      return;
    } else {
      setState(() {
        _error = "Login Faile!";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AppImages.logoImg,
                        fit: BoxFit.cover,
                        height: 200,
                      ),

                      Text(
                        "Welcome Travel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                          fontSize: 30,
                        ),
                      ),

                      Text(
                        "Enter your Email & Password to Sign in",
                        style: TextStyle(color: AppColors.gray2, fontSize: 13),
                      ),

                      SizedBox(height: 3),

                      if (_error != '')
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: Text(
                            _error,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.red,
                            ),
                          ),
                        ),

                      SizedBox(height: 3),

                      CustomInputsIcon(
                        onChanged: _changedFirtsName,
                        label: "First Name!",
                        icon: Icons.drive_file_rename_outline,
                      ),

                      SizedBox(height: 10),

                      CustomInputsIcon(
                        onChanged: _changedLastName,
                        label: "Last Name!",
                        icon: Icons.drive_file_rename_outline,
                      ),

                      SizedBox(height: 10),

                      CustomInputsIcon(
                        onChanged: _changedEmail,
                        label: "Email!",
                        icon: Icons.email_outlined,
                      ),

                      SizedBox(height: 10),

                      CustomPasswordInput(
                        onChanged: _changedPassword,
                        label: "Password!",
                        icon: Icons.password_rounded,
                      ),

                      SizedBox(height: 10),

                      CustomPasswordInput(
                        onChanged: _changedConfirmPassword,
                        label: "Confirm Password!",
                        icon: Icons.password_rounded,
                      ),

                      SizedBox(height: 5),

                      LargeAppButtonPrimary(
                        onPressed: _submitRegister,
                        title: 'Create Account',
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already Have an Account?',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 14,
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
}
