import 'package:flutter/cupertino.dart';

class GBSystem_TextHelper {
  Widget superLargeText(
      {required String text,
      Color? textColor,
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 32,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget largeText(
      {required String text,
      Color? textColor,
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 22,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget normalText(
      {required String text,
      required Color textColor,
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 16,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget smallText(
      {required String text,
      Color? textColor,
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 12,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget superSmallText(
      {required String text,
      Color? textColor,
      FontWeight fontWeight = FontWeight.normal,
      int maxLines = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextAlign? textAlign}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 10,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
