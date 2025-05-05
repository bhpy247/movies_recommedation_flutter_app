import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:provider/provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';
import '../components/auth_theme.dart';

class LoginScreen extends StatefulWidget {
  static BuildContext? context;
  static const String routeName = "/loginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  late AuthenticationController controller;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _error = '');
    try {
      // Implement your Firebase login logic here
     User? user = await controller.loginWithEmail(email:_emailController.text, password:_passwordController.text);
     if(user != null){
       NavigationController.navigateToHomeScreen(
         navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
       );
     }
    } catch (e) {
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

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

    _controller.forward();

    controller = AuthenticationController(
      authenticationProvider: context.read<AuthenticationProvider>(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  LoginScreen.context = context;
  final Size size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: Colors.black,
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: size.width * 0.88,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo with animation
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, __) {
                          return Opacity(
                            opacity: _opacityAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Image.asset(
                                "assets/logo.png",
                                width: size.width * 0.28,
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Login to MovieCon',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please enter your credentials',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email', style: AuthTheme.inputLabelStyle),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        decoration: AuthTheme.inputDecoration('johndoe@gmail.com'),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.isEmpty ? 'Email is required' : null,
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password', style: AuthTheme.inputLabelStyle),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        decoration: AuthTheme.inputDecoration('********'),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? 'Password is required' : null,
                      ),

                      if (_error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AuthTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 8,
                            shadowColor: AuthTheme.primaryColor.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Login', style: AuthTheme.buttonTextStyle),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup'),
                            child: const Text(
                              'Sign up!',
                              style: TextStyle(
                                color: AuthTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
}