import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/addTask.dart';
import 'package:todo/api.dart';
import 'package:todo/uihelper.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<api>(
      builder: (context, api, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'TODO APP',
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: api.fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  //fetching the object array in data
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      log(data[index].data().toString());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${data[index]['task']}'),
                                Text('${data[index]['priority']}'),
                                Text('${data[index]['date']}')
                              ],
                            ),
                            Row(
                              children: [
                                uihelper().optionContainer(
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(Icons.check),
                                  ),
                                ),
                                uihelper().optionContainer(InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.delete),
                                )),
                                uihelper().optionContainer(
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Not data Found'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => addTask())),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
