import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/data/model/home/services_response_model.dart';
import 'package:flutter_assessment/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_assessment/feature/presentation/widget/service_item_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/util/tools.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    if (_homeBloc.state.services == null) {
      _homeBloc.add(const GetServicesEvent());
    }
    if (_homeBloc.state.popularServices == null) {
      _homeBloc.add(const GetPopularServicesEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
      if (state.status == HomeStates.failure) {
        Tools.showErrorMessage(state.error?.errorMessage);
      }
    }, child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.status != HomeStates.loading &&
          _homeBloc.state.services != null &&
          _homeBloc.state.popularServices != null) {
        return _getScreenBody();
      } else if (state.status == HomeStates.failure) {
        return const Center(
          child: Text(AppStrings.error),
        );
      }
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.appMainColor,
        ),
      );
    }));
  }

  Widget _getScreenBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getHeader(AppStrings.servicesHeader),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(child: _getServices())
                ],
              )),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getHeader(AppStrings.popularServicesHeader),
                  SizedBox(
                    height: 30.h,
                  ),
                  Expanded(flex: 2,child: _getPopularServices()),
                  Expanded(child: Container())
                ],
              )),
        ],
      ),
    );
  }

  Widget _getHeader(String header) {
    return Text(
      header,
      style: AppTxtStyles.mainTxtStyle.copyWith(fontSize: 20),
      textAlign: TextAlign.start,
    );
  }

  Widget _getServices() {
    List<Service> services = _homeBloc.state.services?.data ?? [];
    return SingleChildScrollView(
      key: const PageStorageKey<String>('servicesListController'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(services.length,
            (index) => ServiceItemWidget(service: services[index])),
      ),
    );
  }

  Widget _getPopularServices() {
    List<Service> popularServices = _homeBloc.state.popularServices?.data ?? [];
    return SingleChildScrollView(
      key: const PageStorageKey<String>('popularServicesListController'),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(popularServices.length,
            (index) => ServiceItemWidget(service: popularServices[index])),
      ),
    );
  }
}
