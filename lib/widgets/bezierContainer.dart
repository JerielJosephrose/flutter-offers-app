import 'dart:math';
import 'package:annonce/widgets/customClipper.dart';
import 'package:flutter/material.dart';


class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
      )
    );
  }
}