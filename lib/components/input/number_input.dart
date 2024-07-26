import 'package:flutter/material.dart';
import 'package:oprs/constant_values.dart';

class NumberInput extends StatefulWidget {
  final String label;
  final int initialValue,limitValue, changeValue;
  final void Function(int) onValueChanged;

  const NumberInput({
    super.key,
    this.changeValue = 1,
    required this.initialValue,
    required this.onValueChanged,
    required this.label,
    required this.limitValue,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  int currentValue = 0;
  late int limitvalue;
  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
    limitvalue = widget.limitValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child:
            Text(
              widget.label.length > 30 ?
              widget.label.substring(0,30) :
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                color: MyColors.headerFontColor,
              )
            )),
          Wrap(
            children: [
              IconButton.outlined(
                  onPressed: (){
                    if(currentValue > 0){
                      setState(() {
                        currentValue-=widget.changeValue;
                      });
                      widget.onValueChanged(currentValue);
                    }
                  },
                  icon: const Icon(Icons.remove)
              ),
              Container(
                width: 50,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: const Border.fromBorderSide(BorderSide(
                        color: MyColors.mainThemeDarkColor,
                        width: 1,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside
                    )),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Text('${widget.initialValue}'),
              ),
              IconButton.outlined(
                  onPressed: (){
                    if(currentValue <= widget.limitValue){
                      setState(() {
                        currentValue+=widget.changeValue;
                      });
                      widget.onValueChanged(currentValue);
                    }
                  },
                  icon: const Icon(Icons.add)
              )
            ],
          )
        ],
      ),
    );
  }
}