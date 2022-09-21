// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'material.dart';
import 'text_selection_toolbar_text_button.dart';
import 'theme.dart';

// Minimal padding from all edges of the selection toolbar to all edges of the
// viewport.
const double _kToolbarScreenPadding = 8.0;
const double _kHandleSize = 22.0;

// Padding between the toolbar and the anchor.
const double _kToolbarContentDistanceBelow = _kHandleSize - 5.0;
const double _kToolbarContentDistance = 8.0;

const double _spellCheckSuggestionsToolbarHeight = 193;

/// The default context menu for displaying spell check suggestions for the
/// current platform.
///
/// Typically, this widget would be set as
/// `spellCheckSuggestionsToolbarBuilder` in a [SpellCheckConfiguration] that
/// would be passed to a supported parent widget, such as:
///
/// * [TextField.spellCheckConfiguration]
/// * [CupertinoTextField.spellCheckConfiguration]
///
/// See also:
/// * [MaterialSpellCheckSuggestionsToolbar], the default spell check
///   suggestions toolbar for Android.
class AdaptiveSpellCheckSuggestionsToolbar extends StatelessWidget {
  const AdaptiveSpellCheckSuggestionsToolbar({
    super.key,
    required this.primaryAnchor,
    this.secondaryAnchor,
    required this.buttonItems,
  });

  /// {@template flutter.material.AdaptiveSpellCheckSuggestionsToolbar.primaryAnchor}
  /// The main location on which to anchor the menu.
  ///
  /// Optionally, [secondaryAnchor] can be provided as an alternative anchor
  /// location if the menu doesn't fit here.
  /// {@endtemplate}
  final Offset primaryAnchor;

  /// {@template flutter.material.AdaptiveSpellCheckSuggestionsToolbar.secondaryAnchor}
  /// The optional secondary location on which to anchor the menu, if it doesn't
  /// fit at [primaryAnchor].
  /// {@endtemplate}
  final Offset? secondaryAnchor;

  /// {@template flutter.material.AdaptiveSpellCheckSuggestionsToolbar.buttonItems}
  /// The data that will be used to adaptively generate each child button
  /// containing a click-and-replace replacement suggestion or an action related
  /// to a misspelled word of the toolbar.
  /// {@endtemplate}
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

/// The default spell check suggestsions toolbar for Android.
///
/// Tries to position itself below [anchorBelow], but if it doesn't fit, then it
/// positions itself above [anchorAbove].
///
/// See also:
///
///  * [AdaptiveSpellCheckSuggestionsToolbar], which builds the toolbar for the
///    current platform.
class MaterialSpellCheckSuggestionsToolbar extends StatelessWidget {
  const MaterialSpellCheckSuggestionsToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.buttonItems,
  }) : assert(buttonItems != null);

  /// {@macro flutter.material.AdaptiveSpellCheckSuggestionsToolbar.primaryAnchor}
  final Offset anchorAbove;

  /// {@macro flutter.material.AdaptiveSpellCheckSuggestionsToolbar.secondaryAnchor}
  final Offset anchorBelow;

  /// The buttons that will be displayed in the spell check suggestions toolbar.
  final List<ContextMenuButtonItem> buttonItems;

  /// Build the default Android Material spell check suggestions toolbar.
  static Widget _spellCheckSuggestionsToolbarBuilder(BuildContext context, Widget child) {
    return _MaterialSpellCheckSuggestionsToolbarContainer(
      child: child,
    );
  }

  /// Helper method to create the buttons corresponding the spell check
  /// suggestions of a misspelled word or any applicable actions to take.
  List<Widget> _buildToolbarButtons() {
    int buttonIndex = 0;

    List<Widget> buttons =  buttonItems.map((ContextMenuButtonItem buttonItem) {
      TextSelectionToolbarTextButton button = TextSelectionToolbarTextButton(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        onPressed: buttonItem.onPressed,
        alignment: Alignment.centerLeft,
        child: Text(buttonItem.label!),
      );

      if (buttonItem.label! == 'DELETE') {
        return Container(
          decoration: BoxDecoration(border: Border(top: BorderSide (color: Colors.grey))),
          child: button.copyWith(
            child: Text(buttonItem.label!, style: TextStyle(color: Colors.blue))
          )
        );
      }
      return button;
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

    final double paddingBelow =
      math.max(MediaQuery.of(context).viewPadding.bottom, MediaQuery.of(context).viewInsets.bottom);
    final double availableHeightBelow = MediaQuery.of(context).size.height - anchorBelowPadded.dy - paddingBelow;
    final double paddingAbove = MediaQuery.of(context).padding.top
        + _kToolbarScreenPadding;
    final double availableHeightAbove = anchorAbovePadded.dy - _kToolbarContentDistance - paddingAbove;
    final bool fitsBelow = _spellCheckSuggestionsToolbarHeight <= availableHeightBelow;
    final bool fitsAbove = _spellCheckSuggestionsToolbarHeight <= availableHeightAbove;
    // Makes up for the Padding above the Stack.
    final Offset localAdjustment = Offset(_kToolbarScreenPadding, paddingAbove);

    print('height ${MediaQuery.of(context).size.height}');
    print('${MediaQuery.of(context).viewInsets}');
    print('${MediaQuery.of(context).viewPadding}');
    print('anchorBelow $anchorBelow');
    print('anchorAbovePadded $anchorAbovePadded');
    print('anchorBelowPadded $anchorBelowPadded');
    print('paddingAbove $paddingAbove');
    print('paddingBelow $paddingBelow');
    print('availableHeightBelow $availableHeightBelow');
    print('availableHeightAbove $availableHeightAbove');
    print('fitsAbove $fitsAbove');
    print('fitsBelow $fitsBelow');
    print('localAdjustment $localAdjustment');

    return Padding(
      padding: EdgeInsets.fromLTRB( //TODO: fix this to position versus text_selection.dart
        _kToolbarScreenPadding,
        _kToolbarContentDistanceBelow, //paddingAbove,
        _kToolbarScreenPadding,
        _kToolbarScreenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbovePadded - localAdjustment,
          anchorBelow: anchorBelowPadded - localAdjustment,
          fitsAbove: !fitsBelow,   
        ),
        child: AnimatedSize(
        // This duration was eyeballed on a Pixel 2 emulator running Android
        // API 28 for the Material TextSelectionToolbar.
          duration: const Duration(milliseconds: 140),
          child: _spellCheckSuggestionsToolbarBuilder(context, _SpellCheckSuggestsionsToolbarItemsLayout(
            children: <Widget>[..._buildToolbarButtons()],
          )),
        ),
      ),
    );
  }
}

/// The Material-styled toolbar outline for the spell check suggestions
/// toolbar.
class _MaterialSpellCheckSuggestionsToolbarContainer extends StatelessWidget {
  const _MaterialSpellCheckSuggestionsToolbarContainer({
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

/// Renders the spell check suggestions toolbar items in the correct positions
/// in the menu.
class _SpellCheckSuggestsionsToolbarItemsLayout extends StatelessWidget {
  const _SpellCheckSuggestsionsToolbarItemsLayout({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 165,
      height: _spellCheckSuggestionsToolbarHeight,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[...children],
    ),
    );
  }
}
