import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/auth/ui/login_screen.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(fontFamily: "appFont"),
        home: FirebaseAuth.instance.currentUser == null
            ? LoginScreen()
            : HomeScreen(),
      ),
    );
  }
}
