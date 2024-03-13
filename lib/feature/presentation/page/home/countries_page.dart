import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/data/model/home/countries_response_model.dart';
import 'package:flutter_assessment/feature/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/util/tools.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({Key? key}) : super(key: key);

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  late HomeBloc _homeBloc;
  final NumberPaginatorController _paginatorController =
      NumberPaginatorController();
  bool didShowHintBefore = false;
  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    if (_homeBloc.state.countries == null) {
      _homeBloc.add(const GetCountriesEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {
        if (state.status == HomeStates.success && state.currentPageIndex == 1) {
          if(!didShowHintBefore)
            {
              Tools.showHintMsg(AppStrings.countriesPageHint);
              setState(() {
                didShowHintBefore = true;
              });
            }
        }
        else if (state.status == HomeStates.failure) {
          Tools.showErrorMessage(state.error?.errorMessage);
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status != HomeStates.loading && state.countries != null) {
            return _getScreenBody();
          }
          else if (state.status == HomeStates.failure) {
            return const Center(
              child: Text(AppStrings.error),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          );
        },
      ),
    );
  }

  Widget _getScreenBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          SizedBox(
            height: 32.h,
          ),
          Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(
                    child: _getSinglePageBody(),
                  ),
                  _getPagesPaginator(),
                ],
              )),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Text(
      AppStrings.countriesHeader,
      style: AppTxtStyles.mainTxtStyle.copyWith(fontSize: 20),
    );
  }

  Widget _getPagesPaginator() {
    int totalPageCount = _homeBloc.state.countries?.pagination?.totalPages ?? 0;
    return NumberPaginator(
      numberPages: totalPageCount,
      controller: _paginatorController,
      contentBuilder: (index) {
        int currentPageIndex =
            (_homeBloc.state.countries?.pagination?.currentPage ?? 1) - 1;
        return Expanded(
            child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: const PageStorageKey<String>('scrollViewController'),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      totalPageCount,
                      (number) => InkWell(
                            onTap: () {
                              _homeBloc.add(GetCountriesEvent(
                                  newPageIndex: (number + 1)));
                              setState(() {
                                _paginatorController.navigateToPage(number);
                              });
                            },
                            child: Container(
                                width: 32.w,
                                height: 32.h,
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                decoration: BoxDecoration(
                                    color: (number == currentPageIndex)
                                        ? AppColors.appMainColor
                                        : Colors.white,
                                    border: Border.all(
                                        color: (number == currentPageIndex)
                                            ? AppColors.appMainColor
                                            : AppColors.color_E6EAEF,
                                        width: 2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.r),
                                    )),
                                child: Center(
                                  child: Text(
                                    "${number + 1}",
                                    style: AppTxtStyles.btnTxtStyle.copyWith(
                                        color: (number == currentPageIndex)
                                            ? Colors.white
                                            : AppColors.color_333333),
                                  ),
                                )),
                          )),
                ),
              ),
            ),
            Container(
                width: 32.w,
                height: 32.h,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    "...",
                    style: AppTxtStyles.btnTxtStyle
                        .copyWith(color: AppColors.color_333333),
                  ),
                )),
            InkWell(
              onTap: () {
                _homeBloc
                    .add(GetCountriesEvent(newPageIndex: (totalPageCount)));
                setState(() {
                  _paginatorController.navigateToPage(totalPageCount - 1);
                });
              },
              child: Container(
                  width: 32.w,
                  height: 32.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                      color: (currentPageIndex == (totalPageCount - 1))
                          ? AppColors.appMainColor
                          : Colors.white,
                      border: Border.all(
                          color: (currentPageIndex == (totalPageCount - 1))
                              ? AppColors.appMainColor
                              : AppColors.color_E6EAEF,
                          width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.r),
                      )),
                  child: Center(
                    child: Text(
                      "$totalPageCount",
                      style: AppTxtStyles.btnTxtStyle.copyWith(
                          color: (currentPageIndex == (totalPageCount - 1))
                              ? Colors.white
                              : AppColors.color_333333),
                    ),
                  )),
            )
          ],
        ));
      },
      prevButtonBuilder: (context) {
        return Row(
          children: [
            InkWell(
              onTap: () {
                _homeBloc.add(const GetCountriesEvent());
                setState(() {
                  _paginatorController.navigateToPage(0);
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 3.w, right: 1.5.w),
                child: SvgPicture.asset('assets/icon/first_page_btn_ic.svg',
                    width: 32.w, height: 32.h),
              ),
            ),
            InkWell(
              onTap: () {
                if (_paginatorController.currentPage > 0) {
                  _homeBloc.add(GetCountriesEvent(
                      newPageIndex: (_paginatorController.currentPage)));
                  setState(() {
                    _paginatorController.prev();
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 3.w, right: 1.5.w),
                child: SvgPicture.asset('assets/icon/prev_btn_ic.svg',
                    width: 32.w, height: 32.h),
              ),
            )
          ],
        );
      },
      nextButtonBuilder: (context) {
        return Row(
          children: [
            InkWell(
                onTap: () {
                  if (totalPageCount > (_paginatorController.currentPage + 1)) {
                    _homeBloc.add(GetCountriesEvent(
                        newPageIndex: (_paginatorController.currentPage + 1)));
                    setState(() {
                      _paginatorController.next();
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 3.w, left: 1.5.w),
                  child: SvgPicture.asset('assets/icon/next_btn_ic.svg',
                      width: 32.w, height: 32.h),
                )),
            InkWell(
                onTap: () {
                  _homeBloc
                      .add(GetCountriesEvent(newPageIndex: (totalPageCount)));
                  setState(() {
                    _paginatorController.navigateToPage(totalPageCount - 1);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 3.w, left: 1.5.w),
                  child: SvgPicture.asset('assets/icon/last_page_btn_ic.svg',
                      width: 32.w, height: 32.h),
                ))
          ],
        );
      },
    );
  }

  Widget _getSinglePageBody() {
    List<Data> countriesOfCurrentPage = _homeBloc.state.countries?.data ?? [];
    return Card(
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.color_F9F9F9,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      )),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: Text(
                          AppStrings.country,
                          style: AppTxtStyles.stepTxtStyle
                              .copyWith(color: AppColors.color_696F79),
                        ),
                      )),
                      Expanded(
                          child: Center(
                        child: Text(
                          AppStrings.capital,
                          style: AppTxtStyles.stepTxtStyle
                              .copyWith(color: AppColors.color_696F79),
                        ),
                      ))
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 14.h, left: 6.w, right: 6.w),
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  countriesOfCurrentPage[index].name ?? "",
                                  textAlign: TextAlign.center,
                                  style: AppTxtStyles.subHeaderTxtStyle
                                      .copyWith(color: Colors.black),
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  countriesOfCurrentPage[index].capital ?? "",
                                  textAlign: TextAlign.center,
                                  style: AppTxtStyles.subHeaderTxtStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ))
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(height: 1.h, color: AppColors.color_F9F9F9),
                      itemCount: countriesOfCurrentPage.length,
                    ),
                  ),
                )
              ],
            )));
  }
}
