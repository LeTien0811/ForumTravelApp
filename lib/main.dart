import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_torum_app/core/config/theme/app_colors.dart';
import 'package:travel_torum_app/data/model/post/post_model.dart';
import 'package:travel_torum_app/features/layout/app_shell.dart';
import 'package:travel_torum_app/features/page/member/page/edit_profile_page.dart';
import 'package:travel_torum_app/features/page/member/page/profile_page.dart';
import 'package:travel_torum_app/features/page/posts/page/make_posts_page.dart';
import 'package:travel_torum_app/features/page/auth/page/login_page.dart';
import 'package:travel_torum_app/features/page/auth/page/register_page.dart';
import 'package:travel_torum_app/features/page/auth/services/auth_service.dart';
import 'package:travel_torum_app/features/page/home/page/home.dart';
import 'package:travel_torum_app/features/page/posts/page/post_detail_page.dart';
import 'package:travel_torum_app/features/page/posts/page/report_post_page.dart';
import 'package:travel_torum_app/features/page/posts/services/post_services.dart';
import 'package:travel_torum_app/features/page/splash/page/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => PostServices()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final GoRouter _router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(
            onLoginSucces: (member) {
              authService.authSuccess(member);
            },
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterPage(
            onRegisterSucces: (member) {
              authService.authSuccess(member);
            },
          ),
        ),

        ShellRoute(
          builder: (context, state, child) {
            return AppShell(
              member: authService.member!,
              logoutCallBack: authService.logout,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/ReportPostPage',
              builder: (context, state) {
                final PostModel post = state.extra as PostModel;
                return ReportPostPage(post: post);
              },
            ),

            GoRoute(
              path: '/ProfilePage',
              builder: (context, state) => const ProfilePage(),
            ),

            GoRoute(
              path: '/EditProfile',
              builder: (context, state) => const EditProfilePage(),
            ),

            GoRoute(
              path: '/postDetail',
              builder: (context, state) {
                final PostModel post = state.extra as PostModel;
                return PostDetailPage(post: post);
              },
            ),
            
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),

            GoRoute(
              path: '/makePostScreen',
              builder: (context, state) => const MakePostsPage(),
            ),
          ],
        ),
      ],

      redirect: (context, state) {
        final bool isLoading = authService.isLoading;
        final bool isLoggedIn = authService.member != null;

        if (isLoading) return '/splash';

        final bool isAtSplash = state.matchedLocation == '/splash';
        final bool isAtLogin = state.matchedLocation == '/login';
        final bool isAtRegister = state.matchedLocation == '/register';

        if (isAtSplash) {
          return isLoggedIn ? '/home' : '/login';
        }

        if ((isAtLogin || isAtRegister) && isLoggedIn) {
          return '/home';
        }

        if (!isLoggedIn && !isAtLogin && !isAtRegister) {
          return '/login';
        }

        return null;
      },
    );

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
    );
  }
}
