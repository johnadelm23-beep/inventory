import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/core/widgets/app_button.dart';
import 'package:inventory/core/widgets/custom_text_form_field.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/auth/ui/register_screen.dart';
import 'package:inventory/features/auth/ui/widgets/sigin_with_google_container.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _key = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  "!أهلاً بعودتك مرة أخري",
                  style: TextStyle(fontWeight: .bold, fontSize: 30.sp),
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: "الايميل",
                        controller: _emailController,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "هذا الحقل مطلوب";
                          }
                        },
                        keyboardType: .emailAddress,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextFormField(
                        hintText: "كلمة المرور",
                        obscureText: true,
                        controller: _passwordController,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "هذا الحقل مطلوب";
                          }
                        },
                        keyboardType: .visiblePassword,
                      ),
                      SizedBox(height: 20.h),
                      BlocListener<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthLoadingState) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
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
                                backgroundColor:
                                    AppColors.errorColorTextFormField,
                              ),
                            );
                          }
                        },
                        child: AppButton(
                          text: 'تسجيل دخول',
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                password: _passwordController.text,
                                email: _emailController.text,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                AppButton(
                  text: "إنشاء حساب جديد",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => BlocProvider(
                          create: (context) => AuthCubit(),
                          child: RegisterScreen(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                SiginWithGoogleContainer(
                  onTap: () {
                    context.read<AuthCubit>().signInWithGoogle();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
