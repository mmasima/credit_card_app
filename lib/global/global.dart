import 'dart:convert';

import 'package:credit_card/models/card_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> setBankCard(CardDetailsModel cardDetailsList) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> existingCardList = prefs.getStringList('cardDetails') ?? [];

  existingCardList.add(jsonEncode(cardDetailsList.toJson()));

  prefs.setStringList('cardDetails', existingCardList);
}

Future<List<CardDetailsModel>> getBankCard() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> cardDetailsJsonList = prefs.getStringList('cardDetails') ?? [];

  List<CardDetailsModel> cardDetailsList = cardDetailsJsonList
      .map((cards) => CardDetailsModel.fromJson(jsonDecode(cards)))
      .toList();

  return cardDetailsList;
}

Future<void> banCountries(String banCountry) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> existingBannedList = prefs.getStringList('banList') ?? [];

  if (banCountry.isNotEmpty) {
    existingBannedList.add(jsonEncode(banCountry));
  prefs.setStringList('banList', existingBannedList);
  }
}

Future<List> getBanList() async {
  final prefs = await SharedPreferences.getInstance();
  List cardDetailsJsonList = prefs.getStringList('banList') ?? [];

  List cardDetailsList =
      cardDetailsJsonList.map((cards) => (jsonDecode(cards))).toList();

  return cardDetailsList;
}
