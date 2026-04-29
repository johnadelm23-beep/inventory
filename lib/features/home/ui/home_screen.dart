import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/admin/ui/add_product_screen.dart';
import 'package:inventory/features/auth/cubit/cubit/auth_cubit.dart';
import 'package:inventory/features/auth/ui/login_screen.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
              builder: (_) => const Center(child: CircularProgressIndicator()),
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
          backgroundColor: Colors.white,
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final user = context.read<HomeCubit>().userData;

              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SafeArea(
                child: Column(
                  children: [
                    /// HEADER
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "مرحباً بك يا ${user.name} 👋",
                            style: TextStyle(fontSize: 22.sp),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider(
                                        create: (_) => AuthCubit(),
                                        child: const LoginScreen(),
                                      ),
                                    ),
                                    (route) => false,
                                  );
                                },
                                icon: const Icon(Icons.logout),
                              ),

                              if (user.isAdmin == true)
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddProductScreen(),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// LIST
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

                          if (docs.isEmpty) {
                            return Center(
                              child: Text(
                                "لا يوجد منتجات لديك لعرضها",
                                style: TextStyle(fontSize: 25.sp),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.all(16.r),
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final doc = docs[index];
                              final data = doc.data() as Map<String, dynamic>;

                              final id = doc.id;
                              final name = data["name"] ?? "";
                              final description = data["description"] ?? "";

                              final quantity =
                                  int.tryParse(data["quantity"].toString()) ??
                                  0;

                              final minQuantity =
                                  int.tryParse(
                                    data["minQuantity"].toString(),
                                  ) ??
                                  0;

                              final isLow = quantity <= minQuantity;

                              /// controller لكل عنصر
                              final controller = TextEditingController(
                                text: quantity.toString(),
                              );

                              return Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: isLow
                                      ? Colors.red
                                      : AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isLow ? Colors.black : Colors.green,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 6,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// NAME
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: isLow
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),

                                        if (user.isAdmin == true)
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: isLow
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<HomeCubit>()
                                                  .deleteProduct(id);
                                            },
                                          ),
                                      ],
                                    ),

                                    SizedBox(height: 6.h),

                                    Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        color: isLow
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 16.h),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "الكميه المتاحة حاليا: ${quantity}",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: isLow
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),

                                    /// MIN QTY
                                    Text(
                                      "الحد الأدنى: $minQuantity",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: isLow
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 12.h),
                                    Text(
                                      "انقر للتعديل:",
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        color: isLow
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),

                                    /// QUANTITY CONTROL (FIXED)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        /// minus
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            color: AppColors
                                                .backGroundTextFormFiled,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              if (quantity > 0) {
                                                final newValue = quantity - 1;

                                                context
                                                    .read<HomeCubit>()
                                                    .updateQuantity(
                                                      id: id,
                                                      newQuantity: newValue,
                                                    );

                                                controller.text = newValue
                                                    .toString();
                                              }
                                            },
                                          ),
                                        ),

                                        SizedBox(width: 10.w),

                                        /// manual edit (FIXED)
                                        SizedBox(
                                          width: 70,
                                          child: TextField(
                                            onTapOutside: (v) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            controller: controller,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.grey.shade100,

                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            onSubmitted: (value) {
                                              final newValue = int.tryParse(
                                                value,
                                              );

                                              if (newValue != null) {
                                                context
                                                    .read<HomeCubit>()
                                                    .updateQuantity(
                                                      id: id,
                                                      newQuantity: newValue,
                                                    );
                                              }
                                            },
                                          ),
                                        ),

                                        SizedBox(width: 10.w),

                                        /// plus
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            color: AppColors
                                                .backGroundTextFormFiled,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add,

                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              final newValue = quantity + 1;

                                              context
                                                  .read<HomeCubit>()
                                                  .updateQuantity(
                                                    id: id,
                                                    newQuantity: newValue,
                                                  );

                                              controller.text = newValue
                                                  .toString();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (isLow)
                                      const Text(
                                        "الكمية منخفضة لديك",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                  ],
                                ),
                              );
                            },
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
