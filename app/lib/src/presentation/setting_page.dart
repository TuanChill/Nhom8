import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('3. My flower garden', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Audio Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pause, color: Colors.blue, size: 40),
                SizedBox(width: 10),
                Text('1x', style: TextStyle(color: Colors.white, fontSize: 20)),
                Spacer(),
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                Text('1 / 19', style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
              ],
            ),
          ),
          // Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type what you hear...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.grey, size: 20),
                    SizedBox(width: 5),
                    Text('Hint: Anne', style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          Spacer(),
          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text('Skip', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text('Listen again', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text('Check', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
