import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/constant/color_constant.dart';
import 'package:todo/constant/format_constant.dart';
import 'package:todo/constant/text_constant.dart';

class TimeTextField extends StatefulWidget {
  final String title;
  final String defaultDate;
  final Function(DateTime) onDateSelected;

  const TimeTextField(this.title, {this.defaultDate, this.onDateSelected});

  @override
  _TimeTextFieldState createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, color: ColorConstant.textDarkGrey),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: DatePickerTextField(
              onDateSelected: widget.onDateSelected,
              defaultDate: widget.defaultDate,
            ),
          ),
        ],
      ),
    );
  }
}

class DatePickerTextField extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final String defaultDate;

  DatePickerTextField({
    this.onDateSelected,
    this.defaultDate,
  });

  @override
  DatePickerTextFieldState createState() => DatePickerTextFieldState();
}

class DatePickerTextFieldState extends State<DatePickerTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {

    super.initState();
    _controller.text = widget.defaultDate;
  }

  @override
  Widget build(BuildContext context) {
    InputBorder getBorder(Color borderColor) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      );
    }

    return Container(
      child: TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          filled: true,
          hintText: TextConstant.dateTextFieldPlaceholder,
          border: getBorder(ColorConstant.textFieldGrey),
          focusedBorder: getBorder(Colors.black),
          disabledBorder: getBorder(ColorConstant.textFieldGrey),
          enabledBorder: getBorder(ColorConstant.textFieldGrey),
        ),
        controller: _controller,
        onTap: () {
          _showDatePicker();
        },
        showCursor: false,
        enableInteractiveSelection: false,
        focusNode: AlwaysDisabledFocusNode(),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime date = DateTime.now();
    DateTime initialDate = widget.defaultDate != null && widget.defaultDate.isNotEmpty
        ? DateFormat(FormatConstant.timeConstant).parse(widget.defaultDate)
        : DateTime.now();

    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(date.year - 1, date.month, date.day),
      lastDate: DateTime(date.year + 10, date.month, date.day),
    );

    _selectDate(selectedDate);
    FocusScope.of(context).unfocus();
  }

  void _selectDate(DateTime date) {
    if (date != null) {
      final String dateText =
          DateFormat(FormatConstant.displayTime).format(date);
      if (widget.onDateSelected != null) {
        widget.onDateSelected(date);
      }
      setState(() {
        _controller.text = dateText;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;

  @override
  bool get hasPrimaryFocus => false;
}
