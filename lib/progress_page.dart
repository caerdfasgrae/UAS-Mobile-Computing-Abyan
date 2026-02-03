import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  bool loading = true;
  List<dynamic> data = [];

  Future<int> _getUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt("user_id") ?? 0;
  }

  Future<void> load() async {
    setState(() => loading = true);
    final uid = await _getUserId();
    if (uid > 0) data = await ApiService.getProgress(uid);
    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (data.isEmpty) return const Center(child: Text("Belum ada progress"));

    return RefreshIndicator(
      onRefresh: load,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, i) {
          final m = Map<String, dynamic>.from(data[i]);
          return Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m["title"]?.toString() ?? "-",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Poin: ${m["points"]}"),
                Text("Terakhir: ${m["last_seen"]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}