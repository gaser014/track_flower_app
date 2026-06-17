import 'dart:convert';
import 'dart:developer';
import 'dart:io';

/// Elevate Exam App - Clean Architecture Feature Generator
///
/// This script generates complete feature modules following the architecture
/// patterns used in the Elevate Exam App project.
///
/// Key Features:
/// - Injectable dependency injection
/// - json_serializable for DTOs
/// - Result pattern (Success/Error)
/// - PaginationState with mixins
/// - Events pattern with Cubit
/// - BasePaginationDto inheritance
/// - Contract pattern for data sources
/// - Separate API client layer
/// - Comprehensive shimmer effects

//flutter pub run build_runner build --delete-conflicting-outputs
//flutter pub run build_runner watch
//flutter pub run build_runner build
void main() async {
  print('🚀 Starting generator...');
  final generator = ElevateCleanArchGenerator();
  await generator.generateFeature();
  print('✅ Generator completed!');
}

class ElevateCleanArchGenerator {
  late final FeatureConfig config;

  Future<void> generateFeature() async {
    config = _loadConfiguration();

    log("🚀 Generating feature: ${config.featureName}");
    log("📁 Creating directory structure...");

    await _createDirectoryStructure();
    await _generateAllFiles();

    log("✅ Feature '${config.featureName}' generated successfully!");
    log("📝 Don't forget to:");
    log("   - Run 'flutter pub run build_runner build'");
    log("   - Add routes if needed");
    log("   - Update dependency injection");
  }

  FeatureConfig _loadConfiguration() {
    // ═══════════════════════════════════════════════════════════════════════
    // 🎯 PROJECT CONFIGURATION
    // ═══════════════════════════════════════════════════════════════════════
    // Modify these values to match your project structure
    const projectConfig = ProjectConfig(
      packageName: 'flowers_app', // Your app's package name
      configBasePath: 'config', // Path to config folder
      coreWidgetsPath: 'core/widgets', // Path to core widgets
      coreValuesPath: 'core/values', // Path to core values (colors, etc.)
      generateBaseClasses: false, // Set true to generate base classes
      endPointsFieldName: null, // e.g., 'products' for EndPoints.products
    );

    // ═══════════════════════════════════════════════════════════════════════
    // 🧪 FEATURE CONFIGURATION
    // ═══════════════════════════════════════════════════════════════════════
    // This configuration tests ALL generator features:
    // - Paginated methods (lists with pagination)
    // - Single entity methods (get by ID)
    // - POST methods (create)
    // - PUT methods (update)
    // - DELETE methods (delete)
    // - All parameter types
    // - All return types
    // - All feature flags

    return FeatureConfig(
      featureName: 'products',
      projectConfig: projectConfig,
      jsonData: """
         {
            "_id": "69d988754461df0f939b5817",
            "title": "Wdding Flower",
            "slug": "wdding-flower",
            "description": "This is a Pack of White Widding Flowers",
            "imgCover": "https://flower.elevateegy.com/uploads/fefa790a-f0c1-42a0-8699-34e8fc065812-cover_image.png",
            "images": [
                "https://flower.elevateegy.com/uploads/66c36d5d-c067-46d9-b339-d81be57e0149-image_one.png",
                "https://flower.elevateegy.com/uploads/f27e1903-74cf-4ed6-a42c-e43e35b6dd14-image_three.png",
                "https://flower.elevateegy.com/uploads/500fe197-0e16-4b01-9a0d-031ccb032714-image_two.png"
            ],
            "price": 250,
            "priceAfterDiscount": 100,
            "discount": 60,
            "rateAvg": 0,
            "rateCount": 0,
            "sold": 34,
            "quantity": 186,
            "category": "69d988704461df0f939b57cc",
            "occasion": "69d988724461df0f939b57ea",
            "isSuperAdmin": false,
            "createdAt": "2026-04-10T23:32:05.613Z",
            "updatedAt": "2026-04-30T17:44:58.852Z",
            "__v": 0,
            "favoriteId": null,
            "isInWishlist": false
        }
      """,
      methods: {
        // 1️⃣ PAGINATED METHOD - Tests pagination, LoadMore, RefreshIndicator
        MethodConfig(
          name: 'getAllProducts',
          type: MethodType.get,
          returnType: ReturnType.paginatedEntity,
          paramType: ParamType.pagination,
          apiPath: '/api/v1/products',
        ),
        //
        // // 2️⃣ SINGLE ENTITY METHOD - Tests BaseState, single entity handling
        // MethodConfig(
        //   name: 'getProductById',
        //   type: MethodType.get,
        //   returnType: ReturnType.singleEntity,
        //   paramType: ParamType.string,
        //   apiPath: '/api/v1/products',
        // ),
        //
        // // 3️⃣ CREATE METHOD - Tests POST, entity params
        // MethodConfig(
        //   name: 'createProduct',
        //   type: MethodType.post,
        //   returnType: ReturnType.singleEntity,
        //   paramType: ParamType.entity,
        //   apiPath: '/api/v1/products',
        // ),
        //
        // // 4️⃣ UPDATE METHOD - Tests PUT, entity params
        // MethodConfig(
        //   name: 'updateProduct',
        //   type: MethodType.put,
        //   returnType: ReturnType.singleEntity,
        //   paramType: ParamType.entity,
        //   apiPath: '/api/v1/products',
        // ),
        //
        // // 5️⃣ DELETE METHOD - Tests DELETE, void return type
        // MethodConfig(
        //   name: 'deleteProduct',
        //   type: MethodType.delete,
        //   returnType: ReturnType.void_,
        //   paramType: ParamType.string,
        //   apiPath: '/api/v1/products',
        // ),

        // Note: searchProducts removed - it duplicates getProducts functionality
        // Use getProducts with search params instead
      },
      features: {
        FeatureFlag.pagination: true, // ✅ Tests pagination logic
        FeatureFlag.events: true, // ✅ Tests event generation
        FeatureFlag.shimmer: true, // ✅ Tests shimmer widget
        FeatureFlag.emptyState: true, // ✅ Tests empty state widget
      },
    );
  }

  Future<void> _createDirectoryStructure() async {
    final baseDir = Directory("./lib/feature/${config.fileNameBase}");

    // Following 4-layer architecture: api → data → domain → presentation
    final directories = [
      // Api Layer (outermost - depends on data)
      '${baseDir.path}/api/api_client',
      '${baseDir.path}/api/data_sources',

      // Data Layer (depends on domain)
      '${baseDir.path}/data/data_sources',
      '${baseDir.path}/data/fixtures',
      '${baseDir.path}/data/models',
      '${baseDir.path}/data/repositories',

      // Domain Layer (pure - no dependencies)
      '${baseDir.path}/domain/entities',
      '${baseDir.path}/domain/repositories',
      '${baseDir.path}/domain/use_cases',

      // Presentation Layer (depends on domain)
      '${baseDir.path}/presentation/cubit',
      '${baseDir.path}/presentation/screen',
      '${baseDir.path}/presentation/widgets',
    ];

    for (var dir in directories) {
      await Directory(dir).create(recursive: true);
      log("📁 Created: $dir");
    }
  }

  Future<void> _generateAllFiles() async {
    final jsonData = jsonDecode(config.jsonData);

    // Domain Layer
    await _generateEntity(jsonData);
    await _generateParams();
    await _generateRepository();
    await _generateUseCases();

    // Data Layer
    await _generateFixtures(jsonData);
    await _generateDto(jsonData);
    await _generateResponseDto();
    await _generateDataSourceContracts();
    await _generateRepositoryImplementation();

    // API Layer
    await _generateApiClient();
    await _generateDataSourceImplementations();

    // Presentation Layer
    await _generateCubitFiles();
    await _generateScreen();
    await _generateWidgets();
  }

  // Domain Layer Generators
  Future<void> _generateEntity(Map<String, dynamic> jsonData) async {
    final filePath =
        './lib/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';

    final generator = EntityGenerator(config, jsonData);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Entity");
  }

  Future<void> _generateParams() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';

