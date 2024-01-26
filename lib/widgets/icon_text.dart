import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String imageUrl;
  final String text;

  const IconText({Key? key, required this.imageUrl, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: 16,
          height: 16,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const SizedBox(width: 8), // Space between icon and text
        Text(text),
      ],
    );
  }
}
