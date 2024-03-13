import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/data/model/home/services_response_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/colors/app_colors.dart';
import '../../../core/constants/strings/app_assets.dart';
import '../../../core/theme/text_styles.dart';

class ServiceItemWidget extends StatelessWidget {
  Service service;

  ServiceItemWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 157.w,
      height: 195.h,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 103.h,
            width: 151.w,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: (service.mainImage == null ||
                                    service.mainImage!.isEmpty)
                                ? const AssetImage(
                                        AppAssets.avatar_placeholder_ic)
                                    as ImageProvider
                                : NetworkImage(service.mainImage!))),
                  ),
                ),
                Positioned(
                    left: 6,
                    bottom: 7,
                    child: Container(
                      width: 60.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                          color: AppColors.appMainColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(27.r),
                          )),
                      child: Center(
                        child: Text(
                          "\$${service.price ?? 0}",
                          textAlign: TextAlign.center,
                          style: AppTxtStyles.subHeaderTxtStyle
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(child: Text(
            service.title ?? "",
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTxtStyles.size11Weight500ColorBlackTxtStyle,
          ),),
          SizedBox(
            height: 10.h,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppAssets.rating_ic,
                    width: 14.w, height: 14.h),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  "( ${service.averageRating ?? 0} )",
                  textAlign: TextAlign.center,
                  style: AppTxtStyles.size10Weight400TxtStyle
                      .copyWith(color: AppColors.color_FFCB31, fontSize: 11),
                ),
                SizedBox(
                  width: 3.w,
                ),
                VerticalDivider(
                  color: AppColors.color_C3C5C8,
                  thickness: 1.w,
                ),
                SizedBox(
                  width: 3.w,
                ),
                SvgPicture.asset(AppAssets.shopping_cart_ic,
                    width: 17.w, height: 14.h),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  "${service.completedSalesCount ?? 0}",
                  textAlign: TextAlign.center,
                  style: AppTxtStyles.size10Weight400TxtStyle.copyWith(
                    color: AppColors.color_828282,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
