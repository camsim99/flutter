// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

import 'desktop_text_selection_toolbar.dart';
import 'text_selection_toolbar.dart';
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

    return TextSelectionToolbarButtonsBuilder(
      buttonItems: buttonItems,
      builder: (BuildContext context, List<Widget> children) {
        return _AdaptiveTextSelectionToolbarFromChildren(
          primaryAnchor: primaryAnchor,
          secondaryAnchor: secondaryAnchor,
          children: children,
        );
      },
    );
  }
}
