import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

// ignore: must_be_immutable
class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final double? width;
  final String? labelText;
  final Color? color;
  DateTime? selectedDate;
  final bool enabled;
  CustomDatePicker(
      {Key? key,
      this.initialDate,
      required this.onDateSelected,
      this.width,
      this.labelText,
      this.color,
      required this.selectedDate,
      this.enabled = false})
      : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    super.initState();
    widget.selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      locale: Get.locale == Locale("gr") ? Locale('fr') : Get.locale,
      helpText: GbsSystemStrings.str_datePickerHelpText.tr,
      cancelText: GbsSystemStrings.str_cancel.tr,
      confirmText: GbsSystemStrings.str_done.tr,
      errorFormatText: GbsSystemStrings.str_datePickerInputHint.tr,
      errorInvalidText: GbsSystemStrings.str_datePickerInputHint.tr,
      fieldHintText: GbsSystemStrings.str_datePickerInputHint.tr,
      fieldLabelText: GbsSystemStrings.str_datePickerHelpText.tr,
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
        widget.onDateSelected(widget.selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled == true
          ? null
          : () {
              _selectDate(context);
            },
      child: Container(
        width: widget.width,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: widget.enabled ? Colors.grey.shade200 : widget.color,
            borderRadius: BorderRadius.circular(8)),
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            labelText: widget.labelText,
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.selectedDate != null
                    ? "${widget.selectedDate?.day.toString().padLeft(2, '0')}/${widget.selectedDate?.month.toString().padLeft(2, '0')}/${widget.selectedDate?.year}"

                    // '${widget.selectedDate?.year}-${widget.selectedDate?.month.toString().padLeft(2, '0')}-${widget.selectedDate?.day.toString().padLeft(2, '0')}'
                    : "",
                style: TextStyle(fontSize: 12),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDatePickerWithTime extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final double? width;
  final String? labelText;
  final Color? color;
  DateTime? selectedDate;
  final bool enabled;
  CustomDatePickerWithTime(
      {Key? key,
      this.initialDate,
      required this.onDateSelected,
      this.width,
      this.labelText,
      this.color,
      required this.selectedDate,
      this.enabled = false})
      : super(key: key);

  @override
  _CustomDatePickerWithTimeState createState() =>
      _CustomDatePickerWithTimeState();
}

class _CustomDatePickerWithTimeState extends State<CustomDatePickerWithTime> {
  @override
  void initState() {
    super.initState();
    widget.selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    print("lcoale : ${Get.locale}");
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      locale: Get.locale == Locale("gr") ? Locale('fr') : Get.locale,

      // locale: Get.locale,

      // locale: Locale("fr", "FR"),
      helpText: GbsSystemStrings.str_datePickerHelpText.tr,
      cancelText: GbsSystemStrings.str_cancel.tr,
      confirmText: GbsSystemStrings.str_done.tr,
      errorFormatText: GbsSystemStrings.str_datePickerInputHint.tr,
      errorInvalidText: GbsSystemStrings.str_datePickerInputHint.tr,
      fieldHintText: GbsSystemStrings.str_datePickerInputHint.tr,
      fieldLabelText: GbsSystemStrings.str_datePickerHelpText.tr,
    );
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.selectedDate = picked;
        widget.onDateSelected(widget.selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("lcoale : ${Get.locale}");
    return InkWell(
      onTap: widget.enabled == true
          ? null
          : () {
              _selectDate(context);
            },
      child: Container(
        width: widget.width,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: widget.enabled ? Colors.grey.shade200 : widget.color,
            borderRadius: BorderRadius.circular(8)),
        child: InputDecorator(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            labelText: widget.labelText,
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.selectedDate != null
                    ? '${widget.selectedDate?.year}-${widget.selectedDate?.month.toString().padLeft(2, '0')}-${widget.selectedDate?.day.toString().padLeft(2, '0')} ${widget.selectedDate?.hour.toString().padLeft(2, '0')}:${widget.selectedDate?.minute.toString().padLeft(2, '0')}:${widget.selectedDate?.second.toString().padLeft(2, '0')}'
                    : "",
                style: TextStyle(fontSize: 12),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
