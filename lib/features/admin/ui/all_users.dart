import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory/core/theme/app_colors.dart';
import 'package:inventory/features/home/ui/home_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: Text(
            "المستخدمون",
            style: TextStyle(fontSize: 25.sp, color: Colors.white),
          ),
          centerTitle: true,
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("لا يوجد مستخدمين"));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: users.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final data = users[index].data() as Map<String, dynamic>;

                final uid = users[index].id;
                final name = data["name"] ?? "";
                final email = data["email"] ?? "";
                final isAdmin = data["isAdmin"] ?? false;
                final isBlocked = data["isBlocked"] ?? false;
                final password = data["password"] ?? "";

                final isMe = uid == currentUid;

                return Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),

                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isAdmin ? Colors.blue : Colors.grey,
                        child: Icon(
                          isAdmin ? Icons.admin_panel_settings : Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),

                            Text(email, textDirection: TextDirection.rtl),

                            Text(
                              "كلمة المرور: $password",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                            ),

                            Text(
                              isAdmin ? "أدمن" : "مستخدم",
                              style: TextStyle(
                                color: isAdmin ? Colors.blue : Colors.grey,
                              ),
                              textDirection: TextDirection.rtl,
                            ),

                            SizedBox(height: 4.h),

                            if (isBlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "محظور",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                            if (isMe)
                              const Text(
                                "أنت",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            tooltip: isBlocked ? "فك الحظر" : "حظر المستخدم",
                            icon: Icon(
                              isBlocked ? Icons.lock_open : Icons.lock,
                              color: isBlocked ? Colors.green : Colors.grey,
                            ),
                            onPressed: isMe
                                ? null
                                : () {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .update({"isBlocked": !isBlocked});
                                  },
                          ),

                          IconButton(
                            tooltip: "حذف المستخدم",
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: isMe
                                ? null
                                : () {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(uid)
                                        .delete();
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
