import 'package:credit_card/global/global.dart';
import 'package:credit_card/models/card_details.dart';
import 'package:credit_card/widgets/build_credit_card.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late List<CardDetailsModel> cards = [];
  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final savedCards = await getBankCard();
    setState(() {
      cards = savedCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Saved Cards')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cards.isEmpty
                ? const Center(
                    child: Text(
                      'No Cards have been saved',
                    ),
                  )
                : SizedBox(
                    height: 600,
                    child: ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BuildCreditCard(
                            cardHolderName: cards[index].cardHolderName,
                            cardNumber: cards[index].cardNumber,
                            ccv: cards[index].cardCCV,
                            issueCountry: cards[index].country,
                            cardType: cards[index].cardType,
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }
}
