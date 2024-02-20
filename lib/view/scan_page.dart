import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reco/model/classifier.dart';
import 'package:reco/utils/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:reco/utils/classes.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.callback});

  final void Function() callback;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late CameraController cameraController;
  late Interpreter interpreter;
  final predictor = Classifier();

  bool initialized = false;
  DetectionClasses detected = DetectionClasses.other;
  DateTime lastShot = DateTime.now();

  late CameraImage currentFrame;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await predictor.loadModel();

    final cameras = await availableCameras();
    // Create a CameraController object
    cameraController = CameraController(
      cameras[0], // Choose the first camera in the list
      ResolutionPreset.medium, // Choose a resolution preset
    );

    // Initialize the CameraController and start the camera preview
    await cameraController.initialize();
    // Listen for image frames
    await cameraController.startImageStream((image) {
      // Make predictions every 1 second to avoid overloading the device
      if (DateTime.now().difference(lastShot).inSeconds > 0.5) {
        // processCameraImage(image);
        currentFrame = image;
      }
    });

    setState(() {
      initialized = true;
    });
  }

  Future<void> processCameraImage() async {
    final convertedImage = ImageUtils.convertYUV420ToImage(currentFrame);

    final result = await predictor.predict(convertedImage);

    if (detected != result) {
      setState(() {
        detected = result;
        detected = DetectionClasses.plastic;
      });
    }

    lastShot = DateTime.now();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized
        ? Column(
            children: [
              Stack(children: [
                Container(
                  child: CameraPreview(cameraController),
                  width: 500,
                  height: 500,
                ),
                //Button
                Positioned(
                  bottom: 0,
                  right: 100,
                  left: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      child: const Icon(Icons.camera_alt),//const Text("Take photo"),
                      onPressed: () {
                        processCameraImage();
                      },
                    ),
                  ),
                ),
              ]),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: detected.labelContainer,//Text("Object  is : ${detected.label}"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: detected.promptContainer,//Text("Object  is : ${detected.label}"),
              ),
              if (detected != DetectionClasses.other) Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: ElevatedButton(
                  child: const Text("Show Locations"),
                  onPressed: () {
                    Classifier.lastScanned = detected.label;
                    widget.callback();
                  },
                ),
              )
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
