import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/user.dart';

import '../../../povider/provider.dart';
import '../../../values/app_colors.dart';
import '../../detals_page/detail_page.dart';

class FavourtiesTab extends ConsumerWidget {
  const FavourtiesTab({
    Key? key, required this.userId
  }) : super(key: key);
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final favValue = ref.watch(favProvider(userId));
    return favValue.when(data: (data){
      print('success!');
      return Container(
        padding: EdgeInsets.all(15),
        child: GridView.count(physics: BouncingScrollPhysics(),childAspectRatio: (size.width*0.5/ 250),crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, children: List.generate(data.length, (index) {
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(pokemon: data[index], userId: userId,)));
            },
            child: Container( child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              Container(child: Image.network(data[index].image),height: 100,width: size.width*0.6,),
              Container(margin: EdgeInsets.only(left: 10),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                Container(child: Text('#${data[index].pokeId.toString()}'),),
                Container(child: Text(data[index].name, style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),),
                Container(child: Text(data[index].class1, style: TextStyle(color: AppColors.lightTextColor, fontSize: 14),),)
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
    }, error: (e, stack){ return Text(e.toString());}, loading: (){return Text('Loading');});
  }
}
