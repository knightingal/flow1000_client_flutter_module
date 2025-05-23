import 'dart:convert';
import 'dart:developer';

import 'package:flow1000_admin/album_content.dart';
import 'package:flow1000_admin/scroll.dart';
import 'package:flow1000_admin/struct/album_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config.dart';
import 'struct/slot.dart';

class SinglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10),

      child: Center(
        child: Image.network(
          "http://192.168.2.12:3002/linux1000/source/20160321000141BB-39_USS_ARIZONA/0-0138026.jpg",
          width: width / 2,
          height: width / 2,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
