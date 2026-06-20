---
inclusion: manual
---

# Shared Global Data Feature Skill

Comprehensive guide for managing shared/static data (governorates, regions, study stages, lecture types, categories, sliders, support links, notifications) using Clean Architecture with unified base response structure.

> Use this skill when working with any CMS-managed static/reference data that needs to be accessible across the app.

---

## 1. When to Use

Activate this skill when:

- You need to fetch and cache reference data (locations, categories, etc.)
- You want consistent pagination handling across all static data endpoints
- You need dropdown/selection widgets backed by API data
- You want a unified response structure for all filtered/paginated lists

---

## 2. Backend Contract

All shared data endpoints follow the same response structure:

### Base Response Format

```json
{
  "message": "Success message",
  "metadata": {
    "total": 100,
    "limit": 10,
    "currentPage": 1,
    "numberOfPages": 10
  },
  "data": [
    { /* item 1 */ },
    { /* item 2 */ }
  ]
}
```

### Endpoints

#### Governorates
- `GET /api/v1/governorates` - List all governorates
- `GET /api/v1/governorates/:id` - Get single governorate

Sample item:
```json
{
  "_id": "gov_123",
  "displayName": "Cairo",
  "is_active": true,
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

#### Regions (Cities)
- `GET /api/v1/regions?governorate_id=xxx` - List regions by governorate
- `GET /api/v1/regions/:id` - Get single region

Sample item:
```json
{
  "_id": "region_123",
  "displayName": "Nasr City",
  "governorate_id": "gov_123",
  "is_active": true
}
```

#### Study Stages (Grades)
- `GET /api/v1/study-stages` - List all study stages
- `GET /api/v1/study-stages/:id` - Get single study stage

Sample item:
```json
{
  "_id": "stage_123",
  "displayName": "Secondary School",
  "is_active": true
}
```

#### Lecture Types
- `GET /api/v1/lecture-types` - List all lecture types
- `GET /api/v1/lecture-types/:id` - Get single lecture type

Sample item:
```json
{
  "_id": "type_123",
  "displayName": "Group Session",
  "description": "Sessions for multiple students",
  "price_onsite": 100,
  "price_online": 80,
  "platform_percentage_onsite": 10,
  "platform_percentage_online": 15,
  "is_active": true
}
```

#### Categories (Subjects)
- `GET /api/v1/categories` - List all categories
- `GET /api/v1/categories/:id` - Get single category

Sample item:
```json
{
  "_id": "cat_123",
  "displayName": "Mathematics",
  "icon": "math-icon-url",
  "status": "active",
  "order": 1
}
```

---

## 3. Architecture Pattern

### Directory Structure

```
lib/config/shared/global/
├── api/
│   ├── api_client/shared_api_client.dart
│   └── data_sources/
│       ├── shared_remote_data_source_impl.dart
│       └── shared_local_data_source_impl.dart
├── data/
│   ├── data_sources/{remote,local}_data_source_contract.dart
│   ├── fixtures/shared_fixtures.dart
│   ├── models/
│   │   ├── governorate_dto.dart
│   │   ├── governorates_response_dto.dart
│   │   ├── city_dto.dart
│   │   ├── cities_response_dto.dart
│   │   ├── grade_dto.dart
│   │   ├── grades_response_dto.dart
│   │   ├── lecture_type_dto.dart
│   │   ├── lecture_types_response_dto.dart
│   │   ├── subject_dto.dart
│   │   └── subjects_response_dto.dart
│   └── repositories/shared_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── governorate_entity.dart
│   │   ├── city_entity.dart
│   │   ├── grade_entity.dart
│   │   ├── lecture_type_entity.dart
│   │   └── subject_entity.dart
│   ├── repositories/shared_repository.dart
│   └── use_cases/
│       ├── get_governorates_use_case.dart
│       ├── get_cities_use_case.dart
│       ├── get_grades_use_case.dart
│       ├── get_lecture_types_use_case.dart
│       └── get_subjects_use_case.dart
└── presentation/
    ├── cubit/{shared_cubit.dart, shared_events.dart, shared_states.dart}
    └── widgets/
        ├── governorate_dropdown_field.dart
        ├── city_dropdown_field.dart
        ├── education_level_dropdown_field.dart
        ├── subject_dropdown_field.dart
        └── teaching_mode_dropdown_field.dart
