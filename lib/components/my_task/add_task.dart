import 'package:flutter/material.dart';
import 'package:taskmanagementapp/utils/firebase_utils.dart';

import '../home/home.dart';
class AddTaskContent extends StatefulWidget {
  @override
  State<AddTaskContent> createState() => _AddTaskContentState();
}

class _AddTaskContentState extends State<AddTaskContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late DateTime? pickedDate;
  late String taskPriority;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: 20, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("What would you like to do?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Grocery Shopping",
              border: InputBorder.none,
            ),
          ),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              hintText: "Buy essentials for the week",
              border: InputBorder.none,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.calendar_today_outlined), onPressed: ()async  {
                pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // current date
                  firstDate: DateTime(2000),   // earliest date allowed
                  lastDate: DateTime(2100),    // latest date allowed
                );
                if (pickedDate != null) {
                  print("Selected date: ${pickedDate}");
                  // You can also update a controller or state variable here
                }
              }),
              IconButton(
                icon: Icon(Icons.warning_amber_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Select Priority"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: ['Low', 'Medium', 'High'].map((priority) {
                            return ListTile(
                              leading: Icon(Icons.flag),
                              title: Text(priority),
                              onTap: () {
                                taskPriority=priority;
                                print("Selected Priority: $priority");
                                Navigator.pop(context); // Close dialog
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async{
                  showLoadingDialog(context);
                  await FirebaseUtils.uploadAddedTask(_titleController.text, _descController.text, pickedDate!, taskPriority);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                          (Route<dynamic> route) => false);

                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12),
                  backgroundColor: const Color(0xff666af6)
                ),
                child: Icon(Icons.arrow_upward,color: Colors.white,),
              )
            ],
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user can't tap outside to close
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }
}