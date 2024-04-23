enum Categories { Liquor, SoftDrinks, Cigarettes, FrozenFood, Snacks, Other }

class DataModel {
  final int itemID;
  final String itemName;
  final double itemPrice;
  final String category;
  //late String itemPic;

  const DataModel(
      {required this.itemName,
      required this.itemPrice,
      required this.category,
      required this.itemID});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      itemID: json['itemID'],
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      category: json['category']);

  Map<String, dynamic> toJson() => {
        'itemID': itemID,
        'itemName': itemName,
        'itemPrice': itemPrice,
        'category': category
      };
}
