import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Color> showEventColorDialog({BuildContext context,}) async {
  Widget dialog = _EventColorDialog();

//  return showDialog<DateTime>(
//    context: context,
//    useRootNavigator: true,
//    builder: (BuildContext context) {
//      return dialog;
//    },
//  );
  return showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (_, __, ___) {
      return dialog;
    },
    transitionBuilder: (_, anim, __, child) {
      return Transform.scale(
        scale: anim.value,
        child: Opacity(
          opacity: anim.value,
          child: child,
        ),
      );
    },
  );
}

class _EventColorDialog extends StatefulWidget{
  @override
  State<_EventColorDialog> createState() => _EventColorState();
}

class _EventColorState extends State<_EventColorDialog> with TickerProviderStateMixin {
  var color;
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this, value: 1, );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
              child: Text('Select event color', style: TextStyle(fontFamily: 'RobotoMono',fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black87,decoration: TextDecoration.none),),
            ),
            Expanded(
              child: Table(
                children: [
                  TableRow(
                      children: [
                        for (int j = 0 ; j < colors.length; j++)
                           GestureDetector(
                             onTap: (){
                               setState(() {
                                 color = colors[j];
                                 controller.reset();
                                 controller.forward();
                               });
                               new Timer(const Duration(milliseconds: 400), () {
                                 Navigator.pop(context, color);
                               });
                             },
                             child: Builder(builder: (_) {
                               if (color == colors[j]){
                                 return Container(
                                   width: 50,
                                   height: 50,
                                   alignment: Alignment.center,
                                   margin: EdgeInsets.only(bottom: 8.0),
                                   decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.5), shape: BoxShape.circle),
                                   child: Container(
                                     width: 40,
                                     height: 40,
                                     decoration: BoxDecoration(shape: BoxShape.circle,  color: colors[j], border: Border.all(color: Colors.grey.shade500, width: 1)),
                                     child: ScaleTransition(
                                       scale: controller,
                                       child:  Icon(IconData(0xe64c, fontFamily: 'MaterialIcons'),color: Colors.white,),
                                     ),
                                   ),
                                 );
                               }
                               return Container(
                                 width: 50,
                                 height: 50,
                                 alignment: Alignment.center,
                                 margin: EdgeInsets.only(bottom: 8.0),
                                 child: Container(
                                   width: 40,
                                   height: 40,
                                   decoration: BoxDecoration(shape: BoxShape.circle,  color: colors[j], border: Border.all(color: Colors.grey.shade500, width: 1)),
                                 ),
                               );
                             },),
                           ),
                      ]
                  ),
                  TableRow(
                      children: [
                        for (int j = 0 ; j < colors2.length; j++)
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                color = colors2[j];
                                controller.reset();
                                controller.forward();
                              });
                              new Timer(const Duration(milliseconds: 400), () {
                                Navigator.pop(context,color);
                              });
                            },
                            child: Builder(builder: (_) {
                              if (color == colors2[j]){
                                return Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1.5), shape: BoxShape.circle),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(shape: BoxShape.circle,  color: colors2[j], border: Border.all(color: Colors.grey.shade500, width: 1)),
                                    child: ScaleTransition(
                                      scale: controller,
                                      child:  Icon(IconData(0xe64c, fontFamily: 'MaterialIcons'),color: Colors.white,),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(shape: BoxShape.circle,  color: colors2[j], border: Border.all(color: Colors.grey.shade500, width: 1)),
                                ),
                              );
                            },),
                          ),
                      ]
                  )
                ],
              ),
              flex: 1,),
            Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: (){
                  Navigator.pop(context);
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: Center(
                      child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w400, fontFamily: 'RobotoMono',fontSize: 18, color: Colors.black87,decoration: TextDecoration.none),),
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

const  colors =[Colors.lightBlueAccent, Colors.red, Colors.purpleAccent, Colors.deepPurpleAccent, Colors.indigo, Colors.tealAccent ];
const  colors2 =[Colors.greenAccent, Colors.green, Colors.yellowAccent, Colors.orangeAccent, Colors.redAccent, Colors.grey ];