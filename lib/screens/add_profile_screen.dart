import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/profile_store.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});
  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();

  Future<void> _save() async {
    if (_nameCtrl.text.isEmpty || _urlCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile name & URL required')),
      );
      return;
    }
    await context.read<ProfileStore>().addProfile(
          name: _nameCtrl.text,
          url: _urlCtrl.text,
          accountLabel: _labelCtrl.text,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0B1A),
        title: const Text('Add New Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(color: Color(0xFF6C4CE0), shape: BoxShape.circle),
                child: const Icon(Icons.person_add, color: Colors.white, size: 32),
              ),
            ),
            const SizedBox(height: 24),
            _field('Profile Name', _nameCtrl, hint: 'e.g. Shivam 2'),
            _field('Website URL', _urlCtrl, hint: 'https://instagram.com'),
            _field('Account Label', _labelCtrl, hint: 'myinsta@gmail.com'),
            const Text('This label is for your reference only',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CE0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('SAVE PROFILE', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
