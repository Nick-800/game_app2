import 'package:flutter/material.dart';
import 'package:game_app2/helpers/consts.dart';

class MainButton extends StatelessWidget {
  const MainButton({super.key, required this.label, required this.onPressed});
  final String label;

  final Function onPressed;

  @override
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(blueColor),
      ),
      onPressed: () {
        onPressed();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(label),
      ),
    );
  }
}
