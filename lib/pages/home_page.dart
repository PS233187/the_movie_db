import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<Movie> displayedMovies = [];

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

      List<Movie> movies = moviesJson
          .map((movieJson) => Movie.fromJson(movieJson))
          .take(10) // Fetch more movies for the slideshow
          .toList();

      setState(() {
        displayedMovies = movies;
      });
    } else {
      print('Failed to load movies: ${response.statusCode}');
    }
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(
                '',
                height: 100, // Adjust the height as needed
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                'Discover and explore the best movies of all time!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kit One',
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              itemCount: (displayedMovies.length / 3).ceil(),
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * 3;
                int endIndex = (startIndex + 3).clamp(0, displayedMovies.length);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: displayedMovies
                      .sublist(startIndex, endIndex)
                      .map((movie) => Expanded(child: _buildMovieCard(movie)))
                      .toList(),
                );
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
      color: Colors.grey[900],
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
        ],
      ),
    );
  }
}

class Movie {
  final int id;
  final String posterPath;

  Movie({
    required this.id,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      posterPath: json['poster_path'] ?? '', // Ensure posterPath is never null
    );
  }
}
