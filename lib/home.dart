import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'GridUpdate.dart';

import 'select.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  var lupdate;
  List<Asset> images;
  List files=List<File>();
  Color gradientStart = Colors.deepOrange[300]; //Change start gradient color here
  Color gradientEnd = Colors.deepOrange; //Change end gradient color here

  @override
  void initState() {
    super.initState();
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        files.add(File(pickedFile.path));
        lupdate.i=files;
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Select()));
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> loadAssets() async {
    setState(() {
      images=[];
    });
    List<Asset> resultList = List<Asset>();
    List x=[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      print( e.toString());
    }

    if (!mounted) return;
    images.forEach((imageAsset) async {
      final filePath = await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        x.add(tempFile);
      }
    });

    setState(() {
      images = resultList;
      files=x;
      lupdate.i=files;
      files != null?Navigator.push(context, MaterialPageRoute(builder: (context)=>Select())):Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    lupdate=Provider.of<GridUpdate>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),title: Text("Scanner", style: TextStyle(fontSize: 18, color: Colors.white),), elevation: 20, backgroundColor: Colors.black87,
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search,color: Colors.white,),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.sort,color: Colors.white,),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.more_vert,color: Colors.white,),
                ),
              ],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              height: 50,
              buttonBackgroundColor: Colors.black87,
              backgroundColor:Colors.deepOrange,
              color: Colors.black87,
              animationCurve: Curves.linearToEaseOut,
              items: <Widget>[
                IconButton(
                  icon:Icon(Icons.description,color: Colors.white,),
                  iconSize: 30,
                  splashColor: Colors.transparent,
                ),
                IconButton(
                  icon:Icon(Icons.camera_alt,color: Colors.white),
                  iconSize: 30,
                  splashColor: Colors.transparent,
                  onPressed: (){
                    getImage();
                    
                  },
                ),
                IconButton(
                  icon:Icon(Icons.collections,color: Colors.white),
                  iconSize: 30,
                  splashColor: Colors.transparent,
                  onPressed: loadAssets 
                )
              ],

            ),
            body: Container(
                height: 800.0,
                decoration: new BoxDecoration(
                    color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
                    borderRadius: new BorderRadius.only(
                        topLeft:  const  Radius.circular(50.0),
                        topRight: const  Radius.circular(50.0))
                ),
                child: new Container(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(colors: [gradientStart, gradientEnd],
                          begin: const FractionalOffset(0.5, 0.0),
                          end: const FractionalOffset(0.0, 0.5),
                          stops: [0.0,1.0],
                          tileMode: TileMode.clamp
                      ),
                      borderRadius: new BorderRadius.only(
                          topLeft:  const  Radius.circular(50.0),
                          topRight: const  Radius.circular(50.0))
                  ),
                )
            )


        )

    );

  }
}