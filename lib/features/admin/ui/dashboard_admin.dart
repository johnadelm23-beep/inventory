import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/admin/ui/add_product_screen.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key, required this.user});
  final UserData user;

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            "لوحة التحكم",
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),
          centerTitle: true,
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "سجل نشاطاتك : ",
                  style: TextStyle(fontSize: 20.sp, fontWeight: .bold),
                ),

                SizedBox(height: 12.h),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("logs")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final logs = snapshot.data!.docs;

                      if (logs.isEmpty) {
                        return Center(
                          child: Text(
                            "لا يوجد نشاط",
                            style: TextStyle(fontSize: 25.sp),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final doc = logs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          final docId = doc.id;
                          final userName = data["userName"] ?? "";
                          final action = data["action"] ?? "";
                          final product = data["productName"] ?? "";

                          final change = _parseChange(data["change"]);

                          final time = data["time"]?.toDate();

                          final date = time != null
                              ? "${time.day}/${time.month}/${time.year}"
                              : "";

                          final hour = time?.hour ?? 0;
                          final minute = time?.minute ?? 0;

                          final isPM = hour >= 12;
                          final displayHour = hour % 12 == 0 ? 12 : hour % 12;

                          final period = isPM ? "مساءً" : "صباحًا";

                          final timeText =
                              "$displayHour:${minute.toString().padLeft(2, '0')} $period";

                          Color color;
                          IconData icon;

                          if (action == "add") {
                            color = Colors.green;
                            icon = Icons.add_circle;
                          } else if (action == "delete") {
                            color = Colors.red;
                            icon = Icons.delete;
                          } else {
                            color = Colors.orange;
                            icon = Icons.edit;
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: const [
                                BoxShadow(blurRadius: 6, color: Colors.black12),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// 🗑 DELETE
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("logs")
                                        .doc(docId)
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey,
                                  ),
                                ),

                                CircleAvatar(
                                  backgroundColor: color.withOpacity(0.1),
                                  child: Icon(icon, color: color),
                                ),

                                SizedBox(width: 10.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$userName ${getActionText(action)} \"$product\"",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 6.h),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: change > 0
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          change > 0
                                              ? "زاد $change+"
                                              : "نقص ${change * -1}-",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: change > 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 6.h),

                                      Text(
                                        "$date - $timeText",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: AppColors.whiteColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddProductScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _parseChange(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    String v = value.toString().replaceAll("+", "").trim();

    return int.tryParse(v) ?? 0;
  }
}

String getActionText(String action) {
  switch (action) {
    case "add":
      return "قام بإضافة";
    case "delete":
      return "قام بحذف";
    case "edit":
      return "قام بتعديل";
    default:
      return "قام بـ $action";
  }
}
