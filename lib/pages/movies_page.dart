import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List<Movie> allMovies;
  late List<Movie> displayedMovies = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final String apiUrl =
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc";
    final String bearerToken =
        "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1N2Y3OGJkZGFmNTc0YzA4NDEyZjkyNzE0ZGJiOThmZCIsIm5iZiI6MTcyMDY5MDg1NC4xMzAxNTYsInN1YiI6IjY2OGZhNTI2ZGQzZjZkNDQwY2E3MDhkMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mradmAkJcYu_o5_hI74351lcDesuIDomI7rYxIbOCbo";

    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $bearerToken",
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> moviesJson = jsonResponse['results'];
      List<Movie> movies =
      moviesJson.map((movieJson) => Movie.fromJson(movieJson)).toList();
      setState(() {
        allMovies = movies;
        displayedMovies = List.of(movies);
      });
    } else {
      print('Failed to load movies: ${response.statusCode}');
    }
  }

  void filterMovies(String query) {
    setState(() {
      displayedMovies = allMovies
          .where((movie) =>
          movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: const Text(
            'The Movie DB',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Kit One',
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF000000),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search movies...",
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white12,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: filterMovies,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(30.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: displayedMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMovieCard(displayedMovies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey[900], // Donker grijs
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Witte tekst
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  movie.releaseDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300], // Licht grijs voor datum
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  movie.overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white, // Witte tekst
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Rating: ${movie.voteAverage.toString()}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[300], // Licht grijs voor rating
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

  class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toDouble(),
    );
  }
}
