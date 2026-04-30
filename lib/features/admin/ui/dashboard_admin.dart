import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/admin/ui/add_product_screen.dart';
import 'package:inventory/features/auth/data/model/user_data.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

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
          leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            "لوحة التحكم",
            style: TextStyle(fontSize: 25.sp, color: Colors.white),
          ),
          centerTitle: true,
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "مرحباً يا ${widget.user.name} 👋",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

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
                            "لا يوجد نشاط حتى الآن",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final data =
                              logs[index].data() as Map<String, dynamic>;

                          final docId = logs[index].id;

                          final userName = data["userName"] ?? "";
                          final action = data["action"] ?? "";
                          final product = data["productName"] ?? "";
                          final change = data["change"] ?? "";

                          final Timestamp? time = data["time"];
                          final dateTime = time?.toDate();

                          final dateString = dateTime != null
                              ? "${dateTime.day}/${dateTime.month}/${dateTime.year}"
                              : "";

                          final hour = dateTime?.hour ?? 0;
                          final minute = dateTime?.minute ?? 0;

                          final isPM = hour >= 12;
                          final displayHour = hour % 12 == 0 ? 12 : hour % 12;

                          final period = isPM ? "مساءً" : "صباحًا";

                          final timeString =
                              "$displayHour:${minute.toString().padLeft(2, '0')} $period";

                          IconData icon;
                          Color color;

                          if (action == "add") {
                            icon = Icons.add_circle;
                            color = Colors.green;
                          } else if (action == "delete") {
                            icon = Icons.delete;
                            color = Colors.red;
                          } else {
                            icon = Icons.edit;
                            color = Colors.orange;
                          }

                          return Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 5),
                              ],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("logs")
                                        .doc(docId)
                                        .delete();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),

                                Icon(icon, color: color),

                                SizedBox(width: 10.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$userName ${getActionText(action)} المنتج \"$product\"",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp,
                                        ),
                                      ),

                                      Text(
                                        "التغيير: $change",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 14.sp),
                                      ),

                                      SizedBox(height: 5.h),

                                      Text(
                                        "$dateString - $timeString",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13.sp,
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

                SizedBox(height: 10.h),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddProductScreen()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
