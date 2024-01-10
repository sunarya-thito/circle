import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ValueBuilder<T> on ValueListenable<T> {
  Widget build(Widget Function(BuildContext context, T value) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) => builder(context, value),
    );
  }

  Widget buildWithChild(Widget child,
      Widget Function(BuildContext context, T value, Widget child) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (context, value, child) => builder(context, value, child!),
      child: child,
    );
  }
}

extension TextBuilder on Object {
  Widget small(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: widget,
      );
    });
  }

  Widget medium(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: widget,
      );
    });
  }

  Widget large(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyLarge!,
        child: widget,
      );
    });
  }

  Widget titleLarge(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        child: widget,
      );
    });
  }

  Widget titleMedium(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.titleMedium!,
        child: widget,
      );
    });
  }

  Widget titleSmall(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.titleSmall!,
        child: widget,
      );
    });
  }

  Widget headlineLarge(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineLarge!,
        child: widget,
      );
    });
  }

  Widget headlineMedium(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineMedium!,
        child: widget,
      );
    });
  }

  Widget headlineSmall(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineSmall!,
        child: widget,
      );
    });
  }

  Widget labelLarge(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.labelLarge!,
        child: widget,
      );
    });
  }

  Widget labelMedium(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.labelMedium!,
        child: widget,
      );
    });
  }

  Widget labelSmall(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.labelSmall!,
        child: widget,
      );
    });
  }

  Widget displayLarge(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayLarge!,
        child: widget,
      );
    });
  }

  Widget displayMedium(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        child: widget,
      );
    });
  }

  Widget displaySmall(Widget widget) {
    return Builder(builder: (context) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.displaySmall!,
        child: widget,
      );
    });
  }
}
