import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/constant/color_constant.dart';
import 'package:todo/constant/router_constant.dart';
import 'package:todo/constant/text_constant.dart';
import 'package:todo/page/todo/todo_detail/todo_detail_page_args.dart';
import 'package:todo/page/todo/todo_listing/bloc/todo_listing_bloc.dart';
import 'package:todo/page/todo/todo_listing/todo_list_card.dart';
import 'package:todo/widget/hy_app_bar.dart';
import 'package:todo/widget/loading_hub.dart';

class TodoListingPage extends StatefulWidget {
  @override
  _TodoListingPageState createState() => _TodoListingPageState();
}

class _TodoListingPageState extends State<TodoListingPage> {
  @override
  Widget build(BuildContext context) {
    //Using MultiBlocProvider, in future easy to add more bloc
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoListingBloc>(
          create: (BuildContext context) =>
              TodoListingBloc()..add(LoadTodoListingItemsEvent()),
        ),
      ],
      child: TodoListingWidget(),
    );
  }
}

class TodoListingWidget extends StatefulWidget {
  @override
  _TodoListingWidgetState createState() => _TodoListingWidgetState();
}

class _TodoListingWidgetState extends State<TodoListingWidget> {
  @override
  Widget build(BuildContext context) {
    return LoadingHUD(
      child: Scaffold(
        appBar: HYAppBar(TextConstant.todoListingPageNavigationTitle),
        body: TodoListingBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<TodoListingBloc>(context).add(CreateNewTodoEvent());
          },
          child: Icon(Icons.add),
          backgroundColor: ColorConstant.actionButtonBackground,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class TodoListingBody extends StatefulWidget {
  @override
  _TodoListingBodyState createState() => _TodoListingBodyState();
}

class _TodoListingBodyState extends State<TodoListingBody> {
  @override
  Widget build(BuildContext context) {
    //Using MultiBlocListener, in future easy to add more bloc, eg search component bloc
    return MultiBlocListener(
      listeners: [
        BlocListener<TodoListingBloc, TodoListingState>(
          listener: (context, state) async {
            if (state is BeginLoadTodoListingState) {
              LoadingHUD.of(context).show(text: TextConstant.loading);
            } else {
              LoadingHUD.of(context).dismiss();
            }

            if (state is OpenTodoDetailState) {
              TodoDetailPageArgs args = TodoDetailPageArgs(
                TodoDetailPageOption.edit,
                todoId: state.todoId,
              );
              await Navigator.pushNamed(context, todoDetailRouter,
                  arguments: args);

              BlocProvider.of<TodoListingBloc>(context)
                  .add(LoadTodoListingItemsEvent());
            } else if (state is CreateNewTodoState) {
              TodoDetailPageArgs args =
                  TodoDetailPageArgs(TodoDetailPageOption.createNew);
              await Navigator.pushNamed(context, todoDetailRouter,
                  arguments: args);

              BlocProvider.of<TodoListingBloc>(context)
                  .add(LoadTodoListingItemsEvent());
            }
          },
        ),
      ],
      child: BlocBuilder<TodoListingBloc, TodoListingState>(
        condition: (previousState, state) {
          return state.invokeBuild();
        },
        builder: (context, state) {
          if (state is TodoListingInitial) {
            return Container();
          } else if (state is ShowTodoListingState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.todoItems.length + 1,
              itemBuilder: (context, index) {
                // Add footer to avoid the add new button block ui
                if (index == state.todoItems.length) {
                  return SizedBox(
                    height: 70,
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      InkWell(
//                        onTap: () {
//                          BlocProvider.of<TodoListingBloc>(context)
//                              .add(OpenTodoItemEvent(state.todoItems[index].id));
//                        },
                        child: TodoCard(
                          state.todoItems[index],
                          onCompleteButtonPressed: () {
                            BlocProvider.of<TodoListingBloc>(context)
                                .add(ChangeTodoItemStatusEvent(state.todoItems[index]));
                          },
                          onEditPressed: () {
                            BlocProvider.of<TodoListingBloc>(context).add(
                                OpenTodoItemEvent(state.todoItems[index].id));
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