    final generator = ParamsGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Params");
  }

  Future<void> _generateRepository() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/domain/repositories/${config.fileNameBase}_repository.dart';

    final generator = RepositoryGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Repository Interface");
  }

  Future<void> _generateUseCases() async {
    for (var method in config.methods) {
      final fileName = method.name.toSnakeCase();
      final filePath =
          './lib/feature/${config.fileNameBase}/domain/use_cases/$fileName.dart';

      final useCaseGenerator = UseCaseGenerator(config, method);
      final content = useCaseGenerator.generate();

      await File(filePath).writeAsString(content);
    }
    log("✅ Generated: Use Cases (${config.methods.length})");
  }

  // Data Layer Generators
  Future<void> _generateFixtures(Map<String, dynamic> jsonData) async {
    final filePath =
        './lib/feature/${config.fileNameBase}/data/fixtures/${config.singularFileNameBase}_fixtures.dart';

    final generator = FixturesGenerator(config, jsonData);
    await File(filePath).writeAsString(generator.generate());
    log("✅ Generated: Fixtures");
  }

  Future<void> _generateDto(Map<String, dynamic> jsonData) async {
    final filePath =
        './lib/feature/${config.fileNameBase}/data/models/${config.singularFileNameBase}_dto.dart';

    final generator = DtoGenerator(config, jsonData);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: DTO");
  }

  Future<void> _generateResponseDto() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/data/models/${config.fileNameBase}_response_dto.dart';

    final generator = ResponseDtoGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Response DTO");
  }

  Future<void> _generateDataSourceContracts() async {
    final remoteFilePath =
        './lib/feature/${config.fileNameBase}/data/data_sources/${config.fileNameBase}_remote_data_source_contract.dart';
    final localFilePath =
        './lib/feature/${config.fileNameBase}/data/data_sources/${config.fileNameBase}_local_data_source_contract.dart';

    final remoteGenerator = RemoteDataSourceContractGenerator(config);
    final localGenerator = LocalDataSourceContractGenerator(config);

    await File(remoteFilePath).writeAsString(remoteGenerator.generate());
    await File(localFilePath).writeAsString(localGenerator.generate());

    log("✅ Generated: Data Source Contracts");
  }

  Future<void> _generateRepositoryImplementation() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/data/repositories/${config.fileNameBase}_repository_impl.dart';

    final generator = RepositoryImplementationGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Repository Implementation");
  }

  // API Layer Generators
  Future<void> _generateApiClient() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/api/api_client/${config.fileNameBase}_api_client.dart';

    final generator = ApiClientGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: API Client");
  }

  Future<void> _generateDataSourceImplementations() async {
    final remoteFilePath =
        './lib/feature/${config.fileNameBase}/api/data_sources/${config.fileNameBase}_remote_data_source_impl.dart';
    final localFilePath =
        './lib/feature/${config.fileNameBase}/api/data_sources/${config.fileNameBase}_local_data_source_impl.dart';

    final remoteGenerator = RemoteDataSourceImplGenerator(config);
    final localGenerator = LocalDataSourceImplGenerator(config);

    await File(remoteFilePath).writeAsString(remoteGenerator.generate());
    await File(localFilePath).writeAsString(localGenerator.generate());

    log("✅ Generated: Data Source Implementations");
  }

  // Presentation Layer Generators
  Future<void> _generateCubitFiles() async {
    final cubitPath =
        './lib/feature/${config.fileNameBase}/presentation/cubit/${config.fileNameBase}_cubit.dart';
    final eventsPath =
        './lib/feature/${config.fileNameBase}/presentation/cubit/${config.fileNameBase}_events.dart';
    final statesPath =
        './lib/feature/${config.fileNameBase}/presentation/cubit/${config.fileNameBase}_states.dart';

    final cubitGenerator = CubitGenerator(config);
    final eventsGenerator = EventsGenerator(config);
    final statesGenerator = StatesGenerator(config);

    await File(cubitPath).writeAsString(cubitGenerator.generate());
    await File(eventsPath).writeAsString(eventsGenerator.generate());
    await File(statesPath).writeAsString(statesGenerator.generate());

    log("✅ Generated: Cubit, Events & States");
  }

  Future<void> _generateScreen() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/presentation/screen/${config.fileNameBase}_page.dart';

    final generator = ScreenGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
    log("✅ Generated: Screen");
  }

  Future<void> _generateWidgets() async {
    await _generateBodyWidget();
    await _generateShimmerWidget();
    await _generateProductCard(); // Add product card generation
    if (config.hasFeature(FeatureFlag.emptyState)) {
      await _generateEmptyWidget();
    }

    log("✅ Generated: Widgets");
  }

  Future<void> _generateProductCard() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/presentation/widgets/${config.singularFileNameBase}_card.dart';

    final generator = ProductCardGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
  }

  Future<void> _generateBodyWidget() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/presentation/widgets/${config.fileNameBase}_body.dart';

    final generator = BodyWidgetGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
  }

  Future<void> _generateShimmerWidget() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/presentation/widgets/${config.fileNameBase}_shimmer.dart';

    final generator = ShimmerWidgetGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
  }

  Future<void> _generateEmptyWidget() async {
    final filePath =
        './lib/feature/${config.fileNameBase}/presentation/widgets/empty_${config.fileNameBase}_widget.dart';

    final generator = EmptyWidgetGenerator(config);
    final content = generator.generate();

    await File(filePath).writeAsString(content);
  }
}

// Configuration Classes
class ProjectConfig {
  final String packageName;
  final String configBasePath;
  final String coreWidgetsPath;
  final String coreValuesPath;
  final bool generateBaseClasses;
  final String? endPointsFieldName;

  const ProjectConfig({
    this.packageName = 'exam_app',
    this.configBasePath = 'config',
    this.coreWidgetsPath = 'core/widgets',
    this.coreValuesPath = 'core/values',
    this.generateBaseClasses = false,
    this.endPointsFieldName,
  });

  /// Helper to build package import path
  String packageImport(String path) => "import 'package:$packageName/$path';";
}

class FeatureConfig {
  final String featureName;
  final String jsonData;
  final Set<MethodConfig> methods;
  final Map<FeatureFlag, bool> features;
  final ProjectConfig projectConfig;

  FeatureConfig({
    required this.featureName,
    required this.jsonData,
    required this.methods,
    required this.features,
    this.projectConfig = const ProjectConfig(),
  });

  String get fileNameBase => featureName.toLowerCase().replaceAll(' ', '_');

  String get singularFileNameBase =>
      featureName.toSingular().toLowerCase().replaceAll(' ', '_');

  String get classNameBase => featureName.toPascalCase();

  String get singularClassNameBase => featureName.toSingular().toPascalCase();

  String get camelCaseNameBase => featureName.toCamelCase();

  String get singularCamelCaseNameBase =>
      featureName.toSingular().toCamelCase();

  bool hasFeature(FeatureFlag flag) => features[flag] ?? false;

  bool get hasPagination => hasFeature(FeatureFlag.pagination);

  bool get hasEvents => hasFeature(FeatureFlag.events);

  bool get hasShimmer => hasFeature(FeatureFlag.shimmer);

  bool get hasEmptyState => hasFeature(FeatureFlag.emptyState);
}

class MethodConfig {
  final String name;
  final MethodType type;
  final ReturnType returnType;
  final ParamType paramType;
  final String apiPath;

