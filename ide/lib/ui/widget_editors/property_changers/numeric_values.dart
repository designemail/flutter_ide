import 'package:flutter/material.dart';
import 'package:flutter_desktop_widgets/desktop/hover/cursor_widget.dart';
import 'package:flutter_desktop_widgets/desktop/hover/hoverable_element.dart';

class NumericChangeableTextField extends StatefulWidget {
  NumericChangeableTextField({Key key, this.name, this.onUpdate}) : super(key: key);

  final String name;

  final ValueChanged<double> onUpdate;

  @override
  NumericChangeableTextFieldState createState() {
    return new NumericChangeableTextFieldState();
  }
}

class NumericChangeableTextFieldState extends State<NumericChangeableTextField> {
  final TextEditingController textEditingController = TextEditingController(text: "0");


  bool dragging = false;
  bool hovering = false;

  double stringToNumber(String value) {
    return double.tryParse(value);
  }

  void update(String value) {
    var val = stringToNumber(value);
    if (val != null) {
      widget.onUpdate(val);
    }
  }

  void onDragUpdate(DragUpdateDetails update) {
    var number = stringToNumber(textEditingController.text);
    var newNumber = 0.0;
    if (number != null) newNumber = number;

    newNumber += update.primaryDelta * -1;
    widget.onUpdate(newNumber);
    textEditingController.text = newNumber.toString();
  }

  void setCursor() {
    CursorManager.instance.setCursor(CursorType.ResizeY);
  }
  void resetCursor() {
    if(!dragging && !hovering) CursorManager.instance.resetCursor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onVerticalDragUpdate: onDragUpdate,
          onVerticalDragStart: (_) {
            dragging = true;
            setCursor();
          },
          onVerticalDragCancel: () {
            dragging = false;
            resetCursor();
          },
          onVerticalDragEnd: (_) {
            dragging = false;
            resetCursor();
          },
          child: HoveringBuilder(
            onHoverStart: (it) {
              hovering = true;
              setCursor();
            } ,
            onHoverEnd: () {
              hovering = false;
              resetCursor();
            },
            builder: (context, hovering) {
              return SizedBox(
                width: 40,
                child: TextField(controller: textEditingController, onSubmitted: update),
              );
            },
          ),
        ),
        Text(widget.name)
      ],
    );
  }
}

class ChangeableSize extends StatelessWidget {

  const ChangeableSize({Key key, this.onWidthChange, this.onHeightChange}) : super(key: key);

  final ValueChanged<double> onWidthChange;
  final ValueChanged<double> onHeightChange;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Size")),
        Expanded(
          child: NumericChangeableTextField(
            name: "Width",
            onUpdate: onWidthChange,
          ),
        ),
       Expanded(
         child: NumericChangeableTextField(
           name: "Height",
           onUpdate: onHeightChange,
         ),
       ),
      ],
    );
  }
}

class ChangeableConstraints extends StatelessWidget {

  const ChangeableConstraints({Key key, this.onMinWidthChange, this.onMaxWidgetChange, this.onMinHeightChange, this.onMaxHeightChange}) : super(key: key);

  final ValueChanged<double> onMinWidthChange;
  final ValueChanged<double> onMaxWidgetChange;
  final ValueChanged<double> onMinHeightChange;
  final ValueChanged<double> onMaxHeightChange;


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
