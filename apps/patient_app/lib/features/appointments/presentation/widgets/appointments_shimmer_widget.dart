import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for appointments list
class AppointmentsShimmerWidget extends StatelessWidget {
  const AppointmentsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode
          ? ArogyaSewaColors.shimmerBaseDark
          : ArogyaSewaColors.shimmerBaseLight,
      highlightColor: isDarkMode
          ? ArogyaSewaColors.shimmerHighlightDark
          : ArogyaSewaColors.shimmerHighlightLight,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildShimmerCard(context, isDarkMode);
        },
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.shimmerBaseDark
            : ArogyaSewaColors.shimmerBaseLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header section with profile image and status badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// Profile image shimmer
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ArogyaSewaColors.shimmerBaseDark
                        : ArogyaSewaColors.shimmerBaseLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                /// Doctor name and department shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: context.vw(30),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Status badge shimmer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ArogyaSewaColors.shimmerHighlightDark
                        : ArogyaSewaColors.shimmerHighlightLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerHighlightDark
                              : ArogyaSewaColors.shimmerHighlightLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerHighlightDark
                              : ArogyaSewaColors.shimmerHighlightLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// Appointment details section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Date and Time row
                _buildDetailRow(context, isDarkMode),
                const SizedBox(height: 12),

                /// Location row
                _buildDetailRow(context, isDarkMode),
                const SizedBox(height: 12),

                /// Consultation type row
                _buildDetailRow(context, isDarkMode),
                const SizedBox(height: 12),

                /// Payment status row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ArogyaSewaColors.shimmerBaseDark
                        : ArogyaSewaColors.shimmerBaseLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? ArogyaSewaColors.shimmerBaseDark
                                  : ArogyaSewaColors.shimmerBaseLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 80,
                            height: 14,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? ArogyaSewaColors.shimmerBaseDark
                                  : ArogyaSewaColors.shimmerBaseLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Icon placeholder
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ArogyaSewaColors.shimmerBaseDark
                : ArogyaSewaColors.shimmerBaseLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ArogyaSewaColors.shimmerHighlightDark
                  : ArogyaSewaColors.shimmerHighlightLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),

        /// Text placeholders
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                width: 80,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ArogyaSewaColors.shimmerBaseDark
                      : ArogyaSewaColors.shimmerBaseLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ArogyaSewaColors.shimmerBaseDark
                      : ArogyaSewaColors.shimmerBaseLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
