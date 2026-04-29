import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/auth/ui/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (c) => BlocProvider(
                    create: (context) => AuthCubit(),
                    child: LoginScreen(),
                  ),
                ),
                (e) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),

          Text(user?.email ?? ""),
        ],
      ),
    );
  }
}
