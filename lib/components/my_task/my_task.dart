import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanagementapp/utils/firebase_utils.dart';
class MyTask extends StatelessWidget {
  const MyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseUtils.getUserTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No tasks yet."));
        }

        final tasks = snapshot.data!.docs;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final doc = tasks[index];
            final data = doc.data() as Map<String, dynamic>;
            final docId = doc.id;
            final isComplete = data['isComplete'] ?? false;

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
              child: ListTile(
                leading: GestureDetector(
                  onTap: () => FirebaseUtils.toggleComplete(docId, isComplete),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                      color: isComplete ? Colors.green : Colors.transparent,
                    ),
                    child: isComplete
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
                title: Text(
                  data['title'] ?? '',
                  style: TextStyle(
                    decoration: isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(data['description'] ?? ''),
              ),
            );
          },
        );
      },
    );
  }
}
