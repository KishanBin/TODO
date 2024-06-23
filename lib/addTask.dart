import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/api.dart';

class addTask extends StatefulWidget {
  const addTask({super.key});

  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {
  TextEditingController task = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  String priority = 'must';
  String formatedDate = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('TODO APP'),
        centerTitle: true,
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
                    Center(
                      child: Text(
                        'Add Your Task',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Choose Date'),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(formatedDate),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Select Priority'),
                    DropdownButton(
                      value: priority,
                      items: const [
                        DropdownMenuItem(
                          child: Text('must'),
                          value: 'must',
                        ),
                        DropdownMenuItem(
                          child: Text('should'),
                          value: 'should',
                        ),
                        DropdownMenuItem(
                          child: Text('want'),
                          value: 'want',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          priority = value!;
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
                                    task.text, priority, formatedDate);
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
        formatedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
    return formatedDate;
  }
}
