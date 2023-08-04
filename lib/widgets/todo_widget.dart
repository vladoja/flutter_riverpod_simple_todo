import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  const TodoItem(
      {super.key,
      required this.isChecked,
      required this.id,
      required this.title,
      required this.onChanged});
  final bool isChecked;
  final String id;
  final String title;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        value: isChecked,
        title: Text(title),
        onChanged: (value) {
          onChanged(id, value);
        });
  }
}
