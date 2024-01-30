import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:reco/utils/classes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  /// Instance of Interpreter
  late Interpreter _interpreter;

  static const String modelFile = "model.tflite";

  /// Loads interpreter from asset
  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ??
          await Interpreter.fromAsset(
            modelFile,
            //options: InterpreterOptions()..threads = 4,
          );

      _interpreter.allocateTensors();
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }

  /// Gets the interpreter instance
  Interpreter get interpreter => _interpreter;

  Future<DetectionClasses> predict(img.Image image) async {
    img.Image resizedImage = img.copyResize(image, width: 180, height: 180);

    // Convert the resized image to a 1D Float32List.
    Float32List inputBytes = Float32List(1 * 180 * 180 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        var pixel = resizedImage.getPixel(x, y);
        inputBytes[pixelIndex++] = pixel.r.toDouble();
        inputBytes[pixelIndex++] = pixel.g.toDouble();
        inputBytes[pixelIndex++] = pixel.b.toDouble();
      }
    }

    final output = Float32List(1 * 6).reshape([1, 6]);

    // Reshape to input format specific for model. 1 item in list with pixels 150x150 and 3 layers for RGB
    final input = inputBytes.reshape([1, 180, 180, 3]);
    try {
      interpreter.run(input, output);
      final predictionResult = output[0] as List<double>;
      double maxElement = predictionResult.reduce(
        (double maxElement, double element) =>
            element > maxElement ? element : maxElement,
      );
      return DetectionClasses.values[predictionResult.indexOf(maxElement)];
    } catch (e) {
      print(e);
    }
    return DetectionClasses.other;
  }
}
