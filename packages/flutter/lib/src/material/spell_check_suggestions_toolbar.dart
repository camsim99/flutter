// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'debug.dart';
import 'desktop_text_selection_toolbar.dart';
import 'material_localizations.dart';
import 'text_selection_toolbar.dart';
import 'text_selection_toolbar_text_button.dart';
import 'text_selection_toolbar_buttons_builder.dart';
import 'theme.dart';


// Adapted from AdaptiveTextSelectionToolbar for dev, could be used directly
class AdaptiveTextSelectionToolbarSpellCheck extends StatelessWidget {
  const AdaptiveTextSelectionToolbarSpellCheck({
    super.key,
    required this.buttonItems,
    required this.primaryAnchor,
    this.secondaryAnchor,
  });

  final List<ContextMenuButtonItem>? buttonItems;

  final Offset primaryAnchor;

  final Offset? secondaryAnchor;

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if ((buttonItems?.isEmpty ?? false)) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return _AdaptiveTextSelectionToolbarFromButtonItemsForSpellCheck(
      primaryAnchor: primaryAnchor,
      secondaryAncho: secondaryAnchor,
      buttonItems: buttonItems!,
    );
  }
}

// Adapted from _AdaptiveTextSelecitonToolbarFromButtonItems
class _AdaptiveTextSelectionToolbarFromButtonItemsForSpellCheck extends StatelessWidget {
  const _AdaptiveTextSelectionToolbarFromButtonItemsForSpellCheck({
    required this.primaryAnchor,
    this.secondaryAnchor,
    required this.buttonItems,
  }) : assert(buttonItems != null);

  final Offset primaryAnchor;

  final Offset? secondaryAnchor;

  final List<ContextMenuButtonItem> buttonItems;

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if (buttonItems.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    return TextSelectionToolbarButtonsBuilderForSpellCheck(
      buttonItems: buttonItems,
      builder: (BuildContext context, List<Widget> children) {
        return _AdaptiveTextSelectionToolbarFromChildrenForSpellCheck(
          primaryAnchor: primaryAnchor,
          secondaryAnchor: secondaryAnchor,
          children: children,
        );
      },
    );
  }
}

/// Adapted from _AdaptiveTextSelectionToolbarFromChildren
class _AdaptiveTextSelectionToolbarFromChildrenForSpellCheck extends StatelessWidget {
  const _AdaptiveTextSelectionToolbarFromChildrenForSpellCheck({
    required this.primaryAnchor,
    this.secondaryAnchor,
    required this.children,
  }) : assert(children != null);

  /// {@macro flutter.material.AdaptiveTextSelectionToolbar.primaryAnchor}
  final Offset primaryAnchor;

  /// {@macro flutter.material.AdaptiveTextSelectionToolbar.secondaryAnchor}
  final Offset? secondaryAnchor;

  /// The children of the toolbar, typically buttons.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if (children.isEmpty) {
      return const SizedBox(width: 0.0, height: 0.0);
    }
    return TextSelectionToolbarForSpellCheck(
      anchorAbove: primaryAnchor,
      anchorBelow: secondaryAnchor == null ? primaryAnchor : secondaryAnchor!,
      children: children,
    );
  }
}

// Adapted from TextSelectionToolbarButtonsBuilder
class TextSelectionToolbarButtonsBuilderForSpellCheck extends StatelessWidget {
  /// Creates an instance of [TextSelectionToolbarButtonsBuilder].
  const TextSelectionToolbarButtonsBuilderForSpellCheck({
    super.key,
    required this.buttonItems,
    required this.builder,
  });

  /// The information used to create each button Widget.
  final List<ContextMenuButtonItem> buttonItems;

  /// Called with a List of Widgets created from the given [buttonItems].
  ///
  /// Typically builds a text selection toolbar with the given Widgets as
  /// children.
  final ContextMenuFromChildrenBuilder builder;

  @override
  Widget build(BuildContext context) {
    int buttonIndex = 0;
        return builder(
          context,
          buttonItems.map((ContextMenuButtonItem buttonItem) {
            return TextSelectionToolbarTextButton(
              padding: TextSelectionToolbarTextButton.getPadding(buttonIndex++, buttonItems.length),
              onPressed: buttonItem.onPressed,
              child: Text(getButtonLabel(context, buttonItem)),
            );
          }).toList(),
        );
  }
}

// Adapted from TextSelectionToolbarTextButton -- perhaps make my own at this level
class TextSelectionToolbarTextButton extends StatelessWidget {
  /// Creates an instance of TextSelectionToolbarTextButton.
  const TextSelectionToolbarTextButton({
    super.key,
    required this.child,
    required this.padding,
    this.onPressed,
  });

  // These values were eyeballed to match the native text selection menu on a
  // Pixel 2 running Android 10.
  static const double _kMiddlePadding = 9.5;
  static const double _kEndPadding = 14.5;

  /// {@template flutter.material.TextSelectionToolbarTextButton.child}
  /// The child of this button.
  ///
  /// Usually a [Text].
  /// {@endtemplate}
  final Widget child;

  /// {@template flutter.material.TextSelectionToolbarTextButton.onPressed}
  /// Called when this button is pressed.
  /// {@endtemplate}
  final VoidCallback? onPressed;

  /// The padding between the button's edge and its child.
  ///
  /// In a standard Material [TextSelectionToolbar], the padding depends on the
  /// button's position within the toolbar.
  ///
  /// See also:
  ///
  ///  * [getPadding], which calculates the standard padding based on the
  ///    button's position.
  ///  * [ButtonStyle.padding], which is where this padding is applied.
  final EdgeInsets padding;

  /// Returns the standard padding for a button at index out of a total number
  /// of buttons.
  ///
  /// Standard Material [TextSelectionToolbar]s have buttons with different
  /// padding depending on their position in the toolbar.
  static EdgeInsets getPadding(int index, int total) {
    assert(total > 0 && index >= 0 && index < total);
    final _TextSelectionToolbarItemPosition position = _getPosition(index, total);
    return EdgeInsets.only(
      left: _getLeftPadding(position),
      right: _getRightPadding(position),
    );
  }

  static double _getLeftPadding(_TextSelectionToolbarItemPosition position) {
    if (position == _TextSelectionToolbarItemPosition.first
        || position == _TextSelectionToolbarItemPosition.only) {
      return _kEndPadding;
    }
    return _kMiddlePadding;
  }

  static double _getRightPadding(_TextSelectionToolbarItemPosition position) {
    if (position == _TextSelectionToolbarItemPosition.last
        || position == _TextSelectionToolbarItemPosition.only) {
      return _kEndPadding;
    }
    return _kMiddlePadding;
  }

  static _TextSelectionToolbarItemPosition _getPosition(int index, int total) {
    if (index == 0) {
      return total == 1
          ? _TextSelectionToolbarItemPosition.only
          : _TextSelectionToolbarItemPosition.first;
    }
    if (index == total - 1) {
      return _TextSelectionToolbarItemPosition.last;
    }
    return _TextSelectionToolbarItemPosition.middle;
  }

  @override
  Widget build(BuildContext context) {
    // TODO(hansmuller): Should be colorScheme.onSurface
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.colorScheme.brightness == Brightness.dark;
    final Color foregroundColor = isDark ? Colors.white : Colors.black87;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        shape: const RoundedRectangleBorder(),
        minimumSize: const Size(kMinInteractiveDimension, kMinInteractiveDimension),
        padding: padding,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

