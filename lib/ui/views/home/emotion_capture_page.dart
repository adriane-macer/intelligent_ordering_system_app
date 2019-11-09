import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligent_ordering_system/core/models/item.dart';
import 'package:intelligent_ordering_system/core/shared/custom_text_styles.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

class EmotionCapturePage extends StatefulWidget {
  @override
  _EmotionCapturePageState createState() => _EmotionCapturePageState();
}

class _EmotionCapturePageState extends State<EmotionCapturePage> {
  File _imageFile;
  bool isLoading = false;
  Emotion _emotion = Emotion.HAPPY;

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
      if (face.smilingProbability != null) {
        double smilingProbability = face.smilingProbability;
        _emotion = _emotionEquivalent(smilingProbability);
        break;
      }
    }
    if (mounted) {
      setState(() {
        Navigator.pop(context, _emotion);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading || (_imageFile == null)
            ? Center(
                child: Stack(children: <Widget>[
                  Container(
                    color: Colors.lightBlue,
                    child: Center(
                      child: Loading(
                          indicator: LineScalePulseOutIndicator(), size: 100.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Processing image",
                      style: CustomTextStyle.headerFade
                          .copyWith(fontSize: 24.0,color: Colors.white),
                    ),
                  ),
                ]),
              )
            : Container());
  }

  @override
  void initState() {
    super.initState();
    _getImageAndDetectFaces();
  }

  Emotion _emotionEquivalent(double smilingProbability) {
    if (smilingProbability >= 0.60) {
      return Emotion.HAPPY;
    } else if (smilingProbability < 0.60 && smilingProbability >= 0.40) {
      return Emotion.NORMAL;
    } else {
      return Emotion.SAD;
    }
  }
}