  MethodConfig({
    required this.name,
    required this.type,
    required this.returnType,
    required this.paramType,
    required this.apiPath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MethodConfig &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

// Enums
enum MethodType { get, post, put, delete }

enum ReturnType { paginatedEntity, singleEntity, void_ }

enum ParamType { pagination, entity, string, none }

enum FeatureFlag { pagination, events, shimmer, emptyState }

// Generator Interfaces
abstract interface class ICodeGenerator {
  String generate();
}

abstract interface class CodeGenerator implements ICodeGenerator {
  final FeatureConfig config;

  CodeGenerator(this.config);

  @override
  String generate();

  /// Helper to build package import statement
  String packageImport(String path) {
    return "import 'package:${config.projectConfig.packageName}/$path';";
  }

  /// Helper to write package import to StringBuffer
  void writePackageImport(StringBuffer buffer, String path) {
    buffer.write("import 'package:");
    buffer.write(config.projectConfig.packageName);
    buffer.write("/");
    buffer.write(path);
    buffer.writeln("';");
  }
}

// ============================================================================
// DOMAIN LAYER GENERATORS
// ============================================================================

class EntityGenerator extends CodeGenerator {
  final Map<String, dynamic> jsonData;

  EntityGenerator(super.config, this.jsonData);

  @override
  String generate() {
    final properties = _generateProperties();
    final constructorParams = _generateConstructorParams();
    final copyWithParams = _generateCopyWithParams();
    final copyWithBody = _generateCopyWithBody();
    final propsGetter = _generatePropsGetter();

    return '''
import 'package:equatable/equatable.dart';

class ${config.singularClassNameBase}Entity extends Equatable {
$properties

  const ${config.singularClassNameBase}Entity({
$constructorParams
  });

  ${config.singularClassNameBase}Entity copyWith({
$copyWithParams
  }) {
    return ${config.singularClassNameBase}Entity(
$copyWithBody
    );
  }

  @override
  List<Object?> get props => [
$propsGetter
      ];
}
''';
  }

  String _generateProperties() {
    return jsonData.entries
        .map((entry) {
          final key = entry.key == '_id' ? 'id' : entry.key;
          final type = _getDartType(entry.value, key);
          return '  final $type $key;';
        })
        .join('\n');
  }

  String _generateConstructorParams() {
    return jsonData.keys
        .map((key) {
          final paramName = key == '_id' ? 'id' : key;
          return '    this.$paramName,';
        })
        .join('\n');
  }

  String _generatePropsGetter() {
    return jsonData.keys
        .map((key) {
          final paramName = key == '_id' ? 'id' : key;
          return '        $paramName,';
        })
        .join('\n');
  }

  String _generateCopyWithParams() {
    return jsonData.entries
        .map((entry) {
          final key = entry.key == '_id' ? 'id' : entry.key;
          final type = _getDartType(entry.value, key);
          return '    $type $key,';
        })
        .join('\n');
  }

  String _generateCopyWithBody() {
    return jsonData.entries
        .map((entry) {
          final key = entry.key == '_id' ? 'id' : entry.key;
          return '      $key: $key ?? this.$key,';
        })
        .join('\n');
  }

  String _getDartType(dynamic value, String key) {
    if (value == null) return 'String?';

    // Check if it's a List first
    if (value is List) {
      if (value.isEmpty) {
        return 'List<String>?';
      }
      final firstItem = value.first;
      if (firstItem is String) {
        return 'List<String>?';
      } else if (firstItem is int) {
        return 'List<int>?';
      } else if (firstItem is double) {
        return 'List<double>?';
      } else if (firstItem is bool) {
        return 'List<bool>?';
      }
      return 'List<dynamic>?';
    }

    // Check value type
    switch (value.runtimeType) {
      case const (String):
        // Only treat as DateTime if it's a valid date string
        if ((key.toLowerCase().contains('date') ||
                key.toLowerCase().contains('at')) &&
            DateTime.tryParse(value) != null) {
          return 'DateTime?';
        }
        return 'String?';
      case const (int):
        return 'int?';
      case const (double):
        return 'double?';
      case const (bool):
        return 'bool?';
      default:
        // For unknown types, check if name suggests it's a date
        if (key.toLowerCase().contains('date') ||
            key.toLowerCase().contains('at')) {
          return 'DateTime?';
        }
        return 'String?';
    }
  }
}

class FixturesGenerator extends CodeGenerator {
  final Map<String, dynamic> jsonData;

  FixturesGenerator(super.config, this.jsonData);

  @override
  String generate() {
    final buffer = StringBuffer();
    buffer.write("import 'package:");
    buffer.write(config.projectConfig.packageName);
    buffer.write("/feature/");
    buffer.write(config.fileNameBase);
    buffer.write("/domain/entities/");
    buffer.write(config.singularFileNameBase);
    buffer.writeln("_entity.dart';");
    buffer.writeln();
    buffer.writeln('class ${config.singularClassNameBase}Fixtures {');
    buffer.writeln('  ${config.singularClassNameBase}Fixtures._();');
    buffer.writeln();
    buffer.writeln(
      '  static List<${config.singularClassNameBase}Entity> get dummy${config.classNameBase} => List.generate(',
    );
    buffer.writeln('        60,');
    buffer.writeln('        (index) => ${config.singularClassNameBase}Entity(');

    for (var entry in jsonData.entries) {
      final key = entry.key == '_id' ? 'id' : entry.key;
      final value = entry.value;

      if (key == 'id') {
        buffer.writeln("          $key: '\${index + 1}',");
      } else if (value is String) {
        if ((entry.key.toLowerCase().contains('date') ||
                entry.key.toLowerCase().contains('at')) &&
            DateTime.tryParse(value) != null) {
          buffer.writeln("          $key: DateTime(2026, 1, index + 1),");
        } else if (key.toLowerCase().contains('url') ||
            key.toLowerCase().contains('image')) {
          buffer.writeln("          $key: '$value',");
        } else {
          buffer.writeln("          $key: '$value \${index + 1}',");
        }
      } else if (value is int) {
        buffer.writeln("          $key: $value + index,");
      } else if (value is double) {
        buffer.writeln("          $key: $value + index,");
      } else if (value is bool) {
        buffer.writeln("          $key: index % 2 == 0,");
      } else if (value is List) {
        if (value.isEmpty) {
          buffer.writeln("          $key: [],");
        } else {
          final firstItem = value.first;
          if (firstItem is String) {
            buffer.writeln("          $key: ['${value.join("', '")}'],");
          } else {
            buffer.writeln("          $key: $value,");
          }
        }
      } else {
        buffer.writeln("          $key: null,");
      }
    }

    buffer.writeln('        ),');
    buffer.writeln('      );');
    buffer.writeln('}');
    return buffer.toString();
  }
}

class ParamsGenerator extends CodeGenerator {
  ParamsGenerator(super.config);

  @override
  String generate() {
    if (!config.hasPagination) {
      return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/uses_cases/params.dart';

class ${config.singularClassNameBase}Params extends Params {
  final String id;

  const ${config.singularClassNameBase}Params({required this.id});

  @override
  List<Object?> get props => [id];
}
''';
    }

    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/uses_cases/pagination_params.dart';

class ${config.classNameBase}Params extends PaginationParams {
  final String? subjectId;

  const ${config.classNameBase}Params({
    this.subjectId,
    super.page,
    super.limit,
    super.filterList,
  });

  @override
  ${config.classNameBase}Params copyWith({
    String? subjectId,
    int? page,
    int? limit,
  }) {
    return ${config.classNameBase}Params(
      subjectId: subjectId ?? this.subjectId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      filterList: filterList,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    if (subjectId != null) json['subjectId'] = subjectId;
    return json;
  }

  @override
  List<Object?> get props => [...super.props, subjectId];
}
''';
  }
}

class RepositoryGenerator extends CodeGenerator {
  RepositoryGenerator(super.config);

  @override
  String generate() {
    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/entity/base_pagination_entity.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/result.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';

abstract interface  class ${config.classNameBase}Repository {
${_generateMethods()}
}
''';
  }

  String _generateMethods() {
    return config.methods
        .map((method) {
          final methodName = method.name;
          final returnType = _getReturnType(method);
          final paramName = _getParamName(method);
          final paramType = _getParamType(method);

          return '  Future<Result<$returnType>> $methodName({required $paramType $paramName});';
        })
        .join('\n\n');
  }

  String _getReturnType(MethodConfig method) {
    switch (method.returnType) {
      case ReturnType.paginatedEntity:
        return 'BasePaginationEntity<${config.singularClassNameBase}Entity>';
      case ReturnType.singleEntity:
        return '${config.singularClassNameBase}Entity';
      case ReturnType.void_:
        return 'void';
    }
  }

  String _getParamType(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return '${config.classNameBase}Params';
      case ParamType.entity:
        return '${config.singularClassNameBase}Entity';
      case ParamType.string:
        return 'String';
      case ParamType.none:
        return 'void';
    }
  }

  String _getParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }
}

class UseCaseGenerator extends CodeGenerator {
  final MethodConfig method;

  UseCaseGenerator(super.config, this.method);

  @override
  String generate() {
    final className = '${method.name.toPascalCase()}UseCase';
    final returnType = _getReturnType();
    final paramType = _getParamType();
    final repoParamName = _getRepoParamName();

    final imports = StringBuffer();
    if (method.returnType == ReturnType.paginatedEntity) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/entity/base_pagination_entity.dart';",
      );
    }
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/result.dart';",
    );
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/uses_cases/use_cases.dart';",
    );
    if (method.returnType != ReturnType.void_) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';",
      );
    }
    if (method.paramType == ParamType.pagination) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';",
      );
    }
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/repositories/${config.fileNameBase}_repository.dart';",
    );
    imports.writeln("import 'package:injectable/injectable.dart';");

    return '''
$imports
@lazySingleton
class $className extends UseCase<$returnType, $paramType> {
  final ${config.classNameBase}Repository repository;

  $className(this.repository);

  @override
  Future<Result<$returnType>> call($paramType parm) {
    return repository.${method.name}($repoParamName: parm);
  }
}
''';
  }

  String _getReturnType() {
    switch (method.returnType) {
      case ReturnType.paginatedEntity:
        return 'BasePaginationEntity<${config.singularClassNameBase}Entity>';
      case ReturnType.singleEntity:
        return '${config.singularClassNameBase}Entity';
      case ReturnType.void_:
        return 'void';
    }
  }

  String _getParamType() {
    switch (method.paramType) {
      case ParamType.pagination:
        return '${config.classNameBase}Params';
      case ParamType.entity:
        return '${config.singularClassNameBase}Entity';
      case ParamType.string:
        return 'String';
      case ParamType.none:
        return 'NoParams';
    }
  }

  String _getRepoParamName() {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }
}

// ============================================================================
// DATA LAYER GENERATORS
// ============================================================================

class DtoGenerator extends CodeGenerator {
  final Map<String, dynamic> jsonData;

  DtoGenerator(super.config, this.jsonData);

  @override
  String generate() {
    final properties = _generateProperties();
    final constructorParams = _generateConstructorParams();
    final fromJsonBody = _generateManualFromJson();
    final toJsonBody = _generateManualToJson();
    final toEntityParams = _generateToEntityParams();

    return '''
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';

class ${config.singularClassNameBase}Dto {
$properties

  const ${config.singularClassNameBase}Dto({
$constructorParams
  });

$fromJsonBody

  factory ${config.singularClassNameBase}Dto.fromEntity(${config.singularClassNameBase}Entity entity) {
    return ${config.singularClassNameBase}Dto(
${_generateFromEntityParams()}
    );
  }

$toJsonBody

  ${config.singularClassNameBase}Entity toEntity() {
    return ${config.singularClassNameBase}Entity(
$toEntityParams
    );
  }
}
''';
  }

  String _generateProperties() {
    return jsonData.entries
        .map((entry) {
          final key = entry.key == '_id' ? 'id' : entry.key;
          final type = _getDartType(entry.value, key);
          return '  final $type $key;';
        })
        .join('\n');
  }

  String _generateConstructorParams() {
    return jsonData.keys
        .map((key) {
          final paramName = key == '_id' ? 'id' : key;
          return '    this.$paramName,';
        })
        .join('\n');
  }

  String _generateManualFromJson() {
    final buffer = StringBuffer();
    buffer.writeln(
      '  factory ${config.singularClassNameBase}Dto.fromJson(Map<String, dynamic> json) {',
    );
    buffer.writeln('    return ${config.singularClassNameBase}Dto(');
    for (var entry in jsonData.entries) {
      final key = entry.key == '_id' ? 'id' : entry.key;
      final jsonKey = entry.key;
      final value = entry.value;

      // Check if it's actually a date string
      if (value is String &&
          (entry.key.toLowerCase().contains('date') ||
              entry.key.toLowerCase().contains('at')) &&
          DateTime.tryParse(value) != null) {
        buffer.writeln(
          "      $key: json['$jsonKey'] != null ? DateTime.tryParse(json['$jsonKey']) : null,",
        );
      } else {
        buffer.writeln("      $key: json['$jsonKey'],");
      }
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    return buffer.toString();
  }

  String _generateManualToJson() {
    final buffer = StringBuffer();
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    for (var entry in jsonData.entries) {
      final key = entry.key == '_id' ? 'id' : entry.key;
      final jsonKey = entry.key;
      final value = entry.value;

      // Check if it's actually a date string
      if (value is String &&
          (entry.key.toLowerCase().contains('date') ||
              entry.key.toLowerCase().contains('at')) &&
          DateTime.tryParse(value) != null) {
        buffer.writeln("      '$jsonKey': $key?.toIso8601String(),");
      } else {
        buffer.writeln("      '$jsonKey': $key,");
      }
    }
    buffer.writeln('    };');
    buffer.writeln('  }');
    return buffer.toString();
  }

  String _generateToEntityParams() {
    return jsonData.entries
        .map((entry) {
          final key = entry.key == '_id' ? 'id' : entry.key;
          return '      $key: $key,';
        })
        .join('\n');
  }

  String _generateFromEntityParams() {
    return jsonData.keys
        .map((key) {
          final paramName = key == '_id' ? 'id' : key;
          return '      $paramName: entity.$paramName,';
        })
        .join('\n');
  }

  String _getDartType(dynamic value, String key) {
    if (value == null) return 'String?';

    // Check if it's a List first
    if (value is List) {
      if (value.isEmpty) {
        return 'List<String>?';
      }
      final firstItem = value.first;
      if (firstItem is String) {
        return 'List<String>?';
      } else if (firstItem is int) {
        return 'List<int>?';
      } else if (firstItem is double) {
        return 'List<double>?';
      } else if (firstItem is bool) {
        return 'List<bool>?';
      }
      return 'List<dynamic>?';
    }

    // Check value type
    switch (value.runtimeType) {
      case const (String):
        // Only treat as DateTime if it's a valid date string
        if ((key.toLowerCase().contains('date') ||
                key.toLowerCase().contains('at')) &&
            DateTime.tryParse(value) != null) {
          return 'DateTime?';
        }
        return 'String?';
      case const (int):
        return 'int?';
      case const (double):
        return 'double?';
      case const (bool):
        return 'bool?';
      default:
        // For unknown types, check if name suggests it's a date
        if (key.toLowerCase().contains('date') ||
            key.toLowerCase().contains('at')) {
          return 'DateTime?';
        }
        return 'String?';
    }
  }

  String _getDefaultValue(dynamic value, String key) {
    // Check if it's a List first
    if (value is List) {
      return 'null';
    }

    if (key.toLowerCase().contains('date') ||
        key.toLowerCase().contains('at')) {
      return 'null';
    }

    if (value == null) return "''";

    switch (value.runtimeType) {
      case const (String):
        return "''";
      case const (int):
      case const (double):
        return '0';
      case const (bool):
        return 'false';
      default:
        return "''";
    }
  }
}

class ResponseDtoGenerator extends CodeGenerator {
  ResponseDtoGenerator(super.config);

  @override
  String generate() {
    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/entity/base_pagination_entity.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/model/base_pagination_dto.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/model/meta_dto.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.singularFileNameBase}_dto.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';

class ${config.classNameBase}ResponseDto extends BasePaginationDto<${config.singularClassNameBase}Dto> {
  final List<${config.singularClassNameBase}Dto>? ${config.fileNameBase};

  const ${config.classNameBase}ResponseDto({
    super.message,
    super.metadata,
    this.${config.fileNameBase},
  }) : super(data: ${config.fileNameBase});

  factory ${config.classNameBase}ResponseDto.fromJson(Map<String, dynamic> json) {
    return ${config.classNameBase}ResponseDto(
      message: json['message'],
      metadata: json['metadata'] != null ? MetaDto.fromJson(json['metadata']) : null,
      ${config.fileNameBase}: (json['${config.fileNameBase}'] as List?)
          ?.map((e) => ${config.singularClassNameBase}Dto.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['${config.fileNameBase}'] = ${config.fileNameBase}?.map((e) => e.toJson()).toList();
    return json;
  }

  BasePaginationEntity<${config.singularClassNameBase}Entity> to${config.singularClassNameBase}Entity() {
    return toEntity<${config.singularClassNameBase}Entity>((dto) => dto.toEntity());
  }
}
''';
  }
}

class RemoteDataSourceContractGenerator extends CodeGenerator {
  RemoteDataSourceContractGenerator(super.config);

  @override
  String generate() {
    // Build imports based on what's actually needed
    final imports = StringBuffer();
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/result.dart';",
    );

    // Only import single DTO if there are non-paginated methods
    bool needsSingleDto = config.methods.any(
      (m) => m.returnType != ReturnType.paginatedEntity,
    );
    if (needsSingleDto) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.singularFileNameBase}_dto.dart';",
      );
    }

    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.fileNameBase}_response_dto.dart';",
    );
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';",
    );

    return '''
$imports

abstract interface  class ${config.classNameBase}RemoteDataSourceContract {
${_generateMethods()}
}
''';
  }

  String _generateMethods() {
    return config.methods
        .map((method) {
          final methodName = method.name;
          final returnType = _getReturnType(method);
          final paramType = _getContractParamType(method);
          final paramName = _getContractParamName(method);

          return '  Future<Result<$returnType>> $methodName({required $paramType $paramName});';
        })
        .join('\n\n');
  }

  String _getReturnType(MethodConfig method) {
    switch (method.returnType) {
      case ReturnType.paginatedEntity:
        return '${config.classNameBase}ResponseDto';
      case ReturnType.singleEntity:
        return '${config.singularClassNameBase}Dto';
      case ReturnType.void_:
        return 'void';
    }
  }

  String _getContractParamType(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return '${config.classNameBase}Params';
      case ParamType.entity:
        return '${config.singularClassNameBase}Dto';
      case ParamType.string:
        return 'String';
      case ParamType.none:
        return 'void';
    }
  }

  String _getContractParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }
}

