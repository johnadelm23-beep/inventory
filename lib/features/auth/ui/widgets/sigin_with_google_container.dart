import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/core/theme/app_colors.dart';

class SiginWithGoogleContainer extends StatelessWidget {
  const SiginWithGoogleContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.backGroundTextFormFiled,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: .center,
          children: [
            SvgPicture.asset("assets/icons/google.svg"),
            SizedBox(width: 10.w),
            Text("تسجيل الدخول بحساب جوجل", style: TextStyle(fontSize: 20.sp)),
          ],
        ),
      ),
    );
  }
}
