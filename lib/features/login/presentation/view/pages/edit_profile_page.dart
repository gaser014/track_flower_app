import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<LoginCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit profile'),
        ),
        body: BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
             return const Center(
                child: Text('Edit Profile Form Here'),
              );
          },
        ),
      ),
    );
  }
}
