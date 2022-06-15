import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Warpper(800,600, 32)),
    );
  }
}

class Warpper extends StatefulWidget {
  final double width, height;
  final int precision;
  const Warpper(this.width,  this.height, this.precision,{Key? key}) : super(key: key);
  
  @override
  State<Warpper> createState() => _WarpperState();
}

class _WarpperState extends State<Warpper> {
  double positionX = 0, positionY = 0;
  final GlobalKey _globalKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    // item 총 개수
    int itemCount = (widget.height~/widget.precision) * (widget.width ~/widget.precision);
    // 1행당 item 개수
    int crossAxisCount = widget.width ~/widget.precision;
    // 1열당 item 개수
    int mainAxisCount = widget.height ~/widget.precision;
    // Paddings
    double sidePadding = widget.width % widget.precision;
    double topbottomPadding = widget.height % widget.precision;
    // 1 셀당 사이즈
    double cellWidth = ((widget.width-sidePadding)~/crossAxisCount).toDouble();
    double cellheight= ((widget.height-topbottomPadding)~/mainAxisCount).toDouble();
    print('item count: '+ (widget.height~/widget.precision * widget.width ~/widget.precision).toString());
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(
          left: sidePadding /2,
          top: topbottomPadding /2,
          right: sidePadding /2,
          bottom: topbottomPadding /2,
        ),
        child: Stack(
          children: [
            GridView.builder(
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,   //1 개의 행에 보여줄 item 개수
                childAspectRatio: 1.0,   //item 의 가로 1, 세로 2 의 비율
              ), 
              itemBuilder: (context, idx){
                return DragTarget(
                  onWillAccept: ((data){
                    double x = (idx % crossAxisCount) * cellWidth;
                    double y = (idx ~/ crossAxisCount * cellheight).toDouble();
                    // setPosition(x, y);
                    print(idx.toString());
                    return true;
                  }),
                  builder: (BuildContext context, List<Object?> candidateData, List<dynamic> rejectedData) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(idx.toString(),
                        style: TextStyle(fontSize: 10),),
                      )
                  );
                    },
                );
              }
    
              ),
            MovableWidget(positionX, positionY, cellWidth, cellheight, cellWidth, cellheight, key: UniqueKey(),),
          ],
        ),
      ),
    );
  }
}

class MovableWidget extends StatefulWidget {
  final double _defaultPositionX, _defaultPositionY;
  final double width, height;
  final double cellWidth, cellheight;

  const MovableWidget(this._defaultPositionX, this._defaultPositionY, this.width, this.height, this.cellWidth, this.cellheight, {Key? key}) : super(key: key);

  double get positionX => _defaultPositionX;
  double get positionY => _defaultPositionY;

  @override
  State<MovableWidget> createState() => _MovableWidgetState();

}

class _MovableWidgetState extends State<MovableWidget> {
  double positionX = 0;
  double positionY = 0;

  void setPosition(double x, double y){
    setState(() {
      positionX = x;
      positionY = y;
    });
  }

  void move(Offset delta){
    int cellX = delta.dx~/widget.cellWidth;
    int cellY = delta.dy~/widget.cellheight;
    setState(() {
        positionX += cellX * widget.cellWidth;
        positionY += cellY * widget.cellheight;
        varifyPosition(positionX, positionY);
    });
    print('move ($cellX, $cellY)');
  }

  void varifyPosition(double x, double y){
    if (x < 0){
      positionX = 0;
    }
    else if (x > 20000){
      
    }
    if (y < 0){
      positionY = 0;
    }
    else if (y > 20000){

    }
  }

  @override
  Widget build(BuildContext context) {
    bool dragging = false;
    Offset dragStartedPosition = Offset(0, 0);
    return Positioned(
        left: positionX,
        top: positionY,
        child: Draggable(
            onDragUpdate: (((details) {
              if(!dragging){
                print('updated!');
                dragStartedPosition = details.globalPosition;
                dragging = true;
              }
            })),
            onDragEnd: ((details) {
              dragging = false;
              Offset delta = details.offset - dragStartedPosition;
              print('delta ');
              print(delta);
              move(delta);
              }
            ),
            childWhenDragging: Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey,
            ),
            feedback: Container(
              width: widget.width,
              height: widget.height,
              color: Colors.blue,
            ),
            child: Container(
              width: widget.width,
              height: widget.height,
              color: Colors.red[200],
              child: Center(child: Text('Box',style: TextStyle(fontSize: 10))),
            ),
        ),
    );
  }
}