import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AudioRecorderDemoScreen extends StatefulWidget {
  const AudioRecorderDemoScreen({super.key});

  @override
  State<AudioRecorderDemoScreen> createState() => _AudioRecorderDemoScreenState();
}

class _AudioRecorderDemoScreenState extends State<AudioRecorderDemoScreen> {
  bool _recording = false;
  DateTime? _startedAt;

  void _toggleRecord() {
    setState(() {
      _recording = !_recording;
      _startedAt = _recording ? DateTime.now() : _startedAt;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_recording ? 'Recording started (demo UI)' : 'Recording stopped (demo UI)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      appBar: AppBar(title: const Text('Audio Recorder (Demo)')),
      backgroundColor: OsmeaColors.white,
      body: Center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _recording ? Icons.mic : Icons.mic_none,
              size: 72,
              color: _recording ? Colors.red : OsmeaColors.black,
            ),
            OsmeaComponents.sizedBox(height: 16),
            OsmeaComponents.text(
              _recording
                  ? 'Recording...\nStarted at: ${_startedAt?.toLocal().toIso8601String().substring(11, 19)}'
                  : 'Press Start to begin recording (Demo UI)',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.black,
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: 24),
            OsmeaComponents.row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OsmeaComponents.button(
                  onPressed: _toggleRecord,
                  text: _recording ? 'Stop' : 'Start',
                  icon: Icon(_recording ? Icons.stop : Icons.fiber_manual_record),
                ),
                OsmeaComponents.sizedBox(width: 12),
                OsmeaComponents.button(
                  onPressed: _recording ? null : () => Navigator.of(context).maybePop(),
                  text: 'Close',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
