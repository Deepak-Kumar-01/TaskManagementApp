import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final List<String> badges;
  final bool isComplete;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    this.badges = const [],
    this.isComplete = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Checkbox circle
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff666af6), width: 2),
                  color: isComplete ? Colors.green : Colors.transparent,
                ),
                child: isComplete
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Task title and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: isComplete ? TextDecoration.lineThrough : null,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: isComplete ? TextDecoration.lineThrough : null,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: isComplete ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            // Optional badges
            Row(
              children: badges
                  .take(3)
                  .map(
                    (text) => Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFDEDFFF),
                    color: badges.first=="High"?Colors.red:(badges.first=="Medium"?Colors.amber:Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
