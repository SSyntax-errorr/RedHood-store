enum Categories { Liquor, SoftDrinks, Cigarettes, FrozenFood, Snacks, Other }

class DataModel {
  final int itemID;
  final String itemName;
  final double itemPrice;
  final String category;
  final String date;
  final int isCommon;
  //late String itemPic;

  const DataModel(
      {required this.itemName,
      required this.itemPrice,
      required this.category,
      required this.itemID,
      required this.date,
      required this.isCommon});

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
      itemID: json['itemID'],
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
      category: json['category'],
      date: json['date'],
      isCommon: json['isCommon']);

  Map<String, dynamic> toJson() => {
        'itemID': itemID,
        'itemName': itemName,
        'itemPrice': itemPrice,
        'category': category,
        'date': date,
        'isCommon': isCommon
      };
}
