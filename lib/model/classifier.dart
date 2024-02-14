import 'package:image/image.dart' as img;
import 'package:reco/utils/classes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  /// Instance of Interpreter
  late Interpreter _interpreter;

  static const String modelFile = "model.tflite";

  static const int image_size = 180;

  static String? lastScanned;

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
    img.Image resizedImage =
        img.copyResize(image, width: image_size, height: image_size);

    List<double> inputBytes = List<double>.empty(growable: true);

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        var pixel = resizedImage.getPixel(x, y);
        inputBytes.add(pixel.r.toDouble());
        inputBytes.add(pixel.g.toDouble());
        inputBytes.add(pixel.b.toDouble());
      }
    }

    var output = List<double>.filled(6, 0).reshape([1, 6]);

    var input = inputBytes.reshape([1, image_size, image_size, 3]);

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
