import Foundation

public let ComposableStoreState = ComposableState.shared

@dynamicMemberLookup
public final class ComposableState {
  
  public var composableStorageValues: ComposableStorageValues
  
  static let shared = ComposableState()
  
  private init() {
    self.composableStorageValues = ComposableStorageValues()
  }
  
  public subscript<Value>(keyPath: WritableKeyPath<ComposableStorageValues, Value>) -> Value {
    get { composableStorageValues[keyPath: keyPath] }
    set { composableStorageValues[keyPath: keyPath] = newValue }
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<ComposableStorageValues, Value>) -> Value {
    get { composableStorageValues[keyPath: keyPath] }
    
    set { composableStorageValues[keyPath: keyPath] = newValue }
  }
  
  @discardableResult
  public func set<Value>(_ keyPath: WritableKeyPath<ComposableStorageValues, Value>, value: Value) -> Self {
    composableStorageValues[keyPath: keyPath] = value
    return self
  }
  
  @discardableResult
  public func get<Value>(_ keyPath: WritableKeyPath<ComposableStorageValues, Value>) -> Value {
    composableStorageValues[keyPath: keyPath]
  }
}
