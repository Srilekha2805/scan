import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/pdf.dart';
import 'GridUpdate.dart';
import 'ImageUpdate.dart';
import 'dart:io';

import 'crop.dart';

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {

  @override
  Widget build(BuildContext context) {
    var lupdate=Provider.of<GridUpdate>(context);
    var iupdate=Provider.of<ImageUpdate>(context);
    List y=lupdate.generated;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar:AppBar(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),title:  Text("Selected Image",style: new TextStyle(color: Colors.white),), backgroundColor: Colors.black,
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
                  icon:Icon(Icons.picture_as_pdf,color: Colors.white,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Pdf()));
                  },),
              ),
            ]
        ) ,
        backgroundColor: Colors.deepOrange,

        body: Stack(
          children:[
            if(y.length == 1)...[
              Center(
                child:InkWell(
                  child: Image.file(y[0],width: 600,height: 600,),
                  onTap: (){
                    iupdate.i=y[0];
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>Crop()));
                  },
                )
              )
            ]
            else...[
              GridView.count(
                childAspectRatio: 1/2,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                children:List.generate(y.length, (index) {
                  File img = y[index];
                  return GridTile(
                      child:InkWell(
                        child: Image.file(img,width:300,
                          height: 300,),
                        onTap: (){
                          iupdate.i=img;
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>Crop()));
                        },
                      )
                  );
                }
                ),
           ),
        ]
          ],
        )
      ),
    );
  }
}
