import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  final String url;
  final String imagePath;
  final double size;
  final bool isNetwork;
  final BorderRadius borderRadius;
  final String? tooltip;

  const SocialButton({
    super.key,
    required this.url,
    required this.imagePath,
    this.size = 30.0,
    this.isNetwork = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.tooltip,
  });

  Future<void> _launchUrl() async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // ignore errors silently or add logging if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child:
            isNetwork
                ? Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.link, color: Colors.black45),
                      ),
                )
                : Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );

    final child = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: _launchUrl,
        child: content,
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip!, child: child) : child;
  }
}
