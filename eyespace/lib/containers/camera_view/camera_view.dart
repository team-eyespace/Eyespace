import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:eyespace/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CameraView extends StatefulWidget {
  @override
  CameraViewState createState() {
    return new CameraViewState();
  }
}

class CameraViewState extends State<CameraView> {
  CameraController controller;
  Directory storage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async{
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    storage = await getApplicationDocumentsDirectory();
    await controller.initialize();
    setState(() {});
    _takePicture();
  }

  _takePicture() async{
    File image = File(storage.path+'/image.jpg');
    await image.delete();
    await controller.takePicture(storage.path+'/image.jpg');
    String b64 = base64Encode(await image.readAsBytes());
    final dynamic result = await CloudFunctions.instance.call(
      functionName: 'detectGenContext',
      parameters: <String, dynamic>{
        'query': b64,
      },
    );
    await image.delete();
    print(result);
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
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
