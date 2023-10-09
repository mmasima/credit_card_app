import 'package:country_picker/country_picker.dart';
import 'package:credit_card/models/card_details.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_scanner/models/card_details.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../models/card_type.dart';
import '../models/card_utils.dart';
import '../widgets/confirmation_dialog_design.dart';
import '../widgets/error_dialog.dart';
import '../widgets/text_field.dart';
import '../widgets/text_field_credit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardTypeController = TextEditingController();
  TextEditingController ccv = TextEditingController();
  TextEditingController cardHolderName = TextEditingController();

  Country? issueCountry;
  CardType cardType = CardType.Invalid;

  CardDetails? _cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  void _clearCardForm() {
    setState(() {
      cardNumber.clear();
      cardTypeController.clear();
      ccv.clear();
      cardHolderName.clear();
      issueCountry = null;
    });
  }

  void getCardTypeFromNumber(TextEditingController cardNumberController) {
    if (cardNumberController.text.length >= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFormNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  Future<void> scanCard() async {
    final CardDetails? cardDetails =
        await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
      print('hello world $_cardDetails');
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24),
        ),
        leading: IconButton(onPressed: () => scanCard(), icon: Icon(Icons.add)),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () async {
            showConfirmationDialog(context);
          },
          child: const Text('submit'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 40, bottom: 15),
                  child: Text(
                    'Card Details',
                    style: TextStyle(
                      fontSize: 24.0, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        controller: cardHolderName,
                        label: "Name On Card",
                        isRequired: true,
                      ),
                      CreditCardNumberInput(
                        label: "Card Number",
                        cardNumberController: cardNumber,
                        isRequired: true,
                      ),
                      MyTextField(
                        maxLength: 3,
                        isInt: true,
                        controller: ccv,
                        label: "CCV number",
                        isRequired: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            issueCountry?.displayNameNoCountryCode != null
                                ? '${issueCountry?.name}'
                                : '',
                            style: const TextStyle(
                              fontSize: 18.0, // Adjust the font size as needed
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          showCountryPicker(
                              context: context,
                              onSelect: (Country country) {
                                setState(() {
                                  issueCountry = country;
                                });
                              });
                        },
                        child: const Text('Choose country of issue'),
                      ),
                      // const SizedBox(height: 40),

                      const SizedBox(height: 30),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(context) async {
    List banList = await getBanList();
    final savedCards = await getBankCard();
    bool hasError = false;

    if (issueCountry == null) {
      hasError = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: 'Country Banned',
            content: 'This Country has been banned and cant be selected',
            onConfirm: () {
              // Save the address and then go back
            },
          );
        },
      );
    }

    if (banList.contains(issueCountry?.name)) {
      hasError = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: 'Country Banned',
            content: 'This Country has been banned and cant be selected',
            onConfirm: () {
              // Save the address and then go back
            },
          );
        },
      );
    }
    bool isDuplicateNumber =
        savedCards.any((element) => element.cardNumber == cardNumber.text);

    if (isDuplicateNumber) {
      hasError = true;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            title: 'Card Duplicate',
            content: 'Card Number already exists',
            onConfirm: () {
              // Save the address and then go back
            },
          );
        },
      );
    }
    if (!hasError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: 'Confirm',
            content: 'Are you sure you want to save the card details?',
            onConfirm: () {
              _saveAddressAndGoBack(context);
            },
          );
        },
      );
    }
  }

  void _saveAddressAndGoBack(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      getCardTypeFromNumber(cardNumber);
      final cardDetails = CardDetailsModel(
        cardNumber: cardNumber.text,
        cardHolderName: cardHolderName.text,
        cardCCV: ccv.text,
        country: issueCountry?.name ?? '',
        cardType: cardType.name,
      );
      setBankCard(cardDetails);
      _clearCardForm();
    }
  }
}
