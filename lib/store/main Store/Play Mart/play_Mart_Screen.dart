// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:play_pointz/constants/app_colors.dart';
// import 'package:play_pointz/screens/Chat/Provider/Chat_provider.dart';
// import 'package:play_pointz/screens/store/main%20Store/Play%20Mart/Controller/PlayMartController.dart';
// import 'package:play_pointz/screens/store/main%20Store/Play%20Mart/model/PlayMartModel.dart';
// import 'package:play_pointz/screens/store/main%20Store/Play%20Mart/provider/PlayMartProvider.dart';
// import 'package:play_pointz/screens/store/main%20Store/Play%20Mart/widgets/ItemView.dart';
// import 'package:play_pointz/screens/store/main%20Store/Play%20Mart/widgets/Itemcard.dart';
// import 'package:provider/provider.dart';

// class PlayMart extends StatefulWidget {
//   const PlayMart({Key key}) : super(key: key);

//   @override
//   State<PlayMart> createState() => _PlayMartState();
// }

// class _PlayMartState extends State<PlayMart> {
//   final List<PlayMartModel> _list = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackGroundColor,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Color(0xff536471), // Set your desired icon color here
//         ),
//         elevation: 0,
//         title: Text(
//           "Play Mart",
//           style: TextStyle(color: Color(0xff536471)),
//         ),
//         centerTitle: true,
//         leading: BackButton(),
//         backgroundColor: AppColors.scaffoldBackGroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//         child: Column(
//           children: [
//             Consumer<PlayMartProvider>(
//               builder: (context, value, child) {
//                 return StreamBuilder<QuerySnapshot>(
//                   stream: PlayMartController().getItemsStream(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     }

//                     if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }

//                     if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
//                       return Text('No Items available.');
//                     }

//                     List<PlayMartModel> conversations = snapshot.data.docs
//                         .map((doc) => PlayMartModel.fromJson(
//                             doc.data() as Map<String, dynamic>))
//                         .toList();

//                     return Expanded(
//                       child: ListView.separated(
//                         itemBuilder: (context, index) {
//                           return PlayMartItemView();
//                         },
//                         separatorBuilder: (context, index) => SizedBox(
//                           height: 0,
//                         ),
//                         itemCount: conversations.length,
//                       ),
//                     );
//                   },
//                 );
//               },
//             )
//             // Row(
//             //   children: [
//             //     InkWell(
//             //       onTap: () async {
//             //         Navigator.push(
//             //             context,
//             //             MaterialPageRoute(
//             //               builder: (context) => PlayMartItemView(),
//             //             ));
//             //       },
//             //       child: ItemCard(),
//             //     ),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
