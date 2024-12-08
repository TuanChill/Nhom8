import 'package:daily_e/src/application/storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Future<void> Function() onLogoutSuccess;
  ProfilePage({super.key, required this.onLogoutSuccess});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void handleSignOut() async {
    // call sign out service
    try {
      // remove token from storage
      SecureStorage().removeToken();
      await widget.onLogoutSuccess();
    } catch (e) {
      // show error message
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: handleSignOut,
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
