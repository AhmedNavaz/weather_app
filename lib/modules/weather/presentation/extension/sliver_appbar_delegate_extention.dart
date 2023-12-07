import 'dart:math' as math;
import 'package:flutter/material.dart';

// A custom SliverPersistentHeaderDelegate implementation for flexible SliverAppBar.
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  // Minimum and maximum heights for the SliverAppBar.
  final double minHeight;
  final double maxHeight;

  // Child widget to be displayed within the SliverAppBar.
  final Widget child;

  // Constructor to initialize the delegate with required parameters.
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Build method that returns a SizedBox containing the child widget.
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    // Determine if the delegate should be rebuilt based on parameter changes.
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
