import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lessons_page.dart';
import 'vocab_page.dart';
import 'quiz_page.dart';
import 'progress_page.dart';
import 'messages_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int idx = 0;

  int selectedLessonId = 1;
  QuizMode selectedQuizMode = QuizMode.vocab;

  void _openVocab(int lessonId) {
    setState(() {
      selectedLessonId = lessonId;
      idx = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Membuka Kosakata...")),
    );
  }

  void _openQuiz(int lessonId, QuizMode mode) {
    setState(() {
      selectedLessonId = lessonId;
      selectedQuizMode = mode;
      idx = 2;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Membuka Kuis: ${mode.label}")),
    );
  }

  Future<void> _logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LessonsPage(
        onPickLesson: _openVocab,
        onPickQuiz: _openQuiz,
      ),
      VocabPage(lessonId: selectedLessonId),
      QuizPage(
        lessonId: selectedLessonId,
        initialMode: selectedQuizMode,
        onPickLesson: (lid) => setState(() => selectedLessonId = lid),
        onPickMode: (m) => setState(() => selectedQuizMode = m),
      ),
      const ProgressPage(),
      const MessagesPage(),
    ];

    final titles = ["Materi", "Kosakata", "Kuis", "Progress", "Notifikasi"];

    return Scaffold(
      appBar: AppBar(
        title: Text("NihongoStep • ${titles[idx]}"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: "Materi"),
          NavigationDestination(icon: Icon(Icons.translate), label: "Vocab"),
          NavigationDestination(icon: Icon(Icons.quiz), label: "Kuis"),
          NavigationDestination(icon: Icon(Icons.stars), label: "Progress"),
          NavigationDestination(icon: Icon(Icons.notifications), label: "Notif"),
        ],
      ),
    );
  }
}