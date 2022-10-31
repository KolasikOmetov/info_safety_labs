import 'package:flutter/material.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({Key? key, required this.isExists}) : super(key: key);

  final bool Function(String username) isExists;

  static Future<String?> show(BuildContext context, {required bool Function(String username) isExists}) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AddUserDialog(
              isExists: isExists,
            ));
  }

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void _okPressed() {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      Navigator.pop(context, _controller.text);
    }
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    if (widget.isExists(value)) {
      return 'User already exists';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add user'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Username",
          ),
          validator: _validator,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _okPressed,
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
