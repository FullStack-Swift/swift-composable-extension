import ComposableArchitecture

@resultBuilder
public struct ReducerBuilder {
  public static func buildBlock<State, Action, Environment>(_ reducers: Reducer<State, Action, Environment>...) -> Reducer<State, Action, Environment> {
    Reducer<State, Action, Environment>.combine(reducers)
  }
}

extension Reducer {
  public init(@ReducerBuilder content: () -> Reducer<State, Action, Environment>) {
    self = content()
  }
}
