import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/common/model/hospital_entity.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

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
        width: context.vw(55),
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
                  color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                ),
                child: _buildBanner(context),
              ),
            ),

            /// Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.vw(2.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo and Name Row
                    Row(
                      children: [
                        _buildLogo(context),
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
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.vh(0.5)),
                    /// Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: ArogyaSewaColors.primaryColor,
                        ),
                        SizedBox(width: context.vw(1)),
                        Expanded(
                          child: Text(
                            hospital.location,
                            style: TextStyle(
                              color: ArogyaSewaColors.textColorGrey,
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
                            color: ArogyaSewaColors.primaryColor,
                          ),
                          SizedBox(width: context.vw(1)),
                          Text(
                            '${hospital.distanceKm!.toStringAsFixed(1)} $kilometersString',
                            style: TextStyle(
                              color: ArogyaSewaColors.primaryColor,
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

  Widget _buildBanner(BuildContext context) {
    if (hospital.banner != null && hospital.banner!.fileUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: hospital.banner!.fileUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Center(
          child: Icon(
            Icons.medical_services_rounded,
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
            size: 32,
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.medical_services_rounded,
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
            size: 32,
          ),
        ),
      );
    }
    return Center(
      child: Icon(
        Icons.medical_services_rounded,
        color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
        size: 32,
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    if (hospital.logo != null && hospital.logo!.fileUrl.isNotEmpty) {
      return Container(
        width: context.vw(9),
        height: context.vw(9),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: hospital.logo!.fileUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.medical_services_rounded,
                size: context.vw(4),
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
              child: Icon(
                Icons.medical_services_rounded,
                size: context.vw(4),
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: context.vw(9),
      height: context.vw(9),
      decoration: BoxDecoration(
        color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.medical_services_rounded,
        size: context.vw(4),
        color: ArogyaSewaColors.primaryColor,
      ),
    );
  }
}
