import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:moviesapp/utils/extensions.dart';

// import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';

import '../../../models/user_model/user_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';
import '../components/auth_theme.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;
  late AuthenticationController authenticationController;
  late AuthenticationProvider authenticationProvider;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5, curve: Curves.easeIn)));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1, curve: Curves.elasticOut)));

    authenticationProvider = context.read<AuthenticationProvider>();
    authenticationController = AuthenticationController(authenticationProvider: authenticationProvider);

    // Start animation
    _controller.forward();

    // Check login status after animations complete
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      NavigationController.isFirst = false;
      Future.delayed(const Duration(seconds: 10), () async {
        await checkLogin();
      });
    });
  }

  Future<void> checkLogin() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashScreen().checkLogin() called", tag: tag);

    NavigationController.isFirst = false;

    AuthenticationProvider authenticationProvider = context.read<AuthenticationProvider>();

    if (context.checkMounted() && context.mounted) {
      bool isExist = await authenticationController.checkUserWithIdExistOrNotAndIfNotExistThenCreate(userId: authenticationProvider.userId.get());
      MyPrint.printOnConsole("isExist:$isExist", tag: tag);
     if(isExist){

      if (context.checkMounted() && context.mounted) {
        UserModel? userModel = authenticationProvider.userModel.get();

        if (userModel != null && userModel.name.isEmpty) {
          await NavigationController.navigateToLoginScreen(
            navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
          );
          return;
        }

        NavigationController.navigateToHomeScreen(
          navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
        );
      }
     } else {
       await NavigationController.navigateToLoginScreen(
         navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
       );
     }

    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie animation (replace with your own animation or logo)
                    Lottie.asset(
                      'assets/movie_animation.json', // Add your animation file
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'MovieCon',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black.withOpacity(0.3), offset: const Offset(2, 2))],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Your Ultimate Movie Experience', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
