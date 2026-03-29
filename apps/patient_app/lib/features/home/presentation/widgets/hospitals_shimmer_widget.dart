import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for nearest hospitals horizontal list
class HospitalsShimmerWidget extends StatelessWidget {
  const HospitalsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: context.vh(30),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: isDarkMode
                ? ArogyaSewaColors.shimmerBaseDark
                : ArogyaSewaColors.shimmerBaseLight,
            highlightColor: isDarkMode
                ? ArogyaSewaColors.shimmerHighlightDark
                : ArogyaSewaColors.shimmerHighlightLight,
            child: _buildShimmerCard(context, isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, bool isDarkMode) {
    return Container(
      width: context.vw(50),
      margin: EdgeInsets.only(right: context.vw(3)),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.shimmerBaseDark
            : ArogyaSewaColors.shimmerBaseLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.2)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Banner shimmer
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Container(
              height: context.vh(15),
              width: double.infinity,
              color: isDarkMode
                  ? ArogyaSewaColors.shimmerBaseDark
                  : ArogyaSewaColors.shimmerBaseLight,
            ),
          ),

          /// Content shimmer
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.vw(2.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Logo and name row shimmer
                  Row(
                    children: [
                      /// Logo shimmer
                      Container(
                        width: context.vw(9),
                        height: context.vw(9),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: context.vw(2)),
                      /// Name shimmer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: context.vh(1.8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? ArogyaSewaColors.shimmerBaseDark
                                    : ArogyaSewaColors.shimmerBaseLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: context.vh(0.5)),
                            Container(
                              height: context.vh(1.8),
                              width: context.vw(35),
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
                  SizedBox(height: context.vh(0.5)),
                  /// Location shimmer
                  Row(
                    children: [
                      Container(
                        width: context.vw(3),
                        height: context.vh(1.5),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: context.vw(1)),
                      Expanded(
                        child: Container(
                          height: context.vh(1.5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ArogyaSewaColors.shimmerBaseDark
                                : ArogyaSewaColors.shimmerBaseLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.vh(0.3)),
                  /// Distance shimmer
                  Row(
                    children: [
                      Container(
                        width: context.vw(3),
                        height: context.vh(1.5),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: context.vw(1)),
                      Container(
                        height: context.vh(1.5),
                        width: context.vw(15),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.shimmerBaseDark
                              : ArogyaSewaColors.shimmerBaseLight,
                          borderRadius: BorderRadius.circular(4),
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
    );
  }
}
