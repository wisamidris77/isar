part of '../../isar.dart';

/// {@template isar_embedded}
/// Annotation to nest objects of this type in collections.
/// {@endtemplate}
const embedded = Embedded();

/// {@macro isar_embedded}
@Target({TargetKind.classType})
class Embedded {
  /// {@macro isar_embedded}
  const Embedded({this.inheritance = true, this.ignore = const {}, this.generationType = EmbeddedGenerationType.none});

  /// Should properties and accessors of parent classes and mixins be included?
  final bool inheritance;

  /// A list of properties or getter names that Isar should ignore.
  final Set<String> ignore;

  /// The type of generation to use for the embedded object.
  final int generationType;
}


/// Collection of constants to indicate which embedded generation types to use
/// for a specific class.
///
/// {@category Configuration}
class EmbeddedGenerationType {
  /// Indicates to generate all embedded methods.
  static const all = 0x1;
  /// Indicates to generate filter methods for embedded objects.
  static const filters = 0x2;
  /// Indicates to generate query objects methods for embedded objects.
  static const queryObjects = 0x4;
  /// Indicates to generate no embedded methods.
  static const none = 0x0;

  static List<int> get values => [all, filters, queryObjects, none];
}