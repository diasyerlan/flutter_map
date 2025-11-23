import 'package:flutter/material.dart';

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback? onMyLocation;

  const ZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onMyLocation != null) ...[
          _ZoomButton(
            icon: Icons.my_location,
            onPressed: onMyLocation!,
            tooltip: 'My Location',
          ),
          const SizedBox(height: 8),
        ],
        _ZoomButton(
          icon: Icons.add,
          onPressed: onZoomIn,
          tooltip: 'Zoom In',
        ),
        const SizedBox(height: 8),
        _ZoomButton(
          icon: Icons.remove,
          onPressed: onZoomOut,
          tooltip: 'Zoom Out',
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _ZoomButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
