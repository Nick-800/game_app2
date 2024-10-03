import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_app2/main.dart';
import 'package:game_app2/providers/auth_provider.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:game_app2/screens/game_details_screen.dart';
import 'package:game_app2/widgets/cards/game_card.dart';
import 'package:game_app2/widgets/clickables/buttons/main_button.dart';
import 'package:game_app2/widgets/clickables/drawer_tiles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).fetchGames("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GamesProvider, DarkModeProvider>(
        builder: (context, gamesProvider, dmc, _) {
      return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DrawerTile(
                      text: dmc.isDark ? "Light Mode" : "Dark Mode",
                      onTab: () {
            
                        Provider.of<DarkModeProvider>(context, listen: false)
                            .switchMode();
                      },
                      icon: dmc.isDark ? Icons.light_mode : Icons.dark_mode),
                  MainButton(
                      label: "Logout",
                      onPressed: () {
                        Provider.of<AuthenticationProvider>(context,
                                listen: false)
                            .logout()
                            .then((loggedIn) {
                          if (loggedIn) {
                            Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ScreenRouter(),
                              ),
                              (route) => false,
                            );
                          }
                        });
                      })
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: GridView.builder(
            itemCount: gamesProvider.busy ? 6 : gamesProvider.games.length,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: gamesProvider.busy
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.white38,
                          child: Container(
                            color: Colors.white,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GameDetailsScreen(
                                      gameId: gamesProvider.games[index].id
                                          .toString())));
                        },
                        child: GameCard(
                          gameModel: gamesProvider.games[index],
                        ),
                      ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: dmc.isDark ? Colors.white54 : Colors.black45,
          selectedLabelStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.bold, color: Colors.blue),
          unselectedLabelStyle:
              GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 12),
          onTap: (currentIndex) {
            setState(() {
              nowIndex = currentIndex;
            });

            gamesProvider.fetchGames(currentIndex == 0
                ? "all"
                : currentIndex == 1
                    ? "pc"
                    : "browser");
          },
          currentIndex: nowIndex,
          items: const [
            BottomNavigationBarItem(
              label: "ALL",
              icon: Icon(
                FontAwesomeIcons.gamepad,
              ),
            ),
            BottomNavigationBarItem(
                label: "PC", icon: Icon(FontAwesomeIcons.computer)),
            BottomNavigationBarItem(
                label: "WEB", icon: Icon(FontAwesomeIcons.globe)),
          ],
        ),
      );
    });
  }
}
