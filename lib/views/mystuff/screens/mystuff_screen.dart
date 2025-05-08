import 'package:flutter/material.dart';
import 'package:moviesapp/configs/app_colors.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:moviesapp/views/movies/screen/movies_screen.dart';

class MystuffScreen extends StatelessWidget {
  const MystuffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("Hello");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              tabs: [
                const Tab(text: "Favourites"),
                const Tab(text: "Watchlist"),
              ],
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: Styles.primaryColor),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MoviesTab(),
            MoviesTab(),
          ],
        ),
      ),
    );
  }
}