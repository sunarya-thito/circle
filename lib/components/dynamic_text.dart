import 'package:flutter/material.dart';

class DynamicText<T> extends StatefulWidget {
  final ValueNotifier<T>? value;
  final String Function(T value)? formatter;

  const DynamicText({
    Key? key,
    this.value,
    this.formatter,
  }) : super(key: key);

  @override
  _DynamicTextState<T> createState() => _DynamicTextState<T>();
}

class _DynamicTextState<T> extends State<DynamicText<T>> {
  @override
  void initState() {
    super.initState();
    widget.value?.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant DynamicText<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      oldWidget.value?.removeListener(_onValueChanged);
      widget.value?.addListener(_onValueChanged);
    }
  }

  void _onValueChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.value?.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == null) {
      return SizedBox();
    }
    return ValueListenableBuilder<T>(
      valueListenable: widget.value!,
      builder: (context, value, child) {
        return Text(
          widget.formatter?.call(value) ?? value.toString(),
        );
      },
    );
  }
}