class LocalDataSourceContractGenerator extends CodeGenerator {
  LocalDataSourceContractGenerator(super.config);

  @override
  String generate() {
    return '''
abstract interface  class ${config.classNameBase}LocalDataSourceContract {
  // Add local data source methods here if needed
  // Example: Future<void> cache${config.classNameBase}(List<${config.singularClassNameBase}Dto> ${config.fileNameBase});
}
''';
  }
}

class RepositoryImplementationGenerator extends CodeGenerator {
  RepositoryImplementationGenerator(super.config);

  @override
  String generate() {
    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/entity/base_pagination_entity.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/result.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/data_sources/${config.fileNameBase}_remote_data_source_contract.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/fixtures/${config.singularFileNameBase}_fixtures.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.singularFileNameBase}_dto.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/repositories/${config.fileNameBase}_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ${config.classNameBase}Repository)
class ${config.classNameBase}RepositoryImpl implements ${config.classNameBase}Repository {
  final ${config.classNameBase}RemoteDataSourceContract ${config.camelCaseNameBase}RemoteDataSourceContract;

  ${config.classNameBase}RepositoryImpl({
    required this.${config.camelCaseNameBase}RemoteDataSourceContract,
  });

${_generateMethods()}
}
''';
  }

  String _generateMethods() {
    return config.methods
        .map((method) {
          final methodName = method.name;
          final returnType = _getReturnType(method);
          final paramType = _getParamType(method);
          final paramName = _getParamName(method);
          final contractParamName = _getContractParamName(method);

          if (method.returnType == ReturnType.void_) {
            return '''
  @override
  Future<Result<$returnType>> $methodName({required $paramType $paramName}) async {
    final result = await ${config.camelCaseNameBase}RemoteDataSourceContract.$methodName($contractParamName: $paramName);
    return result.when(
      success: (_) => Success(data: null),
      error: (exception) => Error(exception: exception),
    );
  }''';
          }

          if (method.paramType == ParamType.entity) {
            final mapMethod = method.returnType == ReturnType.paginatedEntity
                ? 'to${config.singularClassNameBase}Entity()'
                : 'toEntity()';
            return '''
  @override
  Future<Result<$returnType>> $methodName({required $paramType $paramName}) async {
    final result = await ${config.camelCaseNameBase}RemoteDataSourceContract.$methodName($contractParamName: ${config.singularClassNameBase}Dto.fromEntity($paramName));
    return result.when(
      success: (data) => Success(data: data?.$mapMethod),
      error: (exception) => Error(exception: exception),
    );
  }''';
          }

          // Use makeDummyData pattern for paginated methods
          if (method.returnType == ReturnType.paginatedEntity) {
            return '''
  @override
  Future<Result<$returnType>> $methodName({required $paramType $paramName}) async {
    final result = await ${config.camelCaseNameBase}RemoteDataSourceContract.$methodName($contractParamName: $paramName);
    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData<${config.singularClassNameBase}Entity>(
        params: $paramName,
        allData: ${config.singularClassNameBase}Fixtures.dummy${config.classNameBase},
      ),
      success: (data) => Success(data: data?.to${config.singularClassNameBase}Entity()),
      error: (exception) => Error(exception: exception),
    );
  }''';
          }

          return '''
  @override
  Future<Result<$returnType>> $methodName({required $paramType $paramName}) async {
    final result = await ${config.camelCaseNameBase}RemoteDataSourceContract.$methodName($contractParamName: $paramName);
    return result.when(
      success: (data) => Success(data: data?.toEntity()),
      error: (exception) => Error(exception: exception),
    );
  }''';
        })
        .join('\n\n');
  }

  String _getReturnType(MethodConfig method) {
    switch (method.returnType) {
      case ReturnType.paginatedEntity:
        return 'BasePaginationEntity<${config.singularClassNameBase}Entity>';
      case ReturnType.singleEntity:
        return '${config.singularClassNameBase}Entity';
      case ReturnType.void_:
        return 'void';
    }
  }

  String _getParamType(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return '${config.classNameBase}Params';
      case ParamType.entity:
        return '${config.singularClassNameBase}Entity';
      case ParamType.string:
        return 'String';
      case ParamType.none:
        return 'void';
    }
  }

  String _getParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }

  String _getContractParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }
}

// ============================================================================
// API LAYER GENERATORS
// ============================================================================

class ApiClientGenerator extends CodeGenerator {
  ApiClientGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}ApiClient';
    final methods = StringBuffer();

    for (final method in config.methods) {
      final httpMethod = method.type == MethodType.get
          ? 'get'
          : method.type == MethodType.post
          ? 'post'
          : method.type == MethodType.put
          ? 'put'
          : 'delete';
      final returnType = method.returnType == ReturnType.paginatedEntity
          ? '${config.classNameBase}ResponseDto'
          : '${config.singularClassNameBase}Dto';

      String paramsDef = '';
      // Use EndPoints if configured, otherwise use raw API path
      String url = config.projectConfig.endPointsFieldName != null
          ? 'EndPoints.${config.projectConfig.endPointsFieldName}'
          : "'${method.apiPath}'";
      String body = '';

      if (method.paramType == ParamType.pagination) {
        paramsDef = '{required ${config.classNameBase}Params params}';
        body = ', queryParameters: params.toJson()';
      } else if (method.paramType == ParamType.string) {
        final idName = '${config.singularCamelCaseNameBase}Id';
        paramsDef = '{required String $idName}';
        url = "'\${$url}/\$$idName'";
      } else if (method.paramType == ParamType.entity) {
        final dtoName = '${config.singularCamelCaseNameBase}';
        paramsDef = '{required ${config.singularClassNameBase}Dto $dtoName}';
        body = ', data: $dtoName.toJson()';
      } else if (method.paramType == ParamType.none) {
        paramsDef = '';
      }

      methods.writeln(
        '  Future<$returnType> ${method.name.toCamelCase()}($paramsDef) async {',
      );
      methods.writeln(
        '    final response = await _dio.$httpMethod($url$body);',
      );
      methods.writeln('    return $returnType.fromJson(response.data);');
      methods.writeln('  }');
      methods.writeln();
    }

    final imports = StringBuffer();
    imports.writeln("import 'package:dio/dio.dart';");

    // Only import EndPoints if configured
    if (config.projectConfig.endPointsFieldName != null) {
      imports.write("import 'package:");
      imports.write(config.projectConfig.packageName);
      imports.write("/");
      imports.write(config.projectConfig.configBasePath);
      imports.writeln("/api/end_points.dart';");
    }

    // Check what imports we need
    bool needsSingleDto = config.methods.any(
      (m) =>
          m.returnType != ReturnType.paginatedEntity ||
          m.paramType == ParamType.entity,
    );
    bool needsParams = config.methods.any(
      (m) => m.paramType == ParamType.pagination,
    );

    // Import single DTO if needed (for return type or entity params)
    if (needsSingleDto) {
      imports.write("import 'package:");
      imports.write(config.projectConfig.packageName);
      imports.write("/feature/");
      imports.write(config.fileNameBase);
      imports.write("/data/models/");
      imports.write(config.singularFileNameBase);
      imports.writeln("_dto.dart';");
    }

    imports.write("import 'package:");
    imports.write(config.projectConfig.packageName);
    imports.write("/feature/");
    imports.write(config.fileNameBase);
    imports.write("/data/models/");
    imports.write(config.fileNameBase);
    imports.writeln("_response_dto.dart';");

    if (needsParams) {
      imports.write("import 'package:");
      imports.write(config.projectConfig.packageName);
      imports.write("/feature/");
      imports.write(config.fileNameBase);
      imports.write("/domain/entities/");
      imports.write(config.fileNameBase);
      imports.writeln("_params.dart';");
    }

    imports.writeln("import 'package:injectable/injectable.dart';");

    return '''
