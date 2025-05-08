// models/movies/response_model/movies_response_model.dart
class SimilarMoviesResponseModel {
  final int? page;
  final List<SimilarMovieList>? results;
  final int? totalPages;
  final int? totalResults;

  SimilarMoviesResponseModel({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory SimilarMoviesResponseModel.fromJson(Map<String, dynamic> json) {
    return SimilarMoviesResponseModel(
      page: json['page'],
      results: List<SimilarMovieList>.from(
          json['results'].map((x) => SimilarMovieList.fromJson(x))),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class SimilarMovieList {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int? id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  SimilarMovieList({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory SimilarMovieList.fromJson(Map<String, dynamic> json) {
    return SimilarMovieList(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids'].map((x) => x)),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity']?.toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
    );
  }
}