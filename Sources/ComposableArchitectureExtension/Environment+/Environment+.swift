import Foundation

@dynamicMemberLookup
open class ComposableEnvironment {
  
  public required init() {}
  
  public var composableEnvironmentValues: ComposableEnvironmentValues = .init() {
    didSet {
      updateDependencyInheriteds.removeAllObjects()
    }
  }
  
  public var updateDependencyInheriteds: NSHashTable<ComposableEnvironment> = .weakObjects()
  
  @discardableResult
  public func mergeFromParentComposableEnvironment(_ parent: ComposableEnvironment) -> Self {
    if !parent.updateDependencyInheriteds.contains(self) {
      composableEnvironmentValues.mergeFromParentComposableEnvironmentValues(parent.composableEnvironmentValues)
      parent.updateDependencyInheriteds.add(self)
    }
    return self
  }
  
  public subscript<Value>(keyPath: WritableKeyPath<ComposableEnvironmentValues, Value>) -> Value {
    get { composableEnvironmentValues[keyPath: keyPath] }
    set { composableEnvironmentValues[keyPath: keyPath] = newValue }
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<ComposableEnvironmentValues, Value>) -> Value {
    get { composableEnvironmentValues[keyPath: keyPath] }
    set { composableEnvironmentValues[keyPath: keyPath] = newValue }
  }
  
  @discardableResult
  public func set<Value>(_ keyPath: WritableKeyPath<ComposableEnvironmentValues, Value>, value: Value) -> Self {
    composableEnvironmentValues[keyPath: keyPath] = value
    return self
  }
  
  @discardableResult
  public func get<Value>(_ keyPath: WritableKeyPath<ComposableEnvironmentValues, Value>) -> Value {
    composableEnvironmentValues[keyPath: keyPath]
  }
  
}

@propertyWrapper
public struct DependencyDefined<Value> {
  
  public static subscript<InstanceSelf: ComposableEnvironment>(
    instanceSelf instance: InstanceSelf,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<InstanceSelf, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<InstanceSelf, Self>
  ) -> Value {
    get {
      let wrapper = instance[keyPath: storageKeyPath]
      let keyPath = wrapper.keyPath
      let value = instance.composableEnvironmentValues[keyPath: keyPath]
      return value
    }
    set {
      fatalError()
    }
  }
  
  var keyPath: KeyPath<ComposableEnvironmentValues, Value>
  
  public init(keyPath: KeyPath<ComposableEnvironmentValues, Value>) {
    self.keyPath = keyPath
  }
  
  public var wrappedValue: Value {
    get { fatalError() }
    set { fatalError() }
  }
}

@propertyWrapper
public final class DependencyInherited<Value> where Value: ComposableEnvironment {
  public static subscript<InstanceSelf: ComposableEnvironment>(
    instanceSelf instance: InstanceSelf,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<InstanceSelf, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<InstanceSelf, DependencyInherited>
  ) -> Value {
    get {
      instance[keyPath: storageKeyPath]
        .composableEnvironment
        .mergeFromParentComposableEnvironment(instance)
    }
    set {
      fatalError()
    }
  }
  
  var composableEnvironment: Value
  
  public init(wrappedValue: Value) {
    self.composableEnvironment = wrappedValue
  }
  
  public init() {
    self.composableEnvironment = Value()
  }
  
  public var wrappedValue: Value {
    get { fatalError() }
    set { fatalError() }
  }
}
