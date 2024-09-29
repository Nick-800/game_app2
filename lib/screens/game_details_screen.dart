import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_app/models/game_data_model.dart';
import 'package:http/http.dart' as http;

class GameDetailsScreen extends StatefulWidget {
  final String gameID;

  const GameDetailsScreen({super.key, required this.gameID});

  @override
  // ignore: library_private_types_in_public_api
  _GameDetailsScreenState createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  GameDetailsModel? gameDetailsModel;

  @override
  void initState() {
    super.initState();
    _fetchGameDetails();
  }

  Future<void> _fetchGameDetails() async {
    final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=${widget.gameID}'));
    // ignore: non_constant_identifier_names
    final game_DetailsModel =
        GameDetailsModel.fromJson(jsonDecode(response.body));
    setState(() {
      gameDetailsModel = game_DetailsModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameDetailsModel == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(gameDetailsModel!.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
 
              GameTitleAndThumbnail(
                title: gameDetailsModel!.title,
                thumbnail: gameDetailsModel!.thumbnail,
              ),
              const SizedBox(height: 16),

              // Display game status and short description
              GameStatusAndDescription(
                status: gameDetailsModel!.status,
                shortDescription: gameDetailsModel!.shortDescription,
              ),
              const SizedBox(height: 16),

              // Display game details
              GameDetails(
                description: gameDetailsModel!.description,
                gameUrl: gameDetailsModel!.gameUrl,
                genre: gameDetailsModel!.genre,
                platform: gameDetailsModel!.platform,
                publisher: gameDetailsModel!.publisher,
                developer: gameDetailsModel!.developer,
                releaseDate: gameDetailsModel!.releaseDate,
              ),
              const SizedBox(height: 16),
              gameDetailsModel!.platform != "Browser"
                  // Display minimum system requirements
                  ? MinimumSystemRequirementsWidget(
                      minimumSystemRequirements:
                          gameDetailsModel?.minimumSystemRequirements,
                      gameDetails: gameDetailsModel!,
                    )
                  : const SizedBox(height: 16),
              const SizedBox(height: 16),  
              ScreenshotsWidget(
                screenshots: gameDetailsModel!.screenshots,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameTitleAndThumbnail extends StatelessWidget {
  final String title;
  final String thumbnail;

  const GameTitleAndThumbnail(
      {super.key, required this.title, required this.thumbnail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(thumbnail, scale: 1.1),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}


class GameStatusAndDescription extends StatelessWidget {
  final String status;
  final String shortDescription;

  const GameStatusAndDescription(
      {super.key, required this.status, required this.shortDescription});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(status, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(shortDescription, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}


class GameDetails extends StatelessWidget {
  final String description;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final DateTime releaseDate;

  const GameDetails({
    super.key,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(description, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text('Game URL: $gameUrl', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text('Genre: $genre', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text('Platform: $platform', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text('Publisher: $publisher', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text('Developer: $developer', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
            'Release Date: ${releaseDate.year}-${releaseDate.month}-${releaseDate.day}',
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}


class MinimumSystemRequirementsWidget extends StatelessWidget {
  final MinimumSystemRequirements? minimumSystemRequirements;
  final GameDetailsModel gameDetails;

  const MinimumSystemRequirementsWidget(
      {super.key, this.minimumSystemRequirements, required this.gameDetails});

  @override
  Widget build(BuildContext context) {
    return gameDetails.platform == "Browser"
        ? const Text("No system requirements available for browser games.")
        : gameDetails.minimumSystemRequirements == null
            ? const Text("No system requirements available.")
            : Column(
                children: [
                  const Text('Minimum System Requirements:',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('OS: ${minimumSystemRequirements?.os}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Processor: ${minimumSystemRequirements?.processor}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Memory: ${minimumSystemRequirements?.memory}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Graphics: ${minimumSystemRequirements?.graphics}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Storage: ${minimumSystemRequirements?.storage}',
                      style: const TextStyle(fontSize: 16)),
                ],
              );
  }
}

// Screenshots widget
class ScreenshotsWidget extends StatelessWidget {
  final List<Screenshot> screenshots;

  const ScreenshotsWidget({super.key, required this.screenshots});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 200,
        child: Row(
          children: [
            const Text('Screenshots:', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            
            ...screenshots.map((screenshot) => Image.network(screenshot.image)),
          ],
        ),
      ),
    );
  }
}
