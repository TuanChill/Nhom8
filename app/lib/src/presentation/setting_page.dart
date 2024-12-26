import 'package:daily_e/src/provider/FontProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_e/src/presentation/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English'; // Default language
  bool _isDarkMode = true; // Default theme mode

  final List<String> fonts = ['Roboto', 'Arial', 'Times New Roman'];

  @override
  Widget build(BuildContext context) {
    final fontProvider = Provider.of<FontProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
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
            trailing: PopupMenuButton<String>(
              initialValue: fontProvider.fontFamily,
              onSelected: (value) {
                fontProvider.updateFontFamily(value); // Update font on selection
              },
              itemBuilder: (context) {
                return fonts
                    .map((font) => PopupMenuItem<String>(
                  value: font,
                  child: Text(font),
                ))
                    .toList();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fontProvider.fontFamily,
                    style: TextStyle(
                      fontFamily: fontProvider.fontFamily,
                      fontSize: fontProvider.fontSize,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
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
              themeProvider.themeMode == ThemeMode.dark
                  ? 'Dark Mode'
                  : 'Light Mode',
            ),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
