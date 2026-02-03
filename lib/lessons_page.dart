import 'package:flutter/material.dart';
import 'api_service.dart';
import 'quiz_page.dart';

class LessonsPage extends StatefulWidget {
  final void Function(int lessonId) onPickLesson;
  final void Function(int lessonId, QuizMode mode) onPickQuiz;

  const LessonsPage({
    super.key,
    required this.onPickLesson,
    required this.onPickQuiz,
  });

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  bool loading = true;
  List<dynamic> lessons = [];

  Future<void> load() async {
    setState(() => loading = true);
    lessons = await ApiService.getLessons();
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  QuizMode _modeForLessonTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains("hiragana")) return QuizMode.hiragana;
    if (t.contains("katakana")) return QuizMode.katakana;
    return QuizMode.vocab; // default
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (lessons.isEmpty) return const Center(child: Text("Materi kosong"));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lessons.length,
      itemBuilder: (context, i) {
        final m = Map<String, dynamic>.from(lessons[i]);
        final id = int.parse(m["id"].toString());
        final title = m["title"]?.toString() ?? "-";
        final level = m["level"]?.toString() ?? "N5";
        final asset = m["image_asset"]?.toString();

        final mode = _modeForLessonTitle(title);

        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 72,
                    child: (asset != null && asset.isNotEmpty)
                        ? Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image_not_supported)),
                    )
                        : const Center(child: Icon(Icons.image)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text("Level: $level • Kuis: ${mode.label}"),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.icon(
                            onPressed: () => widget.onPickLesson(id),
                            icon: const Icon(Icons.translate),
                            label: const Text("Kosakata"),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => widget.onPickQuiz(id, mode),
                            icon: const Icon(Icons.quiz),
                            label: Text("Kuis ${mode.label}"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}