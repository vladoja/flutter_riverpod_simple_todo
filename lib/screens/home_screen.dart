import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_simple_todo/data/dummy_data.dart';
import 'package:riverpod_simple_todo/models/todo.dart';
import 'package:riverpod_simple_todo/providers/todo_provider.dart';
import 'package:riverpod_simple_todo/widgets/todo_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Todo> todoList = [];
  late TextEditingController _addItemController;

  @override
  void initState() {
    _addItemController = TextEditingController();
    todoList = ref.read(todosProvider);
    super.initState();
  }

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void onClickedTodoItem(id, state) {
    log("TODO item with id $id has been clicked");
    Todo clickedTodoIdem = todoList.where((element) => element.id == id).first;
    if (clickedTodoIdem != null) {
      clickedTodoIdem.isDone = !clickedTodoIdem.isDone;
    }
    setState(() {});
  }

  void onClickedAddTodoItem() {
    log("Added new item '${_addItemController.text}'");
    if (_addItemController.text.isNotEmpty &&
        _addItemController.text.length > 3) {
      todoList.add(Todo(DateTime.now().millisecondsSinceEpoch.toString(),
          _addItemController.text, false));
      setState(() {});
      log("Total todo items: ${todoList.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Simpe TO DO list')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                  controller: _addItemController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Add New",
                    filled: true,
                    suffix: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: onClickedAddTodoItem,
                      color: Colors.blue,
                    ),
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      // return Text(todoList[index].title);
                      return TodoItem(
                          isChecked: todoList[index].isDone,
                          id: todoList[index].id,
                          title: todoList[index].title,
                          onChanged: onClickedTodoItem);
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
