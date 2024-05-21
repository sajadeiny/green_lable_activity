import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassifierPage extends StatefulWidget {
  @override
  _ImageClassifierPageState createState() => _ImageClassifierPageState();
}

class _ImageClassifierPageState extends State<ImageClassifierPage> {
  XFile? _image;
  late Interpreter _interpreter;
  List<String> _labels = ["Academic Activity",
    "Cultural, Art, and Sport Activity",
    "Health Care Activity",
    "Social Responsibility"];
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final interpreterOptions = InterpreterOptions()..threads = 2;
      _interpreter = await Interpreter.fromAsset('model/fine_tuned_mobilenetv2.tflite', options: interpreterOptions);
      await _loadLabels();
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelTxt = await rootBundle.loadString('model/label.txt');
      _labels = labelTxt.split('\n').where((label) => label.isNotEmpty).toList();
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _performInference(image);
    }
  }

  Future<void> _performInference(XFile imageFile) async {
    try {
      // Placeholder for image preprocessing based on your model's requirements
      // For simplicity, we assume the model expects a 224x224 image with 3 color channels (RGB)
      final input = await _imageToByteList(imageFile, 224, 224);

      // Perform inference
      var output = List.filled(4, 0.0); // Assuming your output is [1, 4]

      _interpreter.run(input, [output]);
      print(output);
      final result = output.first;
      print(result);

      // Placeholder for post-processing the output
      // Modify this based on your model's output format

      // Find the index of the maximum value as the predicted class
      //var maxIndex = output.indexOf(output.reduce((curr, next) => curr > next ? curr : next));
      int maxIndex = result.toInt();
      // Update confidence and label
      //_confidence = result.toInt();

      // Update the UI
      setState(() {
        _image = imageFile;
      });

      // Display classification results
      _showResultsDialog(maxIndex);
    } catch (e) {
      print('Error during inference: $e');
    }
  }

  void _showResultsDialog(int predictedIndex) {
    String label;

    if (predictedIndex == 0) {
      label = "Academic";
    } else if (predictedIndex == 1) {
      label = "Cultural, Art, and Sport";
    } else if (predictedIndex == 2) {
      label = "Health Care";
    } else if (predictedIndex == 3) {
      label = "Social Responsibility";
    } else {
      label = "Unknown Activity";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Classification Results'),
        content: Column(
          children: [
            Image.file(File(_image!.path)),
            SizedBox(height: 10),
            Text('Activity Taype: $label'),
            //Text('Confidence: ${(_confidence * 100).toStringAsFixed(2)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<List<List<List<List<int>>>>> _imageToByteList(XFile image, int inputSizeHeight, int inputSizeWidth) async {
    final ByteData data = await image.readAsBytes().then((value) => ByteData.sublistView(value));
    final buffer = data.buffer.asUint8List();

    // Placeholder for image preprocessing based on your model's requirements
    // For simplicity, this assumes a 224x224 image with 3 color channels (RGB)
    List<List<List<List<int>>>> input = List.generate(
      1,
          (index) => List.generate(
        inputSizeHeight,
            (index) => List.generate(
          inputSizeWidth,
              (index) => List.generate(3, (index) => buffer[index]),
        ),
      ),
    );

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classifier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}

