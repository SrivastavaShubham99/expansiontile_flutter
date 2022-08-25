

import 'package:flutter/material.dart';

class ScreenWithLoader extends StatefulWidget {
  final bool? isLoading;
  Color color;
  final Widget? body;

  ScreenWithLoader({this.isLoading, this.body, this.color = Colors.white38});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScreenWithLoader> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: widget.body,
        ),
        Visibility(
          visible: widget.isLoading!,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: widget.color,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                   CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
