part of 'todo_listing_bloc.dart';

abstract class TodoListingState extends Equatable {
  const TodoListingState();

  // not all state need to update ui, so limit it
  bool invokeBuild() => false;
}

class TodoListingInitial extends TodoListingState {
  @override
  List<Object> get props => [];
}

class BeginLoadTodoListingState extends TodoListingState {
  @override
  List<Object> get props => ["BeginLoadTodoListingState"];
}

class EndLoadTodoListingState extends TodoListingState {
  @override
  List<Object> get props => ["EndLoadTodoListingState"];
}

class ShowTodoListingState extends TodoListingState {

  const ShowTodoListingState(this.todoItems);
  final List<Todo> todoItems;

  @override
  bool invokeBuild() => true;
  @override
  List<Object> get props => ["ShowTodoListingState: $todoItems"];
}

class OpenTodoDetailState extends TodoListingState {
  const OpenTodoDetailState(this.todoId);
  final int todoId;

  @override
  List<Object> get props => ["OpenTodoDetailState"];
}

class CreateNewTodoState extends TodoListingState {
  @override
  List<Object> get props => ["CreateNewTodoState"];
}