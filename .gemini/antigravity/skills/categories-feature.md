---
inclusion: manual
---

# Categories Feature Skill

End-to-end recipe for adding (or regenerating) the `categories` (Subjects/Sections)
feature in the Darsy app. Follows the same pattern as `sliders-feature.md`.

> Figma reference: [`190:1220` — Subjects Categories](https://www.figma.com/design/4BF7msiybooQdIfUc2tLTe/Darsy-Design-v01?node-id=190-1220)

---

## 1. When to Use

Activate this skill when:

- You need a grid of CMS-managed subject/section categories.
- You want the home section widget with header ("الأقسام" + "عرض الكل") and
  a 2-row × 4-column icon grid.
- You want the same Clean Architecture footprint as `feature/categories`.

---

## 2. Backend Contract

Endpoint: `GET /api/v1/sections`

Sample item:

```json
{
  "_id": "category_123456789",
  "name": "الرياضيات",
  "nameEn": "Mathematics",
  "icon": "https://example.com/categories/math_icon.png",
  "isActive": true,
  "order": 1,
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": "2026-01-15T10:30:00.000Z"
}
```

Single-item endpoint: `GET /api/v1/sections/:id`.

---

## 3. Generate the Feature

Update `lib/clean_arch_generator.dart` config to `featureName: 'categories'`
with the JSON above, then:

```bash
dart run lib/clean_arch_generator.dart
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 4. Required Manual Touch-ups

### 4.1 `domain/entities/categories_params.dart`

Remove `super.filterList` from the constructor (same issue as sliders):

```dart
const CategoriesParams({
  this.subjectId,
  super.page,
  super.limit,
}) : super(filterList: const []);
```

### 4.2 `presentation/widgets/categories_shimmer.dart`

Replace `AppColors.gray10` → `AppColors.lightGray` / `AppColors.white`.

### 4.3 `presentation/widgets/empty_categories_widget.dart`

Replace `AppStrings` → `DataStrings.tryAdjustingFilters` and
`AppColors.gray40` → `AppColors.darkGray`.

### 4.4 `presentation/widgets/category_card.dart`

The generator emits `category.imageUrl` and `category.price` which don't exist.
Replace with `category.icon` and `category.nameEn`.

### 4.5 `data/repositories/categories_repository_impl.dart`

Remove the unused `category_dto.dart` import.

### 4.6 `presentation/cubit/categories_cubit.dart`

Wrap one-line `if` returns in braces.

---

## 5. Home Section UI

### Design tokens (from Figma `190:1220`)

| Property | Value | Token |
|----------|-------|-------|
| Container bg | `#F8FAFC` | `AppColors.neutralBackground` |
| Container padding | `px:16 py:12` | — |
| Header title | `20px #0F172A` | `AppColors.neutralDark` |
| "عرض الكل" | `12px #334155` | `AppColors.darkGray` |
| Item icon size | `80×80` | — |
| Icon radius | `20px` | — |
| Label | `14px #1A1A1A` | `AppColors.color00Primary` |
| Label gap | `4px` | — |
| Row gap | `16px` | — |
| Items per row | `4` | — |

### Usage

```dart
// In home screen — shows 2 rows of 4 categories
CategoriesSection(
  onViewAll: () => context.push('/categories'),
  onCategoryTap: (cat) => context.push('/category/${cat.id}'),
);
```

Or standalone:

```dart
const CategoriesPage();
```

### Key widgets

- `CategoriesSection` — full section with BlocProvider, header, grid, shimmer
- `CategoryItem` — single 80×80 icon + label (used in the grid)
- `CategoriesSectionShimmer` — 2-row shimmer placeholder
- `CategoryCard` — admin-style list card (used in paginated list screen)

---

## 6. Category Icons

Icons are stored in `assets/images/categories/` and registered in `pubspec.yaml`.
Constants are in `AppImages` (`lib/core/values/app_assets.dart`):

```dart
AppImages.categoryScience
AppImages.categoryEnglish
AppImages.categoryMath
AppImages.categoryArabic
AppImages.categoryBiology
AppImages.categoryChemistry
AppImages.categoryPhysics
```

The `CategoryFixtures` class uses these local paths for offline/dummy data.
When the API returns a remote URL, `CategoryItem` uses `CachedNetworkImage`.

---

## 7. Dependency Injection

After regeneration run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Confirm `di.config.dart` registers:

- `CategoriesApiClient` (lazySingleton)
- `CategoriesRemoteDataSourceContract` → `CategoriesRemoteDataSourceImpl`
- `CategoriesRepository` → `CategoriesRepositoryImpl`
- `GetCategoriesUseCase`, `GetCategoryByIdUseCase`
- `CategoriesCubit` (factory)

---

## 8. Testing

```bash
flutter analyze lib/feature/categories
```

Expect: `No issues found!`.

---

## 9. Project Conventions Reminders

Same as `sliders-feature.md` — repositories return entities, use `Result.when`,
single cubit per feature, top-level widget classes.

---

**Last updated**: May 2026
**Owner**: Darsy Mobile Team
