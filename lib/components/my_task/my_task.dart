import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanagementapp/components/my_task/task_card.dart';
import 'package:taskmanagementapp/utils/utils.dart';

import '../../utils/firebase_utils.dart';
import '../home/home.dart';
class MyTask extends StatefulWidget {
  const MyTask({super.key});

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  String selectedPriority = 'All'; // High, Medium, Low
  String selectedStatus = 'All';   // Completed, Incomplete

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filters
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Priority Filter
              Row(
                children: [
                  Text("Priority : ",style: TextStyle(fontSize: 16),),
                  DropdownButton<String>(
                    value: selectedPriority,
                    items: ['All', 'High', 'Medium', 'Low']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedPriority = val!),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Status Filter
              Row(
                children: [
                  Text("Status : ",style: TextStyle(fontSize: 16),),
                  DropdownButton<String>(
                    value: selectedStatus,
                    items: ['All', 'Completed', 'Incomplete']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedStatus = val!),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Task List
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseUtils.getUserTasks(), // Gets all tasks
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No tasks yet."));
              }
              List<QueryDocumentSnapshot> tasks = snapshot.data!.docs;
              // Filter by priority
              if (selectedPriority != 'All') {
                tasks = tasks.where((doc) =>
                (doc['priority'] ?? '').toString().toLowerCase() ==
                    selectedPriority.toLowerCase()).toList();
              }
              // Filter by status
              if (selectedStatus != 'All') {
                final isComplete = selectedStatus == 'Completed';
                tasks = tasks.where((doc) =>
                (doc['isComplete'] ?? false) == isComplete).toList();
              }
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final doc = tasks[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final docId = doc.id;
                  final isComplete = data['isComplete'] ?? false;
                  final String title = data['title'] ?? '';
                  final String description = data['description'] ?? '';
                  final DateTime dueDate = data['dueDate']?.toDate();
                  final List<String> badges = [data['priority']];

                  return Dismissible(
                    key: Key(docId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      final shouldDelete = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Delete Task"),
                          content: const Text("Are you sure you want to delete this task?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Delete")),
                          ],
                        ),
                      );
                      return shouldDelete ?? false;
                    },
                    onDismissed: (direction) => FirebaseUtils.deleteTask(docId),
                    child: GestureDetector(
                      onTap: (){
                        _showEditDialog(context,docId,title,description,dueDate,badges.first);
                      },
                      child: TaskCard(
                        title: title,
                        description: description,
                        date: DateFormat('d MMM').format(dueDate),
                        badges: badges,
                        isComplete: isComplete,
                        onTap: () => FirebaseUtils.toggleComplete(docId, isComplete),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  void _showEditDialog(BuildContext context, String docId, String currentTitle, String currentDescription, DateTime currentDueDate, String currentPriority) {
    final _titleController = TextEditingController(text: currentTitle);
    final _descController = TextEditingController(text: currentDescription);
    DateTime selectedDate = currentDueDate;
    String selectedPriority = currentPriority;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        backgroundColor: Colors.white,
        content: StatefulBuilder(
          builder: (context, setStateDialog) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("Due: "),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(DateFormat('d MMM y').format(selectedDate)),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ['High', 'Medium', 'Low']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setStateDialog(() {
                      selectedPriority = val!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              Utils.showLoadingDialog(context);
              await FirebaseUtils.updateTaskDetail(docId, _titleController.text, _descController.text, selectedDate, selectedPriority);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                      (Route<dynamic> route) => false);
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff666af6)
          ),
            child: const Text("Update",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }



}
