import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/core/widgets/custom_text_form_field.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/widgets/custom_drawer.dart';
import 'package:inventory/features/home/ui/widgets/custom_list_view_products.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchTitle = "";
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getUserData();
    context.read<HomeCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is DeleteProductLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          if (state is DeleteProductSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم حذف المنتج بنجاح")),
            );
          }

          if (state is DeleteProductError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("حدث خطأ أثناء الحذف")),
            );
          }
        },
        child: Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.whiteColor, size: 30.r),
            backgroundColor: AppColors.primaryColor,
            title: Text(
              "الصفحة الرئيسية",
              style: TextStyle(fontSize: 25.sp, color: AppColors.whiteColor),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final user = context.watch<HomeCubit>().userData;

              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              textDirection: .rtl,
                              "مرحباً بك يا ${user.name} 👋",
                              style: TextStyle(fontSize: 22.sp),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomTextFormField(
                        hintText: "ابحث عن منتج",
                        keyboardType: .name,
                        onChanged: (v) {
                          setState(() {
                            searchTitle = v.toLowerCase();
                          });
                        },
                      ),
                    ),

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("products")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text("حدث خطأ"));
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final docs = snapshot.data!.docs;
                          final filterProducts = docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final name = (data["name"] ?? "")
                                .toString()
                                .toLowerCase();
                            return name.contains(searchTitle);
                          }).toList();

                          if (docs.isEmpty) {
                            return Center(
                              child: Lottie.asset(
                                'assets/lottie/Empty box.json',
                              ),
                            );
                          } else if (filterProducts.isEmpty) {
                            return Center(
                              child: Lottie.asset('assets/lottie/Empty.json'),
                            );
                          }
                          return CustomListViewProducts(
                            filterProducts: filterProducts,
                            user: user,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
