import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDown<T> extends StatefulWidget {
  T value;
  final List<T> itemsList;
  final Color dropdownColor;
  final Function onChanged;
  final bool isExpanded;
  final double margin;
  final List<DropdownMenuItem<T>> dropDownMenuItems;
  final bool showDropdown;
  final String selectedString;

  CustomDropDown({
    required this.value,
    required this.itemsList,
    required this.dropdownColor,
    required this.onChanged,
    required this.dropDownMenuItems,
    this.isExpanded = true,
    this.showDropdown = true,
    this.selectedString = "",
    this.margin = 00,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      height: 50,
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        color: widget.dropdownColor,
        // color: Colors.green,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: DropdownButton<T>(
            // selectedItemBuilder: (context) {
            //   return [

            //     Text("data")
            //   ];
            // },
            icon: widget.showDropdown
                ? const Icon(Icons.arrow_drop_down)
                : const SizedBox.shrink(),
            isExpanded: widget.isExpanded,
            isDense: true,
            dropdownColor: widget.dropdownColor,
            value: widget.value,
            items: widget.dropDownMenuItems,
            // alignment: Alignment.topLeft,
            onChanged: (value) => updateValue(value as T),
          ),
        ),
      ),
    );
  }

  void updateValue(T value) {
    widget.value = value;
    widget.onChanged(value);
    setState(() {});
  }
}
