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
      // remove token from storage
      SecureStorage().removeToken();
      await widget.onLogoutSuccess();
    } catch (e) {
      // show error message
      print(e);
    }
  }

  void handleGetUserById() async {
    // Get user by id logic
    String user_id = (await SecureStorage().getUserId())!;
    Response res = await UserService().getUserById(user_id);

    final Map<String, dynamic> data = jsonDecode(res.body);
    setState(() {
      user["username"] = data["username"];
      user["email"] = data["email"];
      user["fullName"] = data["fullName"];
    });
  }

  void handleDeleteAccount() async {
    // Delete account logic
    String user_id = (await SecureStorage().getUserId())!;
    UserService().deleteUserById(user_id);
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
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user["email"]!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Điều hướng đến trang chỉnh sửa profile
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Update password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Điều hướng đến trang chỉnh sửa profile
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Activity history'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Điều hướng đến trang chỉnh sửa profile
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
            const Text(
              '*Long press the button to delete your account.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
