import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _remember = true;
  bool _obscure = true;

  void _login() {
    // TODO: replace with real auth check
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter username & password')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C4CE0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.public, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text('SESSION MANAGER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'Manage your browser profiles\neasily and securely',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _userCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _remember,
                      onChanged: (v) => setState(() => _remember = v ?? true),
                      activeColor: const Color(0xFF6C4CE0),
                    ),
                    const Text('Remember Me', style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: Color(0xFF6C4CE0))),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C4CE0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('LOGIN',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('OR', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  child: const Icon(Icons.fingerprint, color: Colors.grey, size: 30),
                ),
                const SizedBox(height: 8),
                const Text('Login with Fingerprint\n(Coming Soon)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
