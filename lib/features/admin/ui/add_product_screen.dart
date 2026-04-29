import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/core/widgets/app_button.dart';
import 'package:inventory/core/widgets/custom_text_form_field.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _quantityController = TextEditingController();

  final _minQuantity_conrtoller = TextEditingController();

  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _descriptionController.dispose();
    _minQuantity_conrtoller.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
        ),
        title: Text(
          "إضافة منتج جديد",
          style: TextStyle(fontSize: 30.sp, color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  spacing: 20.h,

                  children: [
                    CustomTextFormField(
                      hintText: "اسم المنتج",
                      keyboardType: .name,
                      controller: _nameController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "اسم المنتج مطلوب";
                        }
                        if (v.trim().length < 3) {
                          return "اسم المنتج قصير جدًا";
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      hintText: "الكمية المتاحه",
                      keyboardType: .number,
                      controller: _quantityController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "الكمية مطلوبة";
                        }

                        final number = int.tryParse(v);
                        if (number == null) {
                          return "ادخل رقم صحيح";
                        }

                        if (number < 0) {
                          return "الكمية لا يمكن أن تكون سالبة";
                        }

                        return null;
                      },
                    ),
                    CustomTextFormField(
                      hintText: "أقل كميه ترغب بها موجوده لديك",
                      keyboardType: .number,
                      controller: _minQuantity_conrtoller,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "هذا الحقل مطلوب";
                        }

                        final number = int.tryParse(v);
                        if (number == null) {
                          return "ادخل رقم صحيح";
                        }

                        if (number < 0) {
                          return "لا يمكن أن تكون أقل من 0";
                        }

                        return null;
                      },
                    ),
                    CustomTextFormField(
                      hintText: "معلومات عن المنتج",
                      keyboardType: .name,
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    SizedBox(height: 50.h),
                    BlocListener<HomeCubit, HomeState>(
                      listener: (context, state) {
                        if (state is AddProductLoading) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is AddProductSuccess) {
                          Navigator.pop(context); // يقفل اللودينج

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تم إضافة المنتج بنجاح"),
                            ),
                          );

                          Navigator.pop(context); // يرجع للهوم
                        } else if (state is AddProductError) {
                          Navigator.pop(context); // يقفل اللودينج

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("حدث خطأ، حاول مرة أخرى"),
                            ),
                          );
                        }
                      },
                      child: AppButton(
                        text: "إضافة المنتج",
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            context.read<HomeCubit>().addProduct(
                              name: _nameController.text,
                              quantity: _quantityController.text,
                              minQuantity: _minQuantity_conrtoller.text,
                              description: _descriptionController.text,
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
