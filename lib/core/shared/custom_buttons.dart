import 'package:balagh/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:balagh/core/utils/size_config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.text,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    this.isLoading = false,
  }) : super(key: key);
  final String? text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? fontSize;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 60,
        width: width ?? SizeConfig.screenWidth,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          color: backgroundColor,
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading!
              ? const CircularProgressIndicator(
                  color: kWhite,
                )
              : Text(
                  text!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon({
    Key? key,
    required this.text,
    this.onTap,
    this.iconData,
    this.color,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.width,
    this.fontSize,
    this.isLoading = false,
  }) : super(key: key);
  final String text;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 60,
        width: width ?? SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: borderColor ?? Colors.transparent, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (isLoading)!
                ? const CircularProgressIndicator(
                    color: kWhite,
                  )
                : Row(
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize,
                          color: color,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        iconData,
                        color: color,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
