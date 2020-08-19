import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/data_source/todo_data_source.dart';
import 'package:todo/model/todo.dart';

part 'todo_listing_event.dart';
part 'todo_listing_state.dart';

class TodoListingBloc extends Bloc<TodoListingEvent, TodoListingState> {
  @override
  TodoListingState get initialState => TodoListingInitial();

  @override
  Stream<TodoListingState> mapEventToState(
    TodoListingEvent event,
  ) async* {
    if (event is LoadTodoListingItemsEvent) {
      yield* _loadTodo();
    } else if (event is ChangeTodoItemStatusEvent) {
      yield* _changeStatus(event);
    } else if (event is OpenTodoItemEvent) {
      yield* _openDetail(event);
    } else if (event is CreateNewTodoEvent) {
      yield* _createNew(event);
    }
  }

  _getTodoItems() async {
    List<Todo> todoItems = await TodoLocalDataSource().getTodoList();
    return todoItems;
  }

  Stream<TodoListingState> _loadTodo() async* {
    yield BeginLoadTodoListingState();

    List<Todo> todoItems = await _getTodoItems();

    yield EndLoadTodoListingState();
    yield ShowTodoListingState(todoItems);
  }

  Stream<TodoListingState> _changeStatus(
      ChangeTodoItemStatusEvent event) async* {
    yield BeginLoadTodoListingState();

    Todo newTodo = event.todo;
    newTodo.isFinish = !event.todo.isFinish;

    await TodoLocalDataSource().updateTodo(event.todo.id, newTodo);
    List<Todo> todoItems = await _getTodoItems();

    yield EndLoadTodoListingState();
    yield ShowTodoListingState(todoItems);
  }

  Stream<TodoListingState> _openDetail(OpenTodoItemEvent event) async* {
    yield OpenTodoDetailState(event.todoId);
  }

  Stream<TodoListingState> _createNew(CreateNewTodoEvent event) async* {
    yield CreateNewTodoState();
  }
}
