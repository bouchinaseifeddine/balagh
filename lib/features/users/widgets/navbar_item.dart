import 'package:balagh/core/constants/constants.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final int currentTab;
  final Function(int) onTap;

  const NavbarItem({
    super.key,
    required this.index,
    required this.icon,
    required this.currentTab,
    required this.onTap,
  });

  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBar(isActive: widget.currentTab == widget.index),
        Opacity(
          opacity: widget.currentTab == widget.index ? 1 : 0.5,
          child: MaterialButton(
            minWidth: 40,
            onPressed: () {
              widget.onTap(widget.index);
            },
            // to remove the splash and the highlight color when we press the button
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  size: 36,
                  widget.icon,
                  color: kDarkBlue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
        color: kLightBlue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ), // BoxDecoration
    ); // Animated Container
  }
}
