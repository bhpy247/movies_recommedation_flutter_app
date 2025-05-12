import 'package:flutter/material.dart';
import 'package:moviesapp/views/movies/screen/movies_screen.dart';
import 'package:provider/provider.dart';

import '../../../backend/search/search_controller.dart';
import '../../../backend/search/search_provider.dart';

class SearchMoviesScreen extends StatefulWidget {
  static const String routeName = "/searchScreen";
  const SearchMoviesScreen({super.key});

  @override
  State<SearchMoviesScreen> createState() => _SearchMoviesScreenState();
}

class _SearchMoviesScreenState extends State<SearchMoviesScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      final provider = context.read<SearchProvider>();
      final controller = SearchMovieController(searchProvider: provider);
      controller.searchMovies(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: "Enter movie name",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchProvider>().clearSearchResults();
                          setState(() {});
                        },
                      )
                          : null,
                    ),
                    onChanged: (_) => setState(() {}), // To refresh clear button visibility
                    onSubmitted: (_) => _handleSearch(),
                  ),
                ),
                IconButton(
                  onPressed: _handleSearch,
                  icon: const Icon(Icons.search, color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 16),
            if (provider.isLoading.get())
              const CircularProgressIndicator(color: Colors.white)
            else if (provider.searchResults.getList().isEmpty &&
                _searchController.text.isNotEmpty)
              const Text("No results found", style: TextStyle(color: Colors.white))
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,),
                  itemCount: provider.searchResults.getList().length,
                  itemBuilder: (context, index) {
                    final movie = provider.searchResults.getList()[index];
                    return MovieGridItem(movie: movie); // Your custom card
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
