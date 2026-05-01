import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';

class AboutAppListTitle extends StatelessWidget {
  const AboutAppListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text("معلومات التطبيق"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 🔝 Header
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.green),
                          SizedBox(width: 8.w),
                          Text(
                            "معلومات التطبيق",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      /// 📦 Cards
                      _item(" اسم التطبيق", "Inventory App"),
                      _item(" المطور", "John Adel"),
                      _item(" الإصدار", "1.0.0"),
                      _item(" الوصف", "إدارة المخزون والمنتجات"),

                      SizedBox(height: 10.h),

                      /// 📞 Phone
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                " 01226806622",
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.green),
                              onPressed: () {
                                Clipboard.setData(
                                  const ClipboardData(text: "01226806622"),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("تم النسخ ✅")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "إغلاق",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: TextStyle(fontSize: 14.sp)),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
