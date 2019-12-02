import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eyespace/constants/colors.dart';
import 'package:eyespace/containers/drawer/drawer.dart';
import 'package:eyespace/main.dart';
import 'package:firebase_livestream_ml_vision/firebase_livestream_ml_vision.dart';
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:flutter_speech_recognition/flutter_speech_recognition.dart';
import 'package:eyespace/containers/camera_view/detector_painters.dart';
import 'package:eyespace/AppLocalizations.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FirebaseVision _vision;
  List<ImageLabel> _scanResults;
  List<VisionEdgeImageLabel> _visionEdgeScanResults;
  VoiceController textToSpeech;
  RecognitionController speechRecognition;
  bool isListening = false;
  TextEditingController _controllerText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initSpeechRecognition();
    _initTextToSpeech();
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
      // final HttpsCallable dialogflow = CloudFunctions.instance
      //     .getHttpsCallable(functionName: 'detectIntent');
      // dialogflow.call(
      //   <String, dynamic>{
      //     'projectID': 'stepify-solutions',
      //     'sessionID': uid,
      //     'query': text,
      //     'languageCode':
      //         AppLocalizations.of(context).locale.toString() == 'pt_'
      //             ? 'pt-BR'
      //             : 'en'
      //   },
      // ).then((result) {
      //   if (result.data[0]['queryResult']['action'] != "image.identify") {
      //     textToSpeech.speak(result.data[0]['queryResult']['fulfillmentText'] ??
      //         "An error occurred, please try again!");
      //   } else if (result.data[0]['queryResult']['intent']['displayName'] ==
      //       "image.identify") {
      //     _speakObjects();
      //   } else if (result.data[0]['queryResult']['intent']['displayName'] ==
      //       "terrain.identify") {
      //     _speakTerrain();
      //   }
      // });
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
    _vision = FirebaseVision(
        cameras[0],
        ResolutionSetting.high);
    _vision.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  _speakObjects() {
    _vision.addImageLabeler().then((onValue){
        onValue.listen((onData){
          setState(() {
              _scanResults = onData;
            });
        });
      });
    if (_scanResults is! List<ImageLabel>) {
      defaultTargetPlatform == TargetPlatform.iOS &&
              MediaQuery.of(context).accessibleNavigation
          ? textToSpeech.speak(AppLocalizations.of(context).nothingdetected,
              VoiceControllerOptions(delay: 2))
          : textToSpeech.speak(AppLocalizations.of(context).nothingdetected);
    } else {
      String result = '';
      for (ImageLabel label in _scanResults.take(5)) {
        result = result + ", " + label.text;
      }
      defaultTargetPlatform == TargetPlatform.iOS &&
              MediaQuery.of(context).accessibleNavigation
          ? textToSpeech.speak(AppLocalizations.of(context).scenedata + result,
              VoiceControllerOptions(delay: 3))
          : textToSpeech.speak(AppLocalizations.of(context).scenedata + result);
    }
  }

  _speakTerrain() {
    _vision.addVisionEdgeImageLabeler('potholes', ModelLocation.Local).then((onValue){
        onValue.listen((onData){
          setState(() {
              _visionEdgeScanResults = onData;
            });
        });
      });
    if (_visionEdgeScanResults is! List<VisionEdgeImageLabel>) {
      defaultTargetPlatform == TargetPlatform.iOS &&
              MediaQuery.of(context).accessibleNavigation
          ? textToSpeech.speak(AppLocalizations.of(context).nothingdetected,
              VoiceControllerOptions(delay: 2))
          : textToSpeech.speak(AppLocalizations.of(context).nothingdetected);
    } else {
      for (VisionEdgeImageLabel label in _visionEdgeScanResults) {
        if (label.text == 'Asphalt') {
          defaultTargetPlatform == TargetPlatform.iOS &&
                  MediaQuery.of(context).accessibleNavigation
              ? textToSpeech.speak(AppLocalizations.of(context).roadclear,
                  VoiceControllerOptions(delay: 2))
              : textToSpeech.speak(AppLocalizations.of(context).roadclear);
        } else {
          defaultTargetPlatform == TargetPlatform.iOS &&
                  MediaQuery.of(context).accessibleNavigation
              ? textToSpeech.speak(AppLocalizations.of(context).roadnotclear,
                  VoiceControllerOptions(delay: 2))
              : textToSpeech.speak(AppLocalizations.of(context).roadnotclear);
        }
      }
    }
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

  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');

    if (_scanResults == null ||
        _vision == null ||
        !_vision.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _vision.value.previewSize.height,
      _vision.value.previewSize.width,
    );

    if (_scanResults is! List<ImageLabel>) return noResultsText;
    painter = LabelDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  @override
  void dispose() {
    _vision?.dispose();
    super.dispose();
  }

    Widget _buildImage() {
    final size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _vision == null
          ? const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                FirebaseCameraPreview(_vision),
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
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MeSuiteColors.blue,
        title: Text(AppLocalizations.of(context).title),
      ),
      drawer: DrawerContainer(),
      body: _buildImage(),
    );
  }
}
