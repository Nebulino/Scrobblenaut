//                                                              //
// Scrobblenaut - A deadly simple Last.FM API Wrapper for Dart. //
//                  Copyright (c) 2020 Nebulino                 //
//                                                              //

import 'package:dio/dio.dart';
import 'package:scrobblenaut/src/helpers/utils.dart';
import 'package:xml/xml.dart' as xml;

/// It implements [DioException] class.
/// You can find [description] that gives a brief information of what happened.
class LastFMException extends DioException {
  final int _errorCode;
  final String _description;

  int get errorCode => _errorCode;
  String get description => _description;

  LastFMException._(
    this._errorCode,
    this._description, [
    RequestOptions? requestOptions,
  ]) : super(requestOptions: requestOptions ?? RequestOptions(path: ''));

  LastFMException({
    required String errorCode,
    required String description,
    RequestOptions? requestOptions,
  }) : this._(int.parse(errorCode), description, requestOptions);

  factory LastFMException.generate(
    dynamic errorObject, {
    RequestOptions? requestOptions,
  }) {
    if (isXml(errorObject.toString())) {
      // Is a XML
      final xmlError = xml.XmlDocument.parse(errorObject);

      final failedNode = xmlError.children.firstWhere(
        (xmlNode) => xmlNode.getAttribute('status') == 'failed',
      );

      // Needed because lastFM is inconsistent even in errors...
      final errorNode = failedNode.children.firstWhere(
        (xmlNode) => xmlNode.getAttribute('code') != null,
      );

      return LastFMException(
        errorCode: errorNode.getAttribute('code') ?? '',
        description: errorNode.innerText,
        requestOptions: requestOptions,
      );
    } else {
      // Else is a Json...
      return LastFMException(
        errorCode: errorObject['error'].toString(),
        description: errorObject['message']?.toString() ?? '',
        requestOptions: requestOptions,
      );
    }
  }

  @override
  String toString() => '[LastFMException] => [Code $_errorCode]: $_description';
}
