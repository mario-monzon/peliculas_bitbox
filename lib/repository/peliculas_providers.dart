import 'dart:async';
import 'package:peliculas_bitbox/models/movie_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PeliculasProvider{
  final String _apikey = '46514b47bc995b14fd13c566f27ac058';
  final String _url = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _popularesPages = 0;

  bool _cargando  = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

// Para poder insertar informacion al string
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
// Para escuchar la informacion
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> procesarDatos(Uri url) async {

    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    // print(peliculas.items[9].title);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {

    _popularesPages++;

    final url = Uri.https(_url, '3/movie/popular', {'api_key' : _apikey, 'language' : _language, 'page' : _popularesPages.toString()});

    final respuesta = await http.get(url);

    final decodedData = json.decode(respuesta.body);

    final peliculas = Peliculas.fromJsonList(decodedData['results']);

    final resp = peliculas.items;

    _populares.addAll(resp);
    popularesSink(_populares);

    return resp;

  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie', {'api_key' : _apikey, 'language' : _language, 'query' : query});

    return await procesarDatos(url);
  }
}