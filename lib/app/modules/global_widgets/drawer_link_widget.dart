/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerLinkWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final ValueChanged<void> onTap;
  const DrawerLinkWidget({
    Key key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
      color: Color(0xffEE9F76),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Color(0xffEE9F76),
            ),
            Expanded(
              child: Text(text.tr, style: Get.textTheme.bodyText2.merge(TextStyle(fontSize: 14, color: Colors.black54))),
            ),
          ],
        ),
      ),
    );
  }
}
