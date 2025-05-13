import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/utils/extensions.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:moviesapp/utils/my_utils.dart';
import 'package:moviesapp/utils/parsing_helper.dart';
import 'package:moviesapp/views/movies/screen/cast_list.dart';
import 'package:moviesapp/views/movies/screen/similar_movies_list.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/movies/response_model/movies_detail_response_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = "/moviesDetailScreen";
  MoviesDetailArguments? arguments;

  MovieDetailsScreen({super.key, this.arguments});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late MoviesController _controller;
  late MoviesProvider moviesProvider;
  bool _shareVisible = false;

  void onShareClick(String id) async {
    await SharePlus.instance.share(ShareParams(text: 'https://www.imdb.com/title/${id}/?ref_=hm_fanfav_i_1_pd_fp1_r'));
  }

  Future<void> launchYouTubeTrailer(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onWatchTrailerClick() async {
    String youtubeId = moviesProvider.youtubeTrailerId.get();
    MyPrint.printOnConsole("Youtube ID : ${youtubeId}");
    if (youtubeId.checkNotEmpty) {
      await launchYouTubeTrailer(youtubeId);
    }
  }

  @override
  void initState() {
    super.initState();
    moviesProvider = context.read<MoviesProvider>();
    _controller = MoviesController(moviesProvider: moviesProvider);
    _controller.getMovieDetails(context, ParsingHelper.parseIntMethod(widget.arguments?.movieId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller.moviesProvider,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<MoviesProvider>(
          builder: (context, provider, child) {
            if (provider.movieDetailLoading.get()) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error.get().isNotEmpty) {
              return Center(child: Text(provider.error.get()));
            }

            final movie = provider.movieDetail.get()!;
            return Stack(children: [_buildMovieContent(movie), if (_shareVisible) _buildShareOverlay()]);
          },
        ),
      ),
    );
  }

  Widget _buildMovieContent(MovieDetailsModel movie) {
    return SingleChildScrollView(
      physics: _shareVisible ? const NeverScrollableScrollPhysics() : null,
      child: Column(
        children: [
          _buildBackdropImage(movie),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 0),
            child: Column(
              children: [
                _buildMoviePosterAndTitle(movie),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGenresList(movie),
                      const SizedBox(height: 20),
                      _buildRating(movie),
                      const SizedBox(height: 20),
                      _buildOverview(movie),
                      const Divider(color: Colors.white24, thickness: 0.5),
                      const SizedBox(height: 16),
                      const Text('Cast', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
                      const SizedBox(height: 10),
                      CastWidget(movieId: movie.id ?? 0),
                      const SizedBox(height: 20),
                      const Text('Similar', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
                      const SizedBox(height: 10),
                      SimilarMoviesWidget(movieId: movie.id ?? 0),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackdropImage(MovieDetailsModel movie) {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          if (movie.backdropPath != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.95)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePosterAndTitle(MovieDetailsModel movie) {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'poster_${movie.id}',
                  child: movie.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/original${movie.posterPath}',
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title ?? "",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM d, y').format(DateTime.parse(movie.releaseDate ?? "")),
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _shareVisible = true),
                      icon: const Icon(Icons.share, size: 18, color: Colors.white),
                      label: const Text("SHARE", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD24DFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 8,
                        shadowColor: const Color(0xFFD24DFF).withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenresList(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Genres', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (movie.genres ?? []).map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFD24DFF).withOpacity(0.2), const Color(0xFF6A1B9A).withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFFD24DFF).withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD24DFF).withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  genre.name ?? "",
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRating(MovieDetailsModel movie) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 24),
        const SizedBox(width: 6),
        Text(
          movie.voteAverage?.toStringAsFixed(2) ?? "N/A",
          style: const TextStyle(fontSize: 22, color: Colors.amber, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOverview(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
        const SizedBox(height: 8),
        Text(movie.overview ?? "", style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85), height: 1.5)),
      ],
    );
  }

  Widget _buildShareOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(color: const Color(0xFF202020), borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SHARE', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => onShareClick, icon: const Icon(Icons.close, color: Color(0xFFD24DFF), size: 30)),
                  ],
                ),
                // Add your share options here
                // const Expanded(child: Center(child: Text('Share options would go here', style: TextStyle(color: Colors.white)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
