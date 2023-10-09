import 'package:flutter/material.dart';

class BuildCreditCard extends StatefulWidget {
  final String cardHolderName;
  final String ccv;
  final String issueCountry;
  final String cardNumber;
  final String cardType;

  const BuildCreditCard(
      {required this.cardHolderName,
      required this.cardNumber,
      required this.ccv,
      required this.issueCountry,
      required this.cardType,
      super.key});

  @override
  State<BuildCreditCard> createState() => _BuildCreditCardState();
}

class _BuildCreditCardState extends State<BuildCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.black87,
      /*1*/
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(
          top: 22,
          left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogosBlock(widget.issueCountry, widget.cardType),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                widget.cardNumber,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                    label: 'Card Holder', value: widget.cardHolderName),
                _buildDetailsBlock(label: 'CVV', value: widget.ccv),

                /* Here we are going to place the _build, DetailsBlock */
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              color: Color.fromARGB(255, 229, 229, 229),
              fontSize: 9,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Row _buildLogosBlock(String issueCountry, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          issueCountry,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}
