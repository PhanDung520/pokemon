import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/utils/connection_provider.dart';
import 'package:pokemon_app/values/app_colors.dart';
import '../../home_page/viewmodels/home_provider.dart';
import '../viewmodel/detail_provider.dart';
import '../viewmodel/detail_state.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({
    Key? key, required this.pokemon, required this.userId, required this.isConnect
  }) : super(key: key);
  final Pokemon pokemon;
  final int userId;
  final isConnect;

  @override
  ConsumerState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  DetailController detailController = DetailController();
  TextEditingController controllerk1 = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if(widget.isConnect){
      detailController.checkFavourite(widget.pokemon, widget.userId, ref);
      ref.read(commentProvider.notifier).commentDisplay(widget.pokemon.pokeId, ref);
    }else{
      return;
    }
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controllerk1.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F9EF),
          elevation: 2,
          leading: IconButton(icon:const Icon(Icons.arrow_back_ios), color: const Color(0xffCC000000), onPressed: () {
            Navigator.pop(context);
            ref.refresh(favProvider(widget.userId));
          },),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.25,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF3F9EF),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                          Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Text(widget.pokemon.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textColor),),
                            Text(widget.pokemon.class1, style: const TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),)
                          ],),
                          Text('#${widget.pokemon.pokeId}')
                        ],),
                        margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                      ),
                      Container(height: 125,margin: const EdgeInsets.only(bottom: 20, right: 20),child:
                      CachedNetworkImage(
                        imageUrl: widget.pokemon.image,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),)
                    ],
                  ),),
                Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*0.1,color: Colors.white,child:
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(start: 20),
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                            const Text('Height', style:  TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                            Text(widget.pokemon.height.toString(), style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                          ],),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                            const Text('Weight', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                            Text(widget.pokemon.weight.toString(), style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                          ],),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                            const Text('Heightx', style: TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                            Text(widget.pokemon.height.toString(), style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                          ],),
                        )
                      ],),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.black26,),
                          Text('${ref.watch(likeCountProvider(widget.pokemon))} likes', style: const TextStyle(color: AppColors.lightTextColor),)
                        ],
                      ),
                    )
                  ],
                )
                  ,),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsetsDirectional.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.7,
                                child: TextField(
                                  controller: controllerk1,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: ' comment...',
                                    hintStyle: TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                                  ),
                                ),
                              ),
                              InkWell(onTap: (){
                                ref.watch(commentProvider.notifier).addComment(widget.pokemon.pokeId, widget.userId, controllerk1.text, ref);
                                ref.refresh(commentProvider.notifier).addComment(widget.pokemon.pokeId, widget.userId, controllerk1.text, ref);
                              },child: const Icon(Icons.send, color: AppColors.lightTextColor,))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(start: 40, top: 10, end: 20, bottom: 90),
                            child: ListView.builder(
                              itemCount: ref.watch(getListCmtProvider).length,
                              itemBuilder: (context, index){
                                return Container(
                                  margin: const EdgeInsetsDirectional.only(top:10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ref.watch(getListCmtProvider)[ref.watch(getListCmtProvider).length-index-1].name.toString(), style: const TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.w400),),
                                      Container(margin: const EdgeInsetsDirectional.only(top: 5),child: Text(ref.watch(getListCmtProvider)[ref.watch(getListCmtProvider).length-index-1].desc, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 14),)),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(top: 5),
                                        color: Colors.black26,
                                        height: 1,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
            Positioned(bottom: 40, right: 20 ,child: InkWell(
              onTap: () async {
                if(ref.watch(connectivityProvider) == false){
                  return;
                }else{
                  if(ref.watch(detailStateProvider) == DetailStatus.isNotFavourite){
                    //add
                    await ref.watch(addPokeToFavProvider(MyParamsUserIdPoke(userId: widget.userId, poke: widget.pokemon)));
                    ref.refresh(favProvider3(widget.userId));
                    ref.refresh(detailStateProvider);
                    detailController.checkFavourite(widget.pokemon, widget.userId, ref);
                  }
                  if(ref.watch(detailStateProvider) == DetailStatus.isFavourite){
                    //remove
                    await ref.watch(removePokeFromPavProvider(MyParamsUserIdPoke(userId: widget.userId, poke: widget.pokemon)));
                    ref.refresh(favProvider3(widget.userId));
                    ref.refresh(detailStateProvider);
                    detailController.checkFavourite(widget.pokemon, widget.userId, ref);
                  }
                }

              },
              child: Container(alignment: Alignment.center,width:ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ? 140 : 210,height: 50,decoration: BoxDecoration(color: ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ?const Color(0xff3558CD):const Color(0xffD5DEFF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(2,1),
                        blurRadius: 5
                    )
                  ]
              ),
                child: Text(ref.watch(connectivityProvider)==false? 'No Internet':ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ? 'Mark as favourite' : ref.watch(detailStateProvider) == DetailStatus.isFavourite ? 'Remove from favourites' : 'loading', style: TextStyle(color: ref.watch(detailStateProvider) == DetailStatus.isNotFavourite ?Colors.white:const Color(0xff3558CD), fontWeight: FontWeight.w500),),
              ),
            ))
          ],
        )
    );
  }
}