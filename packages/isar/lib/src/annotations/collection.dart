part of '../../isar.dart';

/// {@template isar_collection}
/// Annotation to create an Isar collection.
/// {@endtemplate}
const collection = Collection();

/// {@macro isar_collection}
@Target({TargetKind.classType})
class Collection {
  /// {@macro isar_collection}
  const Collection({
    this.inheritance = true,
    this.accessor,
    this.ignore = const {'copyWith'},
    this.generationType = CollectionGenerationType.none,
  });

  /// Should properties and accessors of parent classes and mixins be included?
  final bool inheritance;

  /// Allows you to override the default collection accessor.
  ///
  /// Example:
  /// ```dart
  /// @Collection(accessor: 'col')
  /// class MyCol {
  ///   late int id;
  /// }
  ///
  /// // access collection:
  /// isar.col.where().findAll();
  /// ```
  final String? accessor;

  /// A list of properties or getter names that Isar should ignore.
  final Set<String> ignore;

  /// The type of generation to use for the collection.
  final int generationType;
}
/// Collection of constants to indicate which collection generation types to use
/// for a specific class.
///
/// {@category Configuration}
class CollectionGenerationType {
  /// Indicates to generate all collection methods.
  static const all = 0x1;
  /// Indicates to generate filter methods.
  static const filters = 0x2;
  /// Indicates to generate query objects methods.
  static const queryObjects = 0x4;
  /// Indicates to generate sort by methods.
  static const sortBy = 0x8;
  /// Indicates to generate distinct by methods.
  static const distinctBy = 0x10;
  /// Indicates to generate property query methods.
  static const propertyQuery = 0x20;
  /// Indicates to generate no collection methods.
  static const none = 0x0;

  static List<int> get values => [all, filters, queryObjects, sortBy, distinctBy, propertyQuery, none];
}