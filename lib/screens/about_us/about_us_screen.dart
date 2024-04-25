import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_pointz/screens/home/home_page.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About Us"),
        leading: BackButton(),
        backgroundColor: Colors.white,
      ),
      // backgroundColor:Gradient()
      //backgroundColor: AppColors.scaffoldBackGroundColor,
      body: Container(
        decoration: BoxDecoration(
          //  gradient: Gradient
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Color.fromARGB(255, 247, 255, 250),
              Color.fromARGB(255, 255, 248, 246),
              Color.fromARGB(255, 255, 241, 244),
              Color.fromARGB(255, 254, 255, 247),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            // title("About Us",25),
            const SizedBox(
              height: 16,
            ),
            paragraph(
              "We are revolutionizing e-commerce in the most epic way that you can imagine. Think gaming. Think earning with gaming. PlayPointz is a fun way that lets you play games, earn pointz and then use these pointz to buy cool stuff from our Pointz Store. No cash or credit ",
              14,
              context,
            ),
            const SizedBox(
              height: 16,
            ),
            paragraph(
              "PlayPointz is a fun way that lets you play games, earn pointz and then use these pointz to buy cool stuff from our Pointz Store. No cash or credit cards or debit cards involved – just PlayPointz!",
              14,
              context,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30.sp,
                    width: 4.sp,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    width: 4.sp,
                  ),
                  Text("It’s easy as Play. Earn. Redeem.")
                  // paragraph(
                  //   "It’s easy as Play. Earn. Redeem. ",
                  //   context,
                  // ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                "Play our daily challenges.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "Earn PlayPointz.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "Radeem your PlayPointz in our Pointz Store.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: title("It’s that simple!", 16)),
            const SizedBox(
              height: 24,
            ),
            paragraph(
                "Our Pointz Store has a range of products that we have come to love, and we are expanding our selection every day. So, there’s always something new to lookout for and get you excited!",
                14,
                context),
            const SizedBox(
              height: 8,
            ),
            paragraph(
                "And that’s not all. Show-off your wins in your Play profile through our Feed and let everyone know your awesomeness. It is a great way to stay connected, start a chat, share some tips, and hang out with other Players.",
                14,
                context),
            const SizedBox(
              height: 8,
            ),
            paragraph(
                "Step into a virtual world with PlayPointz. A Sri Lankan first e-commerce-driven gaming experience.",
                14,
                context),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 14,
            ),
            title("How To Use?", 25),
            const SizedBox(
              height: 14,
            ),
            paragraph(
                "PlayPointz is a gaming e-commerce experience like no other. It’s a new, fun way of buying stuff online, so let’s get to know how you can Play.",
                14,
                context),
            const SizedBox(
              height: 8,
            ),
            paragraph(
                "It’s pretty simple. All you have to do is Play. Earn. Redeem.",
                14,
                context),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                "Play our daily challenges.",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "Earn PlayPointz.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              "Radeem your PlayPointz in our Pointz Store.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            title("What are PlayPointz?", 25),
            SizedBox(
              height: 8,
            ),
            paragraph(
                "Glad you asked! PlayPointz are the currency that we use inside our PlayPointz platform. You will Play to Earn PlayPointz and use those PlayPointz to Redeem products from our Pointz Store.",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            // title("Play",25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 34.sp,
                    width: 4.sp,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    width: 4.sp,
                  ),
                  Text(
                    "Play",
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            stepWithLink(
                "This is where you get to have some fun and play some daily challenges. We will be updating our daily challenges with quizzes you can answer and videos that you can watch. Once you complete these challenges successfully, you will earn your PlayPointz. All of our daily challenges live up to their name – which means they expire within 24 hours. So, if by any chance you miss a daily challenge, you won’t be able to earn PlayPointz with that missed daily challenge on a future date. So,",
                " get Playing today",
                context,
                "play"),

            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 34.sp,
                    width: 4.sp,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    width: 4.sp,
                  ),
                  Text(
                    "Earn",
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w700),
                  )
                  // paragraph(
                  //   "It’s easy as Play. Earn. Redeem. ",
                  //   context,
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "Who needs instant gratification? We do! There are three ways in which you can earn PlayPointz.",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            stepWithLink(
                "Answer more – Earn more: Visit PlayPointz everyday and complete our daily challenges to earn PlayPointz. But there’s a catch. If you attempt a daily challenge and don’t complete it successfully, you will lose the PlayPointz attached to that challenge. So, get you game faces on when you attempt these ",
                "daily challenges!",
                context,
                "play"),
            SizedBox(
              height: 16,
            ),
            stepWithLink(
                "Connect more – Earn more: The best thing about gaming is when you get to play together with a community. So, why not invite your friends and share the fun? You will earn PlayPointz for each friend who creates a PlayPointz profile from your Connect invite.",
                "Get inviting today",
                context,
                "connect"),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "Visit more – Earn more: We love when our PlayPointz community participate every day. For each day you log in to your profile, we will reward you with 2 bonus PlayPointz – yay! But on the flip side, if you don’t login to your PlayPointz account daily, you will lose 2 PlayPointz. So, make sure to visit your PlayPointz account every day to keep your hard-earned PlayPointz and earn bonus PlayPointz.",
                14,
                context),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 34.sp,
                    width: 4.sp,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    width: 4.sp,
                  ),
                  Text(
                    "Redeem",
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            paragraph(
              "This is the most exciting part. This is where you get to convert your PlayPointz to any of the products in our Pointz Store. There’s no cash or credit cards or debit cards involved – just PlayPointz! ",
              14,
              context,
            ),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "All our products go through three stages in the Pointz Store.",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "Waiting: If you see a product with this button, that means it will be available to be Redeemed in a future date. Each of these products will have a timer which tells you when they are ready to go live. Gaming is about strategy. Think of ways of how you can earn the required amount of PlayPointz before the timer runs out to grab products as soon as they are ready to be Redeemed",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "Redeem: You can buy these products now! And by buying we mean, Redeeming them with your PlayPointz. Simply, put these items in your shopping cart and go to check-out. Enter your delivery and contact details and you will have these products right at your doorstep. But be warned – we only stock a limited number of items from each product, so once they go live, be ready to Redeem them quickly! We also update our Feed when products are ready to be Redeemed, so be on the lookout.",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "Taken: Unfortunately, products that are with a ‘Taken’ button are no longer available. Either someone beat you to it, or you have beaten everyone else to it!",
                14,
                context),
            SizedBox(
              height: 32,
            ),
            paragraph(
                "Immerse yourself in a gaming e-commerce experience like no other with PlayPointz.",
                14,
                context),
            SizedBox(
              height: 16,
            ),
            paragraph(
                "It’s simple. It’s fun. Create your profile and get gaming today!",
                14,
                context),
            SizedBox(
              height: 50,
            ),

            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  Padding step(String text1, String text2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: text1,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: text2,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding stepWithLink(
      String text1, String text2, BuildContext context, String redirectTo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: text1,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
        TextSpan(
            text: text2,
            style: TextStyle(fontSize: 14.sp, color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                /*  redirectTo == "connect" || redirectTo == "play"
                    ? socket.off('new-popup-banners')
                    : null; */
                redirectTo == "connect"
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => HomePage(
                                  activeIndex: 3,
                                ))))
                    : redirectTo == "play"
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HomePage(
                                      activeIndex: 1,
                                    ))))
                        : null;
              }),
      ])),
    );
  }

  Padding title(String text, int fontsize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontsize.sp,
            color: Colors.black87),
      ),
    );
  }

  Container paragraph(String text, int fontsize, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      child: RichText(
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: fontsize.sp, color: Colors.black87)),
      ),
    );
  }
}
