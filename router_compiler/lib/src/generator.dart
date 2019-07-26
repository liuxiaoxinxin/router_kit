import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:router_annotation/router_annotation.dart';
import 'package:router_compiler/src/info/info.dart';
import 'package:router_compiler/src/instantiater/instantiater.dart';
import 'package:router_compiler/src/util/exceptions.dart';
import 'package:source_gen/source_gen.dart';

final Logger _log = Logger("JaguarSerializer");

class RouterCompilerGenerator extends GeneratorForAnnotation<Component> {
  static const String _onlyClassMsg =
      "Component annotation can only be defined on a class.";

  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) throw RouterCompilerException(_onlyClassMsg);

    try {
      SerializerInfo info =
          AnnotationParser.parse(element as ClassElement, annotation);

      // TODO check info validity
      // for example valueFromConstructor == true && isNullable == false is not possible

//      final writer = Writer(info);
//
//      writer.generate();
//      return writer.toString();
      return null;
    } on Exception catch (e, s) {
      _log.severe(e);
      _log.severe(s);
      return "// $e \n\n";
    }
  }
}

Builder routerCompilerBuilder({String header}) => PartBuilder(
      [RouterCompilerGenerator()],
      '.route.dart',
      header: header,
    );
