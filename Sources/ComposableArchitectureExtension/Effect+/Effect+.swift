import ComposableArchitecture

@resultBuilder
public struct EffectBuilder {
  public static func buildBlock<Output,Failure: Error>(_ effects: Effect<Output,Failure>...) -> [Effect<Output,Failure>] {
    effects
  }
}

public extension Effect {
  static func concatenate(@EffectBuilder builder: () -> [Effect]) -> Effect {
    .concatenate(builder())
  }
  
  static func merge(@EffectBuilder builder: () -> [Effect]) -> Effect {
    .merge(builder())
  }
}
