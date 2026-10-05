import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';
import 'auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _streams = <_StreamRow>[];
  @override
  void initState() {
    super.initState();
    _addRow();
  }

  @override
  void dispose() {
    for (final row in _streams) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() => setState(() => _streams.add(_StreamRow()));
  void _removeRow(_StreamRow row) => setState(() {
    _streams.remove(row);
    row.dispose();
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 20,
      title: const Row(
        children: [
          Icon(Icons.local_parking_rounded, color: AppTheme.brown, size: 28),
          SizedBox(width: 8),
          Text('AI Parking', style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Sign out',
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
          ),
          icon: const Icon(Icons.logout_rounded),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RTSP monitor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Play RTSP streams or videos from your device.',
                style: TextStyle(color: AppTheme.muted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._streams.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _StreamCard(row: row, onRemove: () => _removeRow(row)),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StreamRow {
  final name = TextEditingController();
  final url = TextEditingController();
  VlcPlayerController? player;
  File? videoFile;
  void load() {
    final value = url.text.trim();
    if (value.isEmpty || !value.toLowerCase().startsWith('rtsp://')) return;
    player?.dispose();
    player = VlcPlayerController.network(
      value,
      hwAcc: HwAcc.full,
      autoPlay: true,
    );
    videoFile = null;
  }

  void loadFile(File file) {
    player?.dispose();
    videoFile = file;
    player = VlcPlayerController.file(file, hwAcc: HwAcc.full, autoPlay: true);
  }

  void dispose() {
    name.dispose();
    url.dispose();
    player?.dispose();
  }
}

class _StreamCard extends StatefulWidget {
  const _StreamCard({required this.row, required this.onRemove});
  final _StreamRow row;
  final VoidCallback onRemove;
  @override
  State<_StreamCard> createState() => _StreamCardState();
}

class _StreamCardState extends State<_StreamCard> {
  final _picker = ImagePicker();

  Future<void> _pickVideo(ImageSource source) async {
    final picked = await _picker.pickVideo(source: source);
    if (picked == null || !mounted) return;
    setState(() {
      widget.row.url.clear();
      widget.row.loadFile(File(picked.path));
    });
  }

  void _play() {
    final value = widget.row.url.text.trim();
    if (!value.toLowerCase().startsWith('rtsp://')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid RTSP URL, for example rtsp://192.168.1.10:554/live',
          ),
        ),
      );
      return;
    }
    setState(widget.row.load);
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A352B25),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: widget.row.player == null
              ? Container(
                  color: const Color(0xFF332C28),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline_rounded,
                        color: AppTheme.sand,
                        size: 54,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No stream loaded',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
              : VlcPlayer(
                  controller: widget.row.player!,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(
                    child: CircularProgressIndicator(color: AppTheme.sand),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.row.name,
                      decoration: const InputDecoration(
                        labelText: 'Camera name',
                        hintText: 'Entrance camera',
                        prefixIcon: Icon(Icons.videocam_outlined),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Remove row',
                    onPressed: widget.onRemove,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.row.url,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'RTSP URL',
                        hintText:
                            'rtsp://username:password@192.168.1.10:554/live',
                        prefixIcon: Icon(Icons.link_rounded),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _play,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Play'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 52),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: PopupMenuButton<ImageSource>(
                  onSelected: _pickVideo,
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: ImageSource.gallery,
                      child: ListTile(
                        leading: Icon(Icons.video_library_outlined),
                        title: Text('Choose recorded video'),
                      ),
                    ),
                    PopupMenuItem(
                      value: ImageSource.camera,
                      child: ListTile(
                        leading: Icon(Icons.videocam_outlined),
                        title: Text('Capture a video'),
                      ),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.video_call_outlined, color: AppTheme.brown),
                        SizedBox(width: 8),
                        Text('Add recorded / captured video'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
