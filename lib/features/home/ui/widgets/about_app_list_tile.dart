import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppListTitle extends StatelessWidget {
  const AboutAppListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text("معلومات التطبيق"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text("معلومات التطبيق"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " اسم التطبيق: Inventory App",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 8),

                    Text(
                      " المطور: John Adel",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 8),

                    Text(" الإصدار: 1.0.0", style: TextStyle(fontSize: 15.sp)),
                    SizedBox(height: 8),

                    Text(
                      " وصف: تطبيق لإدارة المخزون والمنتجات والمستخدمين",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "📞 الهاتف: 01226806622",
                            style: TextStyle(fontSize: 15.sp),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: "01012345678"),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم نسخ رقم الهاتف"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إغلاق"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