```

---

## 4. Unified Base Response Pattern

### 4.1 Response DTO Template

All response DTOs extend `BasePaginationDto`:

```dart
class GovernoratesResponseDto extends BasePaginationDto<GovernorateDto> {
  final List<GovernorateDto>? governorates;

  const GovernoratesResponseDto({
    super.message,
    super.metadata,
    this.governorates,
  }) : super(data: governorates);

  factory GovernoratesResponseDto.fromJson(Map<String, dynamic> json) {
    return GovernoratesResponseDto(
      message: json['message'],
      metadata: json['metadata'] != null 
          ? MetaDto.fromJson(json['metadata']) 
          : null,
      governorates: (json['governorates'] as List?)
          ?.map((e) => GovernorateDto.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['governorates'] = governorates?.map((e) => e.toJson()).toList();
    return json;
  }

  BasePaginationEntity<GovernorateEntity> toGovernorateEntity() {
    return toEntity<GovernorateEntity>((dto) => dto.toEntity());
  }
}
```

**Key Points:**
- Named field (`governorates`) matches API response key
- Pass named field to `super(data: governorates)`
- `toEntity()` method returns `BasePaginationEntity<EntityType>`
- Metadata field name must match API (`metadata` or `pagination`)

### 4.2 API Client Pattern

```dart
@RestApi()
abstract class SharedApiClient {
  factory SharedApiClient(Dio dio, {String baseUrl}) = _SharedApiClient;

  @GET('/governorates')
  Future<GovernoratesResponseDto> getGovernorates(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/governorates/{id}')
  Future<GovernorateDto> getGovernorateById(@Path('id') String id);

  @GET('/regions')
  Future<CitiesResponseDto> getCities(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/study-stages')
  Future<GradesResponseDto> getGrades(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/lecture-types')
  Future<LectureTypesResponseDto> getLectureTypes(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/categories')
  Future<SubjectsResponseDto> getSubjects(
    @Queries() Map<String, dynamic> queries,
  );
}
```

### 4.3 Params Pattern

All params extend `PaginationParams` and override `filterList`:

```dart
class GovernorateParams extends PaginationParams {
  final bool? isActive;

  const GovernorateParams({
    this.isActive,
    super.page,
    super.limit,
  }) : super(filterList: const []);

  @override
  List<FilterParam> get filterList => [
    if (isActive != null) 
      FilterParam(key: 'is_active', value: isActive!),
  ];

  @override
  GovernorateParams copyWith({
    bool? isActive,
    int? page,
    int? limit,
  }) =>
      GovernorateParams(
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
  List<Object?> get props => [...super.props, isActive];
}
```

**For nested filters (e.g., cities by governorate):**

```dart
class CitiesParams extends PaginationParams {
  final String? governorateId;
  final bool? isActive;

  const CitiesParams({
    this.governorateId,
    this.isActive,
    super.page,
    super.limit,
  }) : super(filterList: const []);

  @override
  List<FilterParam> get filterList => [
    if (governorateId != null) 
      FilterParam(key: 'governorate_id', value: governorateId!),
    if (isActive != null) 
      FilterParam(key: 'is_active', value: isActive!),
  ];

  // ... rest of implementation
}
```

---

## 5. Cubit Pattern

### 5.1 State Structure

```dart
class SharedStates extends Equatable {
  final PaginationState<GovernorateEntity> governoratesState;
  final PaginationState<CityEntity> citiesState;
  final PaginationState<GradeEntity> gradesState;
  final PaginationState<LectureTypeEntity> lectureTypesState;
  final PaginationState<SubjectEntity> subjectsState;

  const SharedStates({
    this.governoratesState = const PaginationState.initial(),
    this.citiesState = const PaginationState.initial(),
    this.gradesState = const PaginationState.initial(),
    this.lectureTypesState = const PaginationState.initial(),
    this.subjectsState = const PaginationState.initial(),
  });

  SharedStates copyWith({
    PaginationState<GovernorateEntity>? governoratesState,
    PaginationState<CityEntity>? citiesState,
    PaginationState<GradeEntity>? gradesState,
    PaginationState<LectureTypeEntity>? lectureTypesState,
    PaginationState<SubjectEntity>? subjectsState,
  }) {
    return SharedStates(
      governoratesState: governoratesState ?? this.governoratesState,
      citiesState: citiesState ?? this.citiesState,
      gradesState: gradesState ?? this.gradesState,
      lectureTypesState: lectureTypesState ?? this.lectureTypesState,
      subjectsState: subjectsState ?? this.subjectsState,
    );
  }

  @override
  List<Object?> get props => [
    governoratesState,
    citiesState,
    gradesState,
    lectureTypesState,
    subjectsState,
  ];
}
```

### 5.2 Events Pattern

```dart
sealed class SharedEvents extends Equatable {
  const SharedEvents();
}

// Fetch events
class GetGovernoratesEvent extends SharedEvents {
  final GovernorateParams? params;
  const GetGovernoratesEvent({this.params});
  @override
  List<Object?> get props => [params];
}

class GetCitiesEvent extends SharedEvents {
  final CitiesParams? params;
  const GetCitiesEvent({this.params});
  @override
  List<Object?> get props => [params];
}

// Load more events
class LoadMoreGovernoratesEvent extends SharedEvents {
  final GovernorateParams params;
  const LoadMoreGovernoratesEvent({required this.params});
  @override
  List<Object?> get props => [params];
}

class LoadMoreCitiesEvent extends SharedEvents {
  final CitiesParams params;
  const LoadMoreCitiesEvent({required this.params});
  @override
  List<Object?> get props => [params];
}
```

### 5.3 Cubit Implementation Pattern

```dart
Future<void> _getGovernorates(GetGovernoratesEvent event) async {
  if (state.governoratesState.isLoading) return;

  final params = event.params ?? const GovernorateParams();
  emit(
    state.copyWith(
      governoratesState: state.governoratesState.toLoading(query: params),
    ),
  );

  final result = await _getGovernoratesUseCase.call(params);

  result.when(
    success: (data) {
      if (data != null) {
        emit(
          state.copyWith(
            governoratesState:
                state.governoratesState.toSuccessFromEntity(data),
          ),
        );
      } else {
        emit(
          state.copyWith(
            governoratesState: state.governoratesState.toError(
              Exception('No data received'),
            ),
          ),
        );
      }
    },
    error: (exception) {
      emit(
        state.copyWith(
          governoratesState: state.governoratesState.toError(
            exception ?? Exception('Unknown error'),
          ),
        ),
      );
    },
  );
}
```

---

## 6. Dropdown Widget Pattern

### 6.1 Basic Dropdown

```dart
class GovernorateDropdownField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool enabled;

  const GovernorateDropdownField({
    super.key,
    this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedCubit, SharedStates>(
      buildWhen: (previous, current) =>
          previous.governoratesState != current.governoratesState,
      builder: (context, state) {
        return state.governoratesState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const ShimmerDropdownField(),
          loadingMore: (data) => _buildDropdown(context, data),
          success: (data, meta) => _buildDropdown(context, data),
          error: (exception) => ErrorDropdownField(
            errorText: exception.toString(),
            onRetry: () => context.read<SharedCubit>().doIntent(
              const GetGovernoratesEvent(),
            ),
          ),
          errorMore: (data, exception) => _buildDropdown(context, data),
        );
      },
    );
  }

  Widget _buildDropdown(BuildContext context, List<GovernorateEntity> items) {
    return CustomDropdownField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(e.displayName),
              ))
          .toList(),
      onChanged: enabled ? onChanged : null,
      labelText: 'Governorate',
      hintText: 'Select governorate',
      errorText: errorText,
    );
  }
}
```

### 6.2 Dependent Dropdown (Cities depend on Governorate)

```dart
class CityDropdownField extends StatelessWidget {
  final String? governorateId;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool enabled;

  const CityDropdownField({
    super.key,
    required this.governorateId,
    this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch cities when governorate changes
    useEffect(() {
      if (governorateId != null) {
        context.read<SharedCubit>().doIntent(
          GetCitiesEvent(
            params: CitiesParams(governorateId: governorateId),
          ),
        );
      }
      return null;
    }, [governorateId]);

    return BlocBuilder<SharedCubit, SharedStates>(
      buildWhen: (previous, current) =>
          previous.citiesState != current.citiesState,
      builder: (context, state) {
        if (governorateId == null) {
          return CustomDropdownField<String>(
            value: null,
            items: const [],
            onChanged: null,
            labelText: 'City',
            hintText: 'Select governorate first',
            enabled: false,
          );
        }

        return state.citiesState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const ShimmerDropdownField(),
          loadingMore: (data) => _buildDropdown(context, data),
          success: (data, meta) => _buildDropdown(context, data),
          error: (exception) => ErrorDropdownField(
            errorText: exception.toString(),
            onRetry: () => context.read<SharedCubit>().doIntent(
              GetCitiesEvent(
                params: CitiesParams(governorateId: governorateId),
              ),
            ),
          ),
          errorMore: (data, exception) => _buildDropdown(context, data),
        );
      },
    );
  }

  Widget _buildDropdown(BuildContext context, List<CityEntity> items) {
    return CustomDropdownField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(e.displayName),
              ))
          .toList(),
      onChanged: enabled ? onChanged : null,
      labelText: 'City',
      hintText: 'Select city',
      errorText: errorText,
    );
  }
}
```

---

## 7. Common Patterns & Best Practices

### 7.1 Naming Conventions

| Backend Field | DTO Field | Entity Field | Display |
|--------------|-----------|--------------|---------|
| `displayName` | `displayName` | `displayName` | "Cairo" |
| `_id` | `id` | `id` | - |
| `is_active` | `isActive` | `isActive` | - |
| `governorate_id` | `governorateId` | `governorateId` | - |

### 7.2 Response Key Mapping

The API response key must match the DTO field name:

```json
{
  "governorates": [...],  // ← Must match DTO field name
  "metadata": {...}
}
```

```dart
class GovernoratesResponseDto extends BasePaginationDto<GovernorateDto> {
  final List<GovernorateDto>? governorates;  // ← Must match JSON key
  
