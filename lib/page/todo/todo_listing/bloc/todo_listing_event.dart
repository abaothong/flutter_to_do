part of 'todo_listing_bloc.dart';

abstract class TodoListingEvent extends Equatable {
  const TodoListingEvent();
}

class LoadTodoListingItemsEvent extends TodoListingEvent {

  @override
  List<Object> get props => ["LoadTodoListingItemsEvent"];
}

class ChangeTodoItemStatusEvent extends TodoListingEvent {
  final Todo todo;
  const ChangeTodoItemStatusEvent(this.todo);

  @override
  List<Object> get props => ["ChangeTodoItemStatusEvent: ${todo.id}"];
}

class OpenTodoItemEvent extends TodoListingEvent {
  final int todoId;
  const OpenTodoItemEvent(this.todoId);

  @override
  List<Object> get props => ["OpenTodoItemEvent: $todoId"];
}

class CreateNewTodoEvent extends TodoListingEvent {
  @override
  List<Object> get props => ["CreateNewTodoEvent"];
}