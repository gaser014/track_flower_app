---
name: flutter-clean-architecture-feature
description: >
  The authoritative guide for building a feature in the Darsy Flutter app using its
  Clean Architecture conventions: api → data → domain → presentation layers, plain Dio
  API clients (NO Retrofit), manual JSON models (NO json_serializable), Result<T> with
  .when()/.makeDummyData(), BaseState<T> + PaginationState<T> (NOT ApiState), single
  Cubit per feature with sealed events + doIntent(), and injectable DI. Use this whenever
  creating a new feature, adding a layer, reviewing structure, or onboarding. Trigger on
  "feature جديدة", "new feature", "clean architecture", "repository", "use case", "cubit",
  "data source", "كلين اركتيكشر".
---

# Darsy Clean Architecture — Feature Guide

This is how features are actually built in this repo. Verified against `feature/reviews`,
`feature/sliders`, and `config/shared/global`. Copy these patterns exactly — do not invent
Retrofit/json_serializable/ApiState; they are NOT used here.

> Reference feature: `lib/feature/reviews/` (single + paginated data, BaseState + PaginationState).

---

## 0. Stack at a glance

| Concern | What this repo uses | What it does NOT use |
|---|---|---|
| DI | `injectable` + `get_it` (`@injectable`, `@LazySingleton(as: X)`) | — |
| Networking | **plain `dio`** wrapped in `executeApi()` | ❌ Retrofit / `@RestApi` |
| JSON | **manual** `factory X.fromJson` + `toEntity()` | ❌ `json_serializable` / `.g.dart` |
| Result | `Result<T>` (`Success`/`Error`) + `.when()` / `.makeDummyData()` | ❌ dartz / Either |
| State | `BaseState<T>` (single) + `PaginationState<T>` (lists) | ❌ `ApiState<T>` |
| Cubit | one Cubit/feature, `sealed` events, `doIntent(event)` switch | ❌ one cubit per action |
| Routing | `go_router` + `buildAnimatedPage` + per-feature `config/` | — |

Key base files (import these exact paths):
```dart
import 'package:darsy/config/base_response/result.dart';        // Result, Success, Error
import 'package:darsy/config/base_state/base_state.dart';        // BaseState<T>
import 'package:darsy/config/base_state/pagination_state.dart';  // PaginationState<T>
import 'package:darsy/config/uses_cases/use_cases.dart';         // UseCase<T, Params>, NoParams
import 'package:darsy/config/uses_cases/pagination_params.dart'; // PaginationParams
import 'package:darsy/config/api/api_executor.dart';             // executeApi<T>()
import 'package:darsy/config/dependency_injection/di.dart';      // getIt
```

---

## 1. Folder structure

```
lib/feature/{feature}/
├── api/
│   ├── api_client/{feature}_api_client.dart        # plain Dio, @lazySingleton
│   └── data_sources/
│       ├── {feature}_remote_data_source_impl.dart  # @LazySingleton(as: Contract)
│       └── {feature}_local_data_source_impl.dart   # optional
├── data/
│   ├── data_sources/
│   │   ├── {feature}_remote_data_source_contract.dart
│   │   └── {feature}_local_data_source_contract.dart
│   ├── fixtures/{feature}_fixtures.dart            # dummy data for makeDummyData
│   ├── models/{feature}_model.dart                 # *Model classes, manual fromJson + toEntity
│   └── repositories/{feature}_repository_impl.dart # @LazySingleton(as: Repository)
├── domain/
│   ├── entities/{feature}_entity.dart              # pure Dart / Equatable
│   ├── repositories/{feature}_repository.dart      # abstract contract
│   └── use_cases/{action}_use_case.dart            # one UseCase per file
└── presentation/
    ├── cubit/
    │   ├── {feature}_cubit.dart                    # @injectable, doIntent, part files
    │   ├── {feature}_events.dart                   # part of cubit, sealed
    │   └── {feature}_states.dart                   # part of cubit, Equatable
    ├── pages/ (or screen/)                         # route entry widgets
    └── widgets/
        ├── widgets.dart                            # barrel (export ...)
        ├── {feature}_body.dart
        └── shimmer/{feature}_shimmer.dart
```

> `app_version/{student|teacher}/{feature}/` follows the same internal structure.

---

## 2. Domain layer

### Entity (`domain/entities/{feature}_entity.dart`)
Pure Dart. Use `Equatable` or override `==`/`hashCode`. Add `empty()` + `copyWith()`.

