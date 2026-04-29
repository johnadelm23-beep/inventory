import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class SiginWithGoogleContainer extends StatelessWidget {
  const SiginWithGoogleContainer({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }
        if (state is AuthSuccessState) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => HomeScreen()),
          );
        }
        if (state is AuthErrorState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: AppColors.whiteColor),
              ),
              backgroundColor: AppColors.errorColorTextFormField,
            ),
          );
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
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
                Text(
                  "تسجيل الدخول بحساب جوجل",
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
