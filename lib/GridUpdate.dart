import 'package:flutter/material.dart';

class GridUpdate extends ChangeNotifier{
  List i;

  set generated (newi){
    i=newi;
    notifyListeners();
  }

  List get generated=>i;

}