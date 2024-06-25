import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helper/api.dart';

// ignore: camel_case_types
class addTask extends StatefulWidget {
  const addTask({super.key});

  @override
  State<addTask> createState() => _addTaskState();
}

// ignore: camel_case_types
class _addTaskState extends State<addTask> {
  TextEditingController task = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _priority = 'must';
  String _pickedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: 500,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // color: Colors.amber,
              border: Border.all(
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'Add Your Task',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: task,
                      decoration: const InputDecoration(
                          hintText: 'Ex. workout', label: Text('Add Task')),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Add Task';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                      width: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Select Priority'),
                    DropdownButton(
                      value: _priority,
                      items: const [
                        DropdownMenuItem(
                          value: 'must',
                          child: Text('must'),
                        ),
                        DropdownMenuItem(
                          value: 'should',
                          child: Text('should'),
                        ),
                        DropdownMenuItem(
                          value: 'want',
                          child: Text('want'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                api().sendTask(
                                    task.text, _priority, _pickedDate);
                                const snackBar =
                                    SnackBar(content: Text('Task Added'));
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
                          child: const Text('Add')),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        DateTime selectedDate = picked;
        _pickedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
    return _pickedDate;
  }
}
