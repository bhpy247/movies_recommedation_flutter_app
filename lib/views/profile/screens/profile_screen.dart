import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String getInitials(String fullName) {
    if (fullName.trim().isEmpty) return "";

    List<String> names = fullName.trim().split(" ");
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return (names[0][0] + names[1][0]).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFD24DFF);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<AuthenticationProvider>(
          builder: (context,AuthenticationProvider authenticationProvider,child) {
            final userModel = authenticationProvider.userModel.get();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor,width: .1),
                        shape: BoxShape.circle
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: primaryColor.withOpacity(0.15),
                        child: Text(
                          "${getInitials(userModel?.displayName ?? "")}", // Replace with user name[0]
                          style: TextStyle(
                            fontSize: 52,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(height: 12),
                     Text(
                      userModel?.displayName ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${userModel?.email}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "@${userModel?.displayName}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildOption(context, Icons.edit, "Edit Profile", primaryColor),
                    // _buildOption(context, Icons.person_add_alt_1, "Find Friends", primaryColor),
                    _buildOption(context, Icons.privacy_tip_outlined, "Privacy & Security", primaryColor),
                    // _buildOption(context, Icons.notifications_none, "Notification Settings", primaryColor),
                    _buildOption(context, Icons.help_outline, "Help & Support", primaryColor),
                    GestureDetector(
                      onTap: () {
                        // Handle logout logic
                      },
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Colors.redAccent.shade200,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.06),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}