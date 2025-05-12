import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:moviesapp/views/chat/screens/chat_screen.dart';
import 'package:moviesapp/views/mystuff/screens/mystuff_screen.dart';
import 'package:moviesapp/views/chat/screens/main_chat_screen.dart';
import 'package:moviesapp/views/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/configs/app_colors.dart';

import '../../movies/screen/movies_screen.dart';
import '../../movies/screen/recommended_screen.dart';
import '../components/shimmer_grid_item.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MoviesController _moviesController;
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  // Tab pages - you can replace these with your actual content
  late List<Widget> _tabs = [];

  final _iconList = <IconData>[
    Icons.home,
    Icons.chat_bubble,
    Icons.inventory_2,
    Icons.person,
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = context.read<MoviesProvider>();
      if (!provider.isLoading.get() && provider.hasMore.get()) {
        _moviesController.getMoviesList(context, isRefresh: false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _moviesController.refreshMoviesList(context);
  }


  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "MovieCon";
      case 1:
        return "Chat";
      case 2:
        return "My Stuff";
      case 3:
        return "Profile";
      case 4:
        return "Recommended";
      default:
        return "MovieCon";
    }
  }

  @override
  void initState() {
    super.initState();
    final moviesProvider = context.read<MoviesProvider>();
    _moviesController = MoviesController(moviesProvider: moviesProvider);

    // Initial load
    _moviesController.getMoviesList(context);

    // Setup scroll listener for pagination
    _scrollController.addListener(_scrollListener);
    _tabs = [
      MoviesTab(
        onRefresh: () {
          _refreshData();
        },
        scrollController: _scrollController,
      ),
      const MainChatScreen(),
      const FavoritesAndWatchlistScreen(),
      const ProfileScreen(),
      const RecommendScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: [0,3].contains( _currentIndex) ? AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          actions: [
            IconButton(onPressed: () async {
              await AuthenticationController(authenticationProvider: context.read()).logout(isShowConfirmationDialog: true,isNavigateToLogin: true);
            }, icon: Icon(Icons.logout))
          ],
          centerTitle: true,
          title: Text(
            _getAppBarTitle(_currentIndex),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ) : null,
        body: Stack(
          children: [
            if (_currentIndex == 0)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    onTap: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                      NavigationController.navigateToSearchMovieScreen(navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed));
                    },
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      hintText: 'Search movies...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,

                    ),
                    onTapAlwaysCalled: true,
                    // onChanged: (value) {
                    //   // search logic here
                    // },
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: _currentIndex == 0 ? 80 : 0, bottom: 20),
              child: _tabs[_currentIndex],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Styles.primaryColor,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          onPressed: () => setState(() => _currentIndex = 4),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: _iconList,
          activeIndex: _currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          backgroundColor: const Color(0xFF121212),
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          onTap: (index) => setState(() => _currentIndex = index),
          activeColor: Styles.primaryColor,
          inactiveColor: Colors.white60,
          iconSize: 26,
          backgroundGradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF121212)], // Slight contrast
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          // backgroundGradient: LinearGradient(colors: [Colors.grey,Colors.grey]),

        ),
      ),
    );
  }
}
