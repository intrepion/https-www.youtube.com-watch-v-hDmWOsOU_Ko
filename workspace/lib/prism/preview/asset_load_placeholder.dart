import 'package:flutter/material.dart';

class AssetLoadPlaceholder extends StatelessWidget {
  const AssetLoadPlaceholder.loading({
    super.key,
    required this.width,
    required this.height,
  }) : message = 'Loading...',
       showSpinner = true;

  const AssetLoadPlaceholder.error({
    super.key,
    required this.width,
    required this.height,
    this.message = 'Image failed to load',
  }) : showSpinner = false;

  final double width;
  final double height;
  final String message;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: showSpinner ? const CircularProgressIndicator() : Text(message),
      ),
    );
  }
}
