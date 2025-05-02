import 'package:flutter/material.dart';
import '../components/auth_theme.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = "/signUpScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Implement your Firebase signup logic here
      // await AuthService.signup(
      //   _emailController.text,
      //   _passwordController.text,
      //   _usernameController.text,
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SIGNUP', style: AuthTheme.titleStyle),
                const SizedBox(height: 5),
                Text(
                  'Please sign up to create a new account',
                  style: AuthTheme.subtitleStyle,
                ),
                const SizedBox(height: 35),
                Text('Username', style: AuthTheme.inputLabelStyle),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: AuthTheme.inputDecoration('John Doe'),
                  style: const TextStyle(color: AuthTheme.textColor),
                  validator: (value) => value!.isEmpty ? 'Username is required' : null,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Text('Confirm Password', style: AuthTheme.inputLabelStyle),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: AuthTheme.inputDecoration('*******'),
                  style: const TextStyle(color: AuthTheme.textColor),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please confirm password' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Text('SIGNUP', style: AuthTheme.buttonTextStyle),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AuthTheme.textColor),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Login!',
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
    );
  }
}