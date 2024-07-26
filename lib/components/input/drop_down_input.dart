import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';

class DropDownButtonForm extends StatefulWidget {
  final void Function(String?)? onChanged;
  final String? errorText, hintText, initialValue;
  final List<String> allOptions;

  const DropDownButtonForm({
    super.key,
    this.onChanged,
    this.errorText,
    required this. hintText,
    required this.allOptions,
    required this.initialValue
  });
  @override
  State<DropDownButtonForm> createState() => _DropDownButtonFormState();
}

class _DropDownButtonFormState extends State<DropDownButtonForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: widget.initialValue,
          onChanged: widget.onChanged,
          style: const TextStyle(
              fontSize: 14,
              color: MyColors.headerFontColor
          ),
          decoration: InputDecoration(
              fillColor: MyColors.mainThemeLightColor,
              errorStyle: const TextStyle(color: Colors.red),
              contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: MyColors. mainThemeLightColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: MyColors. mainThemeLightColor, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              labelText: widget.hintText
          ),
          items: widget.allOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
