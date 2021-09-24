import 'dart:math';

import 'package:flutter/material.dart';

class NewsHelper {
  static String truncateStr(str) {
    if (str.length < 55) {
      return str;
    } else {
      return str.toString().substring(0, 55) + '...';
    }
  }

  static Color randomBorderColor() {
    final random = Random();

    List borderColor = [
      const Color.fromRGBO(0x99, 0xC9, 0xFF, 1),
      const Color.fromRGBO(0xAC, 0xD1, 0x57, 1),
      const Color.fromRGBO(0xFF, 0xFF, 0x00, 1),
      const Color.fromRGBO(0x80, 0x00, 0x80, 1),
    ];

    int index = random.nextInt(borderColor.length);

    return borderColor[index];
  }

  static String getArticleImage(imgUrl, context) {
    // Split the url
    List arr = imgUrl.toString().split('images');

    // Get the last index of the arr which is the name

    if (arr.length == 1) return imgUrl;

    double screenSize = MediaQuery.of(context).size.width;
    if (screenSize >= 600) {
      imgUrl = arr[0] + 'images/size/w1000' + arr[1];
    } else if (screenSize >= 300) {
      imgUrl = arr[0] + 'images/size/w600' + arr[1];
    } else if (screenSize >= 150) {
      imgUrl = arr[0] + 'images/size/w300' + arr[1];
    } else {
      imgUrl = arr[0] + 'images/size/w100' + arr[1];
    }

    return imgUrl;
  }

  static String getProfileImage(imgUrl) {
    List arr = imgUrl.toString().split('images');

    if (arr.length == 1) return imgUrl;

    return arr[0] + 'images/size/w60' + arr[1];
  }
}
