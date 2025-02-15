import 'package:flutter/material.dart';

class TextFieldAnimated extends StatefulWidget {
  const TextFieldAnimated(
      {super.key,
      required this.hint,
      this.controller,
      this.keyboardType,
      this.obscureText = false,
      this.suffixIcon,
      this.width,
      this.validator,
      this.prefixIcon,
      this.onSaved,
      this.onChanged});

  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon, prefixIcon;
  final double? width;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;

  @override
  State<TextFieldAnimated> createState() => _TextFieldAnimatedState();
}

class _TextFieldAnimatedState extends State<TextFieldAnimated> {
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: isFocused ? size.height * 0.1 : size.height * 0.06,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      child: Transform.translate(
        offset: Offset(size.width * 0.01,- size.height * 0.01),
        child: Focus(
          onFocusChange: (value) {
            setState(() {
              isFocused ? isFocused = false : isFocused = true;
            });
          },
          child: TextFormField(
            // onFieldSubmitted: (value) {
            //   widget.onSaved!(value);
            // },
            validator: widget.validator,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            // maxLines: 10,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02),
                hintText: widget.hint,
                
                hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
                border: InputBorder.none,
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: const BorderSide(color: Colors.grey, width: 1)),
                // disabledBorder: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10),
                //     borderSide: const BorderSide(color: Colors.red, width: 1)),
                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon),
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
          ),
        ),
      ),
    );
  }
}
