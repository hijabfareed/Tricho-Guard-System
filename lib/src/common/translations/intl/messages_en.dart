// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appTitle": MessageLookupByLibrary.simpleMessage("Haya Pay"),
    "authenticatedUserNotAllowed": MessageLookupByLibrary.simpleMessage(
      "The authenticated user is not allowed to access the specified API endpoint.",
    ),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Authentication failed.",
    ),
    "badRequest": MessageLookupByLibrary.simpleMessage("Bad request."),
    "connectionTimedOut": MessageLookupByLibrary.simpleMessage(
      "Connection timed out.",
    ),
    "dataValidationFailed": MessageLookupByLibrary.simpleMessage(
      "Data validation failed.",
    ),
    "errorUndefinedErrorhappened": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again",
    ),
    "internalServerError": MessageLookupByLibrary.simpleMessage(
      "Internal server error.",
    ),
    "methodNotAllowed": MessageLookupByLibrary.simpleMessage(
      "Method not allowed. Please check the Allow header for the allowed HTTP methods.",
    ),
    "noInternet": MessageLookupByLibrary.simpleMessage("No Internet."),
    "noInternetConnectionDesc": MessageLookupByLibrary.simpleMessage(
      "No Internet connection\\nHurry up! get wifi",
    ),
    "oopsSomethingWrong": MessageLookupByLibrary.simpleMessage(
      "Oops something went wrong!",
    ),
    "receivingTimeout": MessageLookupByLibrary.simpleMessage(
      "Receiving timeout occurred.",
    ),
    "requestCancelled": MessageLookupByLibrary.simpleMessage(
      "Request to the server was cancelled.",
    ),
    "requestTimeout": MessageLookupByLibrary.simpleMessage(
      "Request send timeout.",
    ),
    "resourceNotExist": MessageLookupByLibrary.simpleMessage(
      "The requested resource does not exist.",
    ),
    "someThingWentWrongDesc": MessageLookupByLibrary.simpleMessage(
      "Something went wrong\\nPleaseTry again later.",
    ),
    "somethingWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "tooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many requests.",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "Unexpected error occurred.",
    ),
    "unsupportedMediaType": MessageLookupByLibrary.simpleMessage(
      "Unsupported media type. The requested content type or version number is invalid.",
    ),
  };
}
