import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for doctors grid (2 columns, 5 rows)
class DoctorsShimmerWidget extends StatelessWidget {
  const DoctorsShimmerWidget({super.key});

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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: 10, // 2 columns x 5 rows
        itemBuilder: (context, index) {
          return _buildShimmerCard(context, isDarkMode);
        },
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.shimmerBaseDark
            : ArogyaSewaColors.shimmerBaseLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile image shimmer with status badge placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: isDarkMode
                      ? ArogyaSewaColors.shimmerBaseDark
                      : ArogyaSewaColors.shimmerBaseLight,
                ),
                /// Status badge shimmer placeholder
                Positioned(
                  right: context.vw(2),
                  top: context.vh(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.vw(2),
                      vertical: context.vh(0.5),
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ArogyaSewaColors.shimmerHighlightDark
                          : ArogyaSewaColors.shimmerHighlightLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: context.vw(3),
                          height: context.vh(1.2),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ArogyaSewaColors.shimmerHighlightDark
                                : ArogyaSewaColors.shimmerHighlightLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: context.vw(1)),
                        Container(
                          width: context.vw(12),
                          height: context.vh(1.2),
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
                ),
              ],
            ),
          ),

          /// Content shimmer
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(context.vw(3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name shimmer
                  Container(
                    height: context.vh(2),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ArogyaSewaColors.shimmerBaseDark
                          : ArogyaSewaColors.shimmerBaseLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: context.vh(1)),
                  /// Department shimmer
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
                  SizedBox(height: context.vh(1)),
                  /// Experience shimmer
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
                          width: context.vw(20),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
