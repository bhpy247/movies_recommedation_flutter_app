

class NavigationArguments {
  const NavigationArguments();
}

class OtpScreenNavigationArguments extends NavigationArguments {
  final String mobile;

  const OtpScreenNavigationArguments({
    required this.mobile,
  });
}

class QuizPageNavigationArguments extends NavigationArguments {
  final String levelId;
  final double? starsEarned;

  const QuizPageNavigationArguments({
    required this.levelId,
    this.starsEarned,
  });
}


class MoviesDetailArguments extends NavigationArguments {
  final int movieId;

  const MoviesDetailArguments({
    required this.movieId,
  });
}

// class EventDetailNavigationArgument extends NavigationArguments {
//   final EventModel eventModel;
//   final UserModel? userModel;
//   final bool isFromPastEvent;
//   // final bool isSignUp;
//
//   const EventDetailNavigationArgument({
//     required this.eventModel,
//     this.userModel,
//     this.isFromPastEvent = false
//   });
// }

