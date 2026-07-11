import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularNetworkImage extends StatelessWidget {
  const CircularNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 30,
    this.height = 30,
    this.borderRadius = 30,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.fit = BoxFit.cover
  });

  final double width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final String imageUrl;
  final void Function()? onTap;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) => const Center(
              child: CupertinoActivityIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
