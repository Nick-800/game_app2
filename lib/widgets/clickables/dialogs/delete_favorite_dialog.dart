import 'dart:async';

import 'package:game_app2/helpers/functions_helper.dart';
import 'package:game_app2/providers/games_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/GameCardModel.dart';
import 'package:flutter/material.dart';
import 'package:game_app2/helpers/consts.dart';
import 'package:game_app2/widgets/clickables/buttons/main_button.dart';

class DeleteFavoriteDialog extends StatefulWidget {
  const DeleteFavoriteDialog({super.key, required this.gameModel});
  final GameModel gameModel;
  @override
  State<DeleteFavoriteDialog> createState() => _DeleteFavoriteDialogState();
}

class _DeleteFavoriteDialogState extends State<DeleteFavoriteDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GamesProvider>(builder: (context, gamesConsumer, child) {
      return AlertDialog(
        title: const Text("Delete From Favorites"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Are you sure you want to Delete this game from favorite?"),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainButton(
                    inProgress: gamesConsumer.busy,
                    horizontalPadding: 16,
                    label: "Delete",
                    onPressed: () async {
                      await Provider.of<GamesProvider>(context, listen: false)
                          .deteleFromFavorite(widget.gameModel)
                          .then((deleted) {
                        if (deleted) {
                          showFlush("Deleted", "Deleted Successfully", context);

                          Timer(const Duration(seconds: 3), () {
                            Navigator.pop(context);
                          });
                        } else {
                          showFlush("Failed", " Failed Delete", context);
                        }
                      });
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
