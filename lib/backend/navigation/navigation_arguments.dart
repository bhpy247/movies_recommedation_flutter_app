

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

class ChatScreenArguments extends NavigationArguments {
  final String receiverId;
  final String receiverName;

  const ChatScreenArguments({
    required this.receiverId,
    required this.receiverName,
  });
}

class ActorScreenArguments extends NavigationArguments {
  final int actorId;

  const ActorScreenArguments({
    required this.actorId,
  });
}

class WebViewScreenArguments extends NavigationArguments {
  final String url,  title;

  const WebViewScreenArguments({
    required this.url,
    required this.title,
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

