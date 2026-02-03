import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const NihongoStepApp());
}

class NihongoStepApp extends StatelessWidget {
  const NihongoStepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NihongoStep",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red, // kamu bisa ganti nanti
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const BootPage(),
    );
  }
}

class BootPage extends StatefulWidget {
  const BootPage({super.key});

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {
  Future<bool> _isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getInt("user_id") ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data! ? const HomePage() : const LoginPage();
      },
    );
  }
}