import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.menu,  color: Colors.grey.shade800,), // change this size and style
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DEC', style: TextStyle(color: Colors.grey.shade800, fontSize: 24, fontWeight: FontWeight.w300),),
            SizedBox(width: 12,),
            Container(
              margin: EdgeInsets.only(bottom: 3.0),
              child: Text('2020', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w300),),
            )
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        toolbarHeight: 70,
        shadowColor: Colors.transparent,

      ),
      drawer: DrawerWidget(),
      body: Container(
        margin: EdgeInsets.only(top: 2),
        child:  Container(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(24.0))
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 24, right: 16, top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0 ; i < 8; i++)
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context){
                              if (i == 6)
                                return Text(convertToDay(i), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),);
                              return Text(convertToDay(i), style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w400),);
                            },
                          )
                      )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 24, right: 16, bottom: 6, top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0 ; i < 8; i++)
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context){
                              if (i == 6)
                                return Text((14+i).toString(), style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),);
                              else if (i == 7)
                                return Text('');
                              return Text((14+i).toString(), style: TextStyle(color: Colors.grey.shade900, fontSize: 12, fontWeight: FontWeight.w400),);
                            },
                          )
                      )
                  ],
                ),
              ),
              Container(
                color: Colors.grey.shade500,
                height: 0.7,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Table(
                    columnWidths: {
                      0: FixedColumnWidth(24.0),
                    },
                    border: TableBorder(
                      verticalInside: BorderSide(width: 0.5, color: Colors.grey.shade300),
                      horizontalInside: BorderSide(width: 0.5, color: Colors.grey.shade300)
                    ),
                    children: [
                      for (int i = 0 ; i < 24; i++)
                        TableRow(
                            children:[
                              for (int j = 0 ; j < 8; j++)
                                TableCell(

                                  child: Container(
                                      height: 55,
                                      child:  Center(
                                        child: Builder(
                                          builder: (_){
                                            if (j > 0){
                                              return DottedLine(
                                                dashColor: Colors.grey.shade200,
                                                dashLength: 1,
                                                dashGapLength: 1,
                                                lineThickness: 1,
                                                dashRadius: 16,
                                              );
                                            }else
                                              return Container();
                                          },
                                        ),
                                      )
                                  ),
                                )
                            ]
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String convertToDay(int i) {
    switch (i){
      case 0 :
        return "M";
      case 1 :
        return "T";
      case 2 :
        return "W";
      case 3 :
        return "T";
      case 4 :
        return "F";
      case 5 :
        return "S";
      case 6 :
        return "S";
      default:
        return "";
    }
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}
