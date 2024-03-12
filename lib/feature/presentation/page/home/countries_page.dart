import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/login/login_state.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({Key? key}) : super(key: key);

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const GetCountriesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SafeArea(child: _getScreenBody());
      },
    );
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            height: 40.h,
          )
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      child: Text(
        AppStrings.countriesHeader,
        style: AppTxtStyles.mainFontStyle,
      ),
    );
  }

}
