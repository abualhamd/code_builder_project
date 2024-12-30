import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

void main() {
  generateState([
    {
      "name": "processing",
      "allowedStates": ["picked"]
    },
    {
      "name": "picked",
      "allowedStates": ["onItsWay"]
    },
    {
      "name": "onItsWay",
      "allowedStates": ["delivered"]
    },
    {"name": "delivered", "allowedStates": []},
  ]);
}

void generateState(List<Map<String, dynamic>> states) {
  final emitter = DartEmitter();

  final orderStatusEnum = Enum(
    (enumBuilder) => enumBuilder
      ..name = "OrderStatus"
      ..constructors.add(
        Constructor((constructorBuilder) => constructorBuilder
          ..constant = true
          ..optionalParameters
              .add(Parameter((parameterBuilder) => parameterBuilder
                ..name = 'allowedStates'
                ..type = refer('List<OrderStatus>')
                ..named = true
                ..required = true))),
      )
      ..values.addAll(
        states
            .map(
              (state) => EnumValue(
                (enumValueBuilder) => enumValueBuilder
                  ..name = state['name']
                  ..namedArguments.addAll(
                    {
                      'allowedStates': refer(
                        '[${state['allowedStates'].join(',')}]',
                      ),
                    },
                  ),
              ),
            )
            .toList(),
        // [
        //   EnumValue(
        //     (enumValueBuilder) => enumValueBuilder
        //       ..name = "processing"
        //       ..namedArguments.addAll(
        //         {'allowedStates': refer('[picked]')},
        //       ),
        //   ),
        //   EnumValue(
        //     (enumValueBuilder) => enumValueBuilder
        //       ..name = "picked"
        //       ..namedArguments.addAll(
        //         {'allowedStates': refer('[onItsWay]')},
        //       ),
        //   ),
        //   EnumValue((enumValueBuilder) => enumValueBuilder
        //     ..name = "onItsWay"
        //     ..namedArguments.addAll(
        //       {'allowedStates': refer('[delivered]')},
        //     )),
        //   EnumValue((enumValueBuilder) => enumValueBuilder
        //     ..name = "delivered"
        //     ..namedArguments.addAll(
        //       {'allowedStates': refer('[]')},
        //     )),
        // ],
      ),
  );

  final dartCode =
      DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
          .format('${orderStatusEnum.accept(emitter)}');
  print(dartCode);

  final file = File("lib/dummy.dart")..createSync();

  file.writeAsString(dartCode);
}
