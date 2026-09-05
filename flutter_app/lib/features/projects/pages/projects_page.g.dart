// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsListHash() => r'75b8a3b3efbb97af9cc02aefdd07923c6680ac27';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [projectsList].
@ProviderFor(projectsList)
const projectsListProvider = ProjectsListFamily();

/// See also [projectsList].
class ProjectsListFamily
    extends Family<AsyncValue<PaginatedResponse<ProjectModel>>> {
  /// See also [projectsList].
  const ProjectsListFamily();

  /// See also [projectsList].
  ProjectsListProvider call({
    String? search,
    String? status,
  }) {
    return ProjectsListProvider(
      search: search,
      status: status,
    );
  }

  @override
  ProjectsListProvider getProviderOverride(
    covariant ProjectsListProvider provider,
  ) {
    return call(
      search: provider.search,
      status: provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectsListProvider';
}

/// See also [projectsList].
class ProjectsListProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProjectModel>> {
  /// See also [projectsList].
  ProjectsListProvider({
    String? search,
    String? status,
  }) : this._internal(
          (ref) => projectsList(
            ref as ProjectsListRef,
            search: search,
            status: status,
          ),
          from: projectsListProvider,
          name: r'projectsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectsListHash,
          dependencies: ProjectsListFamily._dependencies,
          allTransitiveDependencies:
              ProjectsListFamily._allTransitiveDependencies,
          search: search,
          status: status,
        );

  ProjectsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
    required this.status,
  }) : super.internal();

  final String? search;
  final String? status;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProjectModel>> Function(ProjectsListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectsListProvider._internal(
        (ref) => create(ref as ProjectsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProjectModel>>
      createElement() {
    return _ProjectsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectsListProvider &&
        other.search == search &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectsListRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProjectModel>> {
  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `status` of this provider.
  String? get status;
}

class _ProjectsListProviderElement
    extends AutoDisposeFutureProviderElement<PaginatedResponse<ProjectModel>>
    with ProjectsListRef {
  _ProjectsListProviderElement(super.provider);

  @override
  String? get search => (origin as ProjectsListProvider).search;
  @override
  String? get status => (origin as ProjectsListProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
