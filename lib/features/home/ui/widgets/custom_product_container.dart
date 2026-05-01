import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:inventory/features/home/cubit/cubit/home_cubit.dart';

class CustomProductContainer extends StatelessWidget {
  const CustomProductContainer({
    super.key,
    required this.isLow,
    required this.name,
    required this.id,
    required this.description,
    required this.quantity,
    required this.minQuantity,
    required this.user,
    required this.controller,
  });

  final bool isLow;
  final String name;
  final String id;
  final String description;
  final int quantity;
  final int minQuantity;
  final UserData user;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.shade400 : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isLow ? Colors.red : Colors.green,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 Name + Delete
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isLow ? Colors.white : Colors.black,
                  ),
                ),
              ),

              if (user.isAdmin == true)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: isLow ? Colors.white : Colors.red,
                  onPressed: () {
                    context.read<HomeCubit>().deleteProduct(id: id, name: name);
                  },
                ),
            ],
          ),

          SizedBox(height: 6.h),

          Text(
            description,
            style: TextStyle(
              fontSize: 15.sp,
              color: isLow ? Colors.white : Colors.grey[700],
            ),
          ),

          SizedBox(height: 12.h),

          _infoRow("الكميه الحالية", "$quantity", isLow),
          _infoRow("الحد الأدنى", "$minQuantity", isLow),

          SizedBox(height: 12.h),

          Text(
            "تعديل الكمية",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isLow ? Colors.white : Colors.black,
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _circleBtn(
                icon: Icons.remove,
                onTap: () {
                  if (quantity > 0) {
                    _update(context, quantity - 1);
                  }
                },
              ),

              SizedBox(width: 10.w),

              SizedBox(
                width: 70,
                child: TextField(
                  onChanged: (value) {
                    (context as Element).markNeedsBuild();
                  },
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    final newValue = int.tryParse(value);
                    if (newValue != null) {
                      _update(context, newValue);
                    }
                  },
                ),
              ),

              SizedBox(width: 10.w),

              _circleBtn(
                icon: Icons.add,
                onTap: () {
                  _update(context, quantity + 1);
                },
              ),
            ],
          ),

          if (isLow)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                "⚠ الكمية منخفضة",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _update(BuildContext context, int newValue) {
    context.read<HomeCubit>().updateQuantity(
      id: id,
      newQuantity: newValue,
      name: name,
      oldQuantity: quantity,
    );

    controller.text = newValue.toString();
  }

  /// 📦 info row
  Widget _infoRow(String title, String value, bool isLow) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 15.sp,
              color: isLow ? Colors.white : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isLow ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 button
  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }
}
