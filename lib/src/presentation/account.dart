import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/presentation/auth/profile_page.dart';
import 'package:daily_e/src/presentation/auth/signin_page.dart';
import 'package:daily_e/src/presentation/auth/signup_page.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<bool> _hasTokenFuture;

  @override
  void initState() {
    super.initState();
    _refreshTokenCheck();
  }

  Future<void> _refreshTokenCheck() async {
    setState(() {
      _hasTokenFuture = _checkToken();
    });
  }

  Future<bool> _checkToken() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasTokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        } else if (snapshot.hasData && snapshot.data!) {
          return const ProfilePage();
        } else {
          return SignInScreen(onLoginSuccess: _refreshTokenCheck);
        }
      },
    );
  }
}
