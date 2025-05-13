class ActorDetailModel {
  final String name;
  final String profilePath;
  final String knownForDepartment;
  final DateTime birthday;
  final String placeOfBirth;
  final List<KnownForMovie> knownFor;

  ActorDetailModel({
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.birthday,
    required this.placeOfBirth,
    required this.knownFor,
  });

  factory ActorDetailModel.fromJson(Map<String, dynamic> json) {
    return ActorDetailModel(
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      knownForDepartment: json['known_for_department'] ?? '',
      birthday: DateTime.parse(json['birthday']),
      placeOfBirth: json['place_of_birth'] ?? '',
      knownFor: (json['combined_credits']['cast'] as List)
          .where((el) => el['poster_path'] != null)
          .map((e) => KnownForMovie.fromJson(e))
          .toList(),
    );
  }
}

class KnownForMovie {
  final int id;
  final String posterPath;

  KnownForMovie({required this.id, required this.posterPath});

  factory KnownForMovie.fromJson(Map<String, dynamic> json) {
    return KnownForMovie(
      id: json['id'],
      posterPath: json['poster_path'],
    );
  }
}