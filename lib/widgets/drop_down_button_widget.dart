import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatelessWidget {
  final Size size;
  final List<String> listOfOptions;
  final String? valueInitial;
  final void Function(String?)? funSelectOption;
  final Text hintText;

  const DropDownButtonWidget({
    super.key,
    required this.size,
    required this.listOfOptions,
    required this.valueInitial,
    required this.funSelectOption,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.92,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        iconSize: 30,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        dropdownColor: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        hint: hintText,
        items:
            listOfOptions.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
        value: valueInitial,
        onChanged: funSelectOption,
        underline: Container(),
      ),
    );
  }
}
