import 'package:daily_e/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryTextFormField extends StatelessWidget {
  PrimaryTextFormField({
    super.key,
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
  });

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
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? textError : null,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColor.kGrayscaleDark100,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        filled: true,
        fillColor: AppColor.kBackground,
        hintText: hintText,
        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: hintTextColor ?? AppColor.kGrayscaleDark100,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.kLine, width: 1),
          borderRadius:
              borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.kLine, width: 1),
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
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.controller,
      validator: (value) => value!.isEmpty ? 'Please fill this field' : null,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColor.kGrayscaleDark100,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        filled: true,
        fillColor: AppColor.kBackground2,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColor.kGrayscaleDark100,
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
          color: AppColor.kGrayscale40,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.kLine, width: 1),
          borderRadius:
              widget.borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.kLine, width: 1),
          borderRadius:
              widget.borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius:
              widget.borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
          borderRadius:
              widget.borderRadius as BorderRadius? ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
