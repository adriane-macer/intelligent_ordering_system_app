import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_ordering_system/ui/face_painter.dart';

class ImageCapturePage extends StatefulWidget {
  @override
  _ImageCapturePageState createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  File _imageFile;
  List<Face> _faces = [];
  bool isLoading = false;
  ui.Image _image;
  double _smilingProbability = 0.0;

  _getImageAndDetectFaces() async {
    final capturedImage =
        await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(capturedImage);
    final faceDetector = FirebaseVision.instance
        .faceDetector(FaceDetectorOptions(enableClassification: true));
    List<Face> faces = await faceDetector.processImage(image);

    for (var face in faces) {
      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        _smilingProbability = face.smilingProbability;
      }
    }
    if (mounted) {
      setState(() {
        _imageFile = capturedImage;
        _faces = faces;
        _loadImage(capturedImage);
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _image = value;
        isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : (_imageFile == null)
                    ? Center(child: Text('No image selected'))
                    : Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: FittedBox(
                                  child: SizedBox(
                                    width: _image.width.toDouble(),
                                    height: _image.height.toDouble(),
                                    child: CustomPaint(
                                      painter: FacePainter(_image, _faces),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (_faces.length > 0)
                                    ? Text(
                                        "Smiling probability = $_smilingProbability")
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (_faces.length > 0)
                                    ? _emotion(_smilingProbability)
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  child: _image == null
                      ? Text(
                          "Capture",
                          style: TextStyle(color: Colors.white),
                        )
                      : Text(
                          "Retake",
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    _getImageAndDetectFaces();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: (_faces.length > 0)
                      ? RaisedButton(
                          color: Colors.green,
                          child: Text(
                            "Show product suggestions",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            //TODO add implementation
                          },
                        )
                      : Container(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emotion(double smilingProbability) {
    if (smilingProbability >= 0.60) {
      return Text(
        "Happy",
        style: TextStyle(color: Colors.green),
      );
    } else if (smilingProbability < 0.60 && smilingProbability >= 0.40) {
      return Text(
        "Normal",
        style: TextStyle(color: Colors.blue),
      );
    } else {
      return Text("Sad", style: TextStyle(color: Colors.red));
    }
  }
}
