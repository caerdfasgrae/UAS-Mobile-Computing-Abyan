import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();

  bool isRegister = false;
  bool loading = false;
  bool hidePass = true;

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _doLogin() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.login(
        email: emailC.text.trim(),
        password: passC.text,
      );

      if (res["success"] == true && res["user"] is Map) {
        final user = Map<String, dynamic>.from(res["user"]);
        final sp = await SharedPreferences.getInstance();
        await sp.setInt("user_id", int.parse(user["id"].toString()));
        await sp.setString("user_name", user["name"].toString());
        await sp.setString("user_email", user["email"].toString());

        _snack("Login berhasil!");
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        _snack(res["message"]?.toString() ?? "Login gagal");
      }
    } catch (_) {
      _snack("Gagal konek ke server");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _doRegister() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.register(
        name: nameC.text.trim(),
        email: emailC.text.trim(),
        password: passC.text,
      );

      if (res["success"] == true) {
        _snack("Register sukses. Silakan login.");
        setState(() => isRegister = false);
      } else {
        _snack(res["message"]?.toString() ?? "Register gagal");
      }
    } catch (_) {
      _snack("Gagal konek ke server");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primaryContainer,
                  cs.surface,
                ],
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 0,
                  color: cs.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: cs.primary,
                              child: Icon(Icons.translate, color: cs.onPrimary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "NihongoStep",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    isRegister
                                        ? "Buat akun dulu ya"
                                        : "Masuk untuk lanjut belajar",
                                    style: TextStyle(color: cs.onSurfaceVariant),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (isRegister) ...[
                          TextField(
                            controller: nameC,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Nama",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        TextField(
                          controller: emailC,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: passC,
                          obscureText: hidePass,
                          onSubmitted: (_) =>
                          loading ? null : (isRegister ? _doRegister() : _doLogin()),
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => hidePass = !hidePass),
                              icon: Icon(hidePass ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: loading
                                ? null
                                : () => isRegister ? _doRegister() : _doLogin(),
                            icon: Icon(isRegister ? Icons.person_add : Icons.login),
                            label: Text(loading
                                ? "Loading..."
                                : (isRegister ? "Register" : "Login")),
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: loading
                              ? null
                              : () => setState(() => isRegister = !isRegister),
                          child: Text(isRegister
                              ? "Sudah punya akun? Login"
                              : "Belum punya akun? Register"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}