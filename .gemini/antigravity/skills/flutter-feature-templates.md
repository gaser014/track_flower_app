---
name: flutter-feature-templates
description: >
  Copy-paste code templates for every layer of a Darsy feature, matching the repo's real
  stack: plain Dio API clients (NO Retrofit), manual *Model fromJson/toEntity (NO
  json_serializable), Result<T> + executeApi, BaseState<T>/PaginationState<T>, single Cubit
  with sealed events + doIntent, injectable DI. Use when scaffolding a use case, model,
  repository, data source, cubit, or screen. Trigger on "template", "scaffold", "boilerplate",
  "اعمللي use case", "اعمللي cubit", "starter code".
---

# Darsy Feature Templates

Placeholders: `{Feature}`/`{feature}` (PascalCase/snake_case), `{Entity}`, `{Model}`, `{Action}`.
Read `flutter-clean-architecture-feature.md` first for the why; this file is the what-to-paste.

> ⚠️ This repo does **NOT** use Retrofit or json_serializable. No `@RestApi`, no `@JsonSerializable`,
> no `.g.dart` for models. `build_runner` only regenerates `di.config.dart` (injectable).

---

## Template 1 — Entity

```dart
import 'package:equatable/equatable.dart';

class {Entity} extends Equatable {
  final String id;
  final String name;

  const {Entity}({required this.id, required this.name});

  factory {Entity}.empty() => const {Entity}(id: '', name: '');

  {Entity} copyWith({String? id, String? name}) =>
      {Entity}(id: id ?? this.id, name: name ?? this.name);

  @override
  List<Object?> get props => [id, name];
}
```

---

## Template 2 — Model (manual JSON, NO codegen)

```dart
import 'package:darsy/feature/{feature}/domain/entities/{feature}_entity.dart';

class {Model}Model {
  final String id;
  final String name;
  final String? createdAt;

  const {Model}Model({required this.id, required this.name, this.createdAt});

  factory {Model}Model.fromJson(Map<String, dynamic> json) => {Model}Model(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        createdAt: json['createdAt'],
      );

  factory {Model}Model.fromEntity({Entity} entity) =>
      {Model}Model(id: entity.id, name: entity.name);

  Map<String, dynamic> toJson() => {'name': name};

  {Entity} toEntity() => {Entity}(id: id, name: name);
}
```

List wrapper (when the API returns `{ data: [...], statistics/metadata: {...} }`):
```dart
class {Feature}ListModel {
  final List<{Model}Model> items;
  const {Feature}ListModel({required this.items});

  factory {Feature}ListModel.fromJson(Map<String, dynamic> json) => {Feature}ListModel(
        items: (json['data'] as List?)
                ?.map((e) => {Model}Model.fromJson(e))
                .toList() ??
            [],
      );

  List<{Entity}> toEntityList() => items.map((e) => e.toEntity()).toList();
}
```

> For the generic CMS envelope `{ message, pagination, data }`, use `BasePaginationDto`/`BasePaginationEntity`
> instead — see `shared-global-data-feature.md`.

---

## Template 3 — Repository contract + impl

```dart
// domain/repositories/{feature}_repository.dart
import 'package:darsy/config/base_response/result.dart';
import 'package:darsy/feature/{feature}/domain/entities/{feature}_entity.dart';

abstract class {Feature}Repository {
  Future<Result<{Entity}>> get{Action}({Action}Params params);
  Future<Result<List<{Entity}>>> get{Feature}List();
}
```

```dart
// data/repositories/{feature}_repository_impl.dart
import 'package:darsy/config/base_response/result.dart';
import 'package:darsy/feature/{feature}/data/data_sources/{feature}_remote_data_source_contract.dart';
import 'package:darsy/feature/{feature}/domain/entities/{feature}_entity.dart';
import 'package:darsy/feature/{feature}/domain/repositories/{feature}_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: {Feature}Repository)
class {Feature}RepositoryImpl implements {Feature}Repository {
  final {Feature}RemoteDataSourceContract _remoteDataSource;

  {Feature}RepositoryImpl({required {Feature}RemoteDataSourceContract remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<{Entity}>> get{Action}({Action}Params params) async {
    final result = await _remoteDataSource.get{Action}(params: params);
    return result.when(
      success: (data) => data != null
          ? Success(data: data.toEntity())
          : const Error(exception: null),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<List<{Entity}>>> get{Feature}List() async {
    final result = await _remoteDataSource.get{Feature}List();
    return result.when(
      success: (data) => Success(data: data?.toEntityList() ?? const []),
      error: (exception) => Error(exception: exception),
    );
  }
}
```

