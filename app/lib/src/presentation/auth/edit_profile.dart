import 'dart:convert';

import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/application/user_service.dart';
import 'package:daily_e/src/utils/snackBarUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _gender = 'Male'; // Default gender

  @override
  void initState() {
    super.initState();
    handleGetUserById();
  }

  void handleGetUserById() async {
    String userId = (await SecureStorage().getUserId())!;
    Response res = await UserService().getUserById(userId);

    final Map<String, dynamic> data = jsonDecode(res.body);
    setState(() {
      _nameController.text = data["fullName"];
      _emailController.text = data["email"];
      _ageController.text = data["age"] != null ? data["age"].toString() : "";
      _gender = data["gender"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Enter your age',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              items: ['Male', 'Female', "Other"]
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Logic to save the profile changes.
                  Response res = await UserService().updateUser(
                    _emailController.text,
                    _ageController.text,
                    _gender,
                    _nameController.text,
                  );

                  if (res.statusCode == 200) {
                    SnackBarUtils.showTopSnackBar(
                        context: context,
                        message: "Update user successfully",
                        backgroundColor: Colors.green);
                    Navigator.pop(context);
                  } else {
                    SnackBarUtils.showTopSnackBar(
                        context: context,
                        message: "Update user failed",
                        backgroundColor: Colors.red);
                  }
                },
                // icon: const Icon(Icons.save, size: 30), // Larger icon
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white), // Change the text color here
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor:
                      Colors.white, // Optional: ensures text color is white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