```dart
class ReviewDetailsEntity {
  final String id;
  final String userName;
  final num rating;
  final String comment;
  final DateTime createdAt;

  const ReviewDetailsEntity({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewDetailsEntity.empty() => ReviewDetailsEntity(
        id: '', userName: '', rating: 0, comment: '', createdAt: DateTime.now(),
      );

  ReviewDetailsEntity copyWith({String? comment, num? rating}) => ReviewDetailsEntity(
        id: id, userName: userName,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        createdAt: createdAt,
      );
}
```

### Repository contract (`domain/repositories/{feature}_repository.dart`)
Returns **entities**, never models. `Future<Result<Entity>>`.

```dart
abstract class ReviewsRepository {
  Future<Result<TeacherReviewsEntity>> getTeacherReviews(ReviewQueryEntity query);
  Future<Result<ReviewDetailsEntity>> createReview(ReviewParams params);
}
```

### Use case (`domain/use_cases/{action}_use_case.dart`)
One file per action. Class name ends with `UseCase`, file ends with `_use_case.dart`.
Extend `UseCase<Output, Params>`; use `@injectable`.

```dart
@injectable
class GetTeacherReviewsUseCase extends UseCase<TeacherReviewsEntity, ReviewQueryEntity> {
  final ReviewsRepository _repository;
  GetTeacherReviewsUseCase(this._repository);

  @override
  Future<Result<TeacherReviewsEntity>> call(ReviewQueryEntity params) =>
      _repository.getTeacherReviews(params);
}
```

- No params → use `NoParams` from `config/uses_cases/use_cases.dart`.
- Paginated list params → extend `PaginationParams` and override `filterList` (see `state-management-patterns.md`).

---

## 3. Data layer

### Model (`data/models/{feature}_model.dart`)
Named `*Model`. **Manual** `fromJson` + `toEntity()` (and `fromEntity` if you send it back).
Handle `_id`/`id`, nested objects, and null defaults defensively.

```dart
class ReviewDetailsModel {
  final String id;
  final String userName;
  final num rating;
  final String comment;
  final String createdAt;

  const ReviewDetailsModel({
    required this.id, required this.userName,
    required this.rating, required this.comment, required this.createdAt,
  });

  factory ReviewDetailsModel.fromJson(Map<String, dynamic> json) => ReviewDetailsModel(
        id: json['_id'] ?? json['id'] ?? '',
        userName: (json['user'] is Map ? json['user']['name'] : null) ?? '',
        rating: json['rating'] ?? 0,
        comment: json['comment'] ?? '',
        createdAt: json['createdAt'] ?? '',
      );

  ReviewDetailsEntity toEntity() => ReviewDetailsEntity(
        id: id, userName: userName, rating: rating, comment: comment,
        createdAt: DateTime.tryParse(createdAt)?.toLocal() ?? DateTime.now(),
      );
}
```

> For paginated list responses, model the wrapper too (`{ data: [...], statistics/metadata: {...} }`).
> For the generic CMS `{ message, pagination, data }` envelope, use `BasePaginationDto`/`BasePaginationEntity`
> — see `shared-global-data-feature.md`.

### Fixtures (`data/fixtures/{feature}_fixtures.dart`)
Static dummy entities used by `makeDummyData` so the UI works offline / before the API is ready.

```dart
abstract class ReviewsFixtures {
  static final TeacherReviewsEntity dummyTeacherReviews = TeacherReviewsEntity(/* ... */);
}
```

### Data source contract (`data/data_sources/{feature}_remote_data_source_contract.dart`)
Returns `Result<Model>` (models, not entities — mapping happens in the repo).

```dart
abstract class ReviewsRemoteDataSourceContract {
  Future<Result<TeacherReviewsModel>> getTeacherReviews({required ReviewQueryEntity query});
}
```

### API client (`api/api_client/{feature}_api_client.dart`)
**Plain Dio**, `@lazySingleton`. No annotations on methods. Parse the response into a `*Model`.

```dart
@lazySingleton
class ReviewsApiClient {
  final Dio _dio;
  ReviewsApiClient(this._dio);

  Future<TeacherReviewsModel> getTeacherReviews({required ReviewQueryEntity query}) async {
    final response = await _dio.get(
      '/user/teachers/${query.teacherId}/ratings',
      queryParameters: query.toJson(),
    );
    return TeacherReviewsModel.fromJson(response.data);
  }
}
```

> Centralize paths in `lib/config/api/end_points.dart` when shared.

