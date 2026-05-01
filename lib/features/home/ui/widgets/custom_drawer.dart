import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/admin/ui/all_users.dart';
import 'package:inventory/features/admin/ui/dashboard_admin.dart';
import 'package:inventory/features/admin/ui/profile_screen.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/auth/ui/login_screen.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/widgets/about_app_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final user = context.watch<HomeCubit>().userData;

        if (user == null) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        }

        return Drawer(
          backgroundColor: const Color(0xfff7f7f7),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 60.h,
                  bottom: 20.h,
                  right: 16.w,
                  left: 16.w,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, Colors.blue],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.person, color: Colors.black),
                    ),
                    SizedBox(width: 12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email ?? "",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              /// 📌 المحتوى
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (user.isAdmin == true)
                      _tile(
                        icon: Icons.dashboard_outlined,
                        title: "لوحة التحكم",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashboardAdmin(user: user),
                            ),
                          );
                        },
                      ),

                    _tile(
                      icon: Icons.person_outline,
                      title: "الملف الشخصي",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              name: user.name ?? "",
                              email: user.email ?? "",
                              isAdmin: user.isAdmin ?? false,
                            ),
                          ),
                        );
                      },
                    ),

                    if (user.isAdmin == true)
                      _tile(
                        icon: Icons.group_outlined,
                        title: "كل المستخدمين",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UsersScreen()),
                          );
                        },
                      ),

                    const Divider(height: 30),

                    AboutAppListTitle(),

                    const Divider(height: 30),

                    /// 🚪 Logout
                    _tile(
                      icon: Icons.logout,
                      title: "تسجيل الخروج",
                      color: Colors.red,
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        context.read<HomeCubit>().cleaUser();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiBlocProvider(
                              providers: [
                                BlocProvider(create: (_) => AuthCubit()),
                                BlocProvider(create: (_) => HomeCubit()),
                              ],
                              child: const LoginScreen(),
                            ),
                          ),
                          (r) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🎯 Widget reusable جميل
  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }
}
