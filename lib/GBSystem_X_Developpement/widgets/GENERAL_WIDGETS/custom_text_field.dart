import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      this.keyboardType,
      this.obscureText = false,
      required this.text,
      this.suffixIcon,
      this.width,
      this.validator,
      this.prefixIcon,
      this.onSaved,
      this.onChanged,
      this.onTap,
      this.enabled = true,
      this.focusNode,
      this.textStyle,
      this.height,
      this.contentPadding});

  final String text;
  final bool enabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon, prefixIcon;
  final double? width;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: height,
      width: width ?? size.width,
      child: TextFormField(
        enabled: enabled,
        onTap: onTap,
        validator: validator,
        onChanged: onChanged,
        onSaved: onSaved,
        focusNode: focusNode,
        style: textStyle,
        decoration: InputDecoration(
            contentPadding: contentPadding,
            labelText: text,
            labelStyle: textStyle,
            hintStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1)),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}
