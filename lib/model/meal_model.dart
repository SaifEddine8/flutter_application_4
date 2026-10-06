class MealModel {
  final String? id;
  final String img;
  final String name;
  final double price;
  final String description;
  final String category;
  final bool isFav;


  MealModel({
     this.id,
    required this.img,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    this.isFav=false,
  });

  MealModel copyWith({
    String? id,
    String? img,
    String? name,
    double? price,
    String? description,
    String? category,
    bool? isFav,

  }) {
    return MealModel(
      id: id ?? this.id,
      img: img ?? this.img,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      isFav: isFav ?? this.isFav,
    );
  }


  Map<String, dynamic> toMap()
  {
    return {
      'id':id,
      'name':name,
      'category':category,
      'description':description,
      'img':img,
      'price':price,
      'isFav':isFav,
      

    };
  }
 factory MealModel.fromMap(Map<String,dynamic>map,String docID)
  {
  return MealModel(
    id:docID,
    img: map['img'], name: map['name'], price: map['price'], description: map['description'], category: map['category']);

  }
}