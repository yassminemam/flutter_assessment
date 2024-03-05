import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../../../injection_container.dart';
import '../../bloc/dependencies/dependencies_bloc.dart';
import '../../bloc/dependencies/dependencies_event.dart';
import '../../bloc/dependencies/dependencies_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final productsBloc = sl<DependenciesBloc>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    productsBloc.add(const GetDependenciesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Assessment"),
      ),
      body: Column(
        children: [
          BlocProvider<DependenciesBloc>(
              create: (context) => productsBloc,
              child: BlocListener<DependenciesBloc, DependenciesState>(
                listener: (BuildContext context, DependenciesState state) {
                  if (state.status == DependenciesStates.loading) {
                    LockOverlay()
                        .showLoadingOverlay(scaffoldKey.currentContext);
                    LockOverlay().closeOverlay();
                  } else if (state.status == DependenciesStates.failure) {
                    LockOverlay().closeOverlay();
                    Tools.ShowErrorMessage(AppStrings.noInternetConnection);
                  }
                  else if (state.status == DependenciesStates.loaded) {
                    LockOverlay().closeOverlay();
                  }
                },
                child: BlocBuilder<DependenciesBloc, DependenciesState>(
                  builder: (context, state) {
                    if (state.status == DependenciesStates.loaded) {
                      return Container(
                        child: Text("${state.dependencies?.status}"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.appMainColor,),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }
}
