import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:eyespace/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:eyespace/containers/camera_view/detector_painters.dart';
import 'package:eyespace/containers/camera_view/utils.dart';

class CameraView extends StatefulWidget {
  @override
  CameraViewState createState() {
    return new CameraViewState();
  }
}

class CameraViewState extends State<CameraView> {
  List<ImageLabel> _scanResults;
  bool _isDetecting = false;
  CameraController controller;
  FlutterTts flutterTts;
  SpeechRecognition _speech = SpeechRecognition();
  bool isListening = false;
  TextEditingController _controllerText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initTts();
  }

  Future _cancelRecognitionHandler() async {
    final res = await _speech.cancel();
    if (_controllerText.text != "") {
      _requestChatBot(_controllerText.text, raid.data['uid'] ?? "");
    }
    _controllerText.text = "";
    setState(() {
      isListening = res;
    });
  }

  Future _cancelRecognition() async {
    final res = await _speech.stop();
    _controllerText.text = "";
    setState(() {
      isListening = res;
    });
  }

  Future _stopRecognition() async {
    final res = await _speech.stop();
    setState(() {
      isListening = res;
    });
  }

  Future _startRecognition() async {
    setState(() {
      isListening = true;
    });
    await _speech.activate();
    await _speech.listen(locale: 'en_US'); //LOCALIZATION
    _speech.setRecognitionResultHandler((handler) {
      _controllerText.text = handler;
    });
    _speech.setRecognitionCompleteHandler((out) {
      setState(() {
        isListening = false;
      });
      _requestChatBot(_controllerText.text, raid.data['uid'] ?? "");
    });
  }

  _requestChatBot(String text, String uid) {
    _controllerText.clear();
    CloudFunctions.instance.call(
      functionName: 'detectIntent',
      parameters: <String, dynamic>{
        'projectID': 'stepify-solutions',
        'sessionID': uid,
        'query': text,
        'languageCode': 'en' //LOCALIZATION
      },
    ).then((result) {
      if (result[0]['queryResult']['action'] != "image.identify") {
        flutterTts.speak(result[0]['queryResult']['fulfillmentText'] ??
            "An error occurred, please try again!");
      } else if (result[0]['queryResult']['intent']['displayName'] ==
          "image.identify") {
        _speakObjects();
      }
    });
  }

  _initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage('en_US');
  }

  _initCamera() async {
    final FirebaseVision mlVision = FirebaseVision.instance;
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
    controller.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      detect(image, mlVision.imageLabeler().processImage).then(
        (dynamic result) {
          setState(() {
            _scanResults = result;
          });

          _isDetecting = false;
        },
      ).catchError(
        (_) {
          _isDetecting = false;
        },
      );
    });
  }

  _speakObjects() {
    if (_scanResults is! List<ImageLabel>) {
      flutterTts.speak("Nothing detected!");
    } else {
      String result = '';
      for (ImageLabel label in _scanResults.take(5)) {
        result = result + ", " + label.text;
      }
      flutterTts.speak("The scene contains the following " + result);
    }
  }

  _cameraPreview() {
    return CameraPreview(controller);
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPress, {
    Color color: Colors.grey,
    Color backgroundColor: Colors.pinkAccent,
  }) {
    return new FloatingActionButton(
        child: new Icon(icon),
        onPressed: onPress,
        backgroundColor: backgroundColor);
  }

  _buildNothing() {
    return Container();
  }

  _buildComposer({double width}) {
    return Container(
        width: width,
        color: Colors.grey.shade200,
        child: new Row(
          children: <Widget>[
            Flexible(
              child: new Padding(
                  padding: new EdgeInsets.all(8.0),
                  child: new TextField(
                    controller: _controllerText,
                    decoration: InputDecoration.collapsed(hintText: ""),
                    onTap: _stopRecognition,
                    onSubmitted: (String out) {
                      if (_controllerText.text == "") {
                        return;
                      } else {
                        _requestChatBot(
                            _controllerText.text, raid.data['uid'] ?? "");
                      }
                    },
                  )),
            ),
            new IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade600),
              onPressed: () {
                _controllerText.text = "";
                _cancelRecognition();
              },
            ),
          ],
        ));
  }

  _captureControlRowWidget(var size) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            width: double.infinity,
            height: 120.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FloatingActionButton(
                          child: new Icon(Icons.camera),
                          onPressed: _speakObjects,
                          backgroundColor: Colors.blueAccent),
                      !isListening
                          ? _buildIconButton(Icons.mic, _startRecognition,
                              backgroundColor: Colors.blue, color: Colors.blue)
                          : _buildIconButton(
                              Icons.mic_off,
                              isListening ? _cancelRecognitionHandler : null,
                              color: Colors.redAccent,
                              backgroundColor: Colors.redAccent,
                            ),
                    ])
              ],
            )));
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');

    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      controller.value.previewSize.height,
      controller.value.previewSize.width,
    );

    if (_scanResults is! List<ImageLabel>) return noResultsText;
    painter = LabelDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Positioned.fill(
          child: new Transform.scale(
            scale: controller.value.aspectRatio / deviceRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: _cameraPreview(),
              ),
            ),
          ),
        ),
        _buildResults(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                height: 180.0,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        isListening || _controllerText.text != ""
                            ? _buildComposer(width: size.width - 40)
                            : _buildNothing(),
                      ],
                    ),
                  ],
                ))),
        _captureControlRowWidget(size),
      ],
    );
  }
}
