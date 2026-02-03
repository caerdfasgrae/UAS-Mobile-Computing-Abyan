import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

enum QuizMode { hiragana, katakana, vocab }

extension QuizModeLabel on QuizMode {
  String get label {
    switch (this) {
      case QuizMode.hiragana:
        return "Hiragana";
      case QuizMode.katakana:
        return "Katakana";
      case QuizMode.vocab:
        return "Kosakata";
    }
  }
}

// kana lokal (boleh kamu tambah)
const hiragana = [
  {"jp": "あ", "romaji": "a"},
  {"jp": "い", "romaji": "i"},
  {"jp": "う", "romaji": "u"},
  {"jp": "え", "romaji": "e"},
  {"jp": "お", "romaji": "o"},
  {"jp": "か", "romaji": "ka"},
  {"jp": "き", "romaji": "ki"},
  {"jp": "く", "romaji": "ku"},
  {"jp": "け", "romaji": "ke"},
  {"jp": "こ", "romaji": "ko"},
];

const katakana = [
  {"jp": "ア", "romaji": "a"},
  {"jp": "イ", "romaji": "i"},
  {"jp": "ウ", "romaji": "u"},
  {"jp": "エ", "romaji": "e"},
  {"jp": "オ", "romaji": "o"},
  {"jp": "カ", "romaji": "ka"},
  {"jp": "キ", "romaji": "ki"},
  {"jp": "ク", "romaji": "ku"},
  {"jp": "ケ", "romaji": "ke"},
  {"jp": "コ", "romaji": "ko"},
];

class QuizPage extends StatefulWidget {
  final int lessonId;
  final QuizMode initialMode;

  final void Function(int lessonId) onPickLesson;
  final void Function(QuizMode mode) onPickMode;

  const QuizPage({
    super.key,
    required this.lessonId,
    required this.initialMode,
    required this.onPickLesson,
    required this.onPickMode,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool loading = true;

  late QuizMode mode;
  late int selectedLessonId;

  List<dynamic> lessons = [];

  List<Map<String, dynamic>> items = [];
  List<String> options = [];

  int score = 0;
  int qIndex = 0;

  // Biar user bisa submit kapan aja
  int answeredCount = 0;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<int> _getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt("user_id") ?? 0;
  }

  @override
  void initState() {
    super.initState();
    mode = widget.initialMode;
    selectedLessonId = widget.lessonId;
    _loadAll();
  }

  @override
  void didUpdateWidget(covariant QuizPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId ||
        oldWidget.initialMode != widget.initialMode) {
      mode = widget.initialMode;
      selectedLessonId = widget.lessonId;
      _loadAll();
    }
  }

  Future<void> _loadAll() async {
    setState(() => loading = true);

    lessons = await ApiService.getLessons();

    score = 0;
    qIndex = 0;
    answeredCount = 0;

    await _loadQuestions();

    if (mounted) setState(() => loading = false);
  }

  Future<void> _loadQuestions() async {
    items.clear();

    if (mode == QuizMode.hiragana) {
      items = hiragana
          .map((e) => {"question": e["jp"], "answer": e["romaji"]})
          .cast<Map<String, dynamic>>()
          .toList();
    } else if (mode == QuizMode.katakana) {
      items = katakana
          .map((e) => {"question": e["jp"], "answer": e["romaji"]})
          .cast<Map<String, dynamic>>()
          .toList();
    } else {
      final raw = await ApiService.getVocabByLesson(selectedLessonId);
      items = raw.map((e) {
        final m = Map<String, dynamic>.from(e);
        return {
          "question": "${m["jp"]} (${m["romaji"]})",
          "answer": m["idn"].toString(),
        };
      }).toList();
    }

    // Biar gak kepanjangan, batasi 10 soal (lebih nyaman demo)
    if (items.length > 10) {
      items.shuffle(Random());
      items = items.take(10).toList();
    }

    qIndex = 0;
    _makeOptions();
  }

