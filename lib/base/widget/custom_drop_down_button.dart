import 'package:flutter/material.dart';
import 'package:spense_app/data/remote/model/country/country.dart';

class CustomDropDownButton extends StatefulWidget {
  final String? initialValue;
  final String? prefixIconPath;
  final String? hint;
  final bool isExpanded;
  final bool borderNeeded;

  final EdgeInsets margin;

  final Color colorInputFieldBackground, colorInputFieldBorder;
  final Color textColor, iconColor, hintColor;

  final List<Country> items;
  final ValueChanged<Country?> onChanged;

  const CustomDropDownButton({
    Key? key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.hint,
    this.prefixIconPath,
    this.borderNeeded = true,
    this.colorInputFieldBackground = const Color(0xFFFAFAFA),
    this.colorInputFieldBorder = const Color(0xFFF3F2F2),
    this.textColor = const Color(0xFF272B37),
    this.hintColor = const Color(0xFF707586),
    this.iconColor = const Color(0xD1272B37),
    this.isExpanded = true,
    this.margin = const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 12.0,
    ),
  }) : super(key: key);

  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  late Country? _currentValue;

  @override
  void initState() {
    _currentValue = widget.items.isNotEmpty ? widget.items.first : null;

    widget.onChanged(_currentValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.colorInputFieldBackground,
        borderRadius: BorderRadius.all(
          const Radius.circular(12.0),
        ),
        border: widget.borderNeeded
            ? Border.fromBorderSide(
                BorderSide(color: widget.colorInputFieldBorder),
              )
            : null,
      ),
      padding: (widget.prefixIconPath != null &&
              widget.prefixIconPath!.trim().isNotEmpty)
          ? const EdgeInsets.only(right: 8.0)
          : const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<Country>(
            hint: (widget.prefixIconPath != null &&
                    widget.prefixIconPath!.trim().isNotEmpty &&
                    widget.hint != null &&
                    widget.hint!.trim().isNotEmpty)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.prefixIconPath != null &&
                          widget.prefixIconPath!.trim().isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(
                            top: 4.0,
                            bottom: 4.0,
                            right: 12.0,
                          ),
                          child: Image.asset(
                            widget.prefixIconPath!,
                            color: widget.iconColor,
                            fit: BoxFit.contain,
                            height: 20.0,
                          ),
                        ),
                      if (widget.hint != null && widget.hint!.trim().isNotEmpty)
                        Text(
                          widget.hint!,
                          style: TextStyle(
                            color: widget.hintColor,
                            fontSize: 16.0,
                            fontFamily: "Product Sans",
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                    ],
                  )
                : null,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 16.0,
              fontFamily: "Product Sans",
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
            items: widget.items.map(
              (Country dropdownItem) {
                return DropdownMenuItem<Country>(
                  value: dropdownItem,
                  child: Row(
                    children: [
                      if (widget.prefixIconPath != null &&
                          widget.prefixIconPath!.trim().isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(
                            top: 4.0,
                            bottom: 4.0,
                            right: 12.0,
                          ),
                          child: Image.asset(
                            widget.prefixIconPath!,
                            color: widget.iconColor,
                            fit: BoxFit.contain,
                            height: 20.0,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          dropdownItem.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: (Country? newlySelectedValue) {
              widget.onChanged(newlySelectedValue);

              if (newlySelectedValue != null) {
                setState(
                  () {
                    _currentValue = newlySelectedValue;
                  },
                );
              }
            },
            value: _currentValue,
            underline: SizedBox.shrink(),
            isExpanded: widget.isExpanded,
          ),
        ),
      ),
    );
  }
}
