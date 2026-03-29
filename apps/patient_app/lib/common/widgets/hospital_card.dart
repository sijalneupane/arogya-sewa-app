import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/common/model/hospital_entity.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shimmer/shimmer.dart';

/// Modern horizontal scrolling card for displaying hospital information
class HospitalCard extends StatelessWidget {
  final HospitalEntity hospital;
  final VoidCallback? onTap;

  const HospitalCard({
    super.key,
    required this.hospital,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.vw(50),
        margin: EdgeInsets.only(right: context.vw(3)),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isDarkMode
                ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.2)
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Banner Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: context.vh(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ArogyaSewaColors.shimmerBaseDark
                      : ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                ),
                child: _buildBanner(context, isDarkMode),
              ),
            ),

            /// Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.vw(2.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo and Name Row - Fixed height to maintain consistent layout
                    SizedBox(
                      height: context.vh(4.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildLogo(context, isDarkMode),
                          SizedBox(width: context.vw(2)),
                          Expanded(
                            child: Text(
                              hospital.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? ArogyaSewaColors.textColorWhite
                                        : ArogyaSewaColors.textColorBlack,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    /// Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite
                              : ArogyaSewaColors.primaryColor,
                        ),
                        SizedBox(width: context.vw(1)),
                        Expanded(
                          child: Text(
                            hospital.location,
                            style: TextStyle(
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                                  : ArogyaSewaColors.textColorGrey,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    /// Distance (if available)
                    if (hospital.distanceKm != null) ...[
                      SizedBox(height: context.vh(0.3)),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_walk_rounded,
                            size: 12,
                            color: isDarkMode
                                ? ArogyaSewaColors.textColorWhite
                                : ArogyaSewaColors.primaryColor,
                          ),
                          SizedBox(width: context.vw(1)),
                          Text(
                            '${hospital.distanceKm!.toStringAsFixed(1)} $kilometersString',
                            style: TextStyle(
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite
                                  : ArogyaSewaColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, bool isDarkMode) {
    if (hospital.banner != null && hospital.banner!.fileUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: hospital.banner!.fileUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => _buildShimmer(isDarkMode),
        errorWidget: (context, url, error) => _buildIconPlaceholder(isDarkMode),
      );
    }
    return _buildIconPlaceholder(isDarkMode);
  }

  Widget _buildLogo(BuildContext context, bool isDarkMode) {
    return Container(
      width: context.vw(9),
      height: context.vw(9),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.shimmerBaseDark
            : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: _buildLogoContent(context, isDarkMode),
      ),
    );
  }

  Widget _buildLogoContent(BuildContext context, bool isDarkMode) {
    if (hospital.logo != null && hospital.logo!.fileUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: hospital.logo!.fileUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmer(isDarkMode, isCircle: true),
        errorWidget: (context, url, error) => _buildLogoIconPlaceholder(context, isDarkMode),
      );
    }
    return _buildLogoIconPlaceholder(context, isDarkMode);
  }

  Widget _buildShimmer(bool isDarkMode, {bool isCircle = false}) {
    return Shimmer.fromColors(
      baseColor: isDarkMode
          ? ArogyaSewaColors.shimmerBaseDark
          : ArogyaSewaColors.shimmerBaseLight,
      highlightColor: isDarkMode
          ? ArogyaSewaColors.shimmerHighlightDark
          : ArogyaSewaColors.shimmerHighlightLight,
      child: Container(
        color: isDarkMode
            ? ArogyaSewaColors.shimmerBaseDark
            : ArogyaSewaColors.shimmerBaseLight,
        child: isCircle
            ? null
            : Center(
                child: Icon(
                  Icons.medical_services_rounded,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.5),
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildIconPlaceholder(bool isDarkMode) {
    return Container(
      color: isDarkMode
          ? ArogyaSewaColors.shimmerBaseDark.withValues(alpha: 0.3)
          : Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.medical_services_rounded,
          color: isDarkMode
              ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.6)
              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildLogoIconPlaceholder(BuildContext context, bool isDarkMode) {
    return Container(
      color: isDarkMode
          ? ArogyaSewaColors.shimmerBaseDark.withValues(alpha: 0.3)
          : Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.medical_services_rounded,
          color: isDarkMode
              ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.6)
              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
          size: context.vw(4),
        ),
      ),
    );
  }
}
