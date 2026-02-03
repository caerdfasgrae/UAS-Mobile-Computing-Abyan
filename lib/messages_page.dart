import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final List<Map<String, String>> notifs = [
    {
      "title": "Tips Belajar",
      "body": "Latihan 10 menit tiap hari lebih efektif daripada lama tapi jarang."
    },
    {
      "title": "Reminder",
      "body": "Coba kuis Hiragana dulu, baru lanjut Katakana."
    },
    {
      "title": "Info",
      "body": "Di tab Materi, kamu bisa langsung pilih jenis kuis."
    },
  ];

  void _showAlert(String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (notifs.isEmpty) return const Center(child: Text("Tidak ada notifikasi"));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifs.length,
      itemBuilder: (context, i) {
        final n = notifs[i];
        return Dismissible(
          key: ValueKey("${n["title"]}-$i"),
          onDismissed: (_) => setState(() => notifs.removeAt(i)),
          child: Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(n["title"]!, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(n["body"]!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showAlert(n["title"]!, n["body"]!), // message/alert
            ),
          ),
        );
      },
    );
  }
}