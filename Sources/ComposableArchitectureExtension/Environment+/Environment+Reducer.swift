import ComposableArchitecture

public extension Reducer where Environment: ComposableEnvironment {
  
  func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: WritableKeyPath<GlobalState, State>,
    action toLocalAction: CasePath<GlobalAction, Action>
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment>
  where GlobalEnvironment: ComposableEnvironment {
    let local = Environment()
    return pullback(
      state: toLocalState,
      action: toLocalAction,
      environment: local.mergeFromParentComposableEnvironment
    )
  }
  
  func pullback<GlobalState, GlobalAction, GlobalEnvironment>(
    state toLocalState: CasePath<GlobalState, State>,
    action toLocalAction: CasePath<GlobalAction, Action>,
    breakpointOnNil: Bool = true,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment>
  where GlobalEnvironment: ComposableEnvironment {
    let local = Environment()
    return pullback(
      state: toLocalState,
      action: toLocalAction,
      environment: local.mergeFromParentComposableEnvironment,
      breakpointOnNil: breakpointOnNil
    )
  }
  
  func forEach<GlobalState, GlobalAction, GlobalEnvironment, ID>(
    state toLocalState: WritableKeyPath<GlobalState, IdentifiedArray<ID, State>>,
    action toLocalAction: CasePath<GlobalAction, (ID, Action)>,
    breakpointOnNil: Bool = true,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment>
  where GlobalEnvironment: ComposableEnvironment {
    let local = Environment()
    return forEach(
      state: toLocalState,
      action: toLocalAction,
      environment: local.mergeFromParentComposableEnvironment,
      breakpointOnNil: breakpointOnNil
    )
  }
  
  func forEach<GlobalState, GlobalAction, GlobalEnvironment, Key>(
    state toLocalState: WritableKeyPath<GlobalState, [Key: State]>,
    action toLocalAction: CasePath<GlobalAction, (Key, Action)>,
    breakpointOnNil: Bool = true,
    _ file: StaticString = #file,
    _ line: UInt = #line
  ) -> Reducer<GlobalState, GlobalAction, GlobalEnvironment>
  where GlobalEnvironment: ComposableEnvironment {
    let local = Environment()
    return forEach(
      state: toLocalState,
      action: toLocalAction,
      environment: local.mergeFromParentComposableEnvironment,
      breakpointOnNil: breakpointOnNil
    )
  }
}
