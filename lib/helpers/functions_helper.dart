import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';




// ignore: non_constant_identifier_names
LaunchExternalUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

showFlush(String title, String message, BuildContext context) {
  Flushbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
  ).show(context);
}

