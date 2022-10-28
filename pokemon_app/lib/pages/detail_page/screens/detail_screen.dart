import 'package:flutter/material.dart';
import 'package:pokemon_app/models/pokemon/pokemon.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.pokemon, required this.userId, required this.isConnect }) : super(key: key);
  final Pokemon pokemon;
  final int userId;
  final bool isConnect;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
