import 'package:flutter/material.dart';
import '../constants.dart';

class DescriptionCard extends StatelessWidget {
  DescriptionCard({this.icon, @required this.textPrimary});

  final IconData icon;
  final String textPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 15.0,
          width: double.infinity,
        ),
        Text(
          textPrimary,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
