import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizResultCard extends StatelessWidget {
  final bool result;
  final String name;
  final int points;
  const QuizResultCard({
    Key key,
    this.result,
    this.name,
    this.points,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
        tween: Tween<double>(begin: 1, end: MediaQuery.of(context).size.width),
        builder: (BuildContext context, dynamic value, Widget child) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                    image: result
                        ? AssetImage("assets/new/win_bc.png")
                        : AssetImage("assets/new/fail_bc.png"),
                    fit: BoxFit.fitWidth)),
            width: size.width * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: 45.h,
                ),
                Text(
                  result ? "Congratulations !" : "Ooops !",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 3.w, color: Colors.white),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 18, right: 18, bottom: 0),
                    child: Text(
                      "$name !".split(" ").first,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  !result
                      ? "You have given the wrong answer"
                      : "You have given the correct answer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: result ? Colors.black : Colors.black,
                      // ? const Color(0xFF3c9000)
                      //  : Color.fromARGB(255, 186, 49, 49),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  result ? "You've earned" : "You Lost ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text("$points PTZ",
                        style: TextStyle(
                            color: result ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp)),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "Answer more, Earn more ",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
          );
        });
  }
}
