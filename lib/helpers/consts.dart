// String basUrl

import 'package:flutter/material.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:provider/provider.dart';

DarkModeProvider dmc = DarkModeProvider();

Color bnw = dmc.isDark ? Colors.red : Colors.blue;
