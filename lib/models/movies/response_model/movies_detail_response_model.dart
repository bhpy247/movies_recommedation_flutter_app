import '../../../utils/parsing_helper.dart';

class MovieDetailsModel {
  bool? adult;
  String? backdropPath;
  dynamic belongsToCollection;
  int? budget;
  List<Genres>? genres;
  String? homepage;
  int? id;
  String? imdbId;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  List<ProductionCompanies>? productionCompanies;
  List<ProductionCountries>? productionCountries;
  String? releaseDate;
  int? revenue;
  int? runtime;
  List<SpokenLanguages>? spokenLanguages;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  MovieDetailsModel({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originCountry,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    adult = ParsingHelper.parseBoolNullableMethod(json['adult']);
    backdropPath = ParsingHelper.parseStringNullableMethod(json['backdrop_path']);
    belongsToCollection = json['belongs_to_collection'];
    budget = ParsingHelper.parseIntNullableMethod(json['budget']);

    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(Genres.fromJson(v));
      });
    }

    homepage = ParsingHelper.parseStringNullableMethod(json['homepage']);
    id = ParsingHelper.parseIntNullableMethod(json['id']);
    imdbId = ParsingHelper.parseStringNullableMethod(json['imdb_id']);
    originCountry = ParsingHelper.parseListMethod<String, String>(json['origin_country']);
    originalLanguage = ParsingHelper.parseStringNullableMethod(json['original_language']);
    originalTitle = ParsingHelper.parseStringNullableMethod(json['original_title']);
    overview = ParsingHelper.parseStringNullableMethod(json['overview']);
    popularity = ParsingHelper.parseDoubleNullableMethod(json['popularity']);
    posterPath = ParsingHelper.parseStringNullableMethod(json['poster_path']);

    if (json['production_companies'] != null) {
      productionCompanies = <ProductionCompanies>[];
      json['production_companies'].forEach((v) {
        productionCompanies!.add(ProductionCompanies.fromJson(v));
      });
    }

    if (json['production_countries'] != null) {
      productionCountries = <ProductionCountries>[];
      json['production_countries'].forEach((v) {
        productionCountries!.add(ProductionCountries.fromJson(v));
      });
    }

    releaseDate = ParsingHelper.parseStringNullableMethod(json['release_date']);
    revenue = ParsingHelper.parseIntNullableMethod(json['revenue']);
    runtime = ParsingHelper.parseIntNullableMethod(json['runtime']);

    if (json['spoken_languages'] != null) {
      spokenLanguages = <SpokenLanguages>[];
      json['spoken_languages'].forEach((v) {
        spokenLanguages!.add(SpokenLanguages.fromJson(v));
      });
    }

    status = ParsingHelper.parseStringNullableMethod(json['status']);
    tagline = ParsingHelper.parseStringNullableMethod(json['tagline']);
    title = ParsingHelper.parseStringNullableMethod(json['title']);
    video = ParsingHelper.parseBoolNullableMethod(json['video']);
    voteAverage = ParsingHelper.parseDoubleNullableMethod(json['vote_average']);
    voteCount = ParsingHelper.parseIntNullableMethod(json['vote_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['belongs_to_collection'] = belongsToCollection;
    data['budget'] = budget;

    if (genres != null) {
      data['genres'] = genres!.map((v) => v.toJson()).toList();
    }

    data['homepage'] = homepage;
    data['id'] = id;
    data['imdb_id'] = imdbId;
    data['origin_country'] = originCountry;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;

    if (productionCompanies != null) {
      data['production_companies'] = productionCompanies!.map((v) => v.toJson()).toList();
    }

    if (productionCountries != null) {
      data['production_countries'] = productionCountries!.map((v) => v.toJson()).toList();
    }

    data['release_date'] = releaseDate;
    data['revenue'] = revenue;
    data['runtime'] = runtime;

    if (spokenLanguages != null) {
      data['spoken_languages'] = spokenLanguages!.map((v) => v.toJson()).toList();
    }

    data['status'] = status;
    data['tagline'] = tagline;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}

class Genres {
  int? id;
  String? name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntNullableMethod(json['id']);
    name = ParsingHelper.parseStringNullableMethod(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class ProductionCompanies {
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;

  ProductionCompanies({this.id, this.logoPath, this.name, this.originCountry});

  ProductionCompanies.fromJson(Map<String, dynamic> json) {
    id = ParsingHelper.parseIntNullableMethod(json['id']);
    logoPath = ParsingHelper.parseStringNullableMethod(json['logo_path']);
    name = ParsingHelper.parseStringNullableMethod(json['name']);
    originCountry = ParsingHelper.parseStringNullableMethod(json['origin_country']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo_path'] = logoPath;
    data['name'] = name;
    data['origin_country'] = originCountry;
    return data;
  }
}

class ProductionCountries {
  String? iso31661;
  String? name;

  ProductionCountries({this.iso31661, this.name});

  ProductionCountries.fromJson(Map<String, dynamic> json) {
    iso31661 = ParsingHelper.parseStringNullableMethod(json['iso_3166_1']);
    name = ParsingHelper.parseStringNullableMethod(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iso_3166_1'] = iso31661;
    data['name'] = name;
    return data;
  }
}

class SpokenLanguages {
  String? englishName;
  String? iso6391;
  String? name;

  SpokenLanguages({this.englishName, this.iso6391, this.name});

  SpokenLanguages.fromJson(Map<String, dynamic> json) {
    englishName = ParsingHelper.parseStringNullableMethod(json['english_name']);
    iso6391 = ParsingHelper.parseStringNullableMethod(json['iso_639_1']);
    name = ParsingHelper.parseStringNullableMethod(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['english_name'] = englishName;
    data['iso_639_1'] = iso6391;
    data['name'] = name;
    return data;
  }
}