import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../line_dashed_painter.dart';

class CalendarScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
      children: [
        for (int i =0; i < 24; i++)
          TableRow(
            children: [
              for (int j =0 ; j < 7; j++)
                Container(
                  height: 55,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: CustomPaint(painter: LineDashedPainter()),
                  )
                )

            ]
          )

      ],
    );
  }

}