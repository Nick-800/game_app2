import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_app2/helpers/functions_helper.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/GameCardModel.dart';
import 'package:flutter/material.dart';
import 'package:game_app2/helpers/consts.dart';
import 'package:game_app2/widgets/clickables/buttons/main_button.dart';

class AddToFavoriteDialog extends StatefulWidget {
  const AddToFavoriteDialog({super.key, required this.gameModel});
  final GameModel gameModel;
  @override
  State<AddToFavoriteDialog> createState() => _AddToFavoriteDialogState();
}

class _AddToFavoriteDialogState extends State<AddToFavoriteDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return AlertDialog(
        title: const Text("Add to Favorites"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to add this game to favorite?"),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainButton(
                    inProgress: gamesConsumer.busy,
                    horizontalPadding: 16,
                    label: "Add",
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        GameModel tgm = widget.gameModel;

                        tgm.uid = FirebaseAuth.instance.currentUser!.uid;
                        await Provider.of<GamesProvider>(context, listen: false)
                            .addToFavorite(tgm)
                            .then((added) {
                          if (added) {
                            showFlush("Added", "Added Successfully", context);

                            Timer(const Duration(seconds: 3), () {
                              Navigator.pop(context);
                            });
                          } else {
                            showFlush("Failed", "Added Faield", context);
                          }
                        });
                      }
                    }),
                MainButton(
                    horizontalPadding: 16,
                    btnColor: redColor,
                    label: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        ),
      );
    });
  }
}
