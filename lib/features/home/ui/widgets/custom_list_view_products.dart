import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';
import 'package:inventory/features/home/ui/widgets/custom_product_container.dart';

class CustomListViewProducts extends StatelessWidget {
  const CustomListViewProducts({
    super.key,
    required this.filterProducts,
    required this.user,
  });
  final List<QueryDocumentSnapshot<Object?>> filterProducts;
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.r),
      itemCount: filterProducts.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final doc = filterProducts[index];
        final data = doc.data() as Map<String, dynamic>;

        final id = doc.id;
        final name = data["name"] ?? "";
        final description = data["description"] ?? "";

        final quantity = int.tryParse(data["quantity"].toString()) ?? 0;

        final minQuantity = int.tryParse(data["minQuantity"].toString()) ?? 0;

        final isLow = quantity <= minQuantity;

        final controller = TextEditingController(text: quantity.toString());

        return CustomProductContainer(
          isLow: isLow,
          name: name,
          id: id,
          description: description,
          quantity: quantity,
          minQuantity: minQuantity,
          user: user,
          controller: controller,
        );
      },
    );
  }
}
