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

class LoginPage extends StatefulWidget {
  final void Function(MemberModel) onLoginSucces;
  const LoginPage({super.key, required this.onLoginSucces});

  @override
  State<StatefulWidget> createState() => _Login_Page();
}

class _Login_Page extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  void _changedEmail(String value) {
    _email = value;
  }

  void _changedPassword(String value) {
    _password = value;
  }

  bool _isEmailValid(String email) {
    return isEmail(email);
  }

  Future<void> _submitLogin() async {
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
      widget.onLoginSucces(Loggedin);
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
            : Padding(
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

                    SizedBox(height: 7),

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

                    SizedBox(height: 7),

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

                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Pasword!",
                          style: TextStyle(color: AppColors.blue),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    LargeAppButtonPrimary(
                      onPressed: _submitLogin,
                      title: 'Press to Login',
                    ),

                    SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade400,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade400,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50.0,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        label: Text(
                          "Login with Google",
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset(
                          AppImages.basePath + 'googleIcon.png',
                          width: 20.5,
                          height: 20.5,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don`t Have an Account?',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/register');
                          },
                          child: Text(
                            'Sign Up',
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
    );
  }
}
