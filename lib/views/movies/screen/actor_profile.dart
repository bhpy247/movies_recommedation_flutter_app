import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:provider/provider.dart';

import '../../../models/movies/response_model/actor_detail_model.dart';

class ActorProfileScreen extends StatefulWidget {
  static const String routeName = "/actorProfileScreen";
  final ActorScreenArguments arguments;

  const ActorProfileScreen({required this.arguments, super.key});

  @override
  State<ActorProfileScreen> createState() => _ActorProfileScreenState();
}

class _ActorProfileScreenState extends State<ActorProfileScreen> {
  ActorDetailModel? actorData;

  @override
  void initState() {
    super.initState();
    _loadActorData();
  }

  Future<void> _loadActorData() async {
    final provider = context.read<MoviesProvider>();
    final controller = MoviesController(moviesProvider: provider);
    final data = await controller.getActorProfile(widget.arguments.actorId);
    setState(() {
      actorData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (actorData == null) return Center(child: const CircularProgressIndicator()); // You can design a loader

    return Scaffold(
      appBar: AppBar(title: Text(actorData!.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/original${actorData!.profilePath}',
                            height: 160,
                            width: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(actorData!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 6),
                              Text("Known for: ${actorData!.knownForDepartment}", style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 6),
                              Text(
                                "DOB: ${DateFormat('d MMM, yyyy').format(actorData!.birthday)}, ${actorData!.placeOfBirth}",
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              Text("Age: ${DateTime.now().year - actorData!.birthday.year}", style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Known For", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actorData!.knownFor.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemBuilder: (_, index) {
                final movie = actorData!.knownFor[index];
                return GestureDetector(
                  onTap: () {
                    NavigationController.navigateToMovieDetailScreen(
                      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                      arguments: MoviesDetailArguments(movieId: movie.id ?? 0),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network('https://image.tmdb.org/t/p/original${movie.posterPath}', fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
