import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';

class CustomTextInput extends StatefulWidget {
  final TextInputType? inputType;
  final bool obscureText;
  final String hintText;
  final IconData? clearIcon;
  final Function(String)? onChanged;
  final Function(String)? iconTapped;
  final void Function()? onTap;
  final int maxValue, minLines, maxLines;
  final String? errorText;
  final bool enabled;
  final String initialValue;

  const CustomTextInput({
    super.key,
    this.inputType,
    this.initialValue = "",
    this.maxValue = 40,
    this.obscureText = false,
    required this.hintText,
    this.clearIcon,
    this.onChanged,
    this.errorText,
    this.iconTapped,
    this.minLines = 1,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        TextFormField(
        keyboardType: widget.inputType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxValue,
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        style: const TextStyle(
            fontSize: 14,
            color: MyColors.bodyFontColor
        ),
        decoration: InputDecoration(
          fillColor: MyColors.mainThemeLightColor,
          labelText: widget.hintText,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: MyColors.bodyFontColor
          ),
          errorStyle: const TextStyle(color: Colors.red),
          errorMaxLines: 2,
          contentPadding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: MyColors.mainThemeDarkColor, width: 5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyColors.mainThemeDarkColor, width: 2.0),
            borderRadius: BorderRadius.circular(5),
          ),
          errorText: widget.errorText,
          suffixIcon: GestureDetector(
              onTap:  () => widget.iconTapped,
              child: Icon( widget.clearIcon ),),
          ),
        ),
      ],
    );
  }
}