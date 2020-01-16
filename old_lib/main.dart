import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

// Material design colors. :p
List<Color> _kColors = <Color>[
  Colors.teal,
  Colors.amber,
  Colors.purple,
  Colors.lightBlue,
  Colors.deepPurple,
  Colors.lime,
];

// MAIN DEFINED AT THE BOTTOM
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chain Reaction',
//       home: HomePage
//       Atom(c: [0,0] , r: 45, vel: [1,0]),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   HomePage();

//   @override 
//   Widget build(BuildContext context) {
//     return Scaffold(

//     )
//   }
// }


/// defines a floating atom on the playing field
class Atom extends StatefulWidget {
  Atom({this.position, this.radius, this.vel})  : _paint = Paint()..color = color; // center, radius and velocity (speed and direction)

  final Paint _paint;
  Offset position = Offset.zero;
  double radius = 0.0;
  Offset vel; // speed and direction with reference to it its own center

  void update(PointerEvent event) {
    position = position + vel;
  }

  void paint(Canvas canvas, Offset offset) {
    canvas.drawCircle(position, radius, _paint);
  }

  @override
  _AtomState createState() => _AtomState();
}

class _AtomState extends State<Atom> with TickerProviderStateMixin {
  AnimationController controller;
  
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DrawCircle(widget.c),
      child: Container(

      ),
    );
  }
}

/// A render object that draws dots under each pointer.
class RenderAtoms extends RenderBox {
  RenderAtoms();

  /// State to remember which dots to paint.
  final Map<int, Atom> _dots = <int, Atom>{};

  /// Indicates that the size of this render object depends only on the
  /// layout constraints provided by the parent.
  /// 
  // @override
  // bool get sizedByParent => true;

  /// By selecting the biggest value permitted by the incoming constraints
  /// during layout, this function makes this render object as large as
  /// possible (i.e., fills the entire screen).
  /// 
  // @override
  // void performResize() {
  //   size = constraints.biggest;
  // }

  /// Makes this render object hittable so that it receives pointer events.
  @override
  bool hitTestSelf(Offset position) => true;

  /// Processes pointer events by mutating state and invalidating its previous
  /// painting commands.
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      final Color color = _kColors[event.pointer.remainder(_kColors.length)];
      _dots[event.pointer] = Dot(color: color)..update(event);
      // We call markNeedsPaint to indicate that our painting commands have
      // changed and that paint needs to be called before displaying a new frame
      // to the user. It's harmless to call markNeedsPaint multiple times
      // because the render tree will ignore redundant calls.
      markNeedsPaint();
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _dots.remove(event.pointer);
      markNeedsPaint();
    } else if (event is PointerMoveEvent) {
      _dots[event.pointer].update(event);
      markNeedsPaint();
    }
  }

  /// Issues new painting commands.
  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    // The "size" property indicates the size of that this render box was
    // allotted during layout. Here we paint our bounds white. Notice that we're
    // located at "offset" from the origin of the canvas' coordinate system.
    // Passing offset during the render tree's paint walk is an optimization to
    // avoid having to change the origin of the canvas's coordinate system too
    // often.
    canvas.drawRect(offset & size, Paint()..color = const Color(0xFFFFFFFF));

    // We iterate through our model and paint each dot.
    for (Dot dot in _dots.values)
      dot.paint(canvas, offset);
  }
}


class DrawCircle extends CustomPainter {

  DrawCircle(this.center);
  List<int> center;

  @override
  void paint(Canvas canvas, Size size) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0.0, 0.0), 100.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  // Create some styled text to tell the user to interact with the app.

  // final RenderParagraph paragraph = RenderParagraph(
  //   const TextSpan(
  //     style: TextStyle(color: Colors.black),
  //     text: 'Touch me!',
  //   ),
  //   textDirection: TextDirection.ltr,
  // );

  // A stack is a render object that layers its children on top of each other.
  // The bottom later is our RenderDots object, and on top of that we show the
  // text.
  final RenderStack stack = RenderStack(
    // textDirection: TextDirection.ltr,
    children: <RenderBox>[
      RenderDots(),
      // paragraph,
    ],
  );
  // The "parentData" field of a render object is controlled by the render
  // object's parent render object. Now that we've added the paragraph as a
  // child of the RenderStack, the paragraph's parentData field has been
  // populated with a StackParentData, which we can use to provide input to the
  // stack's layout algorithm.
  //
  // We use the StackParentData of the paragraph to position the text in the top
  // left corner of the screen.

  // final StackParentData paragraphParentData = paragraph.parentData;
  // paragraphParentData
  //   ..top = 40.0
  //   ..left = 50.0;

  // Finally, we attach the render tree we've built to the screen.
  RenderingFlutterBinding(root: stack);
}
