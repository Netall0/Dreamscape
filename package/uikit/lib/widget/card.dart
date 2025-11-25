import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uikit/extension/platform_extension.dart';

abstract class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool withShadow;
  final Border? border;

  const AdaptiveCard._({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.withShadow = true,
    this.border,
  });

  const factory AdaptiveCard({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    Border? border,
  }) = _AdaptiveCardDefault;

  const factory AdaptiveCard.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) = _AdaptiveCardElevated;

  const factory AdaptiveCard.flat({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
    Border? border,
  }) = _AdaptiveCardFlat;

  factory AdaptiveCard.outlined({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? borderColor,
  }) = _AdaptiveCardOutlined;
}

class _AdaptiveCardDefault extends AdaptiveCard {
  const _AdaptiveCardDefault({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    super.onTap,
    super.backgroundColor,
    super.elevation,
    super.borderRadius,
    super.border,
  }) : super._();

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      withShadow: withShadow,
      border: border,
      child: child,
    ),
    material: () => _MaterialCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      child: child,
    ),
  );
}

class _AdaptiveCardElevated extends AdaptiveCard {
  const _AdaptiveCardElevated({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    super.onTap,
    super.backgroundColor,
  }) : super._(elevation: 8, withShadow: true);

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      withShadow: withShadow,
      border: border,
      child: child,
    ),
    material: () => _MaterialCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      child: child,
    ),
  );
}

class _AdaptiveCardFlat extends AdaptiveCard {
  const _AdaptiveCardFlat({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    super.onTap,
    super.backgroundColor,
    super.border,
  }) : super._(elevation: 0, withShadow: false);

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      withShadow: withShadow,
      border: border,
      child: child,
    ),
    material: () => _MaterialCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      child: child,
    ),
  );
}

class _AdaptiveCardOutlined extends AdaptiveCard {
  _AdaptiveCardOutlined({
    super.key,
    required super.child,
    super.padding,
    super.margin,
    super.onTap,
    Color? borderColor,
    double borderWidth = 1.0,
  }) : super._(
         elevation: 0,
         withShadow: false,
         border: Border.all(
           color: borderColor ?? Colors.grey.shade300,
           width: borderWidth,
         ),
       );

  @override
  Widget build(BuildContext context) => PlatformExtension.when<Widget>(
    cupertino: () => _CupertinoCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      withShadow: withShadow,
      border: border,
      child: child,
    ),
    material: () => _MaterialCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      child: child,
    ),
  );
}

class _CupertinoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool withShadow;
  final Border? border;

  const _CupertinoCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.withShadow = true,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = DecoratedBox(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(
                    elevation != null ? elevation! / 10 : 0.2,
                  ),
                  blurRadius: elevation ?? 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}

class _MaterialCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;

  const _MaterialCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: elevation ?? 2,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          side: border != null ? border!.top : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: padding != null
              ? Padding(padding: padding!, child: child)
              : child,
        ),
      ),
    );
  }
}

//TODO:  cupertion colors to uikit colorsscheme
