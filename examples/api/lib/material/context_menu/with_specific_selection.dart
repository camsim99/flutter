// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This example demonstrates showing a custom context menu only when some
// narrowly defined text is selected.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final TextEditingController _controller = TextEditingController(
    text: 'Select the email address and open the menu: me@example.com',
  );

  void _showDialog (BuildContext context) {
    Navigator.of(context).push(
      DialogRoute<void>(
        context: context,
        builder: (BuildContext context) =>
          const AlertDialog(title: Text('You clicked send email!')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom button for emails'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(height: 20.0),
              TextField(
                controller: _controller,
                contextMenuBuilder: (BuildContext context, EditableTextState editableTextState, Offset primaryAnchor, [Offset? secondaryAnchor]) {
                  // Here we add an "Email" button to the default TextField
                  // context menu for the current platform, but only if an email
                  // address is currently selected.
                  return EditableTextContextMenuButtonItemsBuilder(
                    editableTextState: editableTextState,
                    builder: (BuildContext context, List<ContextMenuButtonItem> buttonItems) {
                      final TextEditingValue value = editableTextState.textEditingValue;
                      if (_isValidEmail(value.selection.textInside(value.text))) {
                        buttonItems.insert(0, ContextMenuButtonItem(
                          label: 'Send email',
                          onPressed: () {
                            ContextMenuController.hide();
                            _showDialog(context);
                          },
                        ));
                      }
                      return DefaultTextSelectionToolbar(
                        primaryAnchor: primaryAnchor,
                        secondaryAnchor: secondaryAnchor,
                        buttonItems: buttonItems,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isValidEmail(String text) {
  return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
    .hasMatch(text);
}
