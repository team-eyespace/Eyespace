import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:eyespace/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:flutter_speech_recognition/flutter_speech_recognition.dart';
import 'package:firebase_mlvision/firebase_mlvision.dart';
import 'package:eyespace/containers/camera_view/utils.dart';
import 'package:eyespace/AppLocalizations.dart';

class CameraView extends StatefulWidget {
  @override
  CameraViewState createState() {
    return new CameraViewState();
  }
}

class CameraViewState extends State<CameraView> {
  List<ImageLabel> _scanResults;
  List<VisionEdgeImageLabel> _visionEdgeScanResults;
  bool _isDetecting = false;
  CameraController controller;
  VoiceController textToSpeech;
  RecognitionController speechRecognition;
  bool isListening = false;
  TextEditingController _controllerText = new TextEditingController();
  final FirebaseVision mlVision = FirebaseVision.instance;
  HandleDetection currentDetector;
  VisionEdgeImageLabeler potholeDetector;
  ImageLabeler imageLabeler;

  @override
  void initState() {
    super.initState();
    potholeDetector =
        mlVision.visionEdgeImageLabeler('potholes', ModelLocation.Local);
    imageLabeler = mlVision.imageLabeler();
    _initCamera();
    _initTextToSpeech();
    _initSpeechRecognition();
  }

  Future _cancelRecognitionHandler() async {
    speechRecognition.stop().then((onValue) {
      setState(() {
        isListening = false;
      });
    });
    if (_controllerText.text != "") {
      _requestChatBot(_controllerText.text, raid.data['uid'] ?? "");
    }
    _controllerText.text = "";
  }

  Future _cancelRecognition() async {
    speechRecognition.stop().then((onValue) {
      setState(() {
        isListening = false;
      });
    });
    _controllerText.text = "";
  }

  Future _stopRecognition() async {
    speechRecognition.stop().then((onValue) {
      setState(() {
        isListening = false;
      });
    });
  }

  Future _startRecognition() async {
    setState(() {
      isListening = true;
    });
    speechRecognition.recognize().listen((onData) {
      _controllerText.text = onData;
    }, onDone: () {
      _requestChatBot(_controllerText.text, raid.data['uid'] ?? "");
      _controllerText.text = "";
      speechRecognition.stop().then((onValue) {
        setState(() {
          isListening = false;
        });
      });
    });
  }

  _requestChatBot(String text, String uid) {
    if (text == "") {
      _controllerText.clear();
    } else {
      _controllerText.clear();
      final HttpsCallable dialogflow = CloudFunctions.instance
          .getHttpsCallable(functionName: 'detectIntent');
      dialogflow.call(
        <String, dynamic>{
          'projectID': 'stepify-solutions',
          'sessionID': uid,
          'query': text,
          'languageCode':
              AppLocalizations.of(context).locale.toString() == 'pt_'
                  ? 'pt-BR'
                  : 'en'
        },
      ).then((result) {
        if (result.data[0]['queryResult']['action'] != "image.identify") {
          textToSpeech.speak(result.data[0]['queryResult']['fulfillmentText'] ??
              "An error occurred, please try again!");
        } else if (result.data[0]['queryResult']['intent']['displayName'] ==
            "image.identify") {
          _speakObjects();
        } else if (result.data[0]['queryResult']['intent']['displayName'] ==
            "terrain.identify") {
          _speakTerrain();
        }
      });
    }
  }

  _initTextToSpeech() async {
    textToSpeech = FlutterTextToSpeech.instance.voiceController();
    await textToSpeech.init();
  }

  _initSpeechRecognition() async {
    speechRecognition = FlutterSpeechRecognition.instance.voiceController();
    await speechRecognition.init();
  }

