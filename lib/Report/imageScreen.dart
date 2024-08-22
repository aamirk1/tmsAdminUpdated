// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:image_network/image_network.dart';
// import 'package:photo_view/photo_view.dart';

// class ImageScreen extends StatefulWidget {
//   final List<String> imageFiles;
//   final int initialIndex;
//   final String pageTitle;

//   const ImageScreen({
//     required this.imageFiles,
//     required this.initialIndex,
//     required String imageFile,
//     required ticketId,
//     required this.pageTitle,
//   });

//   @override
//   _ImageScreenState createState() => _ImageScreenState();
// }

// class _ImageScreenState extends State<ImageScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: Colors.deepPurple,
//         centerTitle: true,
//         title: const Text(
//           'Image',
//           style: TextStyle(color: Colors.white),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//               gradient:
//                   LinearGradient(colors: [Colors.purple, Colors.deepPurple])),
//         ),
//       ),
//       body: Center(
//         child: CarouselSlider.builder(
//           itemCount: widget.imageFiles.length,
//           options: CarouselOptions(
//             initialPage: widget.initialIndex,
//             enlargeCenterPage: true,
//             enableInfiniteScroll: false,
//             onPageChanged: (index, reason) {
//               setState(() {});
//             },
//           ),
//           itemBuilder: (context, index, realIdx) {
//             return Container(
//               child: widget.pageTitle == 'Report Page'
//                   ? ImageNetwork(
//                       height: 400, width: 600, image: widget.imageFiles[index])
//                   //imageProvider: FileImage(File(widget.imageFiles[index])),
//                   // backgroundDecoration:
//                   //     const BoxDecoration(color: Colors.black),

//                   : PhotoView(
//                       imageProvider: FileImage(File(widget.imageFiles[index])),
//                       backgroundDecoration:
//                           const BoxDecoration(color: Colors.black),
//                     ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
