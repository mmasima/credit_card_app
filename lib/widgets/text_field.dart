import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool isRequired;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final bool? isInt;
  const MyTextField(
      {this.label,
      this.hint,
      this.controller,
      this.isRequired = false,
      this.maxLengthEnforcement = MaxLengthEnforcement.none,
      this.maxLength,
      this.maxLines,
      this.isInt = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) // Display label if provided
            Text(
              label!,
            ),
          TextFormField(
            keyboardType: isInt! ? TextInputType.number : TextInputType.text,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            maxLines: maxLines,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
            decoration: InputDecoration(
              hintText: hint,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              enabledBorder: const UnderlineInputBorder(),
              errorStyle: const TextStyle(color: Colors.red),
              suffixIcon: isRequired
                  ? const Icon(
                      Icons.star,
                      color: Colors.black54,
                    )
                  : const Text(
                      'optional',
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
            validator: (value) =>
                isRequired && value!.isEmpty ? 'Field cannot be empty' : null,
          ),
        ],
      ),
    );
  }
}
