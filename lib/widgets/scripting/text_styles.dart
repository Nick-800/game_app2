import 'package:flutter/material.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:provider/provider.dart';

class TextDm extends StatefulWidget {
  const TextDm({super.key, required this.txt});
  final String txt;

  @override
  State<TextDm> createState() => _TextDmState();
}

class _TextDmState extends State<TextDm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder:  (context, darkModeConsumer, _){
      return Text(widget.txt, style: TextStyle(color: darkModeConsumer.isDark
                ? Colors.black12
                : Colors.blue.withOpacity(0.1) ),);
  });
  }
}
