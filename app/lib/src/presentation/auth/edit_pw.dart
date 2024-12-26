import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                hintText: 'Re-enter your new password',
              ),
            ),
            const SizedBox(height: 30),
           Center(child: ElevatedButton(
             onPressed: () {
               // Logic to update the password
               String currentPassword = _currentPasswordController.text;
               String newPassword = _newPasswordController.text;
               String confirmPassword = _confirmPasswordController.text;

               if (newPassword == confirmPassword) {
                 // Simulate password update
                 print('Password updated to: $newPassword');
                 Navigator.pop(context); // Go back to the profile page
               } else {
                 // Show error if passwords don't match
                 showDialog(
                   context: context,
                   builder: (_) => AlertDialog(
                     title: const Text('Error'),
                     content: const Text('Passwords do not match.'),
                     actions: [
                       TextButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text('OK'),
                       ),
                     ],
                   ),
                 );
               }
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.teal[700],
               padding: const EdgeInsets.symmetric(vertical: 15),
             ),
             child: const Text('Save Changes',style: TextStyle(fontSize: 15, color: Colors.white)),

           ),)
          ],
        ),
      ),
    );
  }
}
