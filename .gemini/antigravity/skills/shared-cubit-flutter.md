---
name: shared-cubit-flutter
description: >
  Flutter pattern for using SharedCubit (governorates, cities, grades, subjects) with
  MultiBlocProvider per route — not globally. Use this skill whenever the user needs to
  load shared/lookup data (cities, grades, governorates, subjects) in a specific screen
  or flow in the Darsy app, or when wiring SharedCubit state to DropdownField widgets.
  Trigger on phrases like "shared data في screen", "DropdownField مع SharedCubit",
  "محتاج governorates في صفحة", "MultiBlocProvider pattern", or any request to connect
  shared lookup data to a UI screen or form.
---

# SharedCubit Per-Route Pattern

## المبدأ

SharedCubit بيتوفر **عند الـ Route** بس مش على مستوى التطبيق كله — كل screen بيجيب بس اللي محتاجه.

```
❌ App Level  → هتعمل API calls زيادة
✅ Route Level → بس لما الـ screen يفتح
```

---

## 1. Route Setup

### Screen بسيط (صفحة واحدة)

```dart
class RegisterRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(
          create: (_) => getIt<SharedCubit>()
            ..doIntent(const LoadGovernoratesEvent())
            ..doIntent(const LoadGradeEvent())
            ..doIntent(const LoadSubjectsEvent()),
        ),
      ],
      child: const RegisterScreen(),
    );
  }
}
```

### Multi-step Flow (wizard / onboarding)

```dart
class RegisterFlowRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        // SharedCubit فوق كل الـ steps — مش لكل step لوحده
        BlocProvider(
          create: (_) => getIt<SharedCubit>()
            ..doIntent(const LoadGovernoratesEvent())
            ..doIntent(const LoadGradeEvent()),
        ),
      ],
      child: const RegisterFlowNavigator(), // handles step1, step2, step3
    );
  }
}
```

### ما بيحتاجش SharedCubit

```dart
// Login, OTP, Settings → مش محتاجين shared data
class LoginRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const LoginScreen(),
    );
  }
}
```

---

## 2. DropdownField مع SharedCubit

### Governorates Dropdown

```dart
BlocBuilder<SharedCubit, SharedStates>(
  buildWhen: (prev, curr) =>
      prev.governoratesState != curr.governoratesState,
  builder: (context, state) {
    final govsState = state.governoratesState;

    if (govsState.isLoading) {
      return const DropdownFieldSkeleton();
    }

    return DropdownField(
      controller: _governorateController,
      labelText: 'المحافظة',
      iconPath: AppImages.icLocationPin,
      items: govsState.data.map((g) => g.name).toList(),
      onChanged: (value) {
        final selected = govsState.data.firstWhere((g) => g.name == value);
        // trigger cities load when governorate changes
        context.read<SharedCubit>().doIntent(
          LoadCitiesEvent(governorateId: selected.id),
        );
      },
    );
  },
)
```

### Cities Dropdown (تابع للـ Governorate)

```dart
BlocBuilder<SharedCubit, SharedStates>(
  buildWhen: (prev, curr) => prev.citiesState != curr.citiesState,
  builder: (context, state) {
    final citiesState = state.citiesState;

    return DropdownField(
      controller: _cityController,
      labelText: 'المدينة',
      iconPath: AppImages.icMapPin,
      enabled: citiesState.data.isNotEmpty,
      items: citiesState.data.map((c) => c.name).toList(),
    );
  },
)
```

### Grades Dropdown

```dart
BlocBuilder<SharedCubit, SharedStates>(
  buildWhen: (prev, curr) => prev.gradesState != curr.gradesState,
  builder: (context, state) {
    return DropdownField(
      controller: _gradeController,
      labelText: 'الصف الدراسي',
      items: state.gradesState.data.map((g) => g.name).toList(),
    );
  },
)
```

### Subjects Dropdown

```dart
BlocBuilder<SharedCubit, SharedStates>(
  buildWhen: (prev, curr) => prev.subjectsState != curr.subjectsState,
  builder: (context, state) {
    return DropdownField(
      controller: _subjectController,
      labelText: 'المادة',
      items: state.subjectsState.data.map((s) => s.nameAr).toList(),
    );
  },
)
```

---

## 3. Governorate → City Chain

الـ cities بتتحمل بعد ما المستخدم يختار محافظة — مش مع بداية الـ screen.

```dart
DropdownField(
  controller: _governorateController,
  labelText: 'المحافظة',
  items: state.governoratesState.data.map((g) => g.name).toList(),
  onChanged: (value) {
    // امسح اختيار المدينة القديم
    _cityController.clear();

    final gov = state.governoratesState.data.firstWhere((g) => g.name == value);
    context.read<SharedCubit>().doIntent(
      LoadCitiesEvent(governorateId: gov.id),
    );
  },
)
```

---

## 4. كل Feature بيحمّل إيه

| Screen | SharedCubit؟ | بيحمّل |
|---|---|---|
| Login | ❌ | — |
| OTP | ❌ | — |
| Register | ✅ | govs + grades + subjects |
| Edit Profile | ✅ | govs + grades |
| Create Order | ✅ | subjects + govs |
| Settings | ❌ | — |
| Home | ❌ | — |

---

## 5. القاعدة السريعة

```
محتاج shared data في screen؟
  → Route Level MultiBlocProvider
  → حمّل بس اللي الـ screen محتاجه
  → DropdownField يسمع لـ SharedCubit بـ BlocBuilder
  → Cities بس تتحمل بعد اختيار Governorate (lazy)
```