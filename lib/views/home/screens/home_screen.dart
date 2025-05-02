import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/views/chat/screens/chat_screen.dart';
import 'package:moviesapp/views/profile/screens/profile_screen.dart';
import 'package:moviesapp/views/search/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/configs/app_colors.dart';

import '../../movies/screen/movies_screen.dart';
import '../../recommend/screens/recommend_screen.dart';
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
      const ChatScreen(),
      const SearchScreenTab(),
      const ProfileScreen(),
      const RecommendScreen(),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final provider = context.read<MoviesProvider>();
      if (!provider.isLoading.get() && provider.hasMore.get()) {
        _moviesController.getMoviesList(context, isRefresh: false);
      }
    }
  }

  Future<void> _refreshData() async {
    await _moviesController.refreshMoviesList(context);
  }

  final _iconList = <IconData>[
    Icons.home,
    Icons.chat_bubble,
    Icons.search,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Movies")),
      body: _tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.primaryColor,
        elevation: 0,
        shape: CircleBorder(),
        child: const Icon(Icons.movie, color: Colors.white,),
        onPressed: () => setState(() => _currentIndex = 4), // Recommended tab
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:  AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: _currentIndex,

        gapLocation: GapLocation.center,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) => setState(() => _currentIndex = index),
        activeColor: Styles.primaryColor,
        inactiveColor: Colors.grey,
        iconSize: 24,
        backgroundColor: Styles().darkAppBarColor,
      ),
    );
  }
}
