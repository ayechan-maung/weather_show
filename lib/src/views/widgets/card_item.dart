import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Color? color;

  const CardItem(
      {Key? key, this.child, this.padding, this.margin, this.height, this.width, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color ?? Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }
}
