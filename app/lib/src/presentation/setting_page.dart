// settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English'; // Default language
  String _selectedFont = 'Roboto'; // Default font
  bool _isDarkMode = true; // Default theme mode
  String _selectedBackground = 'Background 1'; // Default background
  double _fontSize = 16.0; // Default font size

  final List<String> backgrounds = [
    'Background 1',
    'Background 2',
    'Background 3',
    'Background 4',
    'Background 5'
  ]; // Background options

  final Map<String, String> backgroundImages = {
    'Background 1': 'https://i.pinimg.com/736x/3e/e4/78/3ee478a682a5d79c0b13625d48d01e8a.jpg',
    'Background 2': 'https://i.pinimg.com/736x/05/8e/e6/058ee63186f443b7e22f30bd2bffcff4.jpg',
    'Background 3': 'https://i.pinimg.com/736x/db/d5/3f/dbd53f9a10b026f6b0b9a98aa45d7648.jpg',
    'Background 4': 'https://i.pinimg.com/736x/6f/4d/c8/6f4dc834172150390ff415466596e908.jpg',
    'Background 5': 'https://i.pinimg.com/736x/0d/77/db/0d77db3a3b2bcfa025d66dfc34220e53.jpg',
  }; // Map of background options to image URLs

  // Define the font families here
  final Map<String, TextStyle> fontStyles = {
    'Roboto': TextStyle(fontFamily: 'Roboto'),
    'Arial': TextStyle(fontFamily: 'Arial'),
    'Times New Roman': TextStyle(fontFamily: 'Times New Roman'),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          // Background image as the base layer
          Positioned.fill(
            child: Image.network(
              backgroundImages[_selectedBackground]! ?? '',
              fit: BoxFit.cover,
            ),
          ),
          // Content of the screen on top of the background
          ListView(
            children: [
              // Language setting
              ListTile(
                title: Text(
                  'Language',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                subtitle: Text(
                  _selectedLanguage,
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: ['English', 'Tiếng Việt']
                      .map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
              ),
              Divider(),

              // Font setting
              ListTile(
                title: Text(
                  'Font',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                subtitle: Text(
                  _selectedFont,
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                trailing: DropdownButton<String>(
                  value: _selectedFont,
                  items: ['Roboto', 'Arial', 'Times New Roman']
                      .map((font) => DropdownMenuItem(
                    value: font,
                    child: Text(font),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFont = value!;
                    });
                  },
                ),
              ),
              Divider(),

              // Font size setting (moved here, below Font and above Change Theme)
              ListTile(
                title: Text(
                  'Font Size',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                subtitle: Slider(
                  value: _fontSize,
                  min: 10.0,
                  max: 30.0,
                  divisions: 4,
                  label: _fontSize.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                  },
                ),
              ),
              Divider(),

              // Dark/Light mode toggle
              SwitchListTile(
                title: Text(
                  'Change Theme',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                subtitle: Text(
                  _isDarkMode ? 'Dark' : 'Light',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
              Divider(),

              // Background selection
              ListTile(
                title: Text(
                  'Background',
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                subtitle: Text(
                  _selectedBackground,
                  style: fontStyles[_selectedFont]?.copyWith(fontSize: _fontSize),
                ),
                trailing: DropdownButton<String>(
                  value: _selectedBackground,
                  items: backgrounds
                      .map((bg) => DropdownMenuItem(
                    value: bg,
                    child: Text(bg),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBackground = value!;
                    });
                  },
                ),
              ),
              Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
