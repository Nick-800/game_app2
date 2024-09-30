import 'package:flutter/material.dart';
import 'package:game_app2/models/GameDetailsModel.dart';

class MinimumSystemRequirmentsCard extends StatelessWidget {
  const MinimumSystemRequirmentsCard({super.key, required this.minimumSystemRequirments});
final MinimumSystemRequirements? minimumSystemRequirments;


  @override
  Widget build(BuildContext context) {
    return  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Minimum System Requirements",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "OS: ${minimumSystemRequirments!.os}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "MEMORY: ${minimumSystemRequirments!.memory}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "PROCESSOR: ${minimumSystemRequirments!.processor}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "GRAPHICS: ${minimumSystemRequirments!.graphics}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "STORAGE: ${minimumSystemRequirments!.storage}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          );
  }
}