$imports

@lazySingleton
class $className {
  final Dio _dio;
  $className(this._dio);

$methods}
''';
  }
}

class RemoteDataSourceImplGenerator extends CodeGenerator {
  RemoteDataSourceImplGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}RemoteDataSourceImpl';
    final contractName = '${config.classNameBase}RemoteDataSourceContract';
    final apiClientName = '${config.classNameBase}ApiClient';
    final methods = StringBuffer();

    for (final method in config.methods) {
      final returnType = method.returnType == ReturnType.paginatedEntity
          ? '${config.classNameBase}ResponseDto'
          : method.returnType == ReturnType.void_
          ? 'void'
          : '${config.singularClassNameBase}Dto';
      final contractParamType = _getContractParamType(method);
      final contractParamName = _getContractParamName(method);
      final methodName = method.name.toCamelCase();
      final apiParamName = _getApiParamName(method);

      methods.writeln('  @override');
      methods.writeln(
        '  Future<Result<$returnType>> $methodName({required $contractParamType $contractParamName}) async {',
      );
      methods.writeln('    return await executeApi<$returnType>(');
      methods.writeln(
        '      () => apiClient.$methodName($apiParamName: $contractParamName),',
      );
      methods.writeln('    );');
      methods.writeln('  }');
      methods.writeln();
    }

    // Build imports based on what's actually needed
    final imports = StringBuffer();
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/api/api_executor.dart';",
    );
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_response/result.dart';",
    );
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/api/api_client/${config.fileNameBase}_api_client.dart';",
    );
    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/data_sources/${config.fileNameBase}_remote_data_source_contract.dart';",
    );

    // Only import single DTO if there are non-paginated methods
    bool needsSingleDto = config.methods.any(
      (m) => m.returnType != ReturnType.paginatedEntity,
    );
    if (needsSingleDto) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.singularFileNameBase}_dto.dart';",
      );
    }

    imports.writeln(
      "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/models/${config.fileNameBase}_response_dto.dart';",
    );

    bool needsParams = config.methods.any(
      (m) => m.paramType == ParamType.pagination,
    );
    if (needsParams) {
      imports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';",
      );
    }
    imports.writeln("import 'package:injectable/injectable.dart';");

    return '''
