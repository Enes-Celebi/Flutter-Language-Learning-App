import 'package:flutter/material.dart';

class CustomBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBottomBar;
  final double height;
  final Widget? child;

  const CustomBar({
    super.key,
    this.isBottomBar = false,
    this.height = 80,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isBottomBar
        ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )
        : const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: borderRadius,
        border: Border(
          bottom: isBottomBar ? BorderSide.none : BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 3),
          top: isBottomBar ? BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 3) : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
