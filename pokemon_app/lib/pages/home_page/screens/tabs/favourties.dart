import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/utils/connection_provider.dart';
import '../../../../values/app_colors.dart';
import '../../../detals_page/screens/detail_page.dart';
import '../../../detals_page/viewmodel/detail_provider.dart';

class FavourtiesTab extends ConsumerStatefulWidget {
  const FavourtiesTab({
    Key? key, required this.userId
  }) : super(key: key);
  final int userId;

  @override
  ConsumerState createState() => _FavourtiesTabState();
}

class _FavourtiesTabState extends ConsumerState<FavourtiesTab> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    ref.watch(favProvider3(widget.userId));
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: GridView.count(physics: const BouncingScrollPhysics(),
        childAspectRatio: (MediaQuery
            .of(context)
            .size
            .width * 0.5 / 250),
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(ref.watch(fProvider3).length, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DetailPage(pokemon: ref.watch(fProvider3)[index], userId: widget.userId,isConnect: ref.watch(connectivityProvider),)));
            },
            child: Container(decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 100,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,child: CachedNetworkImage(
                  imageUrl: ref.watch(fProvider3)[index].image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
              ),),
                Container(margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        '#${ref.watch(fProvider3)[index].pokeId.toString()}'),
                    Text(ref.watch(fProvider3)[index].name, style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                    Text(ref.watch(fProvider3)[index].class1, style: const TextStyle(
                        color: AppColors.lightTextColor, fontSize: 14),)
                  ],),)
              ],),
            ),
          );
        }),),
    );

  }
}
