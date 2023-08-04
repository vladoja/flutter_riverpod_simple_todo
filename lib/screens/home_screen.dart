import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_simple_todo/data/dummy_data.dart';
import 'package:riverpod_simple_todo/models/todo.dart';
import 'package:riverpod_simple_todo/widgets/todo_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todoList = [];

  @override
  void initState() {
    todoList = dummyTodoList;
    super.initState();
  }

  void onClickedTodoItem(id, state) {
    log("TODO item with id $id has been clicked");
    Todo clickedTodoIdem = todoList.where((element) => element.id == id).first;
    if (clickedTodoIdem != null) {
      clickedTodoIdem.isDone = !clickedTodoIdem.isDone;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simpe TO DO list')),
      body: Center(
        child: ListView.separated(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            // return Text(todoList[index].title);
            return TodoItem(
                isChecked: todoList[index].isDone,
                id: todoList[index].id,
                title: todoList[index].title,
                onChanged: onClickedTodoItem);
          },
          separatorBuilder: (context, index) => const Divider(height: 0),
        ),
      ),
    );
  }
}
