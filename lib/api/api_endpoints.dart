class ApiEndpoints {
  final String siteUrl, authUrl, apiUrl ;

  const ApiEndpoints({
    required this.siteUrl,
    required this.authUrl,
    // this.apiUrl = "http://localhost:55557/api/v1",
    this.apiUrl = "https://api.themoviedb.org/3/movie/",
  });

  String getBaseApiUrl() {
    // return "http://192.168.29.164:55557/api/v1";
    return "https://api.themoviedb.org/3/movie/";
  }
  String getApiKey() {
    // return "http://192.168.29.164:55557/api/v1";
    return "fc6b0f8734f6d710fed11de93fc496cc";
  }

  //-------------------------Api Urls-------------------------------------


  String apiGetMovies(int page) {
    return "${getBaseApiUrl()}popular?page=${page}&api_key=${getApiKey()}";
  }

  String apiGetMovieDetails(int movieId) {
    return '${getBaseApiUrl()}$movieId?api_key=${getApiKey()}';
  }
  String apiGetMovieCredits(int movieId) => '${getBaseApiUrl()}$movieId/credits?api_key=${getApiKey()}';
  String apiGetSimilarMovies(int movieId) => '${getBaseApiUrl()}$movieId/recommendations?api_key=${getApiKey()}';
  //endregion


}
