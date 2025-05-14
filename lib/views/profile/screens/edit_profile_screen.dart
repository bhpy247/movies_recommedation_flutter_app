import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../backend/authentication/authentication_provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "/editProfileScreen";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _displayNameController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<AuthenticationProvider>(context, listen: false).userModel.get();
    _displayNameController = TextEditingController(text: userModel?.displayName ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final userModel = authProvider.userModel.get();

    if (userModel == null) {
      _showAlert("Error", "User not found.");
      return;
    }

    final displayName = _displayNameController.text.trim();
    if (displayName.isEmpty) {
      _showAlert("Error", "Display Name is required.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      await firestore.collection('user').doc(userModel.uid).update({
        'displayName': displayName,
        'email': userModel.email,
        'photoUrl': userModel.photoUrl,
      });

      await auth.currentUser?.updateDisplayName(displayName);

      final updatedUser = userModel.copyWith(displayName: displayName);
      authProvider.updateCurrentUser(updatedUser);

      _showAlert("Success", "Profile updated successfully!");
      Navigator.of(context).pop();
    } catch (e) {
      _showAlert("Error", "Failed to update profile: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.purpleAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<AuthenticationProvider>(context).userModel.get();

    if (userModel == null) {
      return const Scaffold(
        body: Center(
          child: Text("User data not available", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          actions: [
            // IconButton(onPressed: () async {
            //   await AuthenticationController(authenticationProvider: context.read()).logout(isShowConfirmationDialog: true,isNavigateToLogin: true);
            // }, icon: Icon(Icons.logout))
          ],
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _displayNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Display Name",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF202020),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Username: ${userModel.displayName  } (Read-only)",
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFd24dff),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLoading ? null : _handleSave,
                child: Text(
                  isLoading ? "Saving..." : "Save Changes",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
