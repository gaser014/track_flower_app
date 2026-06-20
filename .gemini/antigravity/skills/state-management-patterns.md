---
name: state-management-patterns
description: >
  Deep reference for Darsy's state + result system: Result<T> (.when / .makeDummyData),
  BaseState<T> for single values, PaginationState<T> for lists (toLoading/toLoadingMore/
  toSuccess/toError/toErrorMore, canLoadMore, when), PaginationParams + FilterParam for
  query building, and the handleBuilderState/handleBuilderStateList UI helpers. Use whenever
  wiring a cubit to use cases, building paginated lists, infinite scroll, filters, or
  rendering state in widgets. Trigger on "pagination", "load more", "BaseState",
  "PaginationState", "Result.when", "filter params", "infinite scroll", "حالة", "باجينيشن".
---

# State Management Patterns (Darsy)

The repo has **no** `ApiState`. Single values use `BaseState<T>`; lists use `PaginationState<T>`.
API calls return `Result<T>`. This skill is the canonical reference for all four building blocks.

Imports:
```dart
import 'package:darsy/config/base_response/result.dart';        // Result, Success, Error
import 'package:darsy/config/base_state/base_state.dart';        // BaseState<T>
import 'package:darsy/config/base_state/pagination_state.dart';  // PaginationState<T>
import 'package:darsy/config/uses_cases/pagination_params.dart'; // PaginationParams
import 'package:darsy/config/uses_cases/filter_param.dart';      // FilterParam
import 'package:darsy/core/helper/extensions/base_state/handle_builder_state.dart'; // helpers
```

---

## 1. `Result<T>` — what API/repo calls return

`sealed class Result<T>` with `Success<T>(data)` and `Error<T>(exception)`. **Data can be null.**

```dart
result.when(
  success: (data) {            // data is T?  → null-check it
    if (data == null) return const Error(exception: null);
    return Success(data: mapper(data));
  },
  error: (exception) => Error(exception: exception), // exception is Exception?
);
```

### `.makeDummyData` — preferred in this repo
Maps the result and lets a repository fall back to fixtures (the fallback branch is currently
gated off, but this is the established call shape — keep using it for consistency):
```dart
return result.makeDummyData(
  dummyData: {Feature}Fixtures.dummyX,
  success: (data) => Success(data: data?.toEntity()),
  error: (exception) => Error(exception: exception),
);
```

Rule: **always handle the null success case.** `success: (data) => Success(data: data!.toEntity())`
will crash on an empty body.

---

## 2. `BaseState<T>` — single values (detail, action, form submit)

Constructors: `BaseState.initial()`, `BaseState.loading()`, `BaseState.success(data)`, `BaseState.error(exception)`.
Flags: `isInitial`, `isLoading`, `isSuccess`, `isError`. Fields: `data` (`T?`), `exception`.

Cubit handler shape:
```dart
Future<void> _getDetail(GetDetailEvent event) async {
  if (state.detailState.isLoading) return;            // guard re-entry
  emit(state.copyWith(detailState: const BaseState.loading()));

  final result = await _getDetailUseCase(event.params);
  result.when(
    success: (data) => data != null
        ? emit(state.copyWith(detailState: BaseState.success(data)))
        : emit(state.copyWith(detailState: BaseState.error(Exception('No data received')))),
    error: (e) => emit(state.copyWith(
      detailState: BaseState.error(e ?? Exception('Unknown error')),
    )),
  );
}
```

`.when` (exhaustive) for full control in UI:
```dart
state.detailState.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const MyShimmer(),
  success: (data) => DetailView(data: data),
  error: (e) => ErrorView(message: e.toString()),
);
```

---

## 3. `PaginationState<T>` — lists / infinite scroll

States: `initial`, `loading`, `loadingMore`, `success`, `error`, `errorMore`.
Holds: `data` (`List<T>`), `meta` (`MetaEntity?`), `exception`, `query` (`PaginationParams`).

Useful getters: `isLoading`, `isLoadingMore`, `isSuccess`, `isError`, `isErrorMore`,
`isEmpty`/`isNotEmpty`, `itemCount`, `hasMore`, **`canLoadMore`**, `currentPage`, `totalPages`, `totalItems`.

Transition methods (return a new state):
| Method | Use when |
|---|---|
| `toLoading({query})` | first page / refresh (clears data) |
| `toLoadingMore()` | next page (keeps data, bumps query.page) |
| `toSuccess(newData, {meta})` | page 1 replaces, page>1 **appends** automatically |
| `toSuccessFromEntity(BasePaginationEntity)` | when repo returns the CMS pagination entity |
| `toError(e)` | first-page error (clears data) |
| `toErrorMore(e)` | load-more error (keeps existing data) |

### First load
```dart
Future<void> _getList(GetListEvent event) async {
  if (state.listState.isLoading) return;
  final params = event.params;                       // a PaginationParams subclass
  emit(state.copyWith(listState: state.listState.toLoading(query: params)));

  final result = await _getListUseCase(params);
  result.when(
    success: (data) => data != null
        ? emit(state.copyWith(listState: state.listState.toSuccess(data.items, meta: data.meta)))
        : emit(state.copyWith(listState: state.listState.toError(Exception('No data received')))),
    error: (e) => emit(state.copyWith(listState: state.listState.toError(e ?? Exception('Unknown')))),
  );
}
```

