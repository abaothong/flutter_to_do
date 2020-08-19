import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/constant/text_constant.dart';

import 'dart:io' show Platform;

class PopupActionButton {
  final String title;
  final VoidCallback action;

  const PopupActionButton({
    @required this.title,
    @required this.action,
  });
}

class PopupDialog {
  static showSuccessMessage(
    BuildContext context, {
    String title,
    String message,
    VoidCallback action,
  }) {
    PopupDialog.showPopup(
      context,
      title: title,
      message: message,
      actionButtons: [
        PopupActionButton(
          title: TextConstant.ok,
          action: action,
        ),
      ],
    );
  }

  static showErrorMessage(
      BuildContext context, {
        String title,
        String message,
      }) {
    PopupDialog.showPopup(
      context,
      title: title,
      message: message,
      actionButtons: [
        PopupActionButton(
          title: TextConstant.ok,
          action: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
      ],
    );
  }

  static Future<void> showPopup(
    BuildContext context, {
    String title,
    String message,
    List<PopupActionButton> actionButtons,
  }) {
    assert(((title != null) || (message != null)));

    if (message.length <= 0) {
      return null;
    }

    Widget _titleView() {
      if (title != null) {
        return Text(title);
      } else {
        return Container();
      }
    }

    Widget _contentView() {
      if (message != null) {
        return Text(message);
      } else {
        return Container();
      }
    }

    List<Widget> _actionButtonsView() {
      if (actionButtons != null) {
        List<Widget> actionList = [];
        for (var button in actionButtons) {
          actionList.add(
            FlatButton(
              child: Text(button.title),
              onPressed: () {
                button.action();
              },
            ),
          );
        }
        return actionList;
      } else {
        return [
          FlatButton(
            child: Text(TextConstant.ok),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
        ];
      }
    }

    Widget _getPopup() {
      if (Platform.isAndroid) {
        return AlertDialog(
          title: _titleView(),
          content: _contentView(),
          actions: _actionButtonsView(),
        );
      } else {
        return CupertinoTheme(
          data:
              CupertinoTheme.of(context).copyWith(brightness: Brightness.light),
          child: CupertinoAlertDialog(
            title: _titleView(),
            content: _contentView(),
            actions: _actionButtonsView(),
          ),
        );
      }
    }

    _generateDialog() {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return _getPopup();
        },
      );
    }

    return _generateDialog();
  }
}
