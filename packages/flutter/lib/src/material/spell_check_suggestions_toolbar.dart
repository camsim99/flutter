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

// Adapted from TextSelectionToolbar
class TextSelectionToolbarForSpellCheck extends StatelessWidget {
  /// Creates an instance of TextSelectionToolbar.
  const TextSelectionToolbarForSpellCheck({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    this.toolbarBuilder = _defaultToolbarBuilder,
    required this.children,
  }) : assert(children.length > 0);

  /// {@template flutter.material.TextSelectionToolbar.anchorAbove}
  /// The focal point above which the toolbar attempts to position itself.
  ///
  /// If there is not enough room above before reaching the top of the screen,
  /// then the toolbar will position itself below [anchorBelow].
  /// {@endtemplate}
  final Offset anchorAbove;

  /// {@template flutter.material.TextSelectionToolbar.anchorBelow}
  /// The focal point below which the toolbar attempts to position itself, if it
  /// doesn't fit above [anchorAbove].
  /// {@endtemplate}
  final Offset anchorBelow;

  /// {@template flutter.material.TextSelectionToolbar.children}
  /// The children that will be displayed in the text selection toolbar.
  ///
  /// Typically these are buttons.
  ///
  /// Must not be empty.
  /// {@endtemplate}
  ///
  /// See also:
  ///   * [TextSelectionToolbarTextButton], which builds a default Material-
  ///     style text selection toolbar text button.
  final List<Widget> children;

  /// {@template flutter.material.TextSelectionToolbar.toolbarBuilder}
  /// Builds the toolbar container.
  ///
  /// Useful for customizing the high-level background of the toolbar. The given
  /// child Widget will contain all of the [children].
  /// {@endtemplate}
  final ToolbarBuilder toolbarBuilder;

  // Build the default Android Material text selection menu toolbar.
  static Widget _defaultToolbarBuilder(BuildContext context, Widget child) {
    return _TextSelectionToolbarContainer(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Incorporate the padding distance between the content and toolbar.
    final Offset anchorAbovePadded =
        anchorAbove - const Offset(0.0, _kToolbarContentDistance);
    final Offset anchorBelowPadded =
        anchorBelow + const Offset(0.0, _kToolbarContentDistanceBelow);

    final double paddingAbove = MediaQuery.of(context).padding.top
        + _kToolbarScreenPadding;
    final double availableHeight = anchorAbovePadded.dy - _kToolbarContentDistance - paddingAbove;
    final bool fitsAbove = _kToolbarHeight <= availableHeight;
    // Makes up for the Padding above the Stack.
    final Offset localAdjustment = Offset(_kToolbarScreenPadding, paddingAbove);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _kToolbarScreenPadding,
        paddingAbove,
        _kToolbarScreenPadding,
        _kToolbarScreenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbovePadded - localAdjustment,
          anchorBelow: anchorBelowPadded - localAdjustment,
          fitsAbove: fitsAbove,
        ),
        child: _TextSelectionToolbarOverflowable(
          isAbove: fitsAbove,
          toolbarBuilder: toolbarBuilder,
          children: children,
        ),
      ),
    );
  }
}

// A toolbar containing the given children. If they overflow the width
// available, then the overflowing children will be displayed in an overflow
// menu.
class _TextSelectionToolbarOverflowable extends StatefulWidget {
  const _TextSelectionToolbarOverflowable({
    required this.isAbove,
    required this.toolbarBuilder,
    required this.children,
  }) : assert(children.length > 0);

  final List<Widget> children;

  // When true, the toolbar fits above its anchor and will be positioned there.
  final bool isAbove;

  // Builds the toolbar that will be populated with the children and fit inside
  // of the layout that adjusts to overflow.
  final ToolbarBuilder toolbarBuilder;

  @override
  _TextSelectionToolbarOverflowableState createState() => _TextSelectionToolbarOverflowableState();
}

class _TextSelectionToolbarOverflowableState extends State<_TextSelectionToolbarOverflowable> with TickerProviderStateMixin {
  // Whether or not the overflow menu is open. When it is closed, the menu
  // items that don't overflow are shown. When it is open, only the overflowing
  // menu items are shown.
  bool _overflowOpen = false;

  // The key for _TextSelectionToolbarTrailingEdgeAlign.
  UniqueKey _containerKey = UniqueKey();

  // Close the menu and reset layout calculations, as in when the menu has
  // changed and saved values are no longer relevant. This should be called in
  // setState or another context where a rebuild is happening.
  void _reset() {
    // Change _TextSelectionToolbarTrailingEdgeAlign's key when the menu changes
    // in order to cause it to rebuild. This lets it recalculate its
    // saved width for the new set of children, and it prevents AnimatedSize
    // from animating the size change.
    _containerKey = UniqueKey();
    // If the menu items change, make sure the overflow menu is closed. This
    // prevents getting into a broken state where _overflowOpen is true when
    // there are not enough children to cause overflow.
    _overflowOpen = false;
  }

  @override
  void didUpdateWidget(_TextSelectionToolbarOverflowable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the children are changing at all, the current page should be reset.
    if (!listEquals(widget.children, oldWidget.children)) {
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return _TextSelectionToolbarTrailingEdgeAlign(
      key: _containerKey,
      overflowOpen: _overflowOpen,
      textDirection: Directionality.of(context),
      child: AnimatedSize(
        // This duration was eyeballed on a Pixel 2 emulator running Android
        // API 28.
        duration: const Duration(milliseconds: 140),
        child: widget.toolbarBuilder(context, _TextSelectionToolbarItemsLayout(
          isAbove: widget.isAbove,
          overflowOpen: _overflowOpen,
          children: <Widget>[
            // TODO(justinmc): This overflow button should have its own slot in
            // _TextSelectionToolbarItemsLayout separate from children, similar
            // to how it's done in Cupertino's text selection menu.
            // https://github.com/flutter/flutter/issues/69908
            // The navButton that shows and hides the overflow menu is the
            // first child.
            _TextSelectionToolbarOverflowButton(
              icon: Icon(_overflowOpen ? Icons.arrow_back : Icons.more_vert),
              onPressed: () {
                setState(() {
                  _overflowOpen = !_overflowOpen;
                });
              },
              tooltip: _overflowOpen
                  ? localizations.backButtonTooltip
                  : localizations.moreButtonTooltip,
            ),
            ...widget.children,
          ],
        )),
      ),
    );
  }
}
