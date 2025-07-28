import 'package:flutter/material.dart';

class InnerShadowContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final Color backgroundColor;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const InnerShadowContainer({
    Key? key,
    required this.child,
    required this.width,
    required this.height,
    this.shadowColor = Colors.black26,
    this.blurRadius = 4.0,
    this.offset = const Offset(0, 0),
    this.backgroundColor = Colors.transparent,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
      ),
      child: CustomPaint(
        painter: InnerShadowPainter(
          shadowColor: shadowColor,
          blurRadius: blurRadius,
          offset: offset,
          shape: shape,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blurRadius;
  final Offset offset;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  InnerShadowPainter({
    required this.shadowColor,
    required this.blurRadius,
    required this.offset,
    required this.shape,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    final Path outerPath = Path();
    final Path innerPath = Path();

    if (shape == BoxShape.circle) {
      // Create circular paths
      outerPath.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
      innerPath.addOval(Rect.fromLTWH(
        offset.dx,
        offset.dy,
        size.width - offset.dx,
        size.height - offset.dy,
      ));
    } else {
      // Create rectangular paths with border radius
      final RRect outerRRect = borderRadius != null
          ? borderRadius!.toRRect(Rect.fromLTWH(0, 0, size.width, size.height))
          : RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.zero,
            );

      final RRect innerRRect = borderRadius != null
          ? borderRadius!.toRRect(Rect.fromLTWH(
              offset.dx,
              offset.dy,
              size.width - offset.dx,
              size.height - offset.dy,
            ))
          : RRect.fromRectAndRadius(
              Rect.fromLTWH(
                offset.dx,
                offset.dy,
                size.width - offset.dx,
                size.height - offset.dy,
              ),
              Radius.zero,
            );

      outerPath.addRRect(outerRRect);
      innerPath.addRRect(innerRRect);
    }

    // Create the shadow path by subtracting inner from outer
    final Path shadowPath = Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.clipPath(outerPath);
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