  void _makeOptions() {
    if (items.isEmpty) {
      options = [];
      return;
    }

    // proteksi
    if (qIndex >= items.length) qIndex = 0;

    final rnd = Random();
    final correct = items[qIndex]["answer"].toString();

    final pool = items.map((e) => e["answer"].toString()).toSet().toList();
    pool.shuffle(rnd);

    final picks = <String>{correct};
    for (final p in pool) {
      if (picks.length >= 4) break;
      picks.add(p);
    }
    options = picks.toList()..shuffle(rnd);
  }

  Future<void> _answer(String picked) async {
    if (items.isEmpty) return;

    final correct = items[qIndex]["answer"].toString();

    if (picked == correct) {
      score += 10;
      _snack("Benar! +10 poin");
    } else {
      _snack("Salah. Jawaban: $correct");
    }

    answeredCount++;

    if (qIndex < items.length - 1) {
      setState(() {
        qIndex++;
        _makeOptions();
      });
      return;
    }

    await _submitQuiz(showDialogConfirm: false); // auto submit kalau habis
  }

  Future<void> _submitQuiz({bool showDialogConfirm = true}) async {
    if (showDialogConfirm) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Submit Kuis?"),
          content: Text("Skor kamu sekarang: $score\n"
              "Sudah menjawab: $answeredCount soal.\n\n"
              "Yakin mau submit?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Submit"),
            ),
          ],
        ),
      );

      if (ok != true) return;
    }

    // simpan progress hanya untuk vocab
    if (mode == QuizMode.vocab) {
      final uid = await _getUserId();
      if (uid > 0) {
        final saved = await ApiService.saveProgress(
          userId: uid,
          lessonId: selectedLessonId,
          points: score,
        );
        _snack(saved
            ? "Submit berhasil! Skor: $score (tersimpan)"
            : "Submit gagal simpan progress");
      } else {
        _snack("Submit selesai! Skor: $score");
      }
    } else {
      _snack("Submit selesai! Skor: $score");
    }
  }

  Future<void> _changeMode(QuizMode newMode) async {
    setState(() {
      mode = newMode;
      widget.onPickMode(newMode);
      loading = true;
    });

    score = 0;
    qIndex = 0;
    answeredCount = 0;

    await _loadQuestions();

    if (mounted) setState(() => loading = false);
  }

  Future<void> _changeLesson(int lessonId) async {
    setState(() {
      selectedLessonId = lessonId;
      widget.onPickLesson(lessonId);
      loading = true;
    });

    score = 0;
    qIndex = 0;
    answeredCount = 0;

    await _loadQuestions();

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Selector
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune),
                      const SizedBox(width: 8),
                      const Text(
                        "Pilih Kuis",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      DropdownButton<QuizMode>(
                        value: mode,
                        onChanged: (v) => v == null ? null : _changeMode(v),
                        items: QuizMode.values
                            .map(
                              (m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.label),
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (mode == QuizMode.vocab) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Materi (untuk kuis kosakata)",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: selectedLessonId,
                      onChanged: (v) => v == null ? null : _changeLesson(v),
                      items: lessons.map((e) {
                        final m = Map<String, dynamic>.from(e);
                        final id = int.parse(m["id"].toString());
                        final title = m["title"]?.toString() ?? "-";
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(title),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Area quiz dibuat scrollable -> NO OVERFLOW
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("Data kuis kosong"))
                : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mode: ${mode.label}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Soal ${qIndex + 1}/${items.length} • Dijawab: $answeredCount • Skor: $score",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mode == QuizMode.vocab
                              ? "Arti dari: ${items[qIndex]["question"]}"
                              : "Romaji dari: ${items[qIndex]["question"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // tombol jawaban
                ...options.map(
                      (o) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () => _answer(o),
                        child: Text(o),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Submit button
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _submitQuiz(showDialogConfirm: true),
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Submit / Selesai"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}