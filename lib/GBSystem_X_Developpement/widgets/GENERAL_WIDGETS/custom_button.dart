import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

class CustomButton extends StatefulWidget {
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
      this.textBold = false,
      this.numberImage,
      this.showNumber = false,
      this.height,
      this.enabled = false});
  final void Function()? onTap;
  final String text;
  final Color? color, textColor, shadowColor;
  final double? horPadding, verPadding, width, textSize, height;
  final bool textBold;
  final int? numberImage;
  final bool showNumber;
  final bool enabled;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool showAnimation = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onTap,
      // () async {
      //   setState(() {
      //     showAnimation = true;
      //   });
      //   Future.delayed(
      //     Duration(milliseconds: 300),
      //     () {
      //       setState(() {
      //         showAnimation = false;
      //       });
      //     },
      //   );

      //   widget.enabled == false
      //       ? widget.onTap != null
      //           ? widget.onTap!()
      //           : null
      //       : null;
      // },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: showAnimation
            ? EdgeInsets.symmetric(horizontal: 2, vertical: 2)
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: showAnimation
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ]
              : null,
          color: widget.enabled
              ? Colors.grey.shade300
              : (widget.color ?? GbsSystemStrings.str_primary_color),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.verPadding ?? size.height * 0.025,
              horizontal: widget.horPadding ?? size.width * 0.2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    fontSize: widget.textSize ?? 18,
                    letterSpacing: 2,
                    overflow: TextOverflow.ellipsis,
                    color: widget.enabled
                        ? Colors.black
                        : (widget.textColor ?? Colors.white),
                    fontWeight:
                        widget.textBold ? FontWeight.bold : FontWeight.normal),
              ),
              widget.showNumber
                  ? Text(
                      widget.numberImage != null
                          ? "(${widget.numberImage})"
                          : '(0)',
                      style: TextStyle(
                          fontSize: widget.textSize ?? 18,
                          letterSpacing: 2,
                          color: widget.textColor ?? Colors.white,
                          fontWeight: widget.textBold
                              ? FontWeight.bold
                              : FontWeight.normal),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithTrailling extends StatefulWidget {
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
      required this.trailling,
      this.letterSpacing,
      this.isMinSize = false});
  final void Function()? onTap;
  final String text;
  final Color? color, textColor, shadowColor;
  final double? horPadding, verPadding, width, textSize, letterSpacing;
  final bool textBold, isMinSize;
  final Widget trailling;

  @override
  State<CustomButtonWithTrailling> createState() =>
      _CustomButtonWithTraillingState();
}

class _CustomButtonWithTraillingState extends State<CustomButtonWithTrailling> {
  bool showAnimation = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onTap,

      // () {
      //   setState(() {
      //     showAnimation = true;
      //   });
      //   Future.delayed(
      //     Duration(milliseconds: 300),
      //     () {
      //       setState(() {
      //         showAnimation = false;
      //       });
      //     },
      //   );
      //   widget.onTap != null ? widget.onTap!() : null;
      // },
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.color ?? GbsSystemStrings.str_primary_color,
          boxShadow: showAnimation
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.verPadding ?? size.height * 0.025,
              horizontal: widget.horPadding ?? size.width * 0.2),
          child: Row(
            mainAxisSize:
                widget.isMinSize ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.trailling,
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: widget.textSize ?? 18,
                      letterSpacing: widget.letterSpacing ?? 2,
                      color: widget.textColor ?? Colors.white,
                      fontWeight: widget.textBold
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithLeading extends StatefulWidget {
  const CustomButtonWithLeading(
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
  State<CustomButtonWithLeading> createState() =>
      _CustomButtonWithLeadingState();
}

class _CustomButtonWithLeadingState extends State<CustomButtonWithLeading> {
  bool showAnimation = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onTap,
      // () {
      //   setState(() {
      //     showAnimation = true;
      //   });
      //   Future.delayed(
      //     Duration(milliseconds: 300),
      //     () {
      //       setState(() {
      //         showAnimation = false;
      //       });
      //     },
      //   );
      //   widget.onTap != null ? widget.onTap!() : null;
      // },
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          boxShadow: showAnimation
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ]
              : null,
          borderRadius: BorderRadius.circular(6),
          color: widget.color ?? GbsSystemStrings.str_primary_color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.verPadding ?? size.height * 0.025,
              horizontal: widget.horPadding ?? size.width * 0.2),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: widget.textSize ?? 18,
                      letterSpacing: 2,
                      color: widget.textColor ?? Colors.white,
                      fontWeight: widget.textBold
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
              widget.trailling,
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    super.key,
    this.onTap,
    required this.icon,
    this.color,
    this.horPadding,
    this.verPadding,
    this.shadowColor,
    this.width,
    this.height,
    this.raduis,
  });
  final void Function()? onTap;
  final Icon icon;
  final double? raduis;
  final Color? color, shadowColor;
  final double? horPadding, verPadding, width, height;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool showAnimation = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: widget.onTap,
      // () {
      //   setState(() {
      //     showAnimation = true;
      //   });
      //   Future.delayed(
      //     Duration(milliseconds: 300),
      //     () {
      //       setState(() {
      //         showAnimation = false;
      //       });
      //     },
      //   );
      //   widget.onTap != null ? widget.onTap!() : null;
      // },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          boxShadow: showAnimation
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ]
              : null,
          borderRadius: BorderRadius.circular(widget.raduis ?? 6),
          color: widget.color ?? GbsSystemStrings.str_primary_color,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.verPadding ?? size.width * 0.02,
              horizontal: widget.horPadding ?? size.width * 0.02),
          child: Center(
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