  const GovernoratesResponseDto({
    super.message,
    super.metadata,
    this.governorates,
  }) : super(data: governorates);  // ← Pass to super
}
```

### 7.3 Metadata Field Variations

Some endpoints use `metadata`, others use `pagination`:

```dart
// Option 1: metadata
metadata: json['metadata'] != null 
    ? MetaDto.fromJson(json['metadata']) 
    : null,

// Option 2: pagination
metadata: json['pagination'] != null 
    ? MetaDto.fromJson(json['pagination']) 
    : null,
```

Check the actual API response and adjust accordingly.

### 7.4 Filter Params Best Practices

```dart
// ✅ GOOD: Override filterList
@override
List<FilterParam> get filterList => [
  if (isActive != null) FilterParam(key: 'is_active', value: isActive!),
  if (governorateId != null) FilterParam(key: 'governorate_id', value: governorateId!),
];

// ❌ BAD: Don't pass filterList to super constructor
const CitiesParams({
  this.governorateId,
  super.page,
  super.limit,
}) : super(filterList: [...]); // ← Don't do this
```

### 7.5 Cubit State Management

```dart
// ✅ GOOD: Check loading state before fetching
if (state.governoratesState.isLoading) return;

// ✅ GOOD: Use toSuccessFromEntity for BasePaginationEntity
state.governoratesState.toSuccessFromEntity(data)

