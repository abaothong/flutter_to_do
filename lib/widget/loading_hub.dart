import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/constant/color_constant.dart';

class LoadingHUD extends StatefulWidget {
  LoadingHUD({
    @required this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  static LoadingHUDState of(BuildContext context) {
    return context.findAncestorStateOfType();
  }

  // Static Style
  final double iOSActivityIndicatorSize = 25;
  final double boxWidth = 70;
  final double boxHeight = 70;
  final TextStyle messageTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  @override
  State<StatefulWidget> createState() => LoadingHUDState();
}

class LoadingHUDState extends State<LoadingHUD>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  Timer _timer;
  bool exists = true;

  var _isVisible = false;
  var _text = "";
  var _opacity = 0.0;

  @override
  void initState() {
    _animation = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _opacity = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _isVisible = false;
          });
        }
      });

    exists = true;
    super.initState();
  }

  @override
  void dispose() {
    if(_timer != null) {
      _timer.cancel();
    }
    _animation.dispose();
    exists = false;
    super.dispose();
  }

  void dismiss() {
    _animation.reverse();
  }

  void show({String text = ""}) {
    _animation.forward();
    setState(() {
      _isVisible = true;
      _text = text;
    });

    _timer = Timer(Duration(seconds: 60), () {
      if (exists && _animation != null) {
        _animation.reverse();
      }
    });
  }

  bool isCurrentLoading() {
    return _isVisible;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Offstage(
          offstage: !_isVisible,
          child: Opacity(
            opacity: _opacity,
            child: _createHud(),
          ),
        ),
      ],
    );
  }

  Widget _getIndicator() {
    return CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(ColorConstant.theme),
      backgroundColor: Colors.white,
      strokeWidth: 5,
    );
  }

  Widget _createHud() {
    var sizeBox = SizedBox(
      width: widget.boxWidth,
      height: widget.boxHeight,
      child: _getIndicator(),
    );
    return _createHudView(sizeBox);
  }

  Widget _addText() {
    if (_text.length > 0) {
      return Material(
        color: Colors.transparent,
        child: Container(
          child: Text(
            _text,
            textAlign: TextAlign.center,
            style: widget.messageTextStyle,
          ),
        ),
      );
    } else {
      return SizedBox(width: 0);
    }
  }

  Widget _createHudView(Widget child) {
    return Stack(
      children: <Widget>[
        IgnorePointer(
          ignoring: false,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorConstant.loadingHUDBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minHeight: 130,
              minWidth: 130,
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    child: child,
                  ),
                  _addText(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
