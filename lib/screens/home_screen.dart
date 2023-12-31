import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_simple_todo/models/todo.dart';
import 'package:riverpod_simple_todo/providers/filter_provider.dart';
import 'package:riverpod_simple_todo/providers/todo_provider.dart';
import 'package:riverpod_simple_todo/widgets/todo_widget.dart';

const List<Widget> filterWidgets = <Widget>[
  Text('All'),
  Text('Open'),
  Text('Done')
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Todo> todoList = [];
  late TextEditingController _addItemController;
  late List<Filter> filterKeyList;

  @override
  void initState() {
    _addItemController = TextEditingController();
    todoList = ref.read(todosProvider);
    filterKeyList = ref.read(filtersProvider).keys.toList();
    super.initState();
  }

  @override
  void dispose() {
    _addItemController.dispose();
    super.dispose();
  }

  void onClickedTodoItem(id, state) {
    // log("TODO item with id $id has been clicked");
    Todo clickedTodoIdem = todoList.where((element) => element.id == id).first;
    if (clickedTodoIdem != null) {
      clickedTodoIdem.isDone = !clickedTodoIdem.isDone;
    }
    setState(() {});
  }

  void _showInfoMessage({required message, bool warning = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: (warning)
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    backgroundColor: Theme.of(context).colorScheme.onError)
                : Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
      ),
    );
  }

  void onClickedAddTodoItem() {
    // log("Added new item '${_addItemController.text}'");
    if (_addItemController.text.isNotEmpty &&
        _addItemController.text.toString().trim().length >= 3) {
      todoList.add(Todo(DateTime.now().millisecondsSinceEpoch.toString(),
          _addItemController.text.toString().trim(), false));

      setState(() {
        // _addItemController.clear;
        _addItemController.text = "";
      });
      // log("Total todo items: ${todoList.length}");
      _showInfoMessage(message: 'Successfuly created');
    } else {
      _showInfoMessage(
          message: 'Unable to create todo item. Min 3 characters',
          warning: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Map<Filter, bool> _filtersAll = ref.read(filtersProvider);
    final List<Todo> todosToDisplay = ref.watch(filteredTodosProvider);
    // Data for Widget ToggleButtons.isSelected
    final List<bool> _filterList = ref.watch(filtersProvider).values.toList();
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
              const SizedBox(
                height: 10,
              ),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  ref
                      .read(filtersProvider.notifier)
                      .setFilter(filterKeyList[index], true);
                  // setState(() {
                  //   log("Toggle button '$index' is pressed");
                  //   // The button that is tapped is set to true, and the others to false.
                  //   for (int i = 0; i < _filterList.length; i++) {
                  //     _filterList[i] = i == index;
                  //   }
                  // });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[500],
                color: Colors.blue[600],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _filterList,
                children: filterWidgets,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: todosToDisplay.length,
                    itemBuilder: (context, index) {
                      // return Text(todosToDisplay[index].title);
                      return TodoItem(
                          isChecked: todosToDisplay[index].isDone,
                          id: todosToDisplay[index].id,
                          title: todosToDisplay[index].title,
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
