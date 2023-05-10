import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

class AudioListScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AudioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('audio').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final url = document['url'];

              return ListTile(
                title: Text('Audio ${index + 1}'),
                subtitle: Text(url),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerScreen(url: url),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final String url;

  const AudioPlayerScreen({super.key, required this.url});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
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
            const SizedBox(height: 16.0),
            const Text('Now Playing'),
            const SizedBox(height: 8.0),
            Text(widget.url),
          ],
        ),
      ),
    );
  }
}

// class AudioPlayerScreen extends StatefulWidget {
//   final String url;

//   const AudioPlayerScreen({required this.url});

//   @override
//   _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final _audioPlayer = AudioPlayer();
//   bool? isPlaying;
//   @override
//   void initState() {
//     super.initState();
//     _initializeAudioPlayer();
//   }

//   Future<void> _initializeAudioPlayer() async {
//     await _audioPlayer
//         .setAudioSource(ProgressiveAudioSource(Uri.parse(widget.url)));
//     await _audioPlayer.load();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _audioPlayer.dispose();
//   }

//   Future<void> _playAudio() async {
//     await _audioPlayer.play();
//     setState(() {
//       isPlaying = true;
//     });
//   }

//   Future<void> _pauseAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       isPlaying = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Player'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             isPlaying ?? false
//                 ? IconButton(
//                     icon: Icon(Icons.pause),
//                     onPressed: () {
//                       setState(() {
//                         _pauseAudio();
//                       });
//                     },
//                   )
//                 : IconButton(
//                     icon: Icon(Icons.play_arrow),
//                     onPressed: () {
//                       setState(() {
//                         _playAudio();
//                       });
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
