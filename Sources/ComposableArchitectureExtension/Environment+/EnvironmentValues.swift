import Foundation

public struct ComposableEnvironmentValues {
  
  var values = [ObjectIdentifier: DependencyType]()
  
  public subscript<T>(_ key: T.Type) -> T.Value where T: ComposableEnvironmentKey {
    get { get(key) }
    set { set(key,to: newValue) }
  }
  
  public func get<Key>(_ key: Key.Type) -> Key.Value where Key: ComposableEnvironmentKey {
    values[ObjectIdentifier(key)]?.value as? Key.Value ?? key.defaultValue
  }
  
  public mutating func set<Key>(_ key: Key.Type, to value: Key.Value) where Key: ComposableEnvironmentKey {
    values[ObjectIdentifier(key)] = .defined(value)
  }
  
  public func contains<Key>(_ key: Key.Type) -> Bool {
    self.values.keys.contains(ObjectIdentifier(Key.self))
  }
  
  public mutating func removeAll() {
    self.values.removeAll()
  }
  
  public mutating func mergeFromParentComposableEnvironmentValues(_ parentComposableEnvironmentValues: ComposableEnvironmentValues) {
    for (key, value) in parentComposableEnvironmentValues.values {
      guard values[key]?.isDefined != true else { continue }
      values[key] = value.inherit()
    }
  }
  
}

internal enum DependencyType {
  case defined(Any)
  case inherited(Any)
  
  var value: Any {
    switch self {
    case let .defined(value): return value
    case let .inherited(value): return value
    }
  }
  
  func inherit() -> DependencyType {
    switch self {
    case let .defined(value): return .inherited(value)
    case .inherited: return self
    }
  }
  
  var isDefined: Bool {
    switch self {
    case .defined: return true
    case .inherited: return false
    }
  }
}
