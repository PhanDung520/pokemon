import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/values/app_colors.dart';
import '../home_page/home_controller.dart';
import 'detail_controller.dart';
import 'detail_state.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({
    Key? key, required this.pokemon, required this.userId
  }) : super(key: key);
  final Pokemon pokemon;
  final int userId;

  @override
  ConsumerState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  DetailController detailController = DetailController();
  @override
  void initState() {
    // TODO: implement initState
    detailController.checkFavourite(widget.pokemon, widget.userId, ref);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF3F9EF),
          elevation: 2,
          leading: IconButton(icon:Icon(Icons.arrow_back_ios), color: Color(0xffCC000000), onPressed: () {
            Navigator.pop(context);
            ref.refresh(favProvider(widget.userId));
          },),
        ),
        body: Stack(
          children: [
            Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.25,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xffF3F9EF),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                              Container(child: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                                Text(widget.pokemon.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textColor),),
                                Text(widget.pokemon.class1, style: TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),)
                              ],)),
                              Text('#${widget.pokemon.pokeId}')

                            ],),
                            margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                          ),
                          Container(height: 125,margin: EdgeInsets.only(bottom: 20, right: 20),child:
                          Image.network(widget.pokemon.image),)
                        ],
                      ),),
                    Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.1,color: Colors.white,child:
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsetsDirectional.only(start: 20),
                          width: MediaQuery.of(context).size.width*0.5,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                                Text('Height', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                                Text(widget.pokemon.height.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                              ],),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                                Text('Weight', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                                Text(widget.pokemon.weight.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                              ],),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                                Text('Heightx', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                                Text(widget.pokemon.height.toString(), style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
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
              onTap: () async {
                if(ref.watch(detailStateProvider) == DetailStatus.isNotFavourite){
                  //add
                  print('click1');
                  await ref.watch(addPokeToFavProvider(myParamsUserIdPoke(userId: widget.userId, poke: widget.pokemon)));
                  ref.refresh(favProvider3(widget.userId));
                  ref.refresh(detailStateProvider);
                  detailController.checkFavourite(widget.pokemon, widget.userId, ref);
                }
                if(ref.watch(detailStateProvider) == DetailStatus.isFavourite){
                  //remove
                  print('click2');
                  await ref.watch(removePokeFromPavProvider(myParamsUserIdPoke(userId: widget.userId, poke: widget.pokemon)));
                  ref.refresh(favProvider3(widget.userId));
                  ref.refresh(detailStateProvider);
                  detailController.checkFavourite(widget.pokemon, widget.userId, ref);
                }
              },
              child: Container(alignment: Alignment.center,width:ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ? 140 : 210,height: 50,decoration: BoxDecoration(color: ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ?Color(0xff3558CD):Color(0xffD5DEFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2,1),
                        blurRadius: 5
                    )
                  ]
              ),
                child: Text(ref.watch(detailStateProvider) == DetailStatus.isNotFavourite?'Mark as favourite':'Remove from favourites', style: TextStyle(color: ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ?Colors.white:Color(0xff3558CD), fontWeight: FontWeight.w500),),
              ),
            ))
          ],
        )
    );
  }
}