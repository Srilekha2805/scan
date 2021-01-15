import 'package:flutter/material.dart';
import 'dart:io';
import 'GridUpdate.dart';

class ImageUpdate extends ChangeNotifier{
  File i;
  GridUpdate g = new GridUpdate();

  set selected(newi)
  {
    i=newi;
    final index=g.generated.indexOf(newi);
    g.generated[index]=newi;
    notifyListeners();
  }

  File get selected=>i;

}