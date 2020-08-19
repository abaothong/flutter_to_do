import 'package:flutter/material.dart';
import 'package:todo/constant/color_constant.dart';
import 'package:todo/constant/text_constant.dart';

class TitleTextField extends StatefulWidget {
  final String title;
  final String defaultText;
  final Function(String) onTextChange;

  const TitleTextField(this.title, {this.defaultText, this.onTextChange});

  @override
  _TitleTextFieldState createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.defaultText;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 18, color: ColorConstant.textDarkGrey),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                hintText: TextConstant.todoTextFieldPlaceholder,
                border: getBorder(ColorConstant.textFieldGrey),
                focusedBorder: getBorder(Colors.black),
                disabledBorder: getBorder(ColorConstant.textFieldGrey),
                enabledBorder: getBorder(ColorConstant.textFieldGrey),
              ),
              controller: _controller,
              onChanged: (text) {
                if (widget.onTextChange != null) {
                  widget.onTextChange(text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
