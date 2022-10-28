import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokemon_app/pages/detail_page/screens/detail_screen.dart';

import '../../../../models/pokemon/pokemon.dart';
import '../../../../utils/firebase_reference.dart';
import '../../../../values/app_colors.dart';

class AllPokemonTab extends StatefulWidget {
  const AllPokemonTab({Key? key, required this.userId, required this.isConnect}) : super(key: key);
  final int userId;
  final bool isConnect;

  @override
  State<AllPokemonTab> createState() => _AllPokemonTabState();
}

class _AllPokemonTabState extends State<AllPokemonTab> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
