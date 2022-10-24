// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('positions toolbar below anchor when it fits above bottom view padding', (WidgetTester tester) async {
    final double anchorBelow = 200.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setter) {
              setState = setter;
              return MaterialSpellCheckSuggestionsToolbar(
                anchorBelow: const Offset(50.0, anchorBelow),
                buttonItems: buildSuggestionButtons('hello', 'yellow', 'yell'),
              );
            },
          ),
        ),
      ),
    );

    // NOTE: this might not work (may need to do something like findPrivate in text_selection_toolbar_test)
    double toolbarY = tester.getTopLeft(find.byType('_FitsBelowAnchorMaterialSpellCheckSuggestionsToolbar'))
    expect(toolbarY, equals(anchorBelow));
  });

  testWidgets('re-positions toolbar higher below anchor when it does not fit above bottom view padding', (WidgetTester tester) async {
    final double anchorBelow = 200.0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setter) {
              setState = setter;
              return MaterialSpellCheckSuggestionsToolbar(
                anchorBelow: const Offset(50.0, anchorBelow),
                buttonItems: buildSuggestionButtons('world', 'word', 'old'),
              );
            },
          ),
        ),
      ),
    );

    // NOTE: this might not work (may need to do something like findPrivate in text_selection_toolbar_test)
    double toolbarY = tester.getTopLeft(find.byType('_FitsBelowAnchorMaterialSpellCheckSuggestionsToolbar'))
    expect(toolbarY, equals(anchorBelow + 10));
  });
 
}

class _FitsBelowAnchorMaterialSpellCheckSuggestionsToolbar extends MaterialSpellCheckSuggestionsToolbar {
  @override
  double getAvailableHeightBelow(BuildContext context, Offset anchorPadded) {
    // The toolbar will perfectly fit in the space available.
    return 0;
  }
}

class _DoesNotFitBelowAnchorMaterialSpellCheckSuggestionsToolbar extends MaterialSpellCheckSuggestionsToolbar {
    @override
    double getAvailableHeightBelow(BuildContext context, Offset anchorPadded) {
    // The toolbar overlaps the bottom view padding by 10 pixels.
    return -10;
  } 
}
