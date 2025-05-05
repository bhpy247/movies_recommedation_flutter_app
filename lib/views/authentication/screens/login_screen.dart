import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/utils/my_print.dart';
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

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _error = '';
  late AuthenticationController controller;
  bool isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    isLoading = true;
    setState(() {

    });
    setState(() => _error = '');
    try {
      // Implement your Firebase login logic here
     User? user = await controller.loginWithEmail(email:_emailController.text, password:_passwordController.text);
     MyPrint.printOnConsole("user: $user");


     if((user?.email) != null){
       NavigationController.navigateToHomeScreen(
         navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
       );
     }
     isLoading = false;
     setState(() {
     });
    } catch (e) {
      setState(() => _error = e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
      isLoading = false;
      setState(() {
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AuthenticationController(authenticationProvider: context.read<AuthenticationProvider>());
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginScreen.context = context;
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'MovieCon',
                      style: TextStyle(
                        color: AuthTheme.primaryColor,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('LOGIN', style: AuthTheme.titleStyle),
                  const SizedBox(height: 5),
                  Text('Please Login to Continue', style: AuthTheme.subtitleStyle),
                  const SizedBox(height: 35),
                  Text('Email ID', style: AuthTheme.inputLabelStyle),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: AuthTheme.inputDecoration('johndoe@gmail.com'),
                    style: const TextStyle(color: AuthTheme.textColor),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 20),
                  Text('Password', style: AuthTheme.inputLabelStyle),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: AuthTheme.inputDecoration('*******'),
                    style: const TextStyle(color: AuthTheme.textColor),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password is required' : null,
                  ),
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: AuthTheme.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AuthTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Text('LOGIN', style: AuthTheme.buttonTextStyle),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: AuthTheme.textColor),
                      ),
                      TextButton(
                        onPressed: () =>
                            NavigationController.navigateToRegistrationScreen(navigationOperationParameters: NavigationOperationParameters(
                                context: context, navigationType: NavigationType.pushNamedAndRemoveUntil)),
                        child: const Text(
                          'Sign up!',
                          style: TextStyle(color: AuthTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}