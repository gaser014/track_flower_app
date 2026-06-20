# Shimmer Loading Guide

## 📋 Overview

This skill covers how to create shimmer/skeleton loading effects for grid, list, and custom layouts in the Darsy project using `CustomShimmerContainer` and the `shimmer` package.

---

## 🏗️ Architecture: Where Shimmer Files Live

```
feature/{feature_name}/presentation/widgets/
├── shimmer/
│   ├── {feature}_shimmer.dart          # Full-page shimmer (initial load)
│   ├── {feature}_shimmer_more.dart     # Load-more shimmer (pagination)
│   └── {feature}_section_shimmer.dart  # Section-level shimmer (home grid)
```

---

## 🧱 Core Widget: `CustomShimmerContainer`

Located at: `lib/core/widgets/custom_shimmer_container.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  const CustomShimmerContainer({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 12,
  });

  final double height, width, borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
```

**Usage:** Use this as a building block to compose shimmer placeholders that match your real UI.

---

## 🔲 Grid Shimmer Templates

### Horizontal Grid Shimmer (e.g., Home Categories)

For a horizontal scrolling grid with 2 rows of category items:

```dart
import 'package:darsy/core/widgets/custom_shimmer_container.dart';
import 'package:flutter/material.dart';

class CategoriesSectionShimmer extends StatelessWidget {
  const CategoriesSectionShimmer({super.key, this.rows = 2, this.columns = 4});

  final int rows;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < rows; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              columns,
              (_) => const _ShimmerCategoryItem(),
            ),
          ),
        ],
      ],
    );
  }
}

class _ShimmerCategoryItem extends StatelessWidget {
  const _ShimmerCategoryItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image placeholder
        CustomShimmerContainer(
          width: 80,
          height: 80,
          borderRadius: 20,
        ),
        const SizedBox(height: 4),
        // Text placeholder
        CustomShimmerContainer(
          width: 56,
          height: 14,
          borderRadius: 4,
        ),
      ],
    );
  }
}
```

### Vertical Grid Shimmer

For a non-scrolling vertical grid (e.g., 4 columns):

```dart
class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        mainAxisExtent: 105,
      ),
      itemBuilder: (context, index) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomShimmerContainer(
              width: 80,
              height: 80,
              borderRadius: 16,
            ),
          ),
          const SizedBox(height: 4),
          CustomShimmerContainer(
            width: 56,
            height: 14,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}
```

---

## 📃 List Shimmer Templates

### Full-Page List Shimmer (Card Layout)

```dart
import 'package:darsy/core/widgets/custom_shimmer_container.dart';
import 'package:darsy/core/values/app_spacing.dart';
import 'package:flutter/material.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key, this.itemCount = 10});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.lg),
          sliver: SliverList.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) => const _ShimmerCardItem(),
          ),
        ),
      ],
    );
  }
}

class _ShimmerCardItem extends StatelessWidget {
  const _ShimmerCardItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          // Image placeholder
          CustomShimmerContainer(
            width: AppSpacing.cardImageSize,
            height: AppSpacing.cardImageSize,
            borderRadius: AppSpacing.radiusMd,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                CustomShimmerContainer(
                  height: AppSpacing.lg,
                  width: double.infinity,
                  borderRadius: AppSpacing.radiusSm,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Subtitle placeholder
                CustomShimmerContainer(
                  height: 14,
                  width: 100,
                  borderRadius: AppSpacing.radiusSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Load-More Shimmer (Pagination)

```dart
class ListShimmerMore extends StatelessWidget {
  const ListShimmerMore({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverList.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const _ShimmerCardItem(),
          ),
        ),
      ],
    );
  }
}
```

---

## 📐 Grid Layout Rules

### ⚠️ Horizontal Grid inside CustomScrollView
**CRITICAL**: Must have a **fixed height** via `SizedBox`.

```dart
// ✅ Correct
SliverToBoxAdapter(
  child: SizedBox(
    height: 248,
    child: GridView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of ROWS
      ),
      itemBuilder: (context, index) => ItemWidget(),
    ),
  ),
)

// ❌ Wrong — CRASHES
GridView.builder(
  shrinkWrap: true,
  scrollDirection: Axis.horizontal,  // Cannot combine!
)
```

### Vertical Grid inside CustomScrollView

```dart
// ✅ Correct
SliverToBoxAdapter(
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,  // Number of COLUMNS
    ),
    itemBuilder: (context, index) => ItemWidget(),
  ),
)
```

---

## 🔗 Integration with State Handlers

### With `handleBuilderStateList` (PaginationState)
```dart
BlocBuilder<CategoriesCubit, CategoriesStates>(
  builder: (context, state) {
    return state.categoriesState.handleBuilderStateList(
      onLoading: const CategoriesSectionShimmer(),
      onSuccess: HomeCategoriesSuccess(
        homeCategories: state.categoriesState.data,
      ),
    ) ?? const SizedBox.shrink();
  },
)
```

### With `handleBuilderState` (BaseState)
```dart
BlocBuilder<MyCubit, MyStates>(
  builder: (context, state) {
    return state.myState.handleBuilderState(
      onLoading: const MyShimmer(),
      onSuccess: MySuccessWidget(data: state.myState.data),
    ) ?? const SizedBox.shrink();
  },
)
```

---

## 🎨 Shimmer Design Rules

| Element | Width | Height | Border Radius |
|---------|-------|--------|---------------|
| Category icon | 80 | 80 | 20 |
| Category text | 56 | 14 | 4 |
| Card image | `AppSpacing.cardImageSize` | `AppSpacing.cardImageSize` | `AppSpacing.radiusMd` |
| Card title | `double.infinity` | `AppSpacing.lg` | `AppSpacing.radiusSm` |
| Card subtitle | 100 | 14 | `AppSpacing.radiusSm` |
| Banner/Slider | `double.infinity` | 180 | 12 |

---

## 🔧 Quick Checklist

When creating a shimmer for a new section:

- [ ] Match the shimmer layout to the real widget's structure (same grid, same sizes)
- [ ] Use `CustomShimmerContainer` for each placeholder element
- [ ] For horizontal grids: wrap in `SizedBox(height: ...)` — NEVER use `shrinkWrap: true`
- [ ] For vertical grids: use `shrinkWrap: true` + `NeverScrollableScrollPhysics()`
- [ ] Pass shimmer widget via `onLoading` parameter of `handleBuilderState` / `handleBuilderStateList`
- [ ] Place shimmer files in `widgets/shimmer/` directory under the feature
- [ ] Use separate widget classes, not private classes (per common-mistakes skill)

---

## 📚 Related Skills

- `common-mistakes-and-fixes.md` — Widget extraction rules
- `flutter-clean-architecture-feature.md` — Feature structure
- `categories-feature.md` — Categories feature reference

---

**Last Updated**: May 2026
**Version**: 1.0.0
