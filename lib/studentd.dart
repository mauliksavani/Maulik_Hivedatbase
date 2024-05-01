import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentDetailExample extends StatefulWidget {
  const StudentDetailExample({Key? key}) : super(key: key);

  @override
  State<StudentDetailExample> createState() => _StudentDetailExampleState();
}

class _StudentDetailExampleState extends State<StudentDetailExample> {
  List<Map<String, dynamic>> items = [];
  TextEditingController name = TextEditingController();
  TextEditingController rollNO = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  final studentDetail = Hive.box("studentDetail");

  void createItem(Map<String, dynamic> newItem) async {
    await studentDetail.add(newItem);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("....SuccessFully added")));
    refreshItem();
    log("amount data is: ${studentDetail.length}");
  }

  void updateItem(int itemKey, Map<String, dynamic> item) async {
    await studentDetail.put(itemKey, item);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("....SuccessFully updated")));

    refreshItem();
    // log("amount data is: ${shoppingBox.length}");
  }

  void deleteItem(int itemKey) async {
    await studentDetail.delete(itemKey);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("....SuccessFully deleted")));
    refreshItem();
    // log("amount data is: ${shoppingBox.length}");
  }

  void refreshItem() {
    final data = studentDetail.keys.map((key) {
      final item = studentDetail.get(key);
      print("$item");
      return {"key": key, "name": item['name'], "rollNo": item['rollNo'], "address": item['address'], "phone": item['phone'], "email": item['email']};
    }).toList();
    setState(() {
      items = data.reversed.toList();
    });
  }

  void showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      name.text = existingItem['name'];
      rollNO.text = existingItem['rollNo'];
      address.text = existingItem['address'];
      phone.text = existingItem['phone'];
      email.text = existingItem['email'];
    }

    showModalBottomSheet(
        context: ctx,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  top: 15,
                  right: 15,
                  left: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 4),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: name,
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: rollNO,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "RollNo",
                      ),
                    ),
                    TextField(
                      controller: address,
                      decoration: InputDecoration(hintText: "address"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "phone",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "email"),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        if (itemKey == null) {
                          createItem(
                              {"name": name.text, "rollNo": rollNO.text,"address":address.text,"phone":phone.text,"email":email.text});
                        }
                        if (itemKey != null) {
                          updateItem(itemKey, {
                            "name": name.text.trim(),
                            "rollNo": rollNO.text.trim(),
                            "address": address.text.trim(),
                            "phone": phone.text.trim(),
                            "email": email.text.trim(),
                          });
                        }
                        name.text = "";
                        rollNO.text = "";
                        address.text = "";
                        phone.text = "";
                        email.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Text(itemKey == null ? "Create New" : "update"),
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showForm(context, null);
            name.text = "";
            rollNO.text = "";
            address.text = "";
            phone.text = "";
            email.text = "";
          },
          child: Icon(Icons.add)),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final currentItem = items[i];
            return Card(
              color: Colors.orange[200],
              margin: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(currentItem['name']),
                  Text(currentItem['rollNo'].toString()),
                  Text(currentItem['address'].toString()),
                  Text(currentItem['phone'].toString()),
                  Text(currentItem['email'].toString()),
                  SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showForm(context, currentItem['key']);
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteItem(currentItem['key']);
                            },
                            icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
