import 'package:flutter/material.dart';

enum Position { Top, Center, Bottom }

class SeparatedRounded extends StatelessWidget {
  final List<Widget> children;
  final double height;

  SeparatedRounded({
    @required this.children,
    this.height: 40.0,
    Key key,
  }) : super(key: key);

  Container styledButton(BuildContext context, Widget child, Position position) {
    BorderRadius radius;
    switch (position) {
      case Position.Top:
        radius = BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10));
        break;
      case Position.Center:
        radius = BorderRadius.zero;
        break;
      case Position.Bottom:
        radius = BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
        break;
    }

    return Container(
        height: height,
        width: 280.0,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: radius,
          ),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: child),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [styledButton(context, children.first, Position.Top)];

    children.forEach((widget) {
      if (widget == children.first) return;
      if (widget == children.last) return;
      widgets.add(SizedBox(height: 5));
      widgets.add(styledButton(context, widget, Position.Center));
    });

    widgets.add(SizedBox(height: 5));
    widgets.add(styledButton(context, children.last, Position.Bottom));

    return Column(
      children: widgets,
    );
  }
}
