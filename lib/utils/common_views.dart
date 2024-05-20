import 'package:flutter/material.dart';

class CommonViews {
  CommonViews._private();

  static final CommonViews _shared = CommonViews._private();

  factory CommonViews() => _shared;

  AppBar customAppBar({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurpleAccent,
      bottom:  PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 390,
                child: TextField(
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "Search here",
                      suffixIcon: Icon(Icons.search),
                      fillColor: Colors.white,
                      filled: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget createTextFormField(
      {required TextEditingController controller,
        required FocusNode focusNode,
        String? label,
        TextInputAction? inputAction,
        final double? radius,
        ValueChanged<String>? onSubmitted,
        String? prefixText,
        String? hint,
        Widget? suffixIcon,
        IconData? prefixIcon,
        String? errorText,
        FormFieldValidator<String>? validator,
        bool isObscure = false}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.name,
      textInputAction: inputAction ?? TextInputAction.next,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        prefixIcon: Icon(
          prefixIcon,
          size: 25,
          color: Colors.deepPurpleAccent,
        ),
        filled: true,
        fillColor: const Color(0xFFF1E6FF),
        prefix: Text(prefixText ?? ''),
        suffixIcon: suffixIcon,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: _getBorder(radius),
      ),
    );
  }
  OutlineInputBorder _getBorder(radius) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius ?? 10),
        borderSide: BorderSide.none);
  }
}
