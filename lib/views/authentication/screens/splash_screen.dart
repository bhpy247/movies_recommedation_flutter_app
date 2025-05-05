import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:moviesapp/configs/app_colors.dart';
import 'package:moviesapp/utils/extensions.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;
  late final VideoPlayerController _videoController;
  late AuthenticationController authenticationController;
  late AuthenticationProvider authenticationProvider;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.elasticOut),
      ),
    );

    _videoController = VideoPlayerController.asset("assets/avengers.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.setVolume(0);
        _videoController.play();
        _controller.forward();
      });

    authenticationProvider = context.read<AuthenticationProvider>();
    authenticationController = AuthenticationController(
      authenticationProvider: authenticationProvider,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      NavigationController.isFirst = false;

      // await checkLogin();
    });
  }

  Future<void> checkLogin() async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("SplashScreen().checkLogin() called", tag: tag);

    NavigationController.isFirst = false;

    if (context.checkMounted() && context.mounted) {
      bool isExist = await authenticationController
          .checkUserWithIdExistOrNotAndIfNotExistThenCreate(
            userId: authenticationProvider.userId.get(),
          );

      if (isExist) {
        UserModel? userModel = authenticationProvider.userModel.get();

        if (userModel != null && userModel.name.isEmpty) {
          await NavigationController.navigateToHomeScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamedAndRemoveUntil,
            ),
          );
          return;
        }

        NavigationController.navigateToHomeScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      } else {
        await NavigationController.navigateToHomeScreen(
          navigationOperationParameters: NavigationOperationParameters(
            context: context,
            navigationType: NavigationType.pushNamedAndRemoveUntil,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final Size screenSize = MediaQuery.of(context).size;
  final double screenWidth = screenSize.width;
  final double screenHeight = screenSize.height;

  return Scaffold(
    backgroundColor: AuthTheme.primaryColor,
    body: _videoController.value.isInitialized
        ? Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
              Container(color: Colors.black.withOpacity(0.5)),

              // Logo (responsive)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.18),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Image.asset(
                            "assets/logo.png",
                            width: screenWidth * 0.6,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Get Started button (responsive)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                  child: GestureDetector(
                    onTap: () => checkLogin(),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2,
                            vertical: screenHeight * 0.02,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Styles.primaryColor.withOpacity(
                                  _opacityAnimation.value),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Styles.primaryColor.withOpacity(
                                    _opacityAnimation.value * 0.5),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Colors.transparent,
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Styles.primaryColor.withOpacity(
                                      _opacityAnimation.value * 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator()),
  );
}
}