Variant using fixtures (`makeDummyData` — common in this repo):
```dart
final result = await _remoteDataSource.get{Action}(params: params);
return result.makeDummyData(
  dummyData: {Feature}Fixtures.dummy{Action},
  success: (data) => Success(data: data?.toEntity()),
  error: (exception) => Error(exception: exception),
);
```

---

## Template 4 — Use case

```dart
import 'package:darsy/config/base_response/result.dart';
import 'package:darsy/config/uses_cases/use_cases.dart';
import 'package:darsy/feature/{feature}/domain/entities/{feature}_entity.dart';
import 'package:darsy/feature/{feature}/domain/repositories/{feature}_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class Get{Action}UseCase extends UseCase<{Entity}, {Action}Params> {
  final {Feature}Repository _repository;
  Get{Action}UseCase(this._repository);

  @override
  Future<Result<{Entity}>> call({Action}Params params) => _repository.get{Action}(params);
}

class {Action}Params {
  final String field1;
  const {Action}Params({required this.field1});
}
```

No params:
```dart
@injectable
class Get{Feature}ListUseCase extends UseCase<List<{Entity}>, NoParams> {
  final {Feature}Repository _repository;
  Get{Feature}ListUseCase(this._repository);

  @override
  Future<Result<List<{Entity}>>> call(NoParams params) => _repository.get{Feature}List();
}
```

---

## Template 5 — Remote data source (contract + impl)

```dart
// data/data_sources/{feature}_remote_data_source_contract.dart
import 'package:darsy/config/base_response/result.dart';
import 'package:darsy/feature/{feature}/data/models/{feature}_model.dart';

abstract class {Feature}RemoteDataSourceContract {
  Future<Result<{Model}Model>> get{Action}({required {Action}Params params});
  Future<Result<{Feature}ListModel>> get{Feature}List();
}
```

```dart
// api/data_sources/{feature}_remote_data_source_impl.dart
import 'package:darsy/config/api/api_executor.dart';
import 'package:darsy/config/base_response/result.dart';
import 'package:darsy/feature/{feature}/api/api_client/{feature}_api_client.dart';
import 'package:darsy/feature/{feature}/data/data_sources/{feature}_remote_data_source_contract.dart';
import 'package:darsy/feature/{feature}/data/models/{feature}_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: {Feature}RemoteDataSourceContract)
class {Feature}RemoteDataSourceImpl implements {Feature}RemoteDataSourceContract {
  final {Feature}ApiClient _apiClient;

  {Feature}RemoteDataSourceImpl({required {Feature}ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Result<{Model}Model>> get{Action}({required {Action}Params params}) =>
      executeApi<{Model}Model>(() => _apiClient.get{Action}(params: params));

  @override
  Future<Result<{Feature}ListModel>> get{Feature}List() =>
      executeApi<{Feature}ListModel>(() => _apiClient.get{Feature}List());
}
```

---

## Template 6 — API client (plain Dio)

```dart
import 'package:darsy/feature/{feature}/data/models/{feature}_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class {Feature}ApiClient {
  final Dio _dio;
  {Feature}ApiClient(this._dio);

  Future<{Feature}ListModel> get{Feature}List() async {
    final response = await _dio.get('/api/v1/{feature}');
    return {Feature}ListModel.fromJson(response.data);
  }

  Future<{Model}Model> get{Action}({required {Action}Params params}) async {
    final response = await _dio.get('/api/v1/{feature}/${params.field1}');
    return {Model}Model.fromJson(response.data['data'] ?? response.data);
  }

  Future<{Model}Model> create({Action}({required {Action}Params params}) async {
    final response = await _dio.post('/api/v1/{feature}', data: params.toJson());
    return {Model}Model.fromJson(response.data['data'] ?? response.data);
  }
}
```

> Prefer pulling shared paths from `lib/config/api/end_points.dart`.

---

## Template 7 — Cubit + events + states (part files)

