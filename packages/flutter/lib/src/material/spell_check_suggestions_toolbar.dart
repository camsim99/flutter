// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart' show StatelessWidget;

// import 'material.dart';
// import 'text_selection_toolbar_text_button.dart';

// Minimal padding from all edges of the selection toolbar to all edges of the
// viewport.
const double _kToolbarScreenPadding = 8.0;
const double _kToolbarHeight = 88.5; // TODO(camillesimon): change to whatever is needed

const double _kHandleSize = 22.0;

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 8.0;

/// TODO(camillesimon)
class AdaptiveSpellCheckSuggestionsToolbar extends StatelessWidget {
  const AdaptiveSpellCheckSuggestionsToolbar({
    super.key,
    required this.primaryAnchor,
    this.secondaryAnchor,
    required this.buttonItems,
  });

  final Offset primaryAnchor;

  final Offset? secondaryAnchor;

  final List<ContextMenuButtonItem>? buttonItems;

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if (buttonItems?.isEmpty ?? false) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      return MaterialSpellCheckSpellCheckSuggestionsToolbar(
        anchorAbove: primaryAnchor,
        anchorBelow: secondaryAnchor == null ? primaryAnchor : secondaryAnchor!,
        buttonItems: buttonItems!,
      );
      case TargetPlatform.ios:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
        return const SizedBox(width: 0.0, height: 0.0);
    }
  }
}

class MaterialSpellCheckSuggestionsToolbar exends StatelessWidget {
  const MaterialSpellCheckSuggestionsToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.buttonItems,
  }) : assert(buttonItems != null);

  final Offset primaryAnchor;

  final Offset secondaryAnchor;

  final List<ContextMenuButtonItem> buttonItems;

  static Widgtet _spellCheckSuggestionsToolbarBuilder(BuildContext context, Widget child) {
    return _MaterialSpellCheckSuggestionsToolbarContainer(
      child: child,
    );
  }

  List<TextSelectionToolbarTextButton> _buildToolbarButtons() {
    int buttonIndex = 0;

    return buttonItems.map((ContextMenuItem buttonItem) {
      return TextSelectionToolbarTextButton(
        padding:  EdgeInsets.fromLTRB(10, 10, 10, 10),
        onPressed: buttonItem.onPressed,
        child: Text(buttonItem.label),
      );
    }).toList();
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
        child: AnimatedSize(
        // This duration was eyeballed on a Pixel 2 emulator running Android
        // API 28.
          duration: const Duration(milliseconds: 140),
          child: _spellCheckSuggestionsToolbarBuilder(context, _SpellCheckSuggestsionsToolbarItemsLayout( // TODO(camillesimon): figure out if I can use this or not
            fitsAbove: fitsAbove,
            children: <TextSelectionToolbarTextButton>[..._buildToolbarButtons()],
          )),
        ),
      ,)
    );
  }
}

class _MaterialSpellCheckSuggestionsToolbarBuilder extends StatelessWidget {
  const _MaterialSpellCheckSuggestionsToolbarBuilder({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      type: MaterialType.card,
      child: child,
    );
  }
}

class _SpellCheckSuggestsionsToolbarItemsLayout extends StatelessWidget {
  const _SpellCheckSuggestsionsToolbarItemsLayout({
    required this.fitsAbove,
    required this.children,
  });

  final bool fitsAbove;

  final List<TextSelectionToolbarTextButton> children;

  List<Padding> _buildButtonsWithPadding() {
    return children.forEach((TextSelectionToolbarTextButton button) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10), // TODO(camillesimon): Fix sizes here
        child: button,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // TODO(camillesimon): sizeThingys: ..., if needed
      children: <Widget>[child],
    );
  }
}
