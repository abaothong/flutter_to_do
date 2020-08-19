import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:todo/constant/format_constant.dart';
import 'package:todo/data_source/todo_data_source.dart';
import 'package:todo/model/result.dart';
import 'package:todo/model/todo.dart';

part 'todo_detail_event.dart';
part 'todo_detail_state.dart';

class TodoDetailBloc extends Bloc<TodoDetailEvent, TodoDetailState> {
  @override
  TodoDetailState get initialState => TodoDetailInitial();

  @override
  Stream<TodoDetailState> mapEventToState(
    TodoDetailEvent event,
  ) async* {
    if (event is LoadTodoEvent) {
      yield* _load(event);
    } else if (event is SaveTodoEvent) {
      yield* _save(event);
    }
  }

  _getTodo(int id) async {
    Todo todoItem = await TodoLocalDataSource().getTodo(id);
    return todoItem;
  }

  Result _validate(Todo todo) {

    if (todo.title.isEmpty) {
      return Result(
        false,
        errorMessage: "Title cannot empty",
      );
    } else if (todo.startDate.isEmpty) {
      return Result(
        false,
        errorMessage: "Start Date cannot empty",
      );
    } else if (todo.endDate.isEmpty) {
      return Result(
        false,
        errorMessage: "End Date cannot empty",
      );
    }

    DateFormat dateFormat = DateFormat(FormatConstant.timeConstant);
    DateTime startTime = dateFormat.parse(todo.startDate);
    DateTime endTime = dateFormat.parse(todo.endDate);
    final timeLeft = endTime.difference(startTime).inMinutes;
    if (timeLeft < 0) {
      return Result(
        false,
        errorMessage: "End time must later than start time",
      );
    }

    return Result(true);
  }

  Stream<TodoDetailState> _save(
    SaveTodoEvent event,
  ) async* {
    yield BeginLoadTodoDetailState();

    Result result = _validate(event.todo);
    if(result.result) {
      if (event.todo.id != null) {
        await TodoLocalDataSource().updateTodo(event.todo.id, event.todo);
      } else {
        await TodoLocalDataSource().createNewTodo(event.todo);
      }

      yield SaveTodoDoneState(event.todo.id == null);
      yield EndLoadTodoDetailState();
    } else {
      yield PopErrorMessageState(result.errorMessage);
      yield EndLoadTodoDetailState();
    }
  }

  Stream<TodoDetailState> _load(
    LoadTodoEvent event,
  ) async* {
    yield BeginLoadTodoDetailState();
    if (event.id != null) {
      Todo todo = await _getTodo(event.id);
      yield ShowTodoDetailState(todo);
    } else {
      Todo todo = Todo("", startDate: "", endDate: "");
      yield ShowTodoDetailState(todo);
    }

    yield EndLoadTodoDetailState();
  }
}
