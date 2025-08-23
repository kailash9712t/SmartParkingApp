import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomList extends StatefulWidget {
  final List<String> list;
  final String hint;
  final String mainHint;
  final void Function(String) assignValue;
  const CustomList({
    super.key,
    required this.list,
    required this.hint,
    required this.mainHint,
    required this.assignValue,
  });

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  String? selectedValue;
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.hint,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(widget.mainHint),
            items:
                widget.list
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                widget.assignValue(value!);
                isFocused = false;
              });
            },
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isFocused ? Colors.blue : Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            dropdownStyleData: DropdownStyleData(
              offset: const Offset(0, -5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onMenuStateChange: (isOpen) {
              setState(() => isFocused = isOpen);
            },
          ),
        ),
      ],
    );
  }
}