$imports

@LazySingleton(as: $contractName)
class $className implements $contractName {
  final $apiClientName apiClient;

  $className({required this.apiClient});

$methods}
''';
  }

  String _getContractParamType(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return '${config.classNameBase}Params';
      case ParamType.entity:
        return '${config.singularClassNameBase}Dto';
      case ParamType.string:
        return 'String';
      case ParamType.none:
        return 'void';
    }
  }

  String _getContractParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }

  String _getApiParamName(MethodConfig method) {
    switch (method.paramType) {
      case ParamType.pagination:
        return 'params';
      case ParamType.entity:
        return config.singularCamelCaseNameBase;
      case ParamType.string:
        return '${config.singularCamelCaseNameBase}Id';
      case ParamType.none:
        return 'params';
    }
  }
}

class LocalDataSourceImplGenerator extends CodeGenerator {
  LocalDataSourceImplGenerator(super.config);

  @override
  String generate() {
    return '''
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/data/data_sources/${config.fileNameBase}_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ${config.classNameBase}LocalDataSourceContract)
class ${config.classNameBase}LocalDataSourceImpl implements ${config.classNameBase}LocalDataSourceContract {
  // Implement local data source methods here
}
''';
  }
}

// ============================================================================
// PRESENTATION LAYER GENERATORS
// ============================================================================

class CubitGenerator extends CodeGenerator {
  CubitGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}Cubit';
    final stateClass = '${config.classNameBase}States';
    final stateName = '${config.camelCaseNameBase}State';

    // Generate use cases
    final useCases = StringBuffer();
    final constructorParams = StringBuffer();
    final constructorInit = StringBuffer();

    // Separate paginated and single entity methods
    final paginatedMethods = config.methods
        .where((m) => m.returnType == ReturnType.paginatedEntity)
        .toList();

    final singleEntityMethods = config.methods
        .where((m) => m.returnType == ReturnType.singleEntity)
        .toList();

    final voidMethods = config.methods
        .where((m) => m.returnType == ReturnType.void_)
        .toList();

    // Generate use cases for all methods
    for (final method in [
      ...paginatedMethods,
      ...singleEntityMethods,
      ...voidMethods,
    ]) {
      final useCaseName = '${method.name.toPascalCase()}UseCase';
      final fieldName = '_${method.name.toCamelCase()}UseCase';
      useCases.writeln('  final $useCaseName $fieldName;');
      constructorParams.writeln(
        '    required $useCaseName ${method.name.toCamelCase()}UseCase,',
      );
      constructorInit.writeln(
        '      $fieldName = ${method.name.toCamelCase()}UseCase,',
      );
    }

    // Generate event handlers
    final handlers = StringBuffer();
    final switchCases = StringBuffer();

    // Generate handlers for paginated methods
    for (final method in paginatedMethods) {
      final eventName = '${method.name.toPascalCase()}Event';
      final methodName = '_${method.name.toCamelCase()}';

      switchCases.writeln('    $eventName() => $methodName(event),');

      handlers.writeln('''
  Future<void> $methodName($eventName event) async {
    if (state.$stateName.isLoading) return;

    final params = event.params ?? ${config.classNameBase}Params(page: 1);
    emit(
      state.copyWith(
        $stateName: state.$stateName.toLoading(query: params),
      ),
    );

    final result = await _${method.name.toCamelCase()}UseCase.call(params);

    result.when(
      success: (data) {
        if (data != null) {
          emit(
            state.copyWith(
              $stateName: state.$stateName.toSuccessFromEntity(data),
            ),
          );
        } else {
          emit(
            state.copyWith(
              $stateName: state.$stateName.toError(
                Exception('No data received'),
              ),
            ),
          );
        }
      },
      error: (exception) {
        emit(
          state.copyWith(
            $stateName: state.$stateName.toError(
              exception ?? Exception('Unknown error'),
            ),
          ),
        );
      },
    );
  }
''');
    }

    // Generate handlers for single entity methods
    for (final method in singleEntityMethods) {
      final eventName = '${method.name.toPascalCase()}Event';
      final methodName = '_${method.name.toCamelCase()}';
      final singleStateName = '${method.name.toCamelCase()}State';

      switchCases.writeln('    $eventName() => $methodName(event),');

      // Determine the parameter to pass to use case based on paramType
      String useCaseParam;
      switch (method.paramType) {
        case ParamType.string:
          useCaseParam = 'event.id';
          break;
        case ParamType.entity:
          useCaseParam = 'event.entity';
          break;
        case ParamType.pagination:
          useCaseParam = 'event.params';
          break;
        case ParamType.none:
          useCaseParam = 'NoParams()';
          break;
      }

      handlers.writeln('''
  Future<void> $methodName($eventName event) async {
    if (state.$singleStateName.isLoading) return;

    emit(
      state.copyWith(
        $singleStateName: const BaseState.loading(),
      ),
    );

    final result = await _${method.name.toCamelCase()}UseCase.call($useCaseParam);

    result.when(
      success: (data) {
        if (data != null) {
          emit(
            state.copyWith(
              $singleStateName: BaseState.success(data),
            ),
          );
        } else {
          emit(
            state.copyWith(
              $singleStateName: BaseState.error(
                Exception('No data received'),
              ),
            ),
          );
        }
      },
      error: (exception) {
        emit(
          state.copyWith(
            $singleStateName: BaseState.error(
              exception ?? Exception('Unknown error'),
            ),
          ),
        );
      },
    );
  }
''');
    }

    // Generate handlers for void methods (e.g. delete)
    for (final method in voidMethods) {
      final eventName = '${method.name.toPascalCase()}Event';
      final methodName = '_${method.name.toCamelCase()}';
      final voidStateName = '${method.name.toCamelCase()}State';

      switchCases.writeln('    $eventName() => $methodName(event),');

      String useCaseParam;
      switch (method.paramType) {
        case ParamType.string:
          useCaseParam = 'event.id';
          break;
        case ParamType.entity:
          useCaseParam = 'event.entity';
          break;
        case ParamType.pagination:
          useCaseParam = 'event.params';
          break;
        case ParamType.none:
          useCaseParam = 'NoParams()';
          break;
      }

      handlers.writeln('''
  Future<void> $methodName($eventName event) async {
    if (state.$voidStateName.isLoading) return;

    emit(
      state.copyWith(
        $voidStateName: const BaseState.loading(),
      ),
    );

    final result = await _${method.name.toCamelCase()}UseCase.call($useCaseParam);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            $voidStateName: BaseState.success(data),
          ),
        );
      },
      error: (exception) {
        emit(
          state.copyWith(
            $voidStateName: BaseState.error(
              exception ?? Exception('Unknown error'),
            ),
          ),
        );
      },
    );
  }
''');
    }

    // Add LoadMore handler if pagination is enabled
    if (config.hasPagination && paginatedMethods.isNotEmpty) {
      switchCases.writeln(
        '    LoadMore${config.classNameBase}Event() => _loadMore(event),',
      );

      final firstMethod = paginatedMethods.first;
      handlers.writeln('''
  Future<void> _loadMore(LoadMore${config.classNameBase}Event event) async {
    if (!state.$stateName.canLoadMore) return;

    emit(state.copyWith($stateName: state.$stateName.toLoadingMore()));

    final result = await _${firstMethod.name.toCamelCase()}UseCase.call(event.params);

    result.when(
      success: (data) {
        if (data != null) {
          emit(
            state.copyWith(
              $stateName: state.$stateName.toSuccessFromEntity(data),
            ),
          );
        } else {
          emit(
            state.copyWith(
              $stateName: state.$stateName.toErrorMore(
                Exception('No data received'),
              ),
            ),
          );
        }
      },
      error: (exception) {
        emit(
          state.copyWith(
            $stateName: state.$stateName.toErrorMore(
              exception ?? Exception('Unknown error'),
            ),
          ),
        );
      },
    );
  }
''');
    }

    // Add utility methods
    final firstPaginatedMethod = paginatedMethods.isNotEmpty
        ? paginatedMethods.first
        : config.methods.first;

    final utilityMethods =
        '''
  Future<void> refresh${config.classNameBase}() async {
    if (state.$stateName.isLoading || state.$stateName.isLoadingMore) return;

    final currentQuery = state.$stateName.query;
    final params = currentQuery is ${config.classNameBase}Params
        ? currentQuery.copyWith(page: 1)
        : ${config.classNameBase}Params(page: 1);

    await doIntent(${firstPaginatedMethod.name.toPascalCase()}Event(params: params));
  }

  void clearError() {
    if (state.$stateName.isError) {
      emit(state.copyWith($stateName: const PaginationState.initial()));
    } else if (state.$stateName.isErrorMore) {
      emit(
        state.copyWith(
          $stateName: PaginationState(
            state: state.$stateName.state,
            data: state.$stateName.data,
            meta: state.$stateName.meta,
            query: state.$stateName.query,
          ),
        ),
      );
    }
  }

  void reset() {
    emit(const $stateClass());
  }
''';

    final useCaseImports = StringBuffer();
    for (final method in [
      ...paginatedMethods,
      ...singleEntityMethods,
      ...voidMethods,
    ]) {
      useCaseImports.writeln(
        "import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/use_cases/${method.name.toSnakeCase()}.dart';",
      );
    }

    // Add base state import for single entity or void methods
    String baseStateImport = '';
    if (singleEntityMethods.isNotEmpty || voidMethods.isNotEmpty) {
      baseStateImport =
          "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_state/base_state.dart';\n";
    }

    return '''
import 'package:equatable/equatable.dart';
$baseStateImport${config.hasPagination ? "import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/base_state/pagination_state.dart';\n" : ''}import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';
$useCaseImports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part '${config.fileNameBase}_events.dart';
part '${config.fileNameBase}_states.dart';

@injectable
class $className extends Cubit<$stateClass> {
$useCases
  $className({
$constructorParams  }) : $constructorInit      super(const $stateClass());

  @override
  void emit($stateClass state) {
    if (!isClosed) super.emit(state);
  }

  Future<void> doIntent(${config.classNameBase}Events event) async => switch (event) {
$switchCases  };

$handlers
$utilityMethods
}
''';
  }
}

class EventsGenerator extends CodeGenerator {
  EventsGenerator(super.config);

  @override
  String generate() {
    final events = StringBuffer();

    // Separate methods by return type
    final paginatedMethods = config.methods
        .where((m) => m.returnType == ReturnType.paginatedEntity)
        .toList();

    final nonPaginatedMethods = config.methods
        .where((m) => m.returnType != ReturnType.paginatedEntity)
        .toList();
    // Generate events for paginated methods (with optional params)
    for (final method in paginatedMethods) {
      final eventName = '${method.name.toPascalCase()}Event';

      events.writeln(
        'class $eventName extends ${config.classNameBase}Events {',
      );
      events.writeln('  final ${config.classNameBase}Params? params;');
      events.writeln('  const $eventName({this.params});');
      events.writeln('}');
      events.writeln();
    }

    // Generate events for non-paginated methods (with parameters)
    for (final method in nonPaginatedMethods) {
      final eventName = '${method.name.toPascalCase()}Event';

      events.writeln(
        'class $eventName extends ${config.classNameBase}Events {',
      );

      // Determine parameter type based on method config
      switch (method.paramType) {
        case ParamType.string:
          events.writeln('  final String id;');
          events.writeln('  const $eventName({required this.id});');
          break;
        case ParamType.entity:
          events.writeln(
            '  final ${config.singularClassNameBase}Entity entity;',
          );
          events.writeln('  const $eventName({required this.entity});');
          break;
        case ParamType.pagination:
          events.writeln('  final ${config.classNameBase}Params params;');
          events.writeln('  const $eventName({required this.params});');
          break;
        case ParamType.none:
          events.writeln('  const $eventName();');
          break;
      }

      events.writeln('}');
      events.writeln();
    }

    // Add LoadMore event if pagination is enabled
    if (config.hasPagination && paginatedMethods.isNotEmpty) {
      events.writeln(
        'class LoadMore${config.classNameBase}Event extends ${config.classNameBase}Events {',
      );
      events.writeln('  final ${config.classNameBase}Params params;');
      events.writeln(
        '  const LoadMore${config.classNameBase}Event({required this.params});',
      );
      events.writeln('}');
      events.writeln();
    }

    return '''
part of '${config.fileNameBase}_cubit.dart';

sealed class ${config.classNameBase}Events {
  const ${config.classNameBase}Events();
}

$events''';
  }
}

class StatesGenerator extends CodeGenerator {
  StatesGenerator(super.config);

  @override
  String generate() {
    final entityName = '${config.singularClassNameBase}Entity';
    final stateName = '${config.camelCaseNameBase}State';

    // Separate paginated and single entity methods
    final paginatedMethods = config.methods
        .where((m) => m.returnType == ReturnType.paginatedEntity)
        .toList();

    final singleEntityMethods = config.methods
        .where((m) => m.returnType == ReturnType.singleEntity)
        .toList();

    final voidMethods = config.methods
        .where((m) => m.returnType == ReturnType.void_)
        .toList();

    // Generate state fields
    final stateFields = StringBuffer();
    final constructorParams = StringBuffer();
    final copyWithParams = StringBuffer();
    final copyWithBody = StringBuffer();
    final propsItems = StringBuffer();

    // Add paginated state if there are paginated methods
    if (paginatedMethods.isNotEmpty) {
      stateFields.writeln('  final PaginationState<$entityName> $stateName;');
      constructorParams.writeln(
        '    this.$stateName = const PaginationState.initial(),',
      );
      copyWithParams.writeln('    PaginationState<$entityName>? $stateName,');
      copyWithBody.writeln('      $stateName: $stateName ?? this.$stateName,');
      propsItems.write('$stateName');
    }

    // Add single entity states
    for (final method in singleEntityMethods) {
      final singleStateName = '${method.name.toCamelCase()}State';
      if (propsItems.isNotEmpty) propsItems.write(', ');

      stateFields.writeln('  final BaseState<$entityName> $singleStateName;');
      constructorParams.writeln(
        '    this.$singleStateName = const BaseState.initial(),',
      );
      copyWithParams.writeln('    BaseState<$entityName>? $singleStateName,');
      copyWithBody.writeln(
        '      $singleStateName: $singleStateName ?? this.$singleStateName,',
      );
      propsItems.write(singleStateName);
    }

    // Add void states (e.g. delete)
    for (final method in voidMethods) {
      final voidStateName = '${method.name.toCamelCase()}State';
      if (propsItems.isNotEmpty) propsItems.write(', ');

      stateFields.writeln('  final BaseState<void> $voidStateName;');
      constructorParams.writeln(
        '    this.$voidStateName = const BaseState.initial(),',
      );
      copyWithParams.writeln('    BaseState<void>? $voidStateName,');
      copyWithBody.writeln(
        '      $voidStateName: $voidStateName ?? this.$voidStateName,',
      );
      propsItems.write(voidStateName);
    }

    return '''
