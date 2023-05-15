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
              final url = document['name'];

              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.orange,
                    width: 2, //<-- SEE HERE
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ListTile(
                  title: Text(url),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AudioPlayerScreen(url: url),
                      ),
                    );
                  },
                ),
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
      backgroundColor: Colors.amber,
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            const Text('Now Playing'),
            Text(
              widget.url,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
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
