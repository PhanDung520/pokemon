
class Pokemon{
  String class1;
  int attack;
  int height;
  int hp;
  int pokeId;
  String image;
  String name;
  int speed;
  int weight;
  int like;

  Pokemon(this.class1, this.attack, this.height, this.hp, this.pokeId, this.image, this.name, this.speed, this.weight, this.like);

  Map<String, dynamic> toMap(){
    return{
      'class1': class1,
      'attack': attack,
      'height': height,
      'hp': hp,
      'pokeId': pokeId,
      'image': image,
      'name': name,
      'speed': speed,
      'weight': weight,
      'like':like
    };
  }
}

