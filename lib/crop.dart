import 'dart:async';
import 'dart:typed_data';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:native_opencv/edge_detection.dart';
import 'ImageUpdate.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'edge_detection_shape/edge_detection_shape.dart';
import 'edge_detector.dart';

class Crop extends StatefulWidget {
  @override
  _CropState createState() => _CropState();
}

class _CropState extends State<Crop> {
  EdgeDetectionResult edgeDetectionResult;
  String imagePath = null;
  String croppedImagePath = null;
  var iupdate;
  File img;
  GlobalKey imageWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final Uint8List data = await File(imageAssetPath).readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      return completer.complete(image);
    });
    return completer.future;
  }

  Widget _getEdgePaint(AsyncSnapshot<ui.Image> imageSnapshot, BuildContext context) {
    if (imageSnapshot.connectionState == ConnectionState.waiting)
      return Container();

    if (imageSnapshot.hasError) return Text('Error: ${imageSnapshot.error}');

    if (edgeDetectionResult == null) return Container();

    final keyContext = imageWidgetKey.currentContext;

    if (keyContext == null) {
      return Container();
    }

    final box = keyContext.findRenderObject() as RenderBox;

    return EdgeDetectionShape(
      originalImageSize: Size(imageSnapshot.data.width.toDouble(),
          imageSnapshot.data.height.toDouble()),
      renderedImageSize: Size(box.size.width, box.size.height),
      edgeDetectionResult: edgeDetectionResult,
    );
  }

  Future _detectEdges(String filePath) async {
    if (!mounted || filePath == null) {
      return;
    }

    setState(() {
      imagePath = filePath;
    });

    EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);

    setState(() {
      edgeDetectionResult = result;
    });

    if (croppedImagePath == null) {
      _processImage(imagePath, edgeDetectionResult);
    }
  }

  Future _processImage(
      String filePath, EdgeDetectionResult edgeDetectionResult) async {
    if (!mounted || filePath == null) {
      return;
    }

    bool result =
        await EdgeDetector().processImage(filePath, edgeDetectionResult);

    if (result == false) {
      return;
    }

    setState(() {
      croppedImagePath = imagePath;
      img= File(croppedImagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    iupdate = Provider.of<ImageUpdate>(context);
    img=iupdate.selected;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            title: Text(
              "Edit Image",
              style: new TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.save_alt,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    GallerySaver.saveImage(iupdate.selected.path);
                  },
                ),
              ),
            ],
          ),
          backgroundColor: Colors.deepOrange,
          bottomNavigationBar: CurvedNavigationBar(
            height: 50,
            buttonBackgroundColor: Colors.black87,
            backgroundColor: Colors.deepOrange,
            color: Colors.black87,
            animationCurve: Curves.linearToEaseOut,
            items: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.description,
                  color: Colors.white,
                ),
                iconSize: 30,
                splashColor: Colors.transparent,
              ),
              IconButton(
                icon: Icon(Icons.crop, color: Colors.white),
                iconSize: 30,
                splashColor: Colors.transparent,
                onPressed: () {
                  _detectEdges(img.path);
                },
              ),
              IconButton(
                icon: Icon(Icons.rotate_left, color: Colors.white),
                iconSize: 30,
                splashColor: Colors.transparent,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.rotate_right, color: Colors.white),
                iconSize: 30,
                splashColor: Colors.transparent,
                onPressed: () {
                  Transform.rotate(
                      angle: math.pi / 90.0,
                      child: Image.file(iupdate.selected));
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                iconSize: 30,
                splashColor: Colors.transparent,
                onPressed: () {},
              )
            ],
          ),
          body: Center(
            child: Stack(
              fit: StackFit.expand,
              children: [
                IconButton(icon: Icon(Icons.check),
                  onPressed:(){
                    iupdate.i=File(croppedImagePath);
                  },
                  alignment: Alignment.bottomRight,
                ),
                Image.file(
                  img,
                  key: imageWidgetKey,
                  fit: BoxFit.contain,
                ),
                FutureBuilder<ui.Image>(
                    future: loadUiImage(img.path),
                    builder: (BuildContext context,
                        AsyncSnapshot<ui.Image> snapshot) {
                      return _getEdgePaint(snapshot, context);
                    })
              ],
            ),
          )),
    );
  }
}
