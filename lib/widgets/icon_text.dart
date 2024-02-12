import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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
        _buildImage(),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildImage() {
    const BoxFit fit = BoxFit.cover;
    const double width = 16.0;
    const double height = 16.0;
    const Widget placeholder = CircularProgressIndicator();
    const Widget errorWidget = Icon(Icons.error);

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) => placeholder,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}
