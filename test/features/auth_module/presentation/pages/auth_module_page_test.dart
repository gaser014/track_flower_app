import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view/pages/auth_module_page.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';

import 'auth_module_page_test.mocks.dart';

@GenerateMocks([AuthModuleCubit])
void main() {
  late MockAuthModuleCubit mockCubit;

  setUp(() {
    mockCubit = MockAuthModuleCubit();
    if (getIt.isRegistered<AuthModuleCubit>()) {
      getIt.unregister<AuthModuleCubit>();
    }
    getIt.registerFactory<AuthModuleCubit>(() => mockCubit);

    when(mockCubit.stream).thenAnswer((_) => const Stream<AuthModuleState>.empty());
    when(mockCubit.state).thenReturn(const AuthModuleState());
    when(mockCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  Widget buildTestableWidget(Widget widget) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        home: Scaffold(body: widget),
      ),
    );
  }

  testWidgets('renders AuthModulePage correctly', (tester) async {
    // arrange
    when(mockCubit.loadSavedCredentials()).thenAnswer((_) async {});

    // act
    await tester.pumpWidget(buildTestableWidget(const AuthModulePage()));

    // assert
    expect(find.byType(AuthModulePage), findsOneWidget);
    verify(mockCubit.loadSavedCredentials()).called(1);
  });
}
