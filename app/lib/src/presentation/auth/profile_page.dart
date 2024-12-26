import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/application/user_service.dart';
import 'package:daily_e/src/presentation/auth/signup_page.dart';
import 'package:daily_e/src/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:daily_e/src/presentation/auth/edit_profile.dart';
import 'package:daily_e/src/presentation/auth/edit_pw.dart';
import 'package:daily_e/src/presentation/auth/activity_page.dart';
import 'package:daily_e/src/presentation/auth/forgotpassword_page.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final Future<void> Function() onLogoutSuccess;
  ProfilePage({super.key, required this.onLogoutSuccess});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, String> user = {
    "username": "",
    "email": "",
    "fullName": ""
  };

  void handleSignOut() async {
    try {
      SecureStorage().removeToken();
      await widget.onLogoutSuccess();
    } catch (e) {
      print(e);
    }
  }

  void handleGetUserById() async {
    String userId = (await SecureStorage().getUserId())!;
    Response res = await UserService().getUserById(userId);

    final Map<String, dynamic> data = jsonDecode(res.body);
    setState(() {
      user["username"] = data["username"];
      user["email"] = data["email"];
      user["fullName"] = data["fullName"];
    });
  }

  void handleDeleteAccount() async {
    String userId = (await SecureStorage().getUserId())!;
    UserService().deleteUserById(userId);
    SnackBarUtils.showTopSnackBar(
        context: context,
        message: "Delete Account Successfully",
        backgroundColor: Colors.green);

    SecureStorage().clear();
    widget.onLogoutSuccess();
  }

  @override
  void initState() {
    super.initState();
    handleGetUserById();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              user["fullName"]!,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user["email"]!,
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Account',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.edit, color: textColor),
              title: Text(
                'Edit Profile',
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock, color: textColor),
              title: Text(
                'Update password',
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: textColor),
              title: Text(
                'Activity history',
                style: TextStyle(color: textColor),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: textColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityHistory()),
                );
              },
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: handleSignOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: null,
                    onLongPress: handleDeleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '*Long press the button to delete your account.',
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
