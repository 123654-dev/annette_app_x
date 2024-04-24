import 'package:annette_app_x/models/error_types.dart';
import 'package:annette_app_x/utilities/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorFactory {
  static final ErrorFactory _instance = ErrorFactory._internal();

  factory ErrorFactory() {
    return _instance;
  }

  ErrorFactory._internal();

  static Error createError(ErrorType type, String message) {
    switch (type) {
      case ErrorType.internalError:
        return InternalError(message: message);
      case ErrorType.internalWarning:
        return InternalWarning(message: message);
      case ErrorType.externalError:
        return ExternalError(message: message);
      case ErrorType.externalWarning:
        return ExternalWarning(message: message);
      case ErrorType.hiddenError:
        return HiddenError(message: message);
      default:
        return InternalError(message: message);
    }
  }
}

class Error {
  final String message;
  final ErrorType type;
  final double duration;
  late bool showToUser;
  late bool writeToLog;
  late Color backgroundColor = Colors.white;
  late Icon errorIcon = const Icon(
            Icons.warning_rounded,
            color: Colors.white,
          );

  Error(this.message, this.type, {this.duration = 3.0}){
    _showError();
  }

  void _showError() {
    if(!showToUser) return;
    
    final snackBar = SnackBar(
      duration: Duration(seconds: duration.floor(), milliseconds: ((duration - duration.floor()) * 1000).floor()),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          errorIcon,
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Text(message, style: const TextStyle(fontSize: 17)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    );
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class InternalError extends Error {
  InternalError({String message = "", ErrorType type = ErrorType.internalError}) : super(message, type);

  @override
  bool get showToUser => false;
  @override
  bool get writeToLog => true;
}

class InternalWarning extends Error {
  InternalWarning({String message = "", ErrorType type = ErrorType.internalWarning}) : super(message, type);

  @override
  bool get showToUser => false;
  @override
  bool get writeToLog => true;
}

class ExternalError extends Error {
  ExternalError({String message = "", ErrorType type = ErrorType.externalError}) : super(message, type);

  @override
  bool get showToUser => true;
  @override
  bool get writeToLog => true;
  @override
  Color get backgroundColor => Colors.redAccent;
  @override
  Icon get errorIcon => const Icon(
            Icons.report_rounded,
            color: Colors.white,
          );
}

class ExternalWarning extends Error {
  ExternalWarning({String message = "", ErrorType type = ErrorType.externalWarning}) : super(message, type);

  @override
  bool get showToUser => true;
  @override
  bool get writeToLog => true;
  @override
  Color get backgroundColor => Colors.orangeAccent;
}

class HiddenError extends Error {
  HiddenError({String message = "", ErrorType type = ErrorType.hiddenError}) : super(message, type);

  @override
  bool get showToUser => false;
  @override
  bool get writeToLog => false;
}
