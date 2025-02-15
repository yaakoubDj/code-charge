import 'package:flutter/material.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.onTap,
      required this.text,
      this.color,
      this.textColor,
      this.horPadding,
      this.verPadding,
      this.shadowColor,
      this.width,
      this.textSize,
      this.textBold = false});
  final void Function()? onTap;
  final String text;
  final Color? color, textColor, shadowColor;
  final double? horPadding, verPadding, width, textSize;
  final bool textBold;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? GbsSystemStrings.str_primary_color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verPadding ?? size.height * 0.025,
              horizontal: horPadding ?? size.width * 0.2),
          child: Text(
            text,
            style: TextStyle(
                fontSize: textSize ?? 18,
                letterSpacing: 2,
                color: textColor ?? Colors.white,
                fontWeight: textBold ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithTrailling extends StatelessWidget {
  const CustomButtonWithTrailling(
      {super.key,
      this.onTap,
      required this.text,
      this.color,
      this.textColor,
      this.horPadding,
      this.verPadding,
      this.shadowColor,
      this.width,
      this.textSize,
      this.textBold = false,
      required this.trailling});
  final void Function()? onTap;
  final String text;
  final Color? color, textColor, shadowColor;
  final double? horPadding, verPadding, width, textSize;
  final bool textBold;
  final Widget trailling;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color ?? GbsSystemStrings.str_primary_color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verPadding ?? size.height * 0.025,
              horizontal: horPadding ?? size.width * 0.2),
          child: Row(
            children: [
              trailling,
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: textSize ?? 18,
                      letterSpacing: 2,
                      color: textColor ?? Colors.white,
                      fontWeight:
                          textBold ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
