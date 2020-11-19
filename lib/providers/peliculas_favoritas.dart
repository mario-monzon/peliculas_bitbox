import 'package:flutter/material.dart';

import 'package:peliculas_bitbox/models/pelicula_modelo.dart';
import 'package:peliculas_bitbox/providers/db_provider.dart';

class PeliculasFavoritas with ChangeNotifier {

  List<Pelicula> _listaPeliculas = [];


  PeliculasFavoritas() {
    cargardatos();
  }

  List<Pelicula> get listaPeliculas => _listaPeliculas;

  set listaPeliculas(List<Pelicula> value) {
    _listaPeliculas = value;
  //  DBProvider.db.getPeliculas().then((value) => _listaPeliculas.add(value);
    notifyListeners();

  }

  Future<List<Pelicula>> cargardatos() async {
  listaPeliculas = await DBProvider.db.getPeliculas();
}

}