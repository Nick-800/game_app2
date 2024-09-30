import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:game_app2/screens/game_details.dart';
import 'package:game_app2/widgets/cards/game_card.dart';
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
    return Consumer<GamesProvider>(
      builder: (context, gamesProvider, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: GridView.builder(
              itemCount: gamesProvider.isLoading ? 6 : gamesProvider.games.length,
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
                  child: gamesProvider.isLoading
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
                            Navigator.push(context,MaterialPageRoute(builder: (contex)=>GameDetailsScreen(gameId: gamesProvider.games[index].id.toString()))
                                );
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
            selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold),
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
                  label: "ALL", icon: Icon(FontAwesomeIcons.gamepad)),
              BottomNavigationBarItem(
                  label: "PC", icon: Icon(FontAwesomeIcons.computer)),
              BottomNavigationBarItem(
                  label: "WEB", icon: Icon(FontAwesomeIcons.globe)),
            ],
          ),
        );
      }
    );
  }
}
