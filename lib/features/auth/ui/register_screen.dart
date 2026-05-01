import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/core/widgets/app_button.dart';
import 'package:inventory/core/widgets/custom_text_form_field.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _key = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmationPasswordController = TextEditingController();
  @override
  void dispose() {
    _confirmationPasswordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: .end,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ],
              ),
              Text(
                "!أهلاً بك",
                style: TextStyle(fontSize: 30.sp, fontWeight: .bold),
              ),

              Text(
                "أنشئ حساب جديد",
                style: TextStyle(fontSize: 30.sp, fontWeight: .bold),
              ),

              SizedBox(height: 20.h),
              Form(
                key: _key,
                child: Column(
                  children: [
                    CustomTextFormField(
                      keyboardType: .name,
                      hintText: "الاسم",
                      controller: _nameController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        if (v.length < 4) {
                          return "الاسم يجب ان يحتوي علي 4 احرف اة اكثر";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      keyboardType: .emailAddress,
                      controller: _emailController,
                      hintText: "الايميل",

                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(v)) {
                          return "أدخل إيميل صحيح";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      keyboardType: .visiblePassword,
                      controller: _passwordController,

                      hintText: "كلمة المرور",
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(v)) {
                          return "يجب أن تحتوي كلمة المرور على حروف وأرقام";
                        }
                        if (v.length < 5) {
                          return "كلمة المرور ضعيفة";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFormField(
                      keyboardType: .visiblePassword,
                      controller: _confirmationPasswordController,
                      hintText: "تأكيد كلمة المرور",
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        if (v != _passwordController.text) {
                          return "كلمة مرور خاطئه";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
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
                        text: "إنشاء الحساب",
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                              name: _nameController.text,
                              password: _passwordController.text,
                              email: _emailController.text,
                              confirmPassword:
                                  _confirmationPasswordController.text,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
