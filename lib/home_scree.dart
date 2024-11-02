import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});
  @override
  State<HomeScree> createState() => _HomeScreeState();
}


class _HomeScreeState extends State<HomeScree> {
  var titleController = TextEditingController();
  var subTitleController = TextEditingController();
  var taskBox = Hive.box("taskBox");
  List<Map<String, dynamic>> ourData = [];
  int? editingKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Hive CRUD",
          style: TextStyle(color: Colors.white, fontSize: 21),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          titleController.clear();
          subTitleController.clear();
          editingKey = null; // Reset for new entry
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return _buildModalForm();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: ourData.length,
        itemBuilder: (context, index) {
          var currentItem = ourData[index];
          return Card(
            child: ListTile(
              title: Text("${currentItem['title']}"),
              subtitle: Text(currentItem['task']),
              tileColor: Colors.white24,
              textColor: Colors.blue,
              leading: CircleAvatar(
                backgroundColor: Colors.cyan,
                radius: 20,
                child: Text("${index+1}"),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _editData(currentItem);
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Data"),
                              content: Text("Are you want to Delete?"),
                              actions: [
                                TextButton(onPressed: () {

                                  Navigator.of(context).pop();
                                }, child: Text("Cancled")),
                                TextButton(onPressed: () {

                                  _deleteData(currentItem['key']);
                                  Navigator.pop(context);

                                }, child: Text("ok"))
                              ],
                            );
                          },);

                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModalForm() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(hintText: "Enter Student Name"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: TextFormField(
              controller: subTitleController,
              decoration: InputDecoration(hintText: "Enter Student Subject"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 30, right: 30),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () {
                  var title = titleController.text.toString();
                  var subTitle = subTitleController.text.toString();
                  if(title.isNotEmpty && subTitle.isNotEmpty) {
                    var data = {
                      "title": title,
                      "task": subTitle,
                    };
                    if (editingKey != null) {
                      updateData(editingKey, data);

                    }
                    else {
                      createData(data);
                      Navigator.pop(context);
                    }
                  }
                  else {
                    Navigator.pop(context);
                  }// Close the modal
                },
                child: Text(editingKey != null ? "Update Data" : "Add Data"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _editData(Map<String, dynamic> item) {
    titleController.text = item['title'];
    subTitleController.text = item['task'];
    editingKey = item['key'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildModalForm();
      },
    );
  }

  createData(Map<String, dynamic> data) async {
    await taskBox.add(data);
    readData();
  }

  readData() async {
    var data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {
        "key": key,
        'title': item['title'],
        'task': item["task"],
      };
    }).toList();
    setState(() {
      ourData = data.reversed.toList();
    });
  }
  updateData(int? key, Map<String, dynamic> data) async {
    await taskBox.put(key, data);
    readData();
    editingKey = null;

    return taskBox;
  }

  void _deleteData(int key) async {
    await taskBox.delete(key);
    readData();
  }
  @override
  void initState() {
    super.initState();
    readData();
  }
}
