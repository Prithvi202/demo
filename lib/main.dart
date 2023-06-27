import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'ImageScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  void clearImages() {
    setState(() {
      _capturedImages.clear();
    });
  }
  Timer? _recordingTimer;
  CameraController? _cameraController;
  List<Uint8List> _capturedImages = [];
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.high);

    await _cameraController!.initialize();

    await _cameraController!.setFlashMode(FlashMode.off);

    setState(() {});
  }

  void captureImage() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    await _cameraController!.setFlashMode(FlashMode.off);

    final XFile imageFile = await _cameraController!.takePicture();
    final Uint8List imageBytes = await imageFile.readAsBytes();

    setState(() {
      _capturedImages.add(imageBytes);
    });
  }

  void startRecording() {
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      captureImage();
    });
  }

  // void startRecording() {
  //   _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
  //     for (var i = 0; i < 10; i++) {
  //       Timer(Duration(milliseconds: (i * 100) + (timer.tick * 1000)), () {
  //         captureImage();
  //       });
  //     }
  //   });
  //
  //   setState(() {
  //     _isRecording = true;
  //   });
  // }

  void stopRecording() {
    _recordingTimer?.cancel();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          capturedImages: _capturedImages,
          clearImages: clearImages,
        ),
      ),
    ).then((_) {
      setState(() {
        _capturedImages.clear();
        _isRecording = false;
      });
    });
  }
  //
  // void clearImages() {
  //   setState(() {
  //     _capturedImages.clear();
  //   });
  // }
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container(); // Return an empty container or a loading indicator
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isRecording ? null : startRecording,
                style: ElevatedButton.styleFrom(
                  primary: _isRecording ? Colors.red : null,
                ),
                child: Text('Record'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: stopRecording,
                child: Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
