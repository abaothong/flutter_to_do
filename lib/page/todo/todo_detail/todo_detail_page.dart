import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/constant/format_constant.dart';
import 'package:todo/constant/text_constant.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/page/todo/todo_detail/bloc/todo_detail_bloc.dart';
import 'package:todo/page/todo/todo_detail/todo_detail_page_args.dart';
import 'package:todo/widget/hy_app_bar.dart';
import 'package:todo/widget/loading_hub.dart';
import 'package:todo/widget/popup_dialog.dart';
import 'package:todo/widget/text_field/time_text_field.dart';
import 'package:todo/widget/text_field/title_text_field.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage(this.args);
  final TodoDetailPageArgs args;

  @override
  _TodoDetailPageState createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoDetailBloc>(
      create: (context) =>
          TodoDetailBloc()..add(LoadTodoEvent(id: widget.args.todoId)),
      child: TodoDetailWidget(widget.args),
    );
  }
}

class TodoDetailWidget extends StatefulWidget {
  const TodoDetailWidget(this.args);
  final TodoDetailPageArgs args;

  @override
  _TodoDetailWidgetState createState() => _TodoDetailWidgetState();
}

class _TodoDetailWidgetState extends State<TodoDetailWidget> {
  @override
  Widget build(BuildContext context) {
    _exitWarning() {
      return PopupDialog.showPopup(context,
          message: TextConstant.cancelEditWarningMessage,
          actionButtons: [
            PopupActionButton(
              title: TextConstant.cancel,
              action: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            PopupActionButton(
              title: TextConstant.confirm,
              action: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Navigator.of(context).pop();
              },
            ),
          ]);
    }

    Future<bool> _willPopCallback() async {
      _exitWarning();
      return true;
    }

    String navigationTitle =
        widget.args.option == TodoDetailPageOption.createNew
            ? TextConstant.todoDetailPageNavigationTitleAddNew
            : TextConstant.todoListingPageNavigationTitle;

    return LoadingHUD(
      child: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: HYAppBar(
            navigationTitle,
            showBackButton: true,
            onBackButtonPressed: _exitWarning,
          ),
          body: TodoDetailBody(),
        ),
      ),
    );
  }
}

class TodoDetailBody extends StatefulWidget {
  @override
  _TodoDetailBodyState createState() => _TodoDetailBodyState();
}

class _TodoDetailBodyState extends State<TodoDetailBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoDetailBloc, TodoDetailState>(
        listener: (context, state) {
      if (state is BeginLoadTodoDetailState) {
        LoadingHUD.of(context).show(text: TextConstant.loading);
      } else {
        LoadingHUD.of(context).dismiss();
      }

      if (state is SaveTodoDoneState) {
        PopupDialog.showSuccessMessage(
          context,
          title: TextConstant.popupSuccessTitle,
          message: state.isCreateNew
              ? TextConstant.createTodoSuccessMessage
              : TextConstant.updateTodoSuccessMessage,
          action: () {
            //pop the dialog
            Navigator.of(context).pop();

            //pop detail page
            Navigator.of(context).pop();
          },
        );
      } else if (state is PopErrorMessageState) {
        PopupDialog.showErrorMessage(
          context,
          message: state.errorMessage,
        );
      }

    }, buildWhen: (previous, current) {
      return current.invokeBuild();
    }, builder: (context, state) {
      if (state is TodoDetailInitial) {
        return Container();
      } else if (state is ShowTodoDetailState) {
        Todo todo = state.todo;

        return Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: TitleTextField(
                        TextConstant.startDate,
                        defaultText: todo.title,
                        onTextChange: (text) {
                          todo.title = text;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: TimeTextField(
                        TextConstant.startDate,
                        defaultDate: todo.startDate,
                        onDateSelected: (dateTime) {
                          todo.startDate =
                              DateFormat(FormatConstant.timeConstant)
                                  .format(dateTime);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: TimeTextField(
                        TextConstant.endDate,
                        defaultDate: todo.startDate,
                        onDateSelected: (dateTime) {
                          todo.endDate = DateFormat(FormatConstant.timeConstant)
                              .format(dateTime);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              color: Colors.black,
              child: SizedBox.expand(
                child: FlatButton(
                  onPressed: () {
                    BlocProvider.of<TodoDetailBloc>(context)
                        .add(SaveTodoEvent(todo));
                  },
                  child: Text(
                    TextConstant.save,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return Container();
      }
    });
  }
}
