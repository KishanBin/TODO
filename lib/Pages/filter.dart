import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helper/api.dart';

class filterPage extends StatefulWidget {
  const filterPage({super.key});

  @override
  State<filterPage> createState() => _filterPageState();
}

class _filterPageState extends State<filterPage> {
  String _pickedDate = 'Select Date';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        height: double.maxFinite,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () => _selectDate(context),
                elevation: 5,
                child: Text(
                  _pickedDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            StreamBuilder(
              stream: api().fetchData(_pickedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: 400,
                          child: ListView.builder(
                              itemCount: data.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var priority = data[index]['priority'];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Task: ${data[index]['task']}',
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            CircleAvatar(
                                              backgroundColor:
                                                  priority == 'must'
                                                      ? Colors.red
                                                      : (priority == "should"
                                                          ? Colors.yellow
                                                          : Colors.blue),
                                              radius: 5,
                                            )
                                          ],
                                        ),
                                        Text('Priority: $priority'),
                                        Text('Date: ${data[index]['date']}'),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No Data found'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
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
        _pickedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
    return _pickedDate;
  }
}
