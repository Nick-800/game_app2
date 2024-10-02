import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//--------------API-------------------------

String baseUrl = '';

//------------------COLORS--------------------------

Color blueColor = Colors.blue;
Color redColor = Colors.red;
Color greenColor = Colors.green;
Color blueGreyColor = Colors.blueGrey;
Color greyColor = Colors.grey;
Color whiteColor = Colors.white;
Color blackColor = Colors.black;

//-------------------------TEXT STYLES ------------------------

TextStyle largeTitle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

//-------------Debug Functions------------------------

void printDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}
