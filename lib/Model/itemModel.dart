enum Categories { Liquor, SoftDrinks, Cigarettes, FrozenFood, Snacks, Other }

class DataModel {
  final int itemID;
  final String itemName;
  final double itemPrice;
  final String category;
  final String date;
  //late String itemPic;

  const DataModel(
      {required this.itemName,
      required this.itemPrice,
      required this.category,
      required this.itemID,
      required this.date});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      itemID: json['itemID'],
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      category: json['category'],
      date: json['date']);

  Map<String, dynamic> toJson() => {
        'itemID': itemID,
        'itemName': itemName,
        'itemPrice': itemPrice,
        'category': category,
        'date': date
      };
}
