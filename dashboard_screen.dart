import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../services/profile_store.dart';
import 'add_profile_screen.dart';
import 'browser_session_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProfileStore>().load());
  }

  Color _avatarColor(String name) {
    final colors = [
      const Color(0xFF6C4CE0),
      const Color(0xFF4285F4),
      const Color(0xFFE8622C),
      const Color(0xFF2CA05A),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProfileStore>();
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0B1A),
        title: const Text('Session Manager', style: TextStyle(color: Colors.white)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white))],
      ),
      body: RefreshIndicator(
        onRefresh: store.load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Welcome back!',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Manage your browser profiles', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            _actionButton(
              label: 'START ALL PROFILES',
              icon: Icons.play_arrow,
              color: const Color(0xFF2CA05A),
              onTap: store.startAll,
            ),
            const SizedBox(height: 8),
            _actionButton(
              label: 'STOP ALL PROFILES',
              icon: Icons.stop,
              color: const Color(0xFFD9463F),
              onTap: store.stopAll,
            ),
            const SizedBox(height: 20),
            const Text('MY PROFILES',
                style: TextStyle(color: Color(0xFF6C4CE0), fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8),
            ...store.profiles.map((p) => _profileCard(context, store, p)),
            const SizedBox(height: 12),
            _actionButton(
              label: 'ADD NEW PROFILE',
              icon: Icons.add,
              color: const Color(0xFF6C4CE0),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddProfileScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, ProfileStore store, Profile p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171426),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _avatarColor(p.name),
                child: Text(p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('URL: ${p.url}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('Account: ${p.accountLabel}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.circle, size: 8, color: p.isRunning ? const Color(0xFF2CA05A) : const Color(0xFFD9463F)),
              const SizedBox(width: 4),
              Text(p.isRunning ? 'RUNNING' : 'STOPPED',
                  style: TextStyle(
                      color: p.isRunning ? const Color(0xFF2CA05A) : const Color(0xFFD9463F), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await store.setRunning(p.id, true);
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BrowserSessionScreen(profile: p)),
                      );
                    }
                  },
                  icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
                  label: const Text('OPEN', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => store.setRunning(p.id, !p.isRunning),
                  icon: Icon(p.isRunning ? Icons.stop : Icons.play_arrow, size: 16, color: Colors.white),
                  label: Text(p.isRunning ? 'STOP' : 'START', style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.isRunning ? const Color(0xFFD9463F) : const Color(0xFF2CA05A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
