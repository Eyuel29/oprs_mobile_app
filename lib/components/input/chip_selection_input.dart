import 'package:flutter/material.dart';
class SelectionChip{
  String label;
  bool selected;
  SelectionChip(this.label, this.selected);

  SelectionChip copy(){
    return SelectionChip(label, selected);
  }

  @override
  String toString() {
    return 'SelectionChip{label: $label, isSelected: $selected}';
  }
}

class ChipSelectionInput extends StatefulWidget{
  final List<SelectionChip> options;
  final double radius, gap, padding, fontSize;
  final bool singleSelection;
  final int limit;
  final Function(List<SelectionChip>) onSelected;
  final Color lightColor;
  final Color darkColor;

  const ChipSelectionInput({
    super.key,
    required this.options,
    required this.limit,
    required this.onSelected,
    required this.radius,
    required this.gap,
    required this.padding,
    required this.fontSize,
    required this.singleSelection,
    required this.lightColor,
    required this.darkColor,
  });

  void setValues(List<String> values){
    for (var element in options) {
      if(values.contains(element.label)) {
        element.selected = true;
      }
    }
  }

  @override
  State<ChipSelectionInput> createState() => _ChipSelectionInputState();
}

class _ChipSelectionInputState extends State<ChipSelectionInput>{

  int getNumberOfSelected(List<SelectionChip> allSelections){
    return allSelections.where((element) =>
    element.selected == true).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: widget.gap,
          runSpacing: widget.gap,
          children: List.generate(
            widget.options.length,
              (index) {
                return ChoiceChip(
                  label : Text(
                    widget.options[index].label,
                    style: const TextStyle(fontSize: 14),
                  ),
                  showCheckmark: false,
                  selected : widget.options[index].selected,
                  padding : EdgeInsets.all(widget.padding),
                  checkmarkColor : widget.options[index].selected ? widget.lightColor : widget.darkColor,
                  backgroundColor : widget.options[index].selected ? widget.darkColor : widget.lightColor,
                  selectedColor : widget.options[index].selected ? widget.darkColor : widget.lightColor,
                  onSelected : (value){
                    setState(() {
                      if(widget.singleSelection){
                        for (var element in widget.options) {
                          element.selected = false;
                        }
                      }
                      if(!value || getNumberOfSelected(widget.options) <= widget.limit){
                        widget.options[index].selected = value;
                      }
                    });
                    widget.onSelected(widget.options);
                  },
                  labelStyle : TextStyle(
                    color : widget.options[index].selected ? widget.lightColor : widget.darkColor,
                    fontSize: widget.fontSize,
                  ),
                  shape : RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1, color: widget.darkColor, style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside
                    ),
                    borderRadius: BorderRadius.circular(widget.radius)
                ),
              );
            }
          )
      ),
    );
  }
}