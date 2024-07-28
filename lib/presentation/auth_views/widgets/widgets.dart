import 'package:flutter/material.dart';

class XField extends StatelessWidget {
  final String value;
  final TextEditingController? controller;
  final Function(String) onChanged;
  final String? iconFileName;
  final String? Function(String?)? validator;

  const XField({
    super.key,
    required this.value,
    this.controller,
    required this.onChanged,
    this.validator,
    this.iconFileName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextFormField(
          onChanged: onChanged,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(9)),
            fillColor: const Color(0xFFD9D9D9),
            suffixIcon: iconFileName != null ? Image.asset('assets/auth_page/$iconFileName') : null,
            filled: true,
          ),
        ),
      ),
    );
  }
}

class XButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final bool alter;
  final void Function() onPressed;
  const XButton({
    required this.onPressed,
    required this.alter,
    required this.width,
    required this.height,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          foregroundColor: alter ? Theme.of(context).primaryColor : const Color(0xFFF2DA0E),
          backgroundColor: alter ? Colors.white : const Color(0xFF486C7C),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
