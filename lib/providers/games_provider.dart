import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_app2/helpers/consts.dart';
import 'package:game_app2/models/GameCardModel.dart';
import 'package:game_app2/models/GameDetailsModel.dart';
import 'package:game_app2/providers/base_provider.dart';
import 'package:game_app2/services/api.dart';
import 'package:http/http.dart' as http;

class GamesProvider extends BaseProvider {
  GameDetailsModel? detailedGameModel;
  List<GameModel> similarGames = [];
  List<GameModel> games = [];
  List<GameModel> favGames = [];
  Api api = Api();

//-----------------------------------------fetchGameById--------------------------------
  fetchGameById(String id) async {
    setBusy(true);

    final response =
        await api.get("https://www.freetogame.com/api/game?id=$id");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      detailedGameModel = GameDetailsModel.fromJson(decodedData);
      getGamesByCategory(detailedGameModel!.genre);
    }
    setBusy(false);
  }

//-------------------------------------getGamesByCategory--------------------------------
  getGamesByCategory(String category) async {
    setBusy(true);

    final response = await api
        .get("https://www.freetogame.com/api/games?category=$category");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      similarGames =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();
    }

    setBusy(false);
  }

//--------------------------------fetchGames in the home screen-------------------------------

  fetchGames(String platform) async {
    setBusy(true);
    games.clear();
    final response = await http.get(
        Uri.parse("https://www.freetogame.com/api/games?platform=$platform"));

    printDebug("STATUS CODE : ${response.statusCode}");
    printDebug("BODY : ${response.body}");

    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      games =
          List<GameModel>.from(decodedData.map((e) => GameModel.fromJson(e)))
              .toList();

      setBusy(false);
    }
  }

//-----------------------------ADD TO FAVORITES---------------

Future<bool> addToFavorite(GameModel gameModel) async {
    setBusy(true);
    
    printDebug("FUNCTION : addToFavorite : ${gameModel.toJson()}");
    
    bool added = false;
    await getFavoriteGames().then((fetchedFavoriteGame) {
      bool isExist = false;
      for (var item in fetchedFavoriteGame) {
        if (item.id == gameModel.id) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
        FirebaseFirestore.instance
            .collection("favorite_games")
            .add(gameModel.toJson());
        added = true;
      } else {
        added = false;
      }
    });
    setBusy(false);

    return added;
  }



    Future<List<GameModel>> getFavoriteGames() async {
    setBusy(true);

    List<GameModel> tgmList = [];
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("favorite_games")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty) {
          tgmList = List<GameModel>.from(
              data.docs.map((e) => GameModel.fromJson(e.data()))).toList();
        }
      });
    }

    
    printDebug("FAV GAMES LENGTH : ${tgmList.length}");
    
    favGames = tgmList;

    setBusy(false);

    return tgmList;
  }



deteleFromFavorite(GameModel gameModel) async {
    setBusy(true);
    bool deleted = false;
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance
          .collection("favorite_games")
          .where("uid", isEqualTo:  FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((data) async {
        if (data.docs.isNotEmpty) {
          printDebug("DOC UID FROM DELETE ${data.docs.first.id.toString()}");
          
          await FirebaseFirestore.instance
              .collection("favorite_games")
              .doc(data.docs.last.id)
              .delete()
              .then((d) {
            getFavoriteGames();
          });

          deleted = true;
        } else {
          deleted = false;
        }
      });
    }
    setBusy(false);
    return deleted;
  }



}
