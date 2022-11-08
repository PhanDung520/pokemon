import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/models/pokemon/pokemon.dart';
import 'package:pokemon_app/pages/detail_page/bloc/detail_bloc.dart';
import 'package:pokemon_app/pages/detail_page/bloc/detail_event.dart';
import 'package:pokemon_app/pages/detail_page/bloc/detail_state.dart';

import '../../../values/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.pokemon, required this.userId, required this.isConnect }) : super(key: key);
  final Pokemon pokemon;
  final int userId;
  final bool isConnect;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController controllerk1 = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controllerk1.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<DetailFavoriteBloc>(create: (context)=> DetailFavoriteBloc()..add(CheckIsFavorite(pokemon: widget.pokemon, userId: widget.userId, isConnect: widget.isConnect))),
      BlocProvider<DetailAddCommentBloc>(create: (context)=> DetailAddCommentBloc()),
      BlocProvider<DetailLoadCommentBloc>(create: (context)=> DetailLoadCommentBloc()..add(LoadComment(pokeId: widget.pokemon.pokeId, isConnect: widget.isConnect)))
    ], child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F9EF),
          elevation: 2,
          leading: IconButton(icon:const Icon(Icons.arrow_back_ios), color: AppColors.lightTextColor, onPressed: () {
            Navigator.pop(context,'Returned');
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
                        margin: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                          Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Text(widget.pokemon.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textColor),),
                            Text(widget.pokemon.class1, style: const TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),)
                          ],),
                          Text('#${widget.pokemon.pokeId}')
                        ],),
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
                            Text(AppLocalizations.of(context)!.height, style:  const TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                            Text(widget.pokemon.height.toString(), style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                          ],),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                            Text(AppLocalizations.of(context)!.weight, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
                            Text(widget.pokemon.weight.toString(), style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),)
                          ],),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.05,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
                            Text(AppLocalizations.of(context)!.tall, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 12),),
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
                          BlocConsumer<DetailFavoriteBloc, DetailState>(
                            listener: (context, state) {
                            },
                            builder: (context, state) {
                              if(state is DetailFavoriteIsFalse){
                                return Text('${state.newLike.toString()} ${AppLocalizations.of(context)!.like}', style: const TextStyle(color: AppColors.lightTextColor),);
                              } else if(state is DetailFavoriteIsTrue){
                                return Text('${state.newLike.toString()} ${AppLocalizations.of(context)!.like}', style: const TextStyle(color: AppColors.lightTextColor),);
                              } else {
                                return const Text('Loading...');
                              }
                            },
                          )
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
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: AppLocalizations.of(context)!.comment,
                                        hintStyle: const TextStyle(color: AppColors.lightTextColor, fontSize: 14)
                                    ),
                                  ),
                                ),
                                BlocConsumer<DetailAddCommentBloc, DetailState>(
                                  listener: (context, state) {
                                    // TODO: implement listener
                                    if(state is DetailCommentSuccess){
                                      context.read<DetailLoadCommentBloc>().add(LoadComment(pokeId: widget.pokemon.pokeId, isConnect:widget.isConnect));
                                    }
                                  },
                                  builder: (context, state) {
                                    return InkWell(onTap: (){
                                      //do add comment
                                      if(controllerk1.text != ''&& widget.isConnect){
                                        context.read<DetailAddCommentBloc>().add(AddComment(userId: widget.userId, pokeId: widget.pokemon.pokeId, comment: controllerk1.text));
                                      }
                                    },child: const Icon(Icons.send, color: AppColors.lightTextColor,));
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: BlocConsumer<DetailLoadCommentBloc, DetailState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              if(state is DetailLoadCommentSuccess){
                                return Container(
                                  margin: const EdgeInsetsDirectional.only(start: 40, top: 10, end: 20, bottom: 90),
                                  child: ListView.builder(
                                    itemCount: state.listCmt.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        margin: const EdgeInsetsDirectional.only(top:10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(state.listCmt[state.listCmt.length-index-1].name.toString(), style: const TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.w400),),
                                            Container(margin: const EdgeInsetsDirectional.only(top: 5),child: Text(state.listCmt[state.listCmt.length-index-1].desc, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 14),)),
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
                                );
                              }else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ],
            ),
            Positioned(bottom: 40, right: 20 ,child:
              BlocConsumer<DetailFavoriteBloc, DetailState>(
              listener: (context, state) {
                // TODO: implement listener
                // print(state.toString());
              },
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    if(widget.isConnect){
                      if(state is DetailFavoriteIsFalse){
                        context.read<DetailFavoriteBloc>().add(AddToFavorite(pokemon: widget.pokemon, userId: widget.userId));
                      }else{
                        context.read<DetailFavoriteBloc>().add(RemoveFromFavorite(pokemon: widget.pokemon, userId: widget.userId));
                      }
                    }else{
                      final snackBar = SnackBar(
                        content: Text(AppLocalizations.of(context)!.errorInternet),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(alignment: Alignment.center,width: state is DetailFavoriteIsFalse? 140: 210,height: 50,decoration: BoxDecoration(color: state is DetailFavoriteIsFalse? const Color(0xff3558CD):const Color(0xffD5DEFF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2,1),
                          blurRadius: 5
                      )
                    ]
                  ),
                    child:Text(state is DetailFavoriteIsFalse ? AppLocalizations.of(context)!.markAsFav: state is DetailFavoriteIsTrue? AppLocalizations.of(context)!.removeFromFav: AppLocalizations.of(context)!.loading, style: TextStyle(color: state is DetailFavoriteIsFalse? Colors.white: const Color(0xff3558CD), fontWeight: FontWeight.w500),),
                  ),
                );
              },
            ))
          ],
        )
      )
    );
  }
}
