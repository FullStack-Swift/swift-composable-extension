public protocol ComposableStateKey {
  associatedtype Value
  static var defaultValue: Self.Value { get }
}
