import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String loadingText;
  final Color loadingTextColor;
  final String buttonText;
  final Color buttonTextColor, buttonTextBackgroundColor;
  final double radius, insetV, insetH;

   const CustomElevatedButton({
    super.key,
    required this.isLoading,
    required this.loadingText,
    required this.loadingTextColor,
    required this.buttonText,
    required this.buttonTextColor,
    required this.buttonTextBackgroundColor,
    this.onPressed,
    this.radius = 5,
    this.insetV = 20,
    this.insetH = 20,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical:  widget.insetV,horizontal:  widget.insetH),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        backgroundColor: widget.buttonTextBackgroundColor,
        foregroundColor: widget.buttonTextColor,
      ),
      child: widget.isLoading ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.loadingText),
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  widget.loadingTextColor),
              strokeWidth: 2.0,
            ),
          ),
        ],
      )  : Text(
        widget.buttonText,
        style: TextStyle(
          color: widget.buttonTextColor,
          fontSize : 14
        ),
      ),
    );
  }
}
