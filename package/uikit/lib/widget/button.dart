import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uikit/extension/platform_extension.dart';
import 'package:uikit/theme/app_theme.dart';

abstract class AdaptiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final Color? color;
  final IconData? icon;
  final Color? sideColor;

  const AdaptiveButton._({
    required this.sideColor,
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.minWidth,
    this.color,
    this.icon,
  });

  const factory AdaptiveButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? minWidth,
    Color? color,
    Color? sideColor,
  }) = _AdaptiveButtonPrimary;

  const factory AdaptiveButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? minWidth,
    Color? color,
    Color? sideColor,
  }) = _AdaptiveButtonSecondary;

  const factory AdaptiveButton.text({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Color? color,
  }) = _AdaptiveButtonText;

  // Destructive button
  const factory AdaptiveButton.destructive({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? minWidth,
  }) = _AdaptiveButtonDestructive;

  const factory AdaptiveButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required IconData icon,
    required Widget label,
    EdgeInsetsGeometry? padding,
    Color? color,
  }) = _AdaptiveButtonIcon;
}

class _AdaptiveButtonPrimary extends AdaptiveButton {
  const _AdaptiveButtonPrimary({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
    super.minWidth,
    super.color,
    super.sideColor,
  }) : super._();

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoButtonPrimary(
      onPressed: onPressed,
      padding: padding,
      color: color,
      child: child,
    ),
    material: () => _MaterialButtonPrimary(
      onPressed: onPressed,
      padding: padding,
      minWidth: minWidth,
      color: color,
      sideColor: sideColor,
      child: child,
    ),
  );
}

class _AdaptiveButtonSecondary extends AdaptiveButton {
  const _AdaptiveButtonSecondary({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
    super.minWidth,
    super.color,
    super.sideColor,
  }) : super._();

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoButtonSecondary(
      onPressed: onPressed,
      padding: padding,
      color: color,
      child: child,
    ),
    material: () => _MaterialButtonSecondary(
      onPressed: onPressed,
      padding: padding,
      minWidth: minWidth,
      color: color,
      sideColor: sideColor,
      child: child,
    ),
  );
}

class _AdaptiveButtonText extends AdaptiveButton {
  const _AdaptiveButtonText({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
    super.color,
    super.sideColor,
  }) : super._();

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoButtonText(
      onPressed: onPressed,
      padding: padding,
      child: child,
    ),
    material: () => _MaterialButtonText(
      onPressed: onPressed,
      padding: padding,
      color: color,
      child: child,
    ),
  );
}

class _AdaptiveButtonDestructive extends AdaptiveButton {
  const _AdaptiveButtonDestructive({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
    super.sideColor,
    super.minWidth,
  }) : super._();

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoButtonDestructive(
      onPressed: onPressed,
      padding: padding,
      child: child,
    ),
    material: () => _MaterialButtonDestructive(
      onPressed: onPressed,
      padding: padding,
      minWidth: minWidth,
      child: child,
    ),
  );
}

class _AdaptiveButtonIcon extends AdaptiveButton {
  const _AdaptiveButtonIcon({
    super.key,
    required super.onPressed,
    required IconData super.icon,
    required Widget label,
    super.padding,
    super.color,
    super.sideColor,
  }) : super._(child: label);

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoButtonIcon(
      onPressed: onPressed,
      icon: icon!,
      label: child,
      padding: padding,
    ),
    material: () => _MaterialButtonIcon(
      onPressed: onPressed,
      icon: icon!,
      label: child,
      padding: padding,
      color: color,
    ),
  );
}

class _CupertinoButtonPrimary extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const _CupertinoButtonPrimary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(10),

      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: child,
    );
  }
}

class _CupertinoButtonSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? sideColor;

  const _CupertinoButtonSecondary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.color, this.sideColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(10),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: color ?? CupertinoColors.secondarySystemFill.resolveFrom(context),
      child: DefaultTextStyle(
        style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        child: child,
      ),
    );
  }
}

class _CupertinoButtonText extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _CupertinoButtonText({
    required this.onPressed,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}

class _CupertinoButtonDestructive extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _CupertinoButtonDestructive({
    required this.onPressed,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(10),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: DefaultTextStyle(
        style: const TextStyle(color: CupertinoColors.white),
        child: child,
      ),
    );
  }
}

class _CupertinoButtonIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Widget label;
  final EdgeInsetsGeometry? padding;

  const _CupertinoButtonIcon({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(10),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 20), const SizedBox(width: 8), label],
      ),
    );
  }
}

class _MaterialButtonPrimary extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final Color? color;
  final Color? sideColor;

  const _MaterialButtonPrimary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.minWidth,
    this.color,
    this.sideColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: minWidth != null ? Size(minWidth!, 44) : null,
        side: BorderSide(color: sideColor ?? Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(10))),
      ),
      child: child,
    );
  }
}

class _MaterialButtonSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final Color? color;
  final Color? sideColor;

  const _MaterialButtonSecondary({
    required this.onPressed,
    required this.child,
    this.padding,
    this.minWidth,
    this.color,
    this.sideColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: minWidth != null ? Size(minWidth!, 44) : null,
        side: BorderSide(width: 2, color: sideColor ?? theme.colors.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: child,
    );
  }
}

class _MaterialButtonText extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const _MaterialButtonText({
    required this.onPressed,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: child,
    );
  }
}

class _MaterialButtonDestructive extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;

  const _MaterialButtonDestructive({
    required this.onPressed,
    required this.child,
    this.padding,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: minWidth != null ? Size(minWidth!, 44) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: child,
    );
  }
}

class _MaterialButtonIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Widget label;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const _MaterialButtonIcon({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: label,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
