// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AudioUploadScreen extends StatefulWidget {
//   @override
//   _AudioUploadScreenState createState() => _AudioUploadScreenState();
// }

// class _AudioUploadScreenState extends State<AudioUploadScreen> {
//   File _audioFile = File("");
//   final _picker = FilePicker.platform;
//   final _storage = FirebaseStorage.instance;
//   final _firestore = FirebaseFirestore.instance;

//   Future<void> _selectAudio() async {
//     final pickedFile = await _picker.pickFiles(type: FileType.audio);
//     setState(() {
//       _audioFile = File(pickedFile!.files.single.path ?? "");
//     });
//   }

//   Future<void> _uploadAudio() async {
//     final fileName = _audioFile.path.split('/').last;
//     final destination = 'audio/$fileName';
//     final reference = _storage.ref().child(destination);
//     final uploadTask = reference.putFile(_audioFile);

//     await uploadTask.whenComplete(() => null);
//     final downloadUrl = await reference.getDownloadURL();
//     _firestore.collection('audio').add({'url': downloadUrl});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Audio'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _audioFile != null
//                 ? Text('Selected Audio: ${_audioFile.path}')
//                 : Text('No Audio Selected'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectAudio,
//               child: Text('Select Audio'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _audioFile != null ? _uploadAudio : null,
//               child: Text('Upload Audio'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioUploadScreen extends StatefulWidget {
  @override
  _AudioUploadScreenState createState() => _AudioUploadScreenState();
}

class _AudioUploadScreenState extends State<AudioUploadScreen> {
  File _audioFile = File("");
  final _picker = FilePicker.platform;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final _audioNameController = TextEditingController();

  Future<void> _selectAudio() async {
    final pickedFile = await _picker.pickFiles(type: FileType.audio);
    setState(() {
      _audioFile = File(pickedFile!.files.single.path ?? "");
      _audioNameController.text = _audioFile.path.split('/').last;
    });
  }

  Future<void> _uploadAudio() async {
    final fileName = _audioNameController.text.isEmpty
        ? _audioFile.path.split('/').last
        : _audioNameController.text;
    final destination = 'audio/$fileName';
    final reference = _storage.ref().child(destination);
    final uploadTask = reference.putFile(_audioFile);

    await uploadTask.whenComplete(() => null);
    final downloadUrl = await reference.getDownloadURL();
    _firestore.collection('audio').add({'url': downloadUrl});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Audio uploaded successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _audioFile != null
                ? Text('Selected Audio: ${_audioFile.path}')
                : Text('No Audio Selected'),
            SizedBox(height: 20),
            TextField(
              controller: _audioNameController,
              decoration: InputDecoration(
                hintText: 'Enter a new name for the audio file',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectAudio,
              child: Text('Select Audio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _audioFile != null ? _uploadAudio : null,
              child: Text('Upload Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
