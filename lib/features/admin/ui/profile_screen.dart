import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/auth/ui/login_screen.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final bool isAdmin;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => HomeScreen()),
              );
            },
            icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
          ),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            "الملف الشخصي",
            style: TextStyle(fontSize: 25.sp, color: AppColors.whiteColor),
          ),
          centerTitle: true,
        ),

        body: Padding(
          padding: EdgeInsets.all(16.r),
          child: Center(
            child: Column(
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              children: [
                SizedBox(height: 20.h),

                CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primaryColor,
                  child: const Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  email,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 10.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isAdmin ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isAdmin ? "مدير" : "مستخدم",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),

                SizedBox(height: 30.h),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    icon: Icon(
                      Icons.logout,
                      color: AppColors.whiteColor,
                      size: 18.r,
                    ),
                    label: Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