### Remote data source impl (`api/data_sources/{feature}_remote_data_source_impl.dart`)
`@LazySingleton(as: Contract)`. Wrap every call in `executeApi<Model>()` (handles connectivity + Dio errors → `Result`).

```dart
@LazySingleton(as: ReviewsRemoteDataSourceContract)
class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSourceContract {
  final ReviewsApiClient _apiClient;
  ReviewsRemoteDataSourceImpl({required ReviewsApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Result<TeacherReviewsModel>> getTeacherReviews({required ReviewQueryEntity query}) =>
      executeApi<TeacherReviewsModel>(() => _apiClient.getTeacherReviews(query: query));
}
```

### Repository impl (`data/repositories/{feature}_repository_impl.dart`)
`@LazySingleton(as: Repository)`. Map model → entity here. Use `.makeDummyData()` (preferred in this
repo — falls back to fixtures) or plain `.when()`. **Never** `try/catch`.

```dart
@LazySingleton(as: ReviewsRepository)
class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSourceContract _remoteDataSource;
  ReviewsRepositoryImpl({required ReviewsRemoteDataSourceContract remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<TeacherReviewsEntity>> getTeacherReviews(ReviewQueryEntity query) async {
    final result = await _remoteDataSource.getTeacherReviews(query: query);
    return result.makeDummyData(
      dummyData: ReviewsFixtures.dummyTeacherReviews,
      success: (data) => Success(data: data?.toEntity()),
      error: (exception) => Error(exception: exception),
    );
  }
}
```

---

## 4. Presentation layer

### Cubit + events + states (one feature, three files via `part`)

`{feature}_cubit.dart` owns the part files:

```dart
import 'package:darsy/config/base_state/base_state.dart';
import 'package:darsy/config/base_state/pagination_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
// + use_case + entity imports

part 'reviews_events.dart';
part 'reviews_states.dart';

@injectable
class ReviewsCubit extends Cubit<ReviewsStates> {
  final GetTeacherReviewsUseCase _getTeacherReviewsUseCase;
  final CreateReviewUseCase _createReviewUseCase;

  ReviewsCubit({
    required GetTeacherReviewsUseCase getTeacherReviewsUseCase,
    required CreateReviewUseCase createReviewUseCase,
  })  : _getTeacherReviewsUseCase = getTeacherReviewsUseCase,
        _createReviewUseCase = createReviewUseCase,
        super(const ReviewsStates());

  @override
  void emit(ReviewsStates state) {
    if (!isClosed) super.emit(state); // guard against emit-after-close
  }

  // single entry point
  Future<void> doIntent(ReviewsEvents event) async => switch (event) {
        GetTeacherReviewsEvent() => _getTeacherReviews(event),
        CreateReviewEvent() => _createReview(event),
        LoadMoreReviewsEvent() => _loadMoreReviews(event),
      };

  Future<void> _createReview(CreateReviewEvent event) async {
    if (state.actionState.isLoading) return;
    emit(state.copyWith(actionState: const BaseState.loading()));

    final result = await _createReviewUseCase(event.params);
    result.when(
      success: (data) => data != null
          ? emit(state.copyWith(actionState: BaseState.success(data)))
          : emit(state.copyWith(actionState: BaseState.error(Exception('No data')))),
      error: (e) => emit(state.copyWith(actionState: BaseState.error(e ?? Exception('Unknown')))),
    );
  }
}
```

`{feature}_events.dart`:
```dart
part of 'reviews_cubit.dart';

sealed class ReviewsEvents {
  const ReviewsEvents();
}

class GetTeacherReviewsEvent extends ReviewsEvents {
  final ReviewQueryEntity query;
  const GetTeacherReviewsEvent({required this.query});
}

class CreateReviewEvent extends ReviewsEvents {
  final ReviewParams params;
  const CreateReviewEvent({required this.params});
}
```

`{feature}_states.dart` — one state class, an `ApiState`-free combination of
`BaseState<T>` (single values) and `PaginationState<T>` (lists):
```dart
part of 'reviews_cubit.dart';

class ReviewsStates extends Equatable {
  final PaginationState<ReviewDetailsEntity> reviewsState;     // list
  final BaseState<ReviewStatisticsEntity> statisticsState;     // single
  final BaseState<ReviewDetailsEntity> actionState;            // create/update

  const ReviewsStates({
    this.reviewsState = const PaginationState.initial(),
    this.statisticsState = const BaseState.initial(),
    this.actionState = const BaseState.initial(),
  });

  ReviewsStates copyWith({
    PaginationState<ReviewDetailsEntity>? reviewsState,
    BaseState<ReviewStatisticsEntity>? statisticsState,
    BaseState<ReviewDetailsEntity>? actionState,
  }) =>
      ReviewsStates(
        reviewsState: reviewsState ?? this.reviewsState,
        statisticsState: statisticsState ?? this.statisticsState,
        actionState: actionState ?? this.actionState,
      );

  @override
  List<Object?> get props => [reviewsState, statisticsState, actionState];
}
```

