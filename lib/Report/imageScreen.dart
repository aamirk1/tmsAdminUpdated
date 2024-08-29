import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:image_network/image_network.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ticket_management_system/utils/colors.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    super.key,
    required this.imageFiles,
    required this.initialIndex,
    required this.pageTitle,
  });
  final List<String> imageFiles;
  final int initialIndex;
  final String pageTitle;
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    print('imageFiles: ${widget.imageFiles}');
    print('initialIndex: ${widget.initialIndex}');
    print('pageTitle: ${widget.pageTitle}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: marron,
        centerTitle: true,
        title: const Text(
          'Image',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [lightMarron, marron])),
        ),
      ),
      body: Center(
        child: CarouselSlider.builder(
          itemCount: widget.imageFiles.length,
          options: CarouselOptions(
            initialPage: widget.initialIndex,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {});
            },
          ),
          itemBuilder: (context, index, realIdx) {
            return Container(
              child: widget.pageTitle == 'Report Page'
                  ? ImageNetwork(
                      height: 400, width: 600, image: widget.imageFiles[index])
                  : PhotoView(
                      imageProvider: FileImage(File(widget.imageFiles[index])),
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.black),
                    ),
            );
          },
        ),
      ),
    );
  }
}
