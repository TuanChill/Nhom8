import 'package:daily_e/src/provider/FontProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English'; // Default language
  bool _isDarkMode = true; // Default theme mode
  String _selectedBackground = 'Background 1'; // Default background

  final List<String> backgrounds = [
    'Background 1',
    'Background 2',
    'Background 3',
    'Background 4',
    'Background 5'
  ];

  final Map<String, String> backgroundImages = {
    'Background 1':
        'https://i.pinimg.com/736x/3e/e4/78/3ee478a682a5d79c0b13625d48d01e8a.jpg',
    'Background 2':
        'https://i.pinimg.com/736x/05/8e/e6/058ee63186f443b7e22f30bd2bffcff4.jpg',
    'Background 3':
        'https://i.pinimg.com/736x/db/d5/3f/dbd53f9a10b026f6b0b9a98aa45d7648.jpg',
    'Background 4':
        'https://i.pinimg.com/736x/6f/4d/c8/6f4dc834172150390ff415466596e908.jpg',
    'Background 5':
        'https://i.pinimg.com/736x/0d/77/db/0d77db3a3b2bcfa025d66dfc34220e53.jpg',
  };

  final List<String> fonts = ['Roboto', 'Arial', 'Times New Roman'];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              backgroundImages[_selectedBackground]!,
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            children: [
              Divider(),
              ListTile(
                title: Text(
                  'Font Family',
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                subtitle: Text(
                  fontProvider.fontFamily,
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: fontProvider.fontFamily,
                  items: fonts
                      .map((font) => DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          ))
                      .toList(),
                  onChanged: (value) {
                    fontProvider.updateFontFamily(value!);
                  },
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Font Size',
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                subtitle: Slider(
                  value: fontProvider.fontSize,
                  min: 10.0,
                  max: 30.0,
                  divisions: 4,
                  label: fontProvider.fontSize.round().toString(),
                  onChanged: (value) {
                    fontProvider.updateFontSize(value);
                  },
                ),
              ),
              Divider(),
              SwitchListTile(
                title: Text(
                  'Change Theme',
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                subtitle: Text(
                  _isDarkMode ? 'Dark' : 'Light',
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Background',
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
                ),
                subtitle: Text(
                  _selectedBackground,
                  style: TextStyle(
                    fontFamily: fontProvider.fontFamily,
                    fontSize: fontProvider.fontSize,
                  ),
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
