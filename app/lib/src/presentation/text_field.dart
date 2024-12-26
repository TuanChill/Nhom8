import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Constrained TextFormField Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Primary TextFormField:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: PrimaryTextFormField(
                      hintText: 'Enter your text',
                      controller: TextEditingController(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Password TextField:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              PasswordTextField(
                hintText: 'Enter your password',
                height: 50,
                width: double.infinity,
                controller: TextEditingController(),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryTextFormField extends StatelessWidget {
  PrimaryTextFormField({
    Key? key,
    required this.hintText,
    this.keyboardType,
    required this.controller,
    this.hintTextColor,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.inputFormatters,
    this.maxLines,
    this.borderRadius,
    this.textError = 'Please fill this field',
  }) : super(key: key);

  final BorderRadiusGeometry? borderRadius;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final Color? hintTextColor, prefixIconColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? textError;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? textError : null,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: hintTextColor ?? Colors.grey[600],
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final double width, height;
  final TextEditingController controller;
  final BorderRadiusGeometry borderRadius;

  const PasswordTextField({
    Key? key,
    required this.hintText,
    required this.height,
    required this.controller,
    required this.width,
    required this.borderRadius,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        validator: (value) => value!.isEmpty ? 'Please fill this field' : null,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600],
              size: 18,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: widget.borderRadius as BorderRadius? ??
                BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: widget.borderRadius as BorderRadius? ??
                BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: widget.borderRadius as BorderRadius? ??
                BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: widget.borderRadius as BorderRadius? ??
                BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
