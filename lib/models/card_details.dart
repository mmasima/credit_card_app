class CardDetailsModel {
  final String cardNumber;
  final String cardHolderName;
  final String cardCCV;
  final String country;
  final String cardType;

  CardDetailsModel({
    required this.cardNumber,
    required this.cardHolderName,
    required this.cardCCV,
    required this.country,
    required this.cardType,
  });

  // Define a toJson method to convert the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'cardCCV': cardCCV,
      'country': country,
      'cardType': cardType,
    };
  }

  // Define a factory constructor to create an object from a JSON map
  factory CardDetailsModel.fromJson(Map<String, dynamic> json) {
    return CardDetailsModel(
      cardNumber: json['cardNumber'],
      cardHolderName: json['cardHolderName'],
      cardCCV: json['cardCCV'],
      country: json['country'],
      cardType: json['cardType'],
    );
  }
}
