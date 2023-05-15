import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String url;

  const AudioPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.setUrl(widget.url);
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _deleteAudioFile() async {
    final docRef =
        FirebaseFirestore.instance.collection('audio').doc(widget.url);
    await docRef.delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Audio Player'),
        actions: [
          IconButton(
            onPressed: _deleteAudioFile,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (_isPlaying) {
                  await _audioPlayer.pause();
                } else {
                  await _audioPlayer.play();
                }
              },
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 64.0,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            const Text('Now Playing'),
            Text(
              widget.url,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
