import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

class ButtonEntrerSortieWithIcon extends StatelessWidget {
  const ButtonEntrerSortieWithIcon(
      {super.key,
      this.verPadd = 0,
      this.horPadd = 0,
      required this.icon,
      this.onTap,
      required this.color});

  final double verPadd, horPadd;
  final Widget icon;
  final Color color;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horPadd, vertical: verPadd),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon,
      ),
    );
  }
}

class ButtonEntrerSortieWithIconAndText extends StatelessWidget {
  const ButtonEntrerSortieWithIconAndText(
      {super.key,
      this.verPadd = 0,
      this.horPadd = 0,
      required this.icon,
      this.onTap,
      required this.text,
      required this.color,
      required this.number,
      this.width,
      this.shadowBool = false,
      this.disabled = false});

  final double verPadd, horPadd;
  final Widget icon;
  final int? number;
  final double? width;
  final String text;
  final void Function()? onTap;
  final Color color;
  final bool shadowBool, disabled;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: disabled ? null : onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: horPadd, vertical: verPadd),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade400 : color,
          boxShadow: shadowBool
              ? [
                  BoxShadow(
                    color: GbsSystemStrings.str_primary_color.withOpacity(0.3),
                    spreadRadius: -10,
                    blurRadius: 22,
                    offset: const Offset(5, 5), // changes the shadow position
                  ),
                  BoxShadow(
                    color: GbsSystemStrings.str_primary_color.withOpacity(0.3),
                    spreadRadius: -10,
                    blurRadius: 22,
                    offset: const Offset(-5, -5), // changes the shadow position
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                number != null ? text + " ($number) " : text,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
