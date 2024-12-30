import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

void main() {
  final animal = Class(
    (classBuilder) => classBuilder
      ..name = 'TestClass'
      // ..implements = ListBuilder()
      // ..extend = refer('Organism')
      ..methods.add(
        Method.returnsVoid(
          (methodBuilder) => methodBuilder
            ..name = 'greeting'
            ..body = const Code("print('Hello, World!');"),
        ),
      ),
  );
  final emitter = DartEmitter();

  final dartCode =
      DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
          .format('${animal.accept(emitter)}');
  print(dartCode);

  final file = File("lib/dummy.dart")..createSync();

  file.writeAsString(dartCode);
}
