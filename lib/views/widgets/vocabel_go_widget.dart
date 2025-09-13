import 'package:flutter/material.dart';

class VocabTopicTile extends StatelessWidget {
  final String topic;
  final Map<String, dynamic> vocabMap;

  const VocabTopicTile({Key? key, required this.topic, required this.vocabMap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        topic,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      children:
          vocabMap.entries.map((entry) {
            return ListTile(
              title: Text(entry.key, style: const TextStyle(fontSize: 16)),
              trailing: Text(
                entry.value,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            );
          }).toList(),
    );
  }
}
