import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/values/app_colors.dart';

import '../../povider/provider.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({
    Key? key, required this.pokemon, required this.userId
  }) : super(key: key);
  final Pokemon pokemon;
  final int userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokeDetail = ref.watch(pokeByIdProvider(pokemon.pokeId));
    final Size size = MediaQuery.of(context).size;
    final faValue = ref.watch(favProvider(userId));
    String mess='';
    int count =0;
    List<Pokemon> listPokeFav=[];
    faValue.when(data: (data){
      listPokeFav = data;
    }, error: (e, stack){print(e);}, loading: (){print('getting favourite list!');});
    listPokeFav.forEach((element) {
        if(pokemon.pokeId == element.pokeId){
          count =1;
        };
      }
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F9EF),
        elevation: 2,
        leading: IconButton(icon:Icon(Icons.arrow_back_ios), color: Color(0xffCC000000), onPressed: () {
          Navigator.pop(context);
          ref.refresh(favProvider(userId));
        },),
      ),
      body: Stack(
          children: [
            Container(
                child: Column(
              children: [
                Container(
                  height: size.height*0.25,
                  width: size.width,
                  color: Color(0xffF3F9EF),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                        Container(child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Text(pokemon.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textColor),),
                          Text(pokemon.class1, style: TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),)
                        ],)),
                        Text('#${pokemon.pokeId}')

                      ],),
                      margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                    ),
                    Container(height: 125,margin: EdgeInsets.only(bottom: 20, right: 20),child:
                      Image.network(pokemon.image),)
                  ],
                ),),
                Container(width: size.width,height: size.height*0.1,color: Colors.white,child:
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(start: 20),
                        width: size.width*0.5,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Container(
                            height: size.height*0.05,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                              Text('Height', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                              Text(pokemon.height.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                            ],),
                          ),
                          Container(
                            height: size.height*0.05,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                              Text('Weight', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                              Text(pokemon.weight.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                            ],),
                          ),
                          Container(
                            height: size.height*0.05,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                              Text('Heightx', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                              Text(pokemon.height.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                            ],),
                          )
                        ],),
                      )
                    ],
                  )
                  ,),
                Expanded(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(top: 10),
                    color: Colors.white,
                    child: ListView(
                    ),
                  ),
                )
              ],
            )),
            Positioned(bottom: 40, right: 20 ,child: InkWell(
              onTap: () {
                if(count ==0){
                  //add
                  ref.watch(addPokeToFavProvider(myParamsUserIdPoke(userId: userId, poke: pokemon)));
                  //addPokeToFav.when(data: (data){mess = 'add success!';print(mess);}, error: (e, stack){mess = 'error: ${e.toString()}'; print(mess);}, loading: (){mess='adding';print(mess);});
                  ref.refresh(favProvider(userId));
                  // ref.refresh(pokeByIdProvider(pokeId));
                }else{
                 //delete
                  ref.watch(removePokeFromPavProvider(myParamsUserIdPoke(userId: userId, poke: pokemon)));
                 //  removePokeFormFav.when(data: (data){mess = 'remove success!';print(mess);}, error: (e, stack){mess = 'error: ${e.toString()}'; print(mess);}, loading: (){mess='adding';print(mess);});
                  // ref.refresh(pokeByIdProvider(pokeId));
                  ref.refresh(favProvider(userId));
                }
              },
              child: Container(alignment: Alignment.center,width:count==0 ? 140 : 210,height: 50,decoration: BoxDecoration(color: count == 0 ?Color(0xff3558CD):Color(0xffD5DEFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(2,1),
                    blurRadius: 5
                  )
                ]
              ),
                child: Text(count==0?'Mark as favourite':'Remove from favourites', style: TextStyle(color: count == 0?Colors.white:Color(0xff3558CD), fontWeight: FontWeight.w500),),
              ),
            ))
          ],
        )
    );
  }
}