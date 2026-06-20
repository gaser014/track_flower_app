---
inclusion: manual
---

# Sliders Feature Skill

End-to-end recipe for adding (or regenerating) a `sliders` feature in the Darsy
app. Covers JSON-driven Clean Architecture generation, integration with the
existing project conventions, and the reusable banner UI that matches the home
screen design (header banner with auto-play and dotted indicators).

> Use this skill any time you need to scaffold or refactor a similar carousel
> banner feature (header / footer / influencer sliders).

---

## 1. When to Use

Activate this skill when:

- You need a paginated list of CMS-managed banners (image **or** video).
- You want a horizontal `PageView` carousel with auto-play and indicators.
- You want the same Clean Architecture footprint as `feature/sliders` already
  scaffolded in the codebase (api / data / domain / presentation layers).

---

## 2. Backend Contract

Endpoint: `GET /api/v1/sliders`

Sample item:

```json
{
  "_id": "slider_123456789",
  "showIn": "top",                 // top | bottom | influencer
  "image": "https://.../banner.jpg",
  "title": "عرض خاص على الدورات",
  "video": "https://.../promo.mp4", // optional
  "startDate": "2026-01-01T00:00:00.000Z",
  "endDate": "2026-12-31T23:59:59.000Z",
  "active": true,
  "isSmall": false,
  "createdAt": "...",
  "updatedAt": "..."
}
```

Single-item endpoint: `GET /api/v1/sliders/:id`.

---

## 3. Generate the Feature

The Clean Architecture generator at `lib/clean_arch_generator.dart` already has
a `sliders` config. To regenerate:

```bash
dart run lib/clean_arch_generator.dart
flutter pub run build_runner build --delete-conflicting-outputs
```

The generator produces:

```
lib/feature/sliders/
├── api/
│   ├── api_client/sliders_api_client.dart
│   └── data_sources/
│       ├── sliders_remote_data_source_impl.dart
│       └── sliders_local_data_source_impl.dart
├── data/
│   ├── data_sources/{remote,local}_data_source_contract.dart
│   ├── fixtures/slider_fixtures.dart
│   ├── models/{slider_dto.dart, sliders_response_dto.dart}
│   └── repositories/sliders_repository_impl.dart
├── domain/
│   ├── entities/{slider_entity.dart, sliders_params.dart}
│   ├── repositories/sliders_repository.dart
│   └── use_cases/{get_sliders.dart, get_slider_by_id.dart}
└── presentation/
    ├── cubit/{sliders_cubit.dart, sliders_events.dart, sliders_states.dart}
    ├── screen/sliders_page.dart
    └── widgets/
        ├── slider_card.dart           (admin-style list card)
        ├── empty_sliders_widget.dart
        ├── sliders_body.dart
        ├── sliders_shimmer.dart
        ├── sliders_banner.dart        (HOME banner, public widget)
        ├── sliders_banner_shimmer.dart
        └── sliders_video_item.dart
```

---

## 4. Required Manual Touch-ups

The generator emits a few stubs that won’t compile out of the box. Apply these
edits after every regeneration:

### 4.1 `domain/entities/sliders_params.dart`

`PaginationParams` doesn’t expose `isActive` / `isDeleted` super params. Replace
them with a local `active` field and override `filterList` + `toJson`:

```dart
class SlidersParams extends PaginationParams {
  final SliderType? type;
  final String? influencerId;
  final bool? active;

  const SlidersParams({
    this.type,
    this.influencerId,
    this.active,
    super.page,
    super.limit,
  }) : super(filterList: const []);

  @override
  List<FilterParam> get filterList => [
    if (type != null) FilterParam(key: 'showIn', value: type!.value),
    if (influencerId != null) FilterParam(key: 'influencer', value: influencerId!),
    if (active != null) FilterParam(key: 'active', value: active!),
    FilterParam(key: 'endDate[gte]', value: DateTime.now().toUtc().toIso8601String()),
    FilterParam(key: 'startDate[lte]', value: DateTime.now().toUtc().toIso8601String()),
  ];

  @override
  SlidersParams copyWith({SliderType? type, String? influencerId, bool? active, int? page, int? limit}) =>
      SlidersParams(
        type: type ?? this.type,
        influencerId: influencerId ?? this.influencerId,
        active: active ?? this.active,
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
  List<Object?> get props => [...super.props, type, influencerId, active];
}
```

### 4.2 `presentation/widgets/sliders_shimmer.dart`

Replace `AppColors.gray10` with the existing tokens:

```dart
return Shimmer.fromColors(
  baseColor: AppColors.lightGray,
  highlightColor: AppColors.white,
  ...
);
```

### 4.3 `presentation/widgets/empty_sliders_widget.dart`

`AppStrings` and `AppColors.gray40` don’t exist. Use the actual project tokens:

```dart
import 'package:darsy/core/values/app_strings.dart';
...
Text('لا توجد سلايدرات',
  style: AppFontStyle.medium18(context).copyWith(color: AppColors.darkGray)),
Text(DataStrings.tryAdjustingFilters,
  style: AppFontStyle.regular14(context).copyWith(color: AppColors.gray30)),
```

### 4.4 `presentation/widgets/slider_card.dart`

Swap `withOpacity` → `withValues(alpha: …)` (Flutter 3+ deprecation).

### 4.5 `data/repositories/sliders_repository_impl.dart`

Remove the unused `slider_dto.dart` import.

### 4.6 `presentation/cubit/sliders_cubit.dart`

In `fetchSlidersByType`, the param is `active: true`, not `isActive: true`.
Wrap one-line `if` returns in braces to satisfy the curly-braces lint.

### 4.7 Drop `slider_carousel.dart`

The generator still emits a carousel that depends on `carousel_slider` and
`smooth_page_indicator`. Those are **not** in `pubspec.yaml`. Delete the file and
use `sliders_banner.dart` (below) instead.

---

## 5. Home Banner UI

A reusable banner widget that matches the figma frame
[`Sliders / 189:1206`](https://www.figma.com/design/4BF7msiybooQdIfUc2tLTe/Darsy-Design-v01?node-id=189-1206):

- White container, `pt:16 px:16` (top + horizontal padding)
- Card aspect-ratio `327 × 164` (15px corner radius), dark navy `#0e1f33`
  background with cover image fill
- Indicators below the card: 5 pills of `32 × 3 px`, `2px` gap, `4px` radius
- Active pill: brand green `#37bea9` (`AppColors.fillYARJ7Z`)
- Inactive pill: neutral `#e4e4e7` (`AppColors.fill2EO3R6`)
- Auto-play every 4s, supports image **or** video items

```dart
// In any home / dashboard screen
const SlidersBanner(
  type: SliderType.header,   // or .footer, .influencer
  autoPlay: true,
);
```

Or use the standalone preview screen:

```dart
// Standalone scaffold (matches the figma frame exactly)
const SlidersPage(type: SliderType.header);
```

The widget creates its own `SlidersCubit` via `getIt<SlidersCubit>()` and calls
`fetchSlidersByType(type)` automatically. Pass `onSliderTap` to handle
navigation when a banner is tapped.

### 5.1 Important sub-widgets

- `SlidersBannerShimmer` – placeholder while loading (same 15px radius card)
- `SlidersVideoItem` – pauses when its page is offscreen, mutes by default,
  loops, and falls back to `fallbackImageUrl` on error

### 5.2 Wiring into the home tab

The `feature/layout/domain/entities/page_enum.dart` currently uses an empty
`Container()` for the home tab. Plug the banner into that page (or whichever
home widget you build) like so:

```dart
// In your home page body
ListView(
  children: const [
    SlidersBanner(),
    SizedBox(height: 16),
    // ...rest of the home content
  ],
);
```

---

## 6. Dependency Injection

After regeneration always run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Confirm `lib/config/dependency_injection/di.config.dart` registers:

- `SlidersApiClient` (lazySingleton)
- `SlidersRemoteDataSourceContract` → `SlidersRemoteDataSourceImpl`
- `SlidersRepository` → `SlidersRepositoryImpl`
- `GetSlidersUseCase`, `GetSliderByIdUseCase`
- `SlidersCubit` (factory)

If anything is missing, double-check the `@injectable` annotations survived the
manual edits.

---

## 7. Testing the Feature

Run Flutter analyzer scoped to the feature:

```bash
flutter analyze lib/feature/sliders
```

Expect: `No issues found!`. Anything else means a manual touch-up was missed —
re-check section 4.

---

## 8. Project Conventions Reminders

- Repositories return **entities**, never DTOs.
- Use `Result.when(success:, error:)` instead of try/catch.
- Cubits use a single state class with one event family (`sealed class`).
- Widgets are top-level classes, not method-builder functions.
- Prefer composing small private/top-level widgets over giant build methods.

See also:

- `flutter-clean-architecture-feature.md`
- `flutter-feature-templates.md`
- `common-mistakes-and-fixes.md`

---

**Last updated**: May 2026
**Owner**: Darsy Mobile Team
