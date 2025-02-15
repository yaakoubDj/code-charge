import 'package:flutter/material.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';

class ButtonSelectCard extends StatelessWidget {
  const ButtonSelectCard({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.text,
    this.width,
  });

  final bool isSelected;
  final String text;
  final double? width;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        width: width ?? 100,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelected ? Colors.black54 : Colors.grey.shade200,
        ),
        child: Center(
          child: GBSystem_TextHelper().smallText(
              textColor: isSelected ? Colors.white : Colors.black, text: text),
        ),
      ),
    );
  }
}
