import 'package:flutter/material.dart';

class DataWidget<T> extends InheritedWidget {
  final T data;

  const DataWidget({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  static T of<T>(BuildContext context) {
    final DataWidget<T>? result =
        context.dependOnInheritedWidgetOfExactType<DataWidget<T>>();
    assert(result != null, 'No DataWidget<$T> found in context');
    return result!.data;
  }

  static T? maybeOf<T>(BuildContext context) {
    final DataWidget<T>? result =
        context.dependOnInheritedWidgetOfExactType<DataWidget<T>>();
    return result?.data;
  }

  @override
  bool updateShouldNotify(DataWidget<T> oldWidget) {
    return data != oldWidget.data;
  }
}

extension DataWidgetExtension on BuildContext {
  T of<T>() => DataWidget.of<T>(this);
  T? maybeOf<T>() => DataWidget.maybeOf<T>(this);
}
