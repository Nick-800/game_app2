import 'package:flutter/material.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:game_app2/widgets/cards/game_card.dart';
import 'package:game_app2/widgets/clickables/dialogs/delete_favorite_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteGamesScreen extends StatefulWidget {
  const FavoriteGamesScreen({super.key});

  @override
  State<FavoriteGamesScreen> createState() => _FavoriteGamesScreenState();
}

class _FavoriteGamesScreenState extends State<FavoriteGamesScreen> {
  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).getFavoriteGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("FAVORITE GAMES"),
        ),
        body: Center(
            child: GridView.builder(
                itemCount:
                    gamesConsumer.busy ? 6 : gamesConsumer.favGames.length,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: gamesConsumer.busy
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Shimmer.fromColors(
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.white38,
                                  child: Container(
                                    color: Colors.white,
                                    height: double.infinity,
                                    width: double.infinity,
                                  )),
                            )
                          : GameCard(gameModel: gamesConsumer.favGames[index], onLongPress: (){


                             showDialog(
                              
                                    context: context,
                                    builder: (context) {
                                      return DeleteFavoriteDialog(
                                        gameModel: gamesConsumer.games[index],
                                      );
                                    });
                          },));
                })),
      );
    });
  }
}
