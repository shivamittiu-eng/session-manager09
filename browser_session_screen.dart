import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/profile.dart';
import '../services/session_isolation_service.dart';

class BrowserSessionScreen extends StatefulWidget {
  final Profile profile;
  const BrowserSessionScreen({super.key, required this.profile});

  @override
  State<BrowserSessionScreen> createState() => _BrowserSessionScreenState();
}

class _BrowserSessionScreenState extends State<BrowserSessionScreen> {
  final _isolation = SessionIsolationService();
  InAppWebViewController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    await _isolation.restoreSession(widget.profile.id, widget.profile.url);
    setState(() => _ready = true);
  }

  Future<void> _saveAndExit() async {
    await _isolation.persistSession(widget.profile.id, widget.profile.url);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveAndExit();
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0B1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0B1A),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _saveAndExit),
          title: Text('${widget.profile.name} (${Uri.tryParse(widget.profile.url)?.host ?? ''})',
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
        body: !_ready
            ? const Center(child: CircularProgressIndicator())
            : InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.profile.url)),
                onWebViewCreated: (c) => _controller = c,
              ),
      ),
    );
  }
}
