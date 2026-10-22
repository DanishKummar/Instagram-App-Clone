import 'package:flutter/material.dart';

class CustomScrollPhysics extends PageScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  // Reduce the scroll trigger threshold
  @override
  double get dragStartDistanceMotionThreshold => 1; // default is 10.0

  @override
  double get minFlingDistance => 5.0; // default is 50.0

  @override
  double get minFlingVelocity => 20.0; // default is 400.0

  @override
  double get maxFlingVelocity => 5000.0;
}
