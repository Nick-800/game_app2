import 'dart:convert';

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
}
