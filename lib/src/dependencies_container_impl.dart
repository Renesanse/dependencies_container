class DependencyNotFoundException implements Exception {
  final Type dependencyType;

  DependencyNotFoundException(this.dependencyType);

  @override
  String toString() => 'DependencyNotFoundException: undeclared is $dependencyType';
}

class DependenciesContainer {
  final _cache = <Type, Object>{};
  final _factory = <Type, Object Function()>{};
  final _lazySingletons = <Type>{};

  DependenciesContainer({
    Map<Type, Object Function()> dependencies = const <Type, Object Function()>{},
    Set<Type> lazySingletons = const <Type>{},
  }) {
    update(
      dependencies: dependencies,
      lazySingletons: lazySingletons,
    );
  }

  void update({
    Map<Type, Object Function()> dependencies = const <Type, Object Function()>{},
    Set<Type> lazySingletons = const <Type>{},
  }) {
    _factory.addAll(dependencies);
    _lazySingletons.addAll(lazySingletons);
  }

  void clearSingleton<U>() => _cache.remove(U);

  U dependency<U>() {
    if (_lazySingletons.contains(U)) {
      if (_cache[U] == null) {
        _cache[U] = _factory[U]!();
      }
      return _cache[U]! as U;
    } else {
      return _factory[U]!() as U;
    }
  }

  void clear() {
    _cache.clear();
    _factory.clear();
    _lazySingletons.clear();
  }
}