```dart
// presentation/cubit/{feature}_cubit.dart
import 'package:darsy/config/base_state/base_state.dart';
import 'package:darsy/config/base_state/pagination_state.dart';
import 'package:darsy/feature/{feature}/domain/entities/{feature}_entity.dart';
import 'package:darsy/feature/{feature}/domain/use_cases/get_{feature}_list_use_case.dart';
import 'package:darsy/feature/{feature}/domain/use_cases/get_{action}_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part '{feature}_events.dart';
part '{feature}_states.dart';

@injectable
class {Feature}Cubit extends Cubit<{Feature}States> {
  final Get{Feature}ListUseCase _get{Feature}ListUseCase;
  final Get{Action}UseCase _get{Action}UseCase;

  {Feature}Cubit({
    required Get{Feature}ListUseCase get{Feature}ListUseCase,
    required Get{Action}UseCase get{Action}UseCase,
  })  : _get{Feature}ListUseCase = get{Feature}ListUseCase,
        _get{Action}UseCase = get{Action}UseCase,
        super(const {Feature}States());

  @override
  void emit({Feature}States state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> doIntent({Feature}Events event) async => switch (event) {
        Get{Feature}ListEvent() => _get{Feature}List(event),
        Get{Action}Event() => _get{Action}(event),
      };

  Future<void> _get{Feature}List(Get{Feature}ListEvent event) async {
    if (state.listState.isLoading) return;
    emit(state.copyWith(listState: state.listState.toLoading()));

    final result = await _get{Feature}ListUseCase(const NoParams());
    result.when(
      success: (data) => emit(state.copyWith(
        listState: state.listState.toSuccess(data ?? const []),
      )),
      error: (e) => emit(state.copyWith(
        listState: state.listState.toError(e ?? Exception('Unknown error')),
      )),
    );
  }

  Future<void> _get{Action}(Get{Action}Event event) async {
    if (state.detailState.isLoading) return;
    emit(state.copyWith(detailState: const BaseState.loading()));

    final result = await _get{Action}UseCase(event.params);
    result.when(
      success: (data) => data != null
          ? emit(state.copyWith(detailState: BaseState.success(data)))
          : emit(state.copyWith(detailState: BaseState.error(Exception('No data')))),
      error: (e) => emit(state.copyWith(
        detailState: BaseState.error(e ?? Exception('Unknown error')),
      )),
    );
  }
}
```

```dart
// presentation/cubit/{feature}_events.dart
part of '{feature}_cubit.dart';

sealed class {Feature}Events {
  const {Feature}Events();
}

class Get{Feature}ListEvent extends {Feature}Events {
  const Get{Feature}ListEvent();
}

class Get{Action}Event extends {Feature}Events {
  final {Action}Params params;
  const Get{Action}Event({required this.params});
}
```

```dart
// presentation/cubit/{feature}_states.dart
part of '{feature}_cubit.dart';

class {Feature}States extends Equatable {
  final PaginationState<{Entity}> listState;
  final BaseState<{Entity}> detailState;

  const {Feature}States({
    this.listState = const PaginationState.initial(),
    this.detailState = const BaseState.initial(),
  });

  {Feature}States copyWith({
    PaginationState<{Entity}>? listState,
    BaseState<{Entity}>? detailState,
  }) =>
      {Feature}States(
        listState: listState ?? this.listState,
        detailState: detailState ?? this.detailState,
      );

  @override
  List<Object?> get props => [listState, detailState];
}
```

---

## Template 8 — Route entry page

```dart
import 'package:darsy/config/dependency_injection/di.dart';
import 'package:darsy/feature/{feature}/presentation/cubit/{feature}_cubit.dart';
import 'package:darsy/feature/{feature}/presentation/widgets/{feature}_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class {Feature}Page extends StatelessWidget {
  const {Feature}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<{Feature}Cubit>(
      create: (_) => getIt<{Feature}Cubit>()..doIntent(const Get{Feature}ListEvent()),
      child: const {Feature}Body(),
    );
  }
}
```

---

## Template 9 — Body widget (BlocBuilder + handleBuilderStateList)

```dart
import 'package:darsy/core/helper/extensions/base_state/handle_builder_state.dart';
import 'package:darsy/feature/{feature}/presentation/cubit/{feature}_cubit.dart';
import 'package:darsy/feature/{feature}/presentation/widgets/shimmer/{feature}_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class {Feature}Body extends StatelessWidget {
  const {Feature}Body({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<{Feature}Cubit, {Feature}States>(
      buildWhen: (prev, curr) => prev.listState != curr.listState,
      builder: (context, state) {
        return state.listState.handleBuilderStateList(
              onLoading: const {Feature}Shimmer(),
              onSuccess: {Feature}SuccessView(items: state.listState.data),
              onEmpty: const Center(child: Text('لا توجد بيانات')),
              onError: const Center(child: Text('حدث خطأ')),
            ) ??
            const SizedBox.shrink();
      },
    );
  }
}
```

For listener-style side effects (toasts, navigation), use `BlocConsumer` and check
`state.actionState.isSuccess` / `state.actionState.isError`.

---

## Template 10 — Widgets barrel

```dart
// presentation/widgets/widgets.dart
export '{feature}_body.dart';
export '{feature}_success_view.dart';
export 'shimmer/{feature}_shimmer.dart';
```

---

## Quick commands

```bash
# regenerate DI (after adding/removing @injectable / @LazySingleton)
flutter pub run build_runner build --delete-conflicting-outputs

# analyze just your feature
flutter analyze lib/feature/{feature}
```

---

## Related skills
- `flutter-clean-architecture-feature.md`
- `state-management-patterns.md`
- `routes.md`
- `common-mistakes-and-fixes.md`

**Last verified**: May 2026 against `feature/reviews`.
