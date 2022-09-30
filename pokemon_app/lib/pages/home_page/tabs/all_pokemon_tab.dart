import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/values/app_colors.dart';
import '../../../utils/utils.dart';
import '../../detals_page/detail_page.dart';
import '../home_controller.dart';

class AllPokemonTab extends ConsumerStatefulWidget {
  const AllPokemonTab({
    Key? key, required this.userId
  }) : super(key: key);
  final int userId;

  @override
  ConsumerState createState() => _AllPokemonTabState();
}

class _AllPokemonTabState extends ConsumerState<AllPokemonTab> {
  @override
  void initState() {
    // TODO: implement initState
    pokeGet();//get data
    super.initState();
  }

  Future<void> pokeGet() async{
    List<Pokemon> listPoke =[];
    if(mounted){
      await firestore.collection('pokemons').get().then((value) => {
        value.docs.forEach((element) {
          listPoke.add(Pokemon(element['class'], element['attack'], element['height'], element['hp'], element['id'], element['image'], element['name'], element['speed'], element['weight']));
        })
      });
      ref.read(pokeGet2Provider.notifier).state = listPoke;
    }
  }
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(pokeGet2Provider);
    return Container(
      padding: EdgeInsets.all(15),
      child: GridView.count(physics: BouncingScrollPhysics(),childAspectRatio: (MediaQuery.of(context).size.width*0.5/ 250),crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, children: List.generate(data.length, (index) {
        return InkWell(
          onTap: (){
            //move to details
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(pokemon: data[index], userId: widget.userId,)));
          },
          child: Container( child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            Container(child: Image.network(data[index].image),height: 100,width: MediaQuery.of(context).size.width*0.6,),
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
  }
}

