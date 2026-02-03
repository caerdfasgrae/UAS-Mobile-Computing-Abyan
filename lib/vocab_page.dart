import 'package:flutter/material.dart';
import 'api_service.dart';

class VocabPage extends StatefulWidget {
  final int lessonId;
  const VocabPage({super.key, required this.lessonId});

  @override
  State<VocabPage> createState() => _VocabPageState();
}

class _VocabPageState extends State<VocabPage> {
  bool loading = true;
  List<dynamic> vocab = [];
  List<dynamic> filtered = [];
  final searchC = TextEditingController();

  Future<void> load() async {
    setState(() => loading = true);
    vocab = await ApiService.getVocabByLesson(widget.lessonId);
    filtered = vocab;
    if (mounted) setState(() => loading = false);
  }

  void doFilter(String q) {
    final qq = q.toLowerCase();
    setState(() {
      filtered = vocab.where((e) {
        final m = Map<String, dynamic>.from(e);
        return (m["jp"]?.toString().toLowerCase().contains(qq) ?? false) ||
            (m["romaji"]?.toString().toLowerCase().contains(qq) ?? false) ||
            (m["idn"]?.toString().toLowerCase().contains(qq) ?? false);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    load();
    searchC.addListener(() => doFilter(searchC.text));
  }

  @override
  void didUpdateWidget(covariant VocabPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchC,
            decoration: const InputDecoration(
              labelText: "Cari kosakata (jp/romaji/indo)",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("Kosakata kosong"))
              : ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final m = Map<String, dynamic>.from(filtered[i]);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${m["jp"]}  (${m["romaji"]})",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Arti: ${m["idn"]}"),
                    if ((m["example"] ?? "").toString().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text("Contoh: ${m["example"]}"),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}