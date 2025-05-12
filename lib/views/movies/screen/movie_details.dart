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
          _buildMoviePosterAndTitle(movie),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGenresList(movie),
                const SizedBox(height: 16),
                _buildRating(movie),
                const SizedBox(height: 16),
                _buildOverview(movie),
                const SizedBox(height: 16),
                const Text('Cast', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                CastWidget(movieId: movie.id ?? 0),
                const SizedBox(height: 16),
                const Text('Similar', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                SimilarMoviesWidget(movieId: movie.id ?? 0),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackdropImage(MovieDetailsModel movie) {
    return SizedBox(
      height: 221,
      child: Stack(
        children: [
          if (movie.backdropPath != null)
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
              width: double.infinity,
              height: 221,
              fit: BoxFit.cover,
            ),
          Container(width: double.infinity, height: 221, color: Colors.black.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePosterAndTitle(MovieDetailsModel movie) {
    return Transform.translate(
      offset: const Offset(10, -100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 130,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
            child:
                movie.posterPath != null
                    ? CachedNetworkImage(imageUrl: 'https://image.tmdb.org/t/p/original${movie.posterPath}', fit: BoxFit.cover)
                    : const Placeholder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                Text(movie.title ?? "", style: const TextStyle(fontSize: 25, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                if (movie.releaseDate?.isNotEmpty ?? false)
                  Text(
                    DateFormat('MMMM d, y').format(DateTime.parse(movie.releaseDate ?? "")),
                    style: const TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => onShareClick(movie.imdbId ?? ""),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD24DFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('SHARE', style: TextStyle(color: Colors.white, fontSize: 17)),
                              SizedBox(width: 5),
                              Icon(Icons.share, size: 17, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if(context.read<MoviesProvider>().youtubeTrailerId.get().checkNotEmpty)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            onWatchTrailerClick();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD24DFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Trailer', style: TextStyle(color: Colors.white, fontSize: 17)),
                              SizedBox(width: 5),
                              Icon(FontAwesomeIcons.youtube, size: 17, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildGenresList(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Genres', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children:
              (movie.genres ?? [])
                  .map(
                    (genre) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
                      child: Text(genre.name ?? "", style: const TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildRating(MovieDetailsModel movie) {
    return Text(
      'Rating: ${movie.voteAverage?.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOverview(MovieDetailsModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(movie.overview ?? "", style: const TextStyle(fontSize: 17, color: Colors.grey)),
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
