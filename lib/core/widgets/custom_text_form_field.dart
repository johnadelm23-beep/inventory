import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.obscureText = false,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    this.validator,
    this.maxLines = 1,
  });
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: .onUserInteraction,
      textAlign: .start,
      textDirection: .rtl,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText && isPassword,
      validator: widget.validator,
      controller: widget.controller,
      style: TextStyle(fontSize: 20.sp),
      onTapOutside: (v) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.backGroundTextFormFiled,
        prefixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPassword = !isPassword;
                  });
                },
                icon: isPassword
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 20.sp),
        hintTextDirection: TextDirection.rtl,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.backGroundTextFormFiled),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.errorColorTextFormField),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.sp),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
