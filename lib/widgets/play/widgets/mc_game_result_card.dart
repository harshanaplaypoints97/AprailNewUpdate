import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MCGameResultCard extends StatelessWidget {
  final bool result;
  final String name;
  final int points;
  final String answer;
  const MCGameResultCard({
    Key key,
    this.result,
    this.name,
    this.points,
    @required this.size,
    this.answer,
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
                        ? AssetImage("assets/new/wingame.png")
                        : AssetImage("assets/new/lost.png"),
                    fit: BoxFit.fitWidth)),
            width: size.width * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: result ? 60.h : 45.h,
                ),
                Text(
                  result ? "Congratulations !" : "You Lost!",
                  style: TextStyle(
                    fontSize: result ? 22.sp : 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                !result
                    ? Text(
                        "Correct answer is",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: result ? Colors.black : Colors.black,
                            // ? const Color(0xFF3c9000)
                            //  : Color.fromARGB(255, 186, 49, 49),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      )
                    : Container(),
                SizedBox(
                  height: 3.h,
                ),
                !result
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            answer,
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  result ? "You've earned" : "You've Lost ",
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
                    child: Text(result ? "$points PTZ" : "-$points PTZ",
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
                  "Play more, Earn more ",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: result ? 60.h : 30.h,
                ),
              ],
            ),
          );
        });
  }
}
