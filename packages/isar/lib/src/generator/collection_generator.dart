// Allow the use of deprecated members during the transition period.
// TODO(sergiyvoloshyn): Remove these ignores once the code is updated.
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package

part of 'isar_generator.dart';

const _ignoreLints = [
  'duplicate_ignore',
  'invalid_use_of_protected_member',
  'lines_longer_than_80_chars',
  'constant_identifier_names',
  'avoid_js_rounded_ints',
  'no_leading_underscores_for_local_identifiers',
  'require_trailing_commas',
  'unnecessary_parenthesis',
  'unnecessary_raw_strings',
  'unnecessary_null_in_if_null_operators',
  'library_private_types_in_public_api',
  'prefer_const_constructors',
];

class _IsarCollectionGenerator extends GeneratorForAnnotation<Collection> {
  @override
  Future<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final object = _IsarAnalyzer().analyzeCollection(element);
    final idType =
        object.idProperty!.type == IsarType.string ? 'String' : 'int';
    final generationType = annotation.read('generationType').intValue;
    final generationTypeFlags = CollectionGenerationType.values.where((e) => e & generationType != 0).toList();
    return '''
      // coverage:ignore-file
      // ignore_for_file: ${_ignoreLints.join(', ')}
      // ignore_for_file: type=lint

      extension Get${object.dartName}Collection on Isar {
        IsarCollection<$idType, ${object.dartName}> get ${object.accessor} => this.collection();
      }

      ${_generateSchema(object)}

      ${_generateSerialize(object)}

      ${_generateDeserialize(object)}

      ${_generateDeserializeProp(object)}

      ${_generateUpdate(object)}

      ${_generateEnumMaps(object)}

      ${generationTypeFlags.contains(CollectionGenerationType.filters) || generationTypeFlags.contains(CollectionGenerationType.all) ? _FilterGenerator(object).generate() : ''}

      ${generationTypeFlags.contains(CollectionGenerationType.queryObjects) || generationTypeFlags.contains(CollectionGenerationType.all) ? _generateQueryObjects(object) : ''}

      ${generationTypeFlags.contains(CollectionGenerationType.sortBy) || generationTypeFlags.contains(CollectionGenerationType.all) ? _generateSortBy(object) : ''}

      ${generationTypeFlags.contains(CollectionGenerationType.distinctBy) || generationTypeFlags.contains(CollectionGenerationType.all) ? _generateDistinctBy(object) : ''}
      
      ${generationTypeFlags.contains(CollectionGenerationType.propertyQuery) || generationTypeFlags.contains(CollectionGenerationType.all) ? _generatePropertyQuery(object) : ''}
    ''';
  }
}

class _IsarEmbeddedGenerator extends GeneratorForAnnotation<Embedded> {
  @override
  Future<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final object = _IsarAnalyzer().analyzeEmbedded(element);
    final generationType = annotation.read('generationType').intValue;
    final generationTypeFlags = EmbeddedGenerationType.values.where((e) => e & generationType != 0).toList();
    return '''
      // coverage:ignore-file
      // ignore_for_file: ${_ignoreLints.join(', ')}
      // ignore_for_file: type=lint

      ${_generateSchema(object)}

      ${_generateSerialize(object)}

      ${_generateDeserialize(object)}

      ${_generateEnumMaps(object)}

      ${generationTypeFlags.contains(EmbeddedGenerationType.filters) || generationTypeFlags.contains(EmbeddedGenerationType.all) ? _FilterGenerator(object).generate() : ''}

      ${generationTypeFlags.contains(EmbeddedGenerationType.queryObjects) || generationTypeFlags.contains(EmbeddedGenerationType.all) ? _generateQueryObjects(object) : ''}
    ''';
  }
}
