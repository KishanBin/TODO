import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Pages/addTask.dart';
import 'package:todo/Pages/filter.dart';
import 'package:todo/Pages/updateTask.dart';
import 'package:todo/helper/api.dart';
import 'package:todo/helper/uihelper.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<api>(
      builder: (context, api, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Today's Task",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const filterPage()));
                },
                icon: const Icon(Icons.history)),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: api.fetchData(api.formatedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  //fetching the object array in data
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      log(data[index].data().toString());
                      String id = data[index]['id'];
                      String task = data[index]['task'];
                      String priority = data[index]['priority'];
                      String date = data[index]['date'];
                      bool check = data[index]['check'];
                      return Card(
                        color: check == true
                            ? const Color.fromARGB(255, 206, 244, 164)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Task: $task',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: priority == 'must'
                                        ? Colors.red
                                        : (priority == "should"
                                            ? Colors.yellow
                                            : Colors.blue),
                                    radius: 5,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [Text(priority), Text(date)],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          uihelper().optionContainer(
                                            InkWell(
                                              onTap: () {
                                                if (check) {
                                                  check = false;
                                                } else {
                                                  check = true;
                                                }
                                                api.updateTask(
                                                    "tasks/${api.user.uid}/$date",
                                                    id,
                                                    {"check": check});
                                              },
                                              child: check == true
                                                  ? const Icon(Icons.check)
                                                  : null,
                                            ),
                                          ),
                                          uihelper().optionContainer(InkWell(
                                            onTap: () {
                                              api.deleteTask(
                                                  "tasks/${api.user.uid}/$date",
                                                  id);
                                            },
                                            child: const Icon(Icons.delete),
                                          )),
                                          uihelper().optionContainer(
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            updateTask(
                                                              collection:
                                                                  "tasks/${api.user.uid}/$date",
                                                              id: id,
                                                            )));
                                              },
                                              child: const Icon(Icons.edit),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Not data Found'),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => const addTask())),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
