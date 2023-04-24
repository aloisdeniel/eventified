library variant_generator.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

Builder eventifiedBuilder(BuilderOptions options) => SharedPartBuilder(
      [EventifiedGenerator()],
      'eventified',
    );
