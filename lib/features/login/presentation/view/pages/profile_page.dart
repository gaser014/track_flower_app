import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_cubit.dart';
import 'package:track_flowers_app/features/login/presentation/view_model/cubit/login_events.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<LoginCubit>()..doIndented(GetProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
            if (state.getProfileState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.getProfileState.isSuccess) {
              return Center(
                child: Text('User Profile: ${state.getProfileState.data.firstName}'),
              );
            } else if (state.getProfileState.isError) {
              return Center(child: Text(state.getProfileState.exception.toString()));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