  _initCamera() async {
    currentDetector = imageLabeler.processImage;
    controller = CameraController(
        cameras[0],
        defaultTargetPlatform == TargetPlatform.iOS
            ? ResolutionPreset.low
            : ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      controller.startImageStream((CameraImage image) {
        if (_isDetecting) return;
        _isDetecting = true;
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          detect(image, currentDetector).then(
            (dynamic result) {
              setState(() {
                result is List<ImageLabel>
                    ? _scanResults = result
                    : _visionEdgeScanResults = result;
              });
              _isDetecting = false;
            },
          ).catchError(
            (_) {
              _isDetecting = false;
            },
          );
        });
      });
    });
  }

  _speakObjects() {
    currentDetector = imageLabeler.processImage;
    if (_scanResults is! List<ImageLabel>) {
      defaultTargetPlatform == TargetPlatform.iOS
          ? textToSpeech.speak(AppLocalizations.of(context).nothingdetected,
              VoiceControllerOptions(delay: 2))
          : textToSpeech.speak(AppLocalizations.of(context).nothingdetected);
    } else {
      String result = '';
      for (ImageLabel label in _scanResults.take(5)) {
        result = result + ", " + label.text;
      }
      defaultTargetPlatform == TargetPlatform.iOS
          ? textToSpeech.speak(AppLocalizations.of(context).scenedata + result,
              VoiceControllerOptions(delay: 3))
          : textToSpeech.speak(AppLocalizations.of(context).scenedata + result);
    }
  }

  _speakTerrain() {
    currentDetector = potholeDetector.processImage;
    if (_visionEdgeScanResults is! List<VisionEdgeImageLabel>) {
      defaultTargetPlatform == TargetPlatform.iOS
          ? textToSpeech.speak(AppLocalizations.of(context).nothingdetected,
              VoiceControllerOptions(delay: 2))
          : textToSpeech.speak(AppLocalizations.of(context).nothingdetected);
    } else {
      for (VisionEdgeImageLabel label in _visionEdgeScanResults) {
        if (label.text == 'Asphalt') {
          defaultTargetPlatform == TargetPlatform.iOS
              ? textToSpeech.speak(AppLocalizations.of(context).roadclear,
                  VoiceControllerOptions(delay: 2))
              : textToSpeech.speak(AppLocalizations.of(context).roadclear);
        } else {
          defaultTargetPlatform == TargetPlatform.iOS
              ? textToSpeech.speak(AppLocalizations.of(context).roadnotclear,
                  VoiceControllerOptions(delay: 2))
              : textToSpeech.speak(AppLocalizations.of(context).roadnotclear);
        }
      }
    }
  }

  _cameraPreview() {
    return CameraPreview(controller);
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
                  child: Semantics(
                    child: new TextField(
                      controller: _controllerText,
                      decoration: InputDecoration.collapsed(hintText: ""),
                      onTap: _stopRecognition,
                      onSubmitted: (String out) {
                        _requestChatBot(
                            _controllerText.text, raid.data['uid'] ?? "");
                      },
                    ),
                    textField: true,
                    label: AppLocalizations.of(context).edit,
                  )),
            ),
            new Semantics(
              child: new IconButton(
                icon: Icon(Icons.close, color: Colors.grey.shade600),
                onPressed: () {
                  _controllerText.text = "";
                  _cancelRecognition();
                },
              ),
              liveRegion: false,
              button: true,
              label: AppLocalizations.of(context).cancel,
            )
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
                      Semantics(
                        child: FloatingActionButton(
                          child: new Icon(Icons.accessibility_new),
                          heroTag: "speakObjects",
                          onPressed: _speakObjects,
                          backgroundColor: Colors.blue,
                        ),
                        liveRegion: false,
                        button: true,
                        label: AppLocalizations.of(context).cameratext,
                      ),
                      Semantics(
                        child: FloatingActionButton(
                          child: new Icon(Icons.accessible),
                          heroTag: "detectTerrain",
                          onPressed: _speakTerrain,
                          backgroundColor: Colors.blue,
                        ),
                        liveRegion: false,
                        button: true,
                        label: AppLocalizations.of(context).terraindetecttext,
                      ),
                      !isListening
                          ? Semantics(
                              child: FloatingActionButton(
                                child: new Icon(Icons.mic),
                                heroTag: "mic",
                                onPressed: _startRecognition,
                                backgroundColor: Colors.blue,
                              ),
                              liveRegion: false,
                              button: true,
                              label: AppLocalizations.of(context).mictext,
                            )
                          : Semantics(
                              child: FloatingActionButton(
                                child: new Icon(Icons.mic_off),
                                heroTag: "mic",
                                onPressed: isListening
                                    ? _cancelRecognitionHandler
                                    : null,
                                backgroundColor: Colors.redAccent,
                              ),
                              liveRegion: false,
                              button: true,
                              label: AppLocalizations.of(context).micofftext,
                            ),
                    ])
              ],
            )));
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
