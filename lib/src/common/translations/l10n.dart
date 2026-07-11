// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Something went wrong\nPleaseTry again later.`
  String get someThingWentWrongDesc {
    return Intl.message(
      'Something went wrong\\nPleaseTry again later.',
      name: 'someThingWentWrongDesc',
      desc: '',
      args: [],
    );
  }

  /// `No Internet connection\nHurry up! get wifi`
  String get noInternetConnectionDesc {
    return Intl.message(
      'No Internet connection\\nHurry up! get wifi',
      name: 'noInternetConnectionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again`
  String get errorUndefinedErrorhappened {
    return Intl.message(
      'Something went wrong. Please try again',
      name: 'errorUndefinedErrorhappened',
      desc: '',
      args: [],
    );
  }

  /// `Request to the server was cancelled.`
  String get requestCancelled {
    return Intl.message(
      'Request to the server was cancelled.',
      name: 'requestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out.`
  String get connectionTimedOut {
    return Intl.message(
      'Connection timed out.',
      name: 'connectionTimedOut',
      desc: '',
      args: [],
    );
  }

  /// `Receiving timeout occurred.`
  String get receivingTimeout {
    return Intl.message(
      'Receiving timeout occurred.',
      name: 'receivingTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request send timeout.`
  String get requestTimeout {
    return Intl.message(
      'Request send timeout.',
      name: 'requestTimeout',
      desc: '',
      args: [],
    );
  }

  /// `No Internet.`
  String get noInternet {
    return Intl.message('No Internet.', name: 'noInternet', desc: '', args: []);
  }

  /// `Unexpected error occurred.`
  String get unexpectedError {
    return Intl.message(
      'Unexpected error occurred.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get somethingWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `Bad request.`
  String get badRequest {
    return Intl.message('Bad request.', name: 'badRequest', desc: '', args: []);
  }

  /// `Authentication failed.`
  String get authenticationFailed {
    return Intl.message(
      'Authentication failed.',
      name: 'authenticationFailed',
      desc: '',
      args: [],
    );
  }

  /// `The authenticated user is not allowed to access the specified API endpoint.`
  String get authenticatedUserNotAllowed {
    return Intl.message(
      'The authenticated user is not allowed to access the specified API endpoint.',
      name: 'authenticatedUserNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `The requested resource does not exist.`
  String get resourceNotExist {
    return Intl.message(
      'The requested resource does not exist.',
      name: 'resourceNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Method not allowed. Please check the Allow header for the allowed HTTP methods.`
  String get methodNotAllowed {
    return Intl.message(
      'Method not allowed. Please check the Allow header for the allowed HTTP methods.',
      name: 'methodNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported media type. The requested content type or version number is invalid.`
  String get unsupportedMediaType {
    return Intl.message(
      'Unsupported media type. The requested content type or version number is invalid.',
      name: 'unsupportedMediaType',
      desc: '',
      args: [],
    );
  }

  /// `Data validation failed.`
  String get dataValidationFailed {
    return Intl.message(
      'Data validation failed.',
      name: 'dataValidationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests.`
  String get tooManyRequests {
    return Intl.message(
      'Too many requests.',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error.`
  String get internalServerError {
    return Intl.message(
      'Internal server error.',
      name: 'internalServerError',
      desc: '',
      args: [],
    );
  }

  /// `Oops something went wrong!`
  String get oopsSomethingWrong {
    return Intl.message(
      'Oops something went wrong!',
      name: 'oopsSomethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `Haya Pay`
  String get appTitle {
    return Intl.message('Haya Pay', name: 'appTitle', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
