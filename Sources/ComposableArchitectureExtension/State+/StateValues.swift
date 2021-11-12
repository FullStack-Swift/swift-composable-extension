import Foundation

public struct ComposableStorageValues {
  
  var values: [ObjectIdentifier: Any]
  
  public init() {
    self.values = [:]
  }
  
  
  public mutating func removeAll() {
    self.values.removeAll()
  }
  
  public subscript<Key>(_ key: Key.Type) -> Key.Value where Key: ComposableStateKey {
    get {self.get(Key.self)}
    set {self.set(Key.self, to: newValue)}
  }
  
  public func contains<Key>(_ key: Key.Type) -> Bool {
    self.values.keys.contains(ObjectIdentifier(Key.self))
  }
  
  public func get<Key>(_ key: Key.Type) -> Key.Value where Key: ComposableStateKey {
    values[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue
  }
  
  public mutating func set<Key>(_ key: Key.Type, to value: Key.Value?) where Key: ComposableStateKey {
    values[ObjectIdentifier(key)] = value
  }
}

import ComposableArchitecture

@dynamicMemberLookup
@propertyWrapper
public struct SharedState<Value> {
  
  public var wrappedValue: Value {
    get {ComposableStoreState[dynamicMember: keyPath]}
    set {ComposableStoreState[dynamicMember: keyPath] = newValue}
  }
  
  var keyPath: WritableKeyPath<ComposableStorageValues, Value>!
  
  init(keyPath: WritableKeyPath<ComposableStorageValues, Value>) {
    self.keyPath = keyPath
  }
  
  public var projectedValue: Value {
    wrappedValue
  }
  
  public subscript<V>(dynamicMember keyPath: WritableKeyPath<Value, V>) -> SharedState<V> {
    get { .init(keyPath: self.keyPath.appending(path: keyPath)) }
    set { wrappedValue[keyPath: keyPath] = newValue.wrappedValue }
  }
}

extension SharedState: Equatable where Value: Equatable {}

extension SharedState: Hashable where Value: Hashable {}

extension SharedState: Decodable where Value: Decodable {
  public init(from decoder: Decoder) throws {
    do {
      let container = try decoder.singleValueContainer()
      ComposableStoreState[dynamicMember: keyPath] = try container.decode(Value.self)
    } catch {
      ComposableStoreState[dynamicMember: keyPath] = try Value(from: decoder)
    }
  }
}

extension SharedState: Encodable where Value: Encodable {
  public func encode(to encoder: Encoder) throws {
    do {
      var container = encoder.singleValueContainer()
      try container.encode(self.wrappedValue)
    } catch {
      try self.wrappedValue.encode(to: encoder)
    }
  }
}

extension SharedState: CustomReflectable {
  public var customMirror: Mirror {
    Mirror(reflecting: self.wrappedValue)
  }
}

extension SharedState: CustomDumpRepresentable {
  public var customDumpValue: Any {
    self.wrappedValue
  }
}

extension SharedState: CustomDebugStringConvertible where Value: CustomDebugStringConvertible {
  public var debugDescription: String {
    self.wrappedValue.debugDescription
  }
}
