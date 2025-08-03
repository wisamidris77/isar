// Allow the use of deprecated members during the transition period.
// TODO(sergiyvoloshyn): Remove this ignore once the code is updated.
// ignore_for_file: deprecated_member_use

part of 'isar_generator.dart';

const TypeChecker _collectionChecker = TypeChecker.fromRuntime(Collection);
const TypeChecker _embeddedChecker = TypeChecker.fromRuntime(Embedded);
const TypeChecker _enumPropertyChecker = TypeChecker.fromRuntime(EnumValue);
const TypeChecker _idChecker = TypeChecker.fromRuntime(Id);
const TypeChecker _ignoreChecker = TypeChecker.fromRuntime(Ignore);
const TypeChecker _nameChecker = TypeChecker.fromRuntime(Name);
const TypeChecker _indexChecker = TypeChecker.fromRuntime(Index);
const TypeChecker _utcChecker = TypeChecker.fromRuntime(Utc);

extension on ClassElement2 {
  List<PropertyInducingElement2> get allAccessors {
    final ignoreFields =
        collectionAnnotation?.ignore ?? embeddedAnnotation!.ignore;
    final allAccessorsMap = {
      if (collectionAnnotation?.inheritance ?? embeddedAnnotation!.inheritance)
        for (final supertype in allSupertypes) ...{
          if (!supertype.isDartCoreObject)
            for (final getter in supertype.getters)
              getter.variable3!.name3!: getter.variable3!,
          if (!supertype.isDartCoreObject)
            for (final setter in supertype.setters)
              setter.variable3!.name3!: setter.variable3!,
        },
      for (final getter in getters2)
        getter.variable3!.name3!: getter.variable3!,
      for (final setter in setters2)
        setter.variable3!.name3!: setter.variable3!,
    };
    final allAccessors = allAccessorsMap.values.toList();
    final usableAccessors = allAccessors.where(
      (e) =>
          e.isPublic &&
          !e.isStatic &&
          !_ignoreChecker.hasAnnotationOf(e.nonSynthetic2) &&
          !ignoreFields.contains(e.name3!) &&
          e.name3! != 'hashCode',
    );

    final uniqueAccessors = <String, PropertyInducingElement2>{};
    for (final accessor in usableAccessors) {
      uniqueAccessors[accessor.name3!] = accessor;
    }
    return uniqueAccessors.values.toList();
  }
}

extension on PropertyInducingElement2 {
  bool get hasIdAnnotation {
    final ann = _idChecker.firstAnnotationOfExact(nonSynthetic2);
    return ann != null;
  }

  bool get hasUtcAnnotation {
    final ann = _utcChecker.firstAnnotationOfExact(nonSynthetic2);
    return ann != null;
  }

  List<Index> get indexAnnotations {
    return _indexChecker.annotationsOfExact(nonSynthetic2).map((ann) {
      return Index(
        name: ann.getField('name')!.toStringValue(),
        composite:
            ann
                .getField('composite')!
                .toListValue()!
                .map((e) => e.toStringValue()!)
                .toList(),
        unique: ann.getField('unique')!.toBoolValue()!,
        hash: ann.getField('hash')!.toBoolValue()!,
      );
    }).toList();
  }
}

extension on EnumElement2 {
  FieldElement2? get enumValueProperty {
    final annotatedProperties =
        fields2
            .where((e) => !e.isEnumConstant)
            .where(_enumPropertyChecker.hasAnnotationOfExact)
            .toList();
    if (annotatedProperties.length > 1) {
      _err('Only one property can be annotated with @enumProperty', this);
    } else {
      return annotatedProperties.firstOrNull;
    }
  }
}

extension on Element2 {
  String get isarName {
    final ann = _nameChecker.firstAnnotationOfExact(nonSynthetic2);
    late String name;
    if (ann == null) {
      name = this.name3!;
    } else {
      name = ann.getField('name')!.toStringValue()!;
    }
    _checkIsarName(name, this);
    return name;
  }

  Collection? get collectionAnnotation {
    final ann = _collectionChecker.firstAnnotationOfExact(nonSynthetic2);
    if (ann == null) {
      return null;
    }
    return Collection(
      inheritance: ann.getField('inheritance')!.toBoolValue()!,
      accessor: ann.getField('accessor')!.toStringValue(),
      ignore:
          ann
              .getField('ignore')!
              .toSetValue()!
              .map((e) => e.toStringValue()!)
              .toSet(),
    );
  }

  String get collectionAccessor {
    var accessor = collectionAnnotation?.accessor;
    if (accessor != null) {
      return accessor;
    }

    accessor = displayName.decapitalize();
    if (!accessor.endsWith('s')) {
      accessor += 's';
    }

    return accessor;
  }

  Embedded? get embeddedAnnotation {
    final ann = _embeddedChecker.firstAnnotationOfExact(nonSynthetic2);
    if (ann == null) {
      return null;
    }
    return Embedded(
      inheritance: ann.getField('inheritance')!.toBoolValue()!,
      ignore:
          ann
              .getField('ignore')!
              .toSetValue()!
              .map((e) => e.toStringValue()!)
              .toSet(),
    );
  }
}

void _checkIsarName(String name, Element2 element) {
  if (name.isEmpty || name.startsWith('_')) {
    _err('Names must not be blank or start with "_".', element);
  }
}

Never _err(String msg, [Element2? element]) {
  throw InvalidGenerationSourceError(msg, element: element);
}

extension on String {
  String capitalize() {
    switch (length) {
      case 0:
        return this;
      case 1:
        return toUpperCase();
      default:
        return substring(0, 1).toUpperCase() + substring(1);
    }
  }

  String decapitalize() {
    switch (length) {
      case 0:
        return this;
      case 1:
        return toLowerCase();
      default:
        return substring(0, 1).toLowerCase() + substring(1);
    }
  }
}
