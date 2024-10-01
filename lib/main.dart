import 'package:flutter/material.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:game_app2/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:game_app2/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamesProvider>(create: (_) => GamesProvider()),
        ChangeNotifierProvider<DarkModeProvider>(
            create: (_) => DarkModeProvider())
      ],
      child:
          Consumer<DarkModeProvider>(builder: (context, darkModeConsumer, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            dividerTheme: DividerThemeData(
              color: darkModeConsumer.isDark ? Colors.white24 : Colors.black26,
            ),
            tabBarTheme: TabBarTheme(
            labelColor: darkModeConsumer.isDark ? Colors.white : Colors.blueGrey),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: darkModeConsumer.isDark ? Colors.white24 : Colors.white
              
            ),
            appBarTheme: const AppBarTheme(
            centerTitle: true, backgroundColor: Colors.blue),
            drawerTheme: DrawerThemeData(
            backgroundColor: darkModeConsumer.isDark ? Colors.black : Colors.white),
            scaffoldBackgroundColor: darkModeConsumer.isDark ? Colors.black : Colors.white,
            textTheme: GoogleFonts.cairoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: false,
          ),
          home: const HomeScreen(),
        );
      }),
    );
  }
}
