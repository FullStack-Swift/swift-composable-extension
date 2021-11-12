public protocol ComposableEnvironmentKey {
  associatedtype Value
  static var defaultValue: Self.Value { get }
}
