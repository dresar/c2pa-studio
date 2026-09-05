// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workspaceImagesHash() => r'3ba26f4e20556adb3ad8a90106bbf9bcb8f6adf7';

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

/// See also [workspaceImages].
@ProviderFor(workspaceImages)
const workspaceImagesProvider = WorkspaceImagesFamily();

/// See also [workspaceImages].
class WorkspaceImagesFamily
    extends Family<AsyncValue<PaginatedResponse<ImageModel>>> {
  /// See also [workspaceImages].
  const WorkspaceImagesFamily();

  /// See also [workspaceImages].
  WorkspaceImagesProvider call(
    String projectId,
  ) {
    return WorkspaceImagesProvider(
      projectId,
    );
  }

  @override
  WorkspaceImagesProvider getProviderOverride(
    covariant WorkspaceImagesProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'workspaceImagesProvider';
}

/// See also [workspaceImages].
class WorkspaceImagesProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ImageModel>> {
  /// See also [workspaceImages].
  WorkspaceImagesProvider(
    String projectId,
  ) : this._internal(
          (ref) => workspaceImages(
            ref as WorkspaceImagesRef,
            projectId,
          ),
          from: workspaceImagesProvider,
          name: r'workspaceImagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workspaceImagesHash,
          dependencies: WorkspaceImagesFamily._dependencies,
          allTransitiveDependencies:
              WorkspaceImagesFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  WorkspaceImagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ImageModel>> Function(
            WorkspaceImagesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkspaceImagesProvider._internal(
        (ref) => create(ref as WorkspaceImagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ImageModel>>
      createElement() {
    return _WorkspaceImagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceImagesProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkspaceImagesRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ImageModel>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _WorkspaceImagesProviderElement
    extends AutoDisposeFutureProviderElement<PaginatedResponse<ImageModel>>
    with WorkspaceImagesRef {
  _WorkspaceImagesProviderElement(super.provider);

  @override
  String get projectId => (origin as WorkspaceImagesProvider).projectId;
}

String _$workspaceNotifierHash() => r'c0c9bcb4e7b8e3193edb0da15382b68f8dae2a35';

abstract class _$WorkspaceNotifier
    extends BuildlessAutoDisposeNotifier<WorkspaceState> {
  late final String projectId;

  WorkspaceState build(
    String projectId,
  );
}

/// See also [WorkspaceNotifier].
@ProviderFor(WorkspaceNotifier)
const workspaceNotifierProvider = WorkspaceNotifierFamily();

/// See also [WorkspaceNotifier].
class WorkspaceNotifierFamily extends Family<WorkspaceState> {
  /// See also [WorkspaceNotifier].
  const WorkspaceNotifierFamily();

  /// See also [WorkspaceNotifier].
  WorkspaceNotifierProvider call(
    String projectId,
  ) {
    return WorkspaceNotifierProvider(
      projectId,
    );
  }

  @override
  WorkspaceNotifierProvider getProviderOverride(
    covariant WorkspaceNotifierProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'workspaceNotifierProvider';
}

/// See also [WorkspaceNotifier].
class WorkspaceNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WorkspaceNotifier, WorkspaceState> {
  /// See also [WorkspaceNotifier].
  WorkspaceNotifierProvider(
    String projectId,
  ) : this._internal(
          () => WorkspaceNotifier()..projectId = projectId,
          from: workspaceNotifierProvider,
          name: r'workspaceNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workspaceNotifierHash,
          dependencies: WorkspaceNotifierFamily._dependencies,
          allTransitiveDependencies:
              WorkspaceNotifierFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  WorkspaceNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  WorkspaceState runNotifierBuild(
    covariant WorkspaceNotifier notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(WorkspaceNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkspaceNotifierProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<WorkspaceNotifier, WorkspaceState>
      createElement() {
    return _WorkspaceNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceNotifierProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkspaceNotifierRef on AutoDisposeNotifierProviderRef<WorkspaceState> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _WorkspaceNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WorkspaceNotifier,
        WorkspaceState> with WorkspaceNotifierRef {
  _WorkspaceNotifierProviderElement(super.provider);

  @override
  String get projectId => (origin as WorkspaceNotifierProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
