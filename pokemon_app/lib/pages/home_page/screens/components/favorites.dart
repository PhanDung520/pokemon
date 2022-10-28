import 'package:flutter/material.dart';
import '../../../../values/app_colors.dart';

import 'package:cached_network_image/cached_network_image.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({Key? key, required this.userId, required this.isConnect}) : super(key: key);
  final int userId;
  final bool isConnect;

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
