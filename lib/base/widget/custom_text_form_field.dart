import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final int? maxLength;
  final String? hint;
  final String? iconPath;
  final bool showVisibilityOptionForPassword;
  final bool borderNeeded;

  final EdgeInsets margin;
  final TextEditingController formController;
  final TextInputType inputType;

  final Color colorInputFieldBackground, colorInputFieldBorder;
  final Color textColor, hintColor, iconColor;

  const CustomTextFormField({
    Key? key,
    required this.formController,
    required this.inputType,
    this.hint,
    this.iconPath,
    this.maxLength,
    this.borderNeeded = true,
    this.colorInputFieldBackground = const Color(0xFFFAFAFA),
    this.colorInputFieldBorder = const Color(0xFFF3F2F2),
    this.textColor = const Color(0xFF272B37),
    this.hintColor = const Color(0xFF707586),
    this.iconColor = const Color(0xD1272B37),
    this.showVisibilityOptionForPassword = true,
    this.margin = const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 12.0,
    ),
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isTextVisible;

  @override
  void initState() {
    _isTextVisible = widget.inputType != TextInputType.visiblePassword;
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
      padding: (widget.iconPath != null && widget.iconPath!.trim().isNotEmpty)
          ? ((widget.inputType == TextInputType.visiblePassword &&
                  widget.showVisibilityOptionForPassword)
              ? EdgeInsets.zero
              : const EdgeInsets.only(right: 16.0))
          : ((widget.inputType == TextInputType.visiblePassword &&
                  widget.showVisibilityOptionForPassword)
              ? const EdgeInsets.only(left: 16.0)
              : const EdgeInsets.symmetric(horizontal: 16.0)),
      child: TextFormField(
        obscureText: !_isTextVisible,
        style: TextStyle(
          color: widget.textColor,
          fontSize: 16.0,
          fontFamily: "Product Sans",
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          prefixIcon:
              (widget.iconPath != null && widget.iconPath!.trim().isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.asset(
                        widget.iconPath!,
                        color: widget.iconColor,
                        fit: BoxFit.contain,
                        height: 20.0,
                      ),
                    )
                  : null,
          suffixIcon: (widget.inputType == TextInputType.visiblePassword &&
                  widget.showVisibilityOptionForPassword)
              ? GestureDetector(
                  child: Icon(
                    // Based on passwordVisible state choose the icon
                    _isTextVisible ? Icons.visibility_off : Icons.visibility,
                    color: widget.iconColor,
                  ),
                  onTap: () {
                    setState(() {
                      _isTextVisible = !_isTextVisible;
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          hintStyle: TextStyle(
            color: widget.hintColor,
            fontSize: 16.0,
            fontFamily: "Product Sans",
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: widget.hint,
        ),
        controller: widget.formController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength),
        ],
      ),
    );
  }
}
