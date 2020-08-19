import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/constant/color_constant.dart';
import 'package:todo/constant/format_constant.dart';
import 'package:todo/constant/text_constant.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widget/ratio_button.dart';

class TodoCard extends StatefulWidget {
  final Todo todoItem;
  final VoidCallback onCompleteButtonPressed;
  final VoidCallback onEditPressed;
  const TodoCard(this.todoItem,
      {this.onCompleteButtonPressed, this.onEditPressed});

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Timer timer;
  String timeLeftString;

  @override
  void initState() {
    super.initState();
    _getTimeLeft();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _getTimeLeft());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timeView() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TodoListCardTimeWidget(
              TextConstant.startDate,
              _displayTimeFormat(
                widget.todoItem.startDate,
              ),
            ),
          ),
          Expanded(
            child: TodoListCardTimeWidget(
              TextConstant.endDate,
              _displayTimeFormat(
                widget.todoItem.endDate,
              ),
            ),
          ),
          Expanded(
            child: TodoListCardTimeWidget(
              TextConstant.todoListingPageTimeLeft,
              timeLeftString,
            ),
          ),
        ],
      );
    }

    _statusView() {
      String status = widget.todoItem.isFinish
          ? TextConstant.todoListingPageComplete
          : TextConstant.todoListingPageIncomplete;
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        color: ColorConstant.todoCardStatusBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              TextConstant.todoListingPageStatus,
              style: TextStyle(
                color: ColorConstant.textLightGrey,
              ),
            ),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.todoItem.isFinish
                      ? ColorConstant.todoCardCompleteGreen
                      : Colors.black,
                ),
              ),
            ),
            InkWell(
              onTap: () => widget.onCompleteButtonPressed(),
              child: Text(TextConstant.todoListingPageCompleteTickText),
            ),
            InkWell(
              onTap: () => widget.onCompleteButtonPressed(),
              child: SizedBox(width: 5),
            ),
            InkWell(
              onTap: () => widget.onCompleteButtonPressed(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: CustomPaint(
                  painter: RadioIcon(
                    widget.todoItem.isFinish,
                    outlineColor: ColorConstant.theme,
                  ),
                  willChange: true,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 100,
        maxHeight: 180.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstant.shadow, width: 2.0),
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: ColorConstant.shadow,
              blurRadius: 3.0,
              offset: new Offset(0.0, 3.0),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => widget.onEditPressed(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.todoItem.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.all(8),
                        child: Container(child: _timeView()),
                      ),
                    ],
                  ),
                ),
              ),
              _statusView(),
            ],
          ),
        ),
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} hrs ${parts[1].padLeft(2, '0')} min';
  }

  _getTimeLeft() {
    DateFormat dateFormat = DateFormat(FormatConstant.timeConstant);
    DateTime startTime = dateFormat.parse(widget.todoItem.startDate);
    DateTime endTime = dateFormat.parse(widget.todoItem.endDate);
    DateTime currentTime = DateTime.now();

    final endTimeDiff = currentTime.difference(endTime).inMinutes;
    final startTimeDiff = startTime.difference(currentTime).inMinutes;

    setState(() {
      if (endTimeDiff > 0) {
        //expire
        timeLeftString = "--";
      } else if (startTimeDiff > 0) {
        //haven't start, using end time - start time
        final timeLeft = endTime.difference(startTime).inMinutes;
        timeLeftString = durationToString(timeLeft);
      } else {
        // using end time - current time
        final timeLeft = endTime.difference(currentTime).inMinutes;
        timeLeftString = durationToString(timeLeft);
      }
    });
  }

  _displayTimeFormat(String rawTimeString) {
    DateFormat dateFormat = DateFormat(FormatConstant.timeConstant);
    DateTime rawTime = dateFormat.parse(rawTimeString);
    return DateFormat(FormatConstant.displayTime).format(rawTime);
  }
}

class TodoListCardTimeWidget extends StatelessWidget {
  final String title;
  final String value;
  const TodoListCardTimeWidget(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: ColorConstant.textLightGrey),
        ),
        Text(value),
      ],
    );
  }
}
