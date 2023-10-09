import 'package:credit_card/models/card_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/card_utils.dart';

class CreditCardNumberInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool isRequired;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final bool? isInt;

  TextEditingController cardNumberController;
  CreditCardNumberInput(
      {required this.cardNumberController,
      this.maxLengthEnforcement = MaxLengthEnforcement.none,
      this.label,
      this.hint,
      this.isRequired = false,
      this.maxLength,
      this.maxLines,
      this.isInt = false,
      super.key});

  @override
  State<CreditCardNumberInput> createState() => _CreditCardNumberInputState();
}

class _CreditCardNumberInputState extends State<CreditCardNumberInput> {
  CardType cardType = CardType.Invalid;
  
  void getCardTypeFrmNumber(TextEditingController cardNumberController) {
    if (cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFormNumber(input);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  @override
  void initState() {
    TextEditingController cardNumber = widget.cardNumberController;
    cardNumber.addListener(
      () {
        getCardTypeFrmNumber(cardNumber);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) // Display label if provided
            Text(
              widget.label!,
            ),
          TextFormField(
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            controller: widget.cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberInputFormatter(),
            ],
            decoration: InputDecoration(
              suffix: Text(
                CardUtils.getCardName(
                  cardType,
                ),
              ),
              suffixIcon: widget.isRequired
                  ? const Icon(
                      Icons.star,
                      color: Colors.black54,
                    )
                  : const Text(
                      'optional',
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