### Load more (note: `toErrorMore` keeps the list visible)
```dart
Future<void> _loadMore(LoadMoreEvent event) async {
  if (!state.listState.canLoadMore) return;          // single source of truth
  emit(state.copyWith(listState: state.listState.toLoadingMore()));

  final result = await _getListUseCase(event.params);
  result.when(
    success: (data) => emit(state.copyWith(
      listState: state.listState.toSuccess(data?.items ?? const [], meta: data?.meta))),
    error: (e) => emit(state.copyWith(
      listState: state.listState.toErrorMore(e ?? Exception('Unknown')))),
  );
}
```

### Scroll trigger (in a `StatefulWidget` body)
```dart
void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent * 0.8) {
    final cubit = context.read<{Feature}Cubit>();
    final s = cubit.state.listState;
    if (s.canLoadMore && cubit.state.currentQuery != null) {
      cubit.doIntent(LoadMoreEvent(
        query: cubit.state.currentQuery!.copyWith(page: s.currentPage + 1)));
    }
  }
}
```

### Rendering with `.when`
```dart
state.listState.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const ListShimmer(),
  loadingMore: (items) => ListView(items: items, footerLoading: true),
  success: (items, meta) => ListView(items: items),
  error: (e) => ErrorView(onRetry: ...),
  errorMore: (items, e) => ListView(items: items), // keep showing what we have
);
```

---

## 4. UI helpers — `handleBuilderState` / `handleBuilderStateList`

Shorter than `.when` for the common loading/success/empty/error split. They return `Widget?`
(remember the `?? const SizedBox.shrink()`).

```dart
// BaseState
state.detailState.handleBuilderState(
  onLoading: const MyShimmer(),
  onSuccess: DetailView(data: state.detailState.data),
  onError: const ErrorView(),
) ?? const SizedBox.shrink();

// PaginationState (note onEmpty)
state.listState.handleBuilderStateList(
  onLoading: const ListShimmer(),
  onSuccess: SuccessView(items: state.listState.data),
  onEmpty: const EmptyView(),
  onError: const ErrorView(),
) ?? const SizedBox.shrink();
```

Behavior notes:
- Default `onLoading` is a `CupertinoActivityIndicator` if you omit it.
- `handleBuilderStateList` returns `onEmpty` when `success && isEmpty`, and `onSuccess` for `loadingMore`.
- Pair with `buildWhen` scoped to the slice you render to avoid rebuilding the whole screen.

---

## 5. `PaginationParams` + `FilterParam` — query building

`PaginationParams` has `page` (default 1), `limit` (default 10), `filterList`. `toJson()` emits
`page`, `limit`, and every active filter. Subclass it for feature queries and override `filterList`.

```dart
class CoursesParams extends PaginationParams {
  final String? subjectId;
  final bool? isActive;

  const CoursesParams({this.subjectId, this.isActive, super.page, super.limit})
      : super(filterList: const []);

  @override
  List<FilterParam> get filterList => [
        if (subjectId != null) FilterParam(key: 'subject', value: subjectId!),
        if (isActive != null) FilterParam(key: 'is_active', value: isActive!),
      ];

  @override
  CoursesParams copyWith({String? subjectId, bool? isActive, int? page, int? limit}) =>
      CoursesParams(
        subjectId: subjectId ?? this.subjectId,
        isActive: isActive ?? this.isActive,
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );

  @override
  Map<String, dynamic> toJson() {
    final base = <String, dynamic>{
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
    for (final f in filterList) {
      if (f.isActive && f.value != null) base[f.key] = f.value;
    }
    return base;
  }

  @override
  List<Object?> get props => [...super.props, subjectId, isActive];
}
```

Gotchas:
- The base `copyWith` signature only accepts `page`/`limit`. If you need to copy custom fields,
  **override `copyWith`** in your subclass (as above).
- Pass the params to `toLoading(query: params)` so refresh/load-more can rebuild the query.
- Range/operator filters are just keys: `FilterParam(key: 'endDate[gte]', value: iso)`.

---

## 6. Cubit conventions (every feature)
- One Cubit per feature, `@injectable`, named constructor params.
- Override `emit` to guard `isClosed`:
  ```dart
  @override
  void emit(MyStates state) { if (!isClosed) super.emit(state); }
  ```
- Single `Future<void> doIntent(MyEvents e)` switch over a `sealed` event family.
- Re-entry guard at the top of each handler (`if (state.x.isLoading) return;`).
- Keep a `currentQuery` in state if you support refresh/load-more.
- `clearError()` / `reset()` helpers as needed.

---

## Related skills
- `flutter-clean-architecture-feature.md` — where these fit in the layers
- `flutter-feature-templates.md` — paste-ready cubit/state code
- `shared-global-data-feature.md` — `BasePaginationDto`/`toSuccessFromEntity` for CMS lists
- `shimmer-skeletonizer-guide.md` — loading widgets for `onLoading`

**Last verified**: May 2026 against `config/base_state/*`, `feature/reviews`, `config/shared/global`.
