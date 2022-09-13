// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'material.dart';
import 'text_selection_toolbar_text_button.dart';
import 'theme.dart';

// Minimal padding from all edges of the selection toolbar to all edges of the
// viewport.
const double _kToolbarScreenPadding = 8.0; //TODO(camillesimon): Where is this coming from?
const double _kToolbarHeight = 192 ; // TODO(camillesimon): change to whatever is needed

const double _kHandleSize = 22.0; //TODO(camillesimon): Do anchors need t odisappear?

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 2.0;
const double _kToolbarContentDistance = 8.0;

/// TODO(camillesimon): comment
class AdaptiveSpellCheckSuggestionsToolbar extends StatelessWidget {
  const AdaptiveSpellCheckSuggestionsToolbar({
    super.key,
    required this.primaryAnchor,
    this.secondaryAnchor,
    required this.buttonItems,
  });

  /// TODO: comment
  final Offset primaryAnchor;

  /// TODO: comment
  final Offset? secondaryAnchor;

  /// TODO: comment
  final List<ContextMenuButtonItem>? buttonItems;

  @override
  Widget build(BuildContext context) {
    // If there aren't any buttons to build, build an empty toolbar.
    if (buttonItems?.isEmpty ?? false) {
      return const SizedBox(width: 0.0, height: 0.0);
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      return MaterialSpellCheckSuggestionsToolbar(
        anchorAbove: primaryAnchor,
        anchorBelow: secondaryAnchor == null ? primaryAnchor : secondaryAnchor!,
        buttonItems: buttonItems!,
      );
      case TargetPlatform.iOS:
      default:
        return const SizedBox(width: 0.0, height: 0.0);
    }
  }
}

  /// TODO: comment
class MaterialSpellCheckSuggestionsToolbar extends StatelessWidget {
  const MaterialSpellCheckSuggestionsToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.buttonItems,
  }) : assert(buttonItems != null);

  /// TODO: comment
  final Offset anchorAbove;

  /// TODO: comment
  final Offset anchorBelow;

  /// TODO: comment
  final List<ContextMenuButtonItem> buttonItems;

  static Widget _spellCheckSuggestionsToolbarBuilder(BuildContext context, Widget child) {
    return _MaterialSpellCheckSuggestionsToolbarContainer(
      child: child,
    );
  }

  List<TextSelectionToolbarTextButton> _buildToolbarButtons() {
    int buttonIndex = 0;

    List<TextSelectionToolbarTextButton> buttons =  buttonItems.map((ContextMenuButtonItem buttonItem) {
      TextSelectionToolbarTextButton textButton = TextSelectionToolbarTextButton(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        onPressed: buttonItem.onPressed,
        child: Text(buttonItem.label!),
      );
      if (buttonItem.label! == 'DELETE') {
        textButton = TextSelectionToolbarTextButton(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          onPressed: buttonItem.onPressed,
          child: Text(buttonItem.label!, style: TextStyle(color: Colors.blue)),
        );
      }
      return textButton;
    }).toList();

    return buttons;
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
          child: _spellCheckSuggestionsToolbarBuilder(context, _SpellCheckSuggestsionsToolbarItemsLayout(
            fitsAbove: fitsAbove,
            children: <TextSelectionToolbarTextButton>[..._buildToolbarButtons()],
          )),
        ),
      ),
    );
  }
}

  /// TODO: comment
class _MaterialSpellCheckSuggestionsToolbarContainer extends StatelessWidget {
  const _MaterialSpellCheckSuggestionsToolbarContainer({
    required this.child,
  });

  /// TODO: comment
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

  /// TODO: comment
class _SpellCheckSuggestsionsToolbarItemsLayout extends StatelessWidget {
  const _SpellCheckSuggestsionsToolbarItemsLayout({
    required this.fitsAbove,
    required this.children,
  });

  /// TODO: comment
  final bool fitsAbove;

  /// TODO: comment
  final List<TextSelectionToolbarTextButton> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 165,
      height: _kToolbarHeight,
      child: Column(
      // TODO(camillesimon): sizeThingys: ..., if needed.. needs to be left aligned. delete button?
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[...children],
    ),
    );
  }
}
