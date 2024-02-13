import 'package:balagh/core/constants/constants.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final String label;
  final int currentTab;
  final Function(int) onTap;

  const NavbarItem({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
    required this.currentTab,
    required this.onTap,
  });

  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
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
            size: 32,
            widget.icon,
            color: widget.currentTab == widget.index ? kDeepBlue : kDarkGrey,
          ),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.currentTab == widget.index ? kDeepBlue : kDarkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