> Full state transition + `.when()` reference: `state-management-patterns.md`.

### Route entry widget (`presentation/pages/{feature}_page.dart`)
Provide the cubit with `getIt`, fire initial intents, delegate body to a separate widget.

```dart
class TeacherReviewsPage extends StatelessWidget {
  final TeacherProfileEntity teacher;
  const TeacherReviewsPage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: DataStrings.ratings, showBackButton: true, centerTitle: true),
      body: SafeArea(
        child: BlocProvider<ReviewsCubit>(
          create: (_) => getIt<ReviewsCubit>()
            ..doIntent(GetTeacherReviewsEvent(
                query: ReviewQueryEntity(teacherId: teacher.id ?? '', page: 1)))
            ..doIntent(GetUserReviewStatusEvent(teacherId: teacher.id ?? '')),
          child: TeacherReviewsBody(teacher: teacher),
        ),
      ),
    );
  }
}
```

### Body / widgets
- Use `BlocBuilder` with `buildWhen` scoped to the one state slice it renders.
- Render via `state.xxx.when(...)` (full control) or `state.xxx.handleBuilderState/handleBuilderStateList(...)` helpers.
- **Top-level / separate widget classes only** — no `Widget _buildX()` methods.
- Export reusable widgets from `widgets/widgets.dart`.
- Shimmer placeholders live in `widgets/shimmer/` (see `shimmer-skeletonizer-guide.md`).

---

## 5. Config / routing
Per-feature `config/` holds `*_routes.dart`, `*_navigation_args.dart`, `*_navigation_helper.dart`,
`*_router_config.dart`. Plug `XRouterConfig.getRoutes()` into `lib/core/routes/app_routes.dart`.
Full details: **`routes.md`**.

---

## 6. Build & verify
```bash
flutter pub run build_runner build --delete-conflicting-outputs   # regenerates di.config.dart ONLY
flutter analyze lib/feature/{feature}                              # expect: No issues found!
```
`build_runner` here is for **injectable** (DI) — not JSON/Retrofit. Run it after adding/removing any
`@injectable` / `@LazySingleton` annotated class so `di.config.dart` picks it up.

---

## 7. New-feature checklist
- [ ] `domain/entities` — entity + `empty()` + `copyWith()`
- [ ] `domain/repositories` — abstract contract returning `Result<Entity>`
- [ ] `domain/use_cases` — one `*UseCase` per action (`@injectable`)
- [ ] `data/models` — `*Model` with manual `fromJson` + `toEntity`
- [ ] `data/fixtures` — dummy data (optional but used by `makeDummyData`)
- [ ] `data/data_sources` — remote (+ local) contract
- [ ] `api/api_client` — plain Dio client (`@lazySingleton`)
- [ ] `api/data_sources` — `*Impl` wrapping `executeApi` (`@LazySingleton(as: Contract)`)
- [ ] `data/repositories` — `*Impl` mapping model→entity (`@LazySingleton(as: Repository)`)
- [ ] `presentation/cubit` — cubit + sealed events + states (`part of`), `doIntent`, `emit` guard
- [ ] `presentation/pages` + `widgets` (+ `widgets.dart` barrel, `shimmer/`)
- [ ] `config/` routing + register in `app_routes.dart`
- [ ] `flutter pub run build_runner build` → `flutter analyze lib/feature/{feature}`

---

## 8. Related skills
- `state-management-patterns.md` — Result / BaseState / PaginationState / params deep dive
- `flutter-feature-templates.md` — copy-paste templates matching this guide
- `common-mistakes-and-fixes.md` — real pitfalls and fixes
- `routes.md` — routing config files
- `shared-global-data-feature.md` — CMS lookup data (governorates, cities, grades…)
- `shimmer-skeletonizer-guide.md` — loading placeholders
- `figma-mcp-implementation.md` — Figma → Flutter token mapping

**Last verified**: May 2026 against `feature/reviews`, `feature/sliders`, `config/shared/global`.