part of '${config.fileNameBase}_cubit.dart';

class ${config.classNameBase}States extends Equatable {
$stateFields
  const ${config.classNameBase}States({
$constructorParams  });

  ${config.classNameBase}States copyWith({
$copyWithParams  }) {
    return ${config.classNameBase}States(
$copyWithBody    );
  }

  @override
  List<Object?> get props => [$propsItems];
}
''';
  }
}

class ScreenGenerator extends CodeGenerator {
  ScreenGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}Page';
    final cubitName = '${config.classNameBase}Cubit';
    final bodyName = '${config.classNameBase}Body';

    // Get first paginated method for initial event
    final screenPaginatedMethods = config.methods
        .where((m) => m.returnType == ReturnType.paginatedEntity)
        .toList();
    final firstMethod = screenPaginatedMethods.isNotEmpty
        ? screenPaginatedMethods.first
        : config.methods.first;
    final firstEvent = '${firstMethod.name.toPascalCase()}Event';

    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.configBasePath}/dependency_injection/di.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreWidgetsPath}/custom_app_bar.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/cubit/${config.fileNameBase}_cubit.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/widgets/${config.fileNameBase}_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "${config.classNameBase}"),
      body: SafeArea(
        child: BlocProvider<$cubitName>(
          create: (context) => getIt<$cubitName>()
            ..doIntent(const $firstEvent()),
          child: const $bodyName(),
        ),
      ),
    );
  }
}
''';
  }
}

class BodyWidgetGenerator extends CodeGenerator {
  BodyWidgetGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}Body';
    final cubitName = '${config.classNameBase}Cubit';
    final shimmerName = '${config.classNameBase}Shimmer';
    final entityName = '${config.singularClassNameBase}Entity';
    final paramsName = '${config.classNameBase}Params';
    final stateName = '${config.camelCaseNameBase}State';

    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreWidgetsPath}/pagination_scroll_view.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.fileNameBase}_params.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/cubit/${config.fileNameBase}_cubit.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/widgets/empty_${config.fileNameBase}_widget.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/widgets/${config.singularFileNameBase}_card.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/presentation/widgets/${config.fileNameBase}_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<$cubitName>();

    return BlocBuilder<$cubitName, ${config.classNameBase}States>(
      builder: (context, state) {
        return PaginationScrollView<$entityName>(
          state: state.$stateName,
          onLoadMore: () => cubit.doIntent(
            LoadMore${config.classNameBase}Event(
              params: state.$stateName.query.copyWith(
                page: state.$stateName.currentPage + 1,
              ) as $paramsName,
            ),
          ),
          onRefresh: cubit.refresh${config.classNameBase},
          loadingWidget: const $shimmerName(),
          loadingMoreWidget: const _LoadingMoreShimmer(),
          emptyWidget: const Empty${config.classNameBase}Widget(),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          itemBuilder: (context, item, index) => ${config.singularClassNameBase}Card(${config.singularCamelCaseNameBase}: item),
        );
      },
    );
  }
}

class _LoadingMoreShimmer extends StatelessWidget {
  const _LoadingMoreShimmer();

  @override
  Widget build(BuildContext context) => const ${config.classNameBase}ShimmerMore();
}
''';
  }
}

class ShimmerWidgetGenerator extends CodeGenerator {
  ShimmerWidgetGenerator(super.config);

  @override
  String generate() {
    final className = '${config.classNameBase}Shimmer';
    final pkg = config.projectConfig.packageName;
    final valuesPath = config.projectConfig.coreValuesPath;

    return '''
import 'package:$pkg/$valuesPath/app_colors.dart';
import 'package:$pkg/$valuesPath/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for ${config.classNameBase}
/// Follows base.md pattern: StatelessWidget classes, const constructors, AppColors/AppSpacing
class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsetsDirectional.all(AppSpacing.lg),
          sliver: _ShimmerSlivers(),
        ),
      ],
    );
  }
}

/// Shimmer for "load more" state
class ${className}More extends StatelessWidget {
  const ${className}More({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: _ShimmerSlivers(itemCount: 3),
        ),
      ],
    );
  }
}

class _ShimmerSlivers extends StatelessWidget {
  const _ShimmerSlivers({this.itemCount = 10});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const _ShimmerItem(),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  const _ShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.gray10,
      highlightColor: AppColors.lightGray,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: AppSpacing.cardImageSize,
                height: AppSpacing.cardImageSize,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: AppSpacing.lg,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }
}

class EmptyWidgetGenerator extends CodeGenerator {
  EmptyWidgetGenerator(super.config);

  @override
  String generate() {
    final className = 'Empty${config.classNameBase}Widget';

    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_colors.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_font_style.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_spacing.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_strings.dart';
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: AppSpacing.xxxl * 2.5,
            color: AppColors.grayA6,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            // TODO: add AppStrings.no${config.classNameBase}Found
            'No ${config.classNameBase} found',
            style: AppFontStyle.medium18(context).copyWith(
              color: AppColors.gray40,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.tryAdjustingFilters,
            style: AppFontStyle.regular14(context).copyWith(
              color: AppColors.gray30,
            ),
          ),
        ],
      ),
    );
  }
}
''';
  }
}

class ProductCardGenerator extends CodeGenerator {
  ProductCardGenerator(super.config);

  @override
  String generate() {
    final className = '${config.singularClassNameBase}Card';
    final entityName = '${config.singularClassNameBase}Entity';
    final paramName = config.singularCamelCaseNameBase;

    return '''
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_colors.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_font_style.dart';
import 'package:${config.projectConfig.packageName}/${config.projectConfig.coreValuesPath}/app_spacing.dart';
import 'package:${config.projectConfig.packageName}/feature/${config.fileNameBase}/domain/entities/${config.singularFileNameBase}_entity.dart';
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  final $entityName $paramName;

  const $className({
    super.key,
    required this.$paramName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: AppSpacing.cardImageSize,
              height: AppSpacing.cardImageSize,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                image: $paramName.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage($paramName.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: $paramName.imageUrl == null
                  ? const Icon(Icons.image, color: AppColors.grayA6)
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    $paramName.name ?? '${config.singularClassNameBase}',
                    style: AppFontStyle.medium16(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if ($paramName.price != null)
                    Text(
                      '\\\${$paramName.price!.toStringAsFixed(2)}',
                      style: AppFontStyle.regular14(context).copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''';
  }
}

// ============================================================================
// STRING EXTENSIONS
// ============================================================================

extension StringExtensions on String {
  /// Converts string to PascalCase (e.g., "user_profile" -> "UserProfile")
  String toPascalCase() {
    if (isEmpty) return this;
    return split(RegExp(r'[_\s-]'))
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join('');
  }

  /// Converts string to camelCase (e.g., "user_profile" -> "userProfile")
  String toCamelCase() {
    if (isEmpty) return this;
    final pascal = toPascalCase();
    return pascal[0].toLowerCase() + pascal.substring(1);
  }

  /// Converts string to snake_case (e.g., "UserProfile" -> "user_profile")
  String toSnakeCase() {
    if (isEmpty) return this;
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Converts plural to singular (basic implementation)
  String toSingular() {
    if (isEmpty) return this;
    if (endsWith('ies')) {
      return '${substring(0, length - 3)}y';
    }
    if (endsWith('es')) {
      return substring(0, length - 2);
    }
    if (endsWith('s')) {
      return substring(0, length - 1);
    }
    return this;
  }
}
