import 'package:flutter/material.dart';
import '../services/coach_service.dart';

class CoachChatScreen extends StatefulWidget {
  const CoachChatScreen({super.key});

  @override
  State<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends State<CoachChatScreen> {

  List<Map<String, String>> messages = [];

  final controller = TextEditingController();

  int streak = 3;
  double progress = 0.4;

  void sendMessage() {

    final text = controller.text;
    controller.clear();

    setState(() {
      messages.add({"role": "user", "text": text});

      String reply = CoachService.getMessage(
        progress: progress,
        isDayCompleted: progress == 1,
        streak: streak,
      );

      messages.add({"role": "coach", "text": reply});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Coach"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];

                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.blue
                          : Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Text(msg["text"]!),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Coach'a yaz...",
                    ),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}