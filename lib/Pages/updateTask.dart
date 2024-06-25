import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helper/api.dart';

class updateTask extends StatefulWidget {
  String id;
  String collection;
  updateTask({super.key, required this.id, required this.collection});

  @override
  State<updateTask> createState() => _updateTaskState();
}

class _updateTaskState extends State<updateTask> {
  TextEditingController task = TextEditingController();
  String _priority = 'must';
  String _pickedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Add task here
                TextFormField(
                  controller: task,
                  decoration: const InputDecoration(
                      hintText: 'Ex. workout', label: Text('New Task')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Add New Task';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //Reselet the priority
                DropdownButton(
                  value: _priority,
                  items: const [
                    DropdownMenuItem(
                      value: 'must',
                      child: Text('Must'),
                    ),
                    DropdownMenuItem(
                      value: 'should',
                      child: Text('Should'),
                    ),
                    DropdownMenuItem(
                      value: 'want',
                      child: Text('Want'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _priority = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                //datebutton
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => _selectDate(context),
                  elevation: 5,
                  child: Text(
                    _pickedDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          try {
                            Map<String, dynamic> data = {
                              "task": task.text,
                              "priority": _priority,
                              "date": _pickedDate
                            };
                            api()
                                .updateTask(widget.collection, widget.id, data);
                            const snackBar =
                                SnackBar(content: Text("Task Updated "));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          } catch (e) {
                            const snackBar =
                                SnackBar(content: Text('No Connection'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: const Text('Update')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //seleting the date to update the task
  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _pickedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
    return _pickedDate;
  }
}
