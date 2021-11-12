import ComposableArchitecture

extension Reducer {
  static func subscriptions(
    _ subscriptions: @escaping (State, Environment) -> [AnyHashable: Effect<Action, Never>]
  ) -> Reducer {
    var activeSubscriptions: [AnyHashable: Effect<Action, Never>] = [:]
    return Reducer { state, _, environment in
      let currentSubscriptions = subscriptions(state, environment)
      defer { activeSubscriptions = currentSubscriptions }
      return .merge(
        Set(activeSubscriptions.keys).union(currentSubscriptions.keys).map { id in
          switch (activeSubscriptions[id], currentSubscriptions[id]) {
          case (.some, .none):
            return .cancel(id: id)
          case let (.none, .some(effect)):
            return effect.cancellable(id: id)
          default:
            return .none
          }
        }
      )
    }
  }
}
