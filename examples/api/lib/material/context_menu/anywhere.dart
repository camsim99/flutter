// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This sample demonstrates allowing a context menu to be shown in a widget
// subtree in response to user gestures.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _showDialog (BuildContext context) {
    Navigator.of(context).push(
      DialogRoute<void>(
        context: context,
        builder: (BuildContext context) =>
          const AlertDialog(title: Text('You clicked print!')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Context menu in SelectionArea'),
        ),
        body: _ContextMenuRegion(
          contextMenuBuilder: (BuildContext context, Offset primaryAnchor, [Offset? secondaryAnchor]) {
            // The custom context menu will look like the default context menu
            // on the current platform, but it will have only a single 'Print'
            // button.
            return DefaultTextSelectionToolbar(
              primaryAnchor: primaryAnchor,
              secondaryAnchor: secondaryAnchor,
              buttonItems: <ContextMenuButtonItem>[
                ContextMenuButtonItem(
                  onPressed: () {
                    ContextMenuController.hide();
                    _showDialog(context);
                  },
                  label: 'Print',
                ),
              ],
            );
          },
          // In this case we're wrapping a big open space in a GestureDetector
          // in order to show the context menu, but we could also wrap a single
          // wiget like an Image to give it a context menu.
          child: ListView(
            children: <Widget>[
              Container(height: 20.0),
              const Text('Right click or long press anywhere to show the custom menu.'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows and hides the context menu based on user gestures.
///
/// By default, shows the menu on right clicks and long presses.
class _ContextMenuRegion extends StatefulWidget {
  /// Creates an instance of [_ContextMenuRegion].
  const _ContextMenuRegion({
    required this.child,
    required this.contextMenuBuilder,
  });

  /// Builds the context menu.
  final ContextMenuBuilder contextMenuBuilder;

  /// The child widget that will be listened to for gestures.
  final Widget child;

  @override
  State<_ContextMenuRegion> createState() => _ContextMenuRegionState();
}

class _ContextMenuRegionState extends State<_ContextMenuRegion> {
  Offset? _longPressOffset;

  static bool get _longPressEnabled {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  void _onSecondaryTapUp(TapUpDetails details) {
    _show(details.globalPosition);
  }

  void _onTap() {
    if (!ContextMenuController.isShown) {
      return;
    }
    _hide();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _longPressOffset = details.globalPosition;
  }

  void _onLongPress() {
    assert(_longPressOffset != null);
    _show(_longPressOffset!);
    _longPressOffset = null;
  }

  void _show(Offset position) {
    ContextMenuController.show(
      context: context,
      contextMenuBuilder: (BuildContext context) {
        return widget.contextMenuBuilder(context, position);
      },
    );
  }

  void _hide() {
    ContextMenuController.hide();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapUp: _onSecondaryTapUp,
      onTap: _onTap,
      onLongPress: _longPressEnabled ? _onLongPress : null,
      onLongPressStart: _longPressEnabled ? _onLongPressStart : null,
      child: widget.child,
    );
  }
}
