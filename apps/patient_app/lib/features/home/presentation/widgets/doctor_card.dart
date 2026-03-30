import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/domain/entities/doctor_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shimmer/shimmer.dart';

/// Attractive card widget for displaying doctor information in grid
class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final VoidCallback? onTap;

  const DoctorCard({super.key, required this.doctor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            /// Profile Image Section with Status Badge
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildProfileImage(context, isDarkMode),

                    /// Status Badge positioned on the right side of profile image
                    Positioned(
                      // right: context.vw(2),
                      right: 1,
                      bottom: 2,
                      child: _buildStatusBadge(context, isDarkMode),
                    ),
                  ],
                ),
              ),
            ),

            /// Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.vw(3)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Doctor Name
                    Text(
                      doctor.user.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite
                            : ArogyaSewaColors.textColorBlack,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.vh(0.5)),

                    /// Department
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_rounded,
                          size: 12,
                          color: ArogyaSewaColors.primaryColor,
                        ),
                        SizedBox(width: context.vw(1)),
                        Expanded(
                          child: Text(
                            doctor.department.name,
                            style: TextStyle(
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite.withValues(
                                      alpha: 0.7,
                                    )
                                  : ArogyaSewaColors.textColorGrey,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.vh(0.5)),

                    /// Experience
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline_rounded,
                          size: 12,
                          color: ArogyaSewaColors.primaryColor,
                        ),
                        SizedBox(width: context.vw(1)),
                        Expanded(
                          child: Text(
                            doctor.experience,
                            style: TextStyle(
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite.withValues(
                                      alpha: 0.7,
                                    )
                                  : ArogyaSewaColors.textColorGrey,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, bool isDarkMode) {
    final profileImg = doctor.user.profileImage;

    if (profileImg != null && profileImg.fileUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: profileImg.fileUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) =>
            _buildImagePlaceholder(isDarkMode),
      );
    }
    return _buildImagePlaceholder(isDarkMode);
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: ArogyaSewaColors.shimmerBaseLight,
      highlightColor: ArogyaSewaColors.shimmerHighlightLight,
      child: Container(
        color: ArogyaSewaColors.shimmerBaseLight,
        child: Center(
          child: Icon(
            Icons.person_rounded,
            color: Colors.white.withValues(alpha: 0.3),
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isDarkMode) {
    return Center(
      child: Icon(
        Icons.person_rounded,
        color: isDarkMode
            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.5)
            : ArogyaSewaColors.primaryColor.withValues(alpha: 0.5),
        size: 48,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDarkMode) {
    Color badgeColor;
    Color textColor;
    IconData statusIcon;

    switch (doctor.status) {
      case DoctorStatusEnum.available:
        badgeColor = Colors.green;
        textColor = Colors.white;
        statusIcon = Icons.check_circle_rounded;
        break;
      case DoctorStatusEnum.onLeave:
        badgeColor = Colors.orange;
        textColor = Colors.white;
        statusIcon = Icons.beach_access_rounded;
        break;
      case DoctorStatusEnum.onAppointment:
        badgeColor = Colors.blue;
        textColor = Colors.white;
        statusIcon = Icons.event_available_rounded;
        break;
      case DoctorStatusEnum.inactive:
        badgeColor = Colors.grey;
        textColor = Colors.white;
        statusIcon = Icons.info_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.vw(2),
        vertical: context.vh(0.5),
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: textColor),
          SizedBox(width: context.vw(1)),
          Text(
            doctor.status.value,
            style: TextStyle(
              color: textColor,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
