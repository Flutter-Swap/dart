// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

sealed class SwapResult {
  const SwapResult();
}

class SwapResultLoading extends SwapResult {
  const SwapResultLoading();
  @override
  bool operator ==(covariant SwapResultLoading other) {
    return true;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class SwapResultSuccess extends SwapResult {
  const SwapResultSuccess(this.newChild);
  final Widget newChild;

  @override
  bool operator ==(covariant SwapResultSuccess other) {
    if (identical(this, other)) return true;

    return other.newChild == newChild;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ newChild.hashCode;
}

class SwapResultFailed extends SwapResult {
  const SwapResultFailed(
    this.error, {
    this.stackTrace,
  });
  final dynamic error;
  final StackTrace? stackTrace;

  @override
  bool operator ==(covariant SwapResultFailed other) {
    if (identical(this, other)) return true;

    return other.error == error;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ error.hashCode;
}
