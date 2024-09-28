import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_app/screens/game_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:game_app/models/game_model.dart';
import 'package:game_app/widgets/cards/game_card.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int nowIndex = 0;
  bool isLoading = false;
  List<GameModel> games = [];
  List<GameDetails>  gameDetails = [];


  fetchGames(String platform) async {
    setState(() {
      isLoading = true;
    });

    games.clear();
    final response = await http.get(
        Uri.parse("https://www.freetogame.com/api/games?platform=$platform"));

    if (kDebugMode) {
      print("STATUS CODE : ${response.statusCode}");
      print("BODY : ${response.body}");
    }

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      games =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchGames("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GridView.builder(
          itemCount: isLoading ? 6 : games.length,
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
              child: isLoading
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
                  : GameCard(gameModel: games[index],
                             onCardTap: (gameModel){
                              print("Card Tapped ${gameModel.id}");
                             },),
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

          fetchGames(currentIndex == 0
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
}
