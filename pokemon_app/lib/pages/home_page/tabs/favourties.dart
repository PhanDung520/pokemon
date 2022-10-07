import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../values/app_colors.dart';
import '../../detals_page/detail_controller.dart';
import '../../detals_page/detail_page.dart';

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
    final data = ref.watch(fProvider3);
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
        children: List.generate(data.length, (index) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  DetailPage(pokemon: data[index], userId: widget.userId,)));
            },
            child: Container(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(child: Image.network(data[index].image),
                  height: 100,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,),
                Container(margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        '#${data[index].pokeId.toString()}'),
                    Text(data[index].name, style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                    Text(data[index].class1, style: const TextStyle(
                        color: AppColors.lightTextColor, fontSize: 14),)
                  ],),)

              ],),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),),
    );

  }
}