// ✅ GOOD: Handle null data
if (data != null) {
  emit(state.copyWith(...));
} else {
  emit(state.copyWith(
    governoratesState: state.governoratesState.toError(
      Exception('No data received'),
    ),
  ));
}
```

---

## 8. Testing the Feature

### 8.1 Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 8.2 Verify DI Registration

Check `lib/config/dependency_injection/di.config.dart` for:

- `SharedApiClient` (lazySingleton)
- `SharedRemoteDataSourceContract` → `SharedRemoteDataSourceImpl`
- `SharedRepository` → `SharedRepositoryImpl`
- All use cases (`GetGovernoratesUseCase`, etc.)
- `SharedCubit` (factory)

### 8.3 Run Analyzer

```bash
flutter analyze lib/config/shared/global
```

Expect: `No issues found!`

---

## 9. Migration Checklist

When refactoring existing shared data:

- [ ] Create unified response DTOs extending `BasePaginationDto`
- [ ] Update API client with `@Queries()` for all list endpoints
- [ ] Create params classes extending `PaginationParams`
- [ ] Update repository to return `BasePaginationEntity<T>`
- [ ] Update cubit to use `PaginationState<T>`
- [ ] Update widgets to use `state.when()` pattern
- [ ] Run build_runner
- [ ] Test all dropdowns and data fetching
- [ ] Verify pagination works correctly
- [ ] Check error handling and retry logic

---

## 10. Related Skills

- `sliders-feature.md` - Similar pagination pattern
- `categories-feature.md` - Category-specific implementation
- `flutter-clean-architecture-feature.md` - General architecture
- `flutter-feature-templates.md` - Code templates
- `common-mistakes-and-fixes.md` - Troubleshooting

---

**Last updated**: May 2026  
**Owner**: Darsy Mobile Team
