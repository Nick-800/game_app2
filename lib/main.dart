import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_app2/firebase_options.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:game_app2/screens/home_screen.dart';
import 'package:game_app2/screens/loginscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:game_app2/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
                labelColor:
                    darkModeConsumer.isDark ? Colors.white : Colors.blueGrey),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor:
                    darkModeConsumer.isDark ? Colors.white24 : Colors.white),
            appBarTheme: const AppBarTheme(
                centerTitle: true, backgroundColor: Colors.blue),
            drawerTheme: DrawerThemeData(
                backgroundColor:
                    darkModeConsumer.isDark ? Colors.black : Colors.white),
            scaffoldBackgroundColor:
                darkModeConsumer.isDark ? Colors.black : Colors.white,
            textTheme: GoogleFonts.cairoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: false,
          ),
          home: const ScreenRouter(),
        );
      }),
    );
  }
}

class ScreenRouter extends StatefulWidget {
  const ScreenRouter({super.key});

  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return firebaseAuth.currentUser != null
        ? const HomeScreen()
        : const Loginscreen();
  }
}
