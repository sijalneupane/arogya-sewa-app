import 'package:flutter/material.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

/// Reusable interactive viewer for displaying images with zoom and pan functionality
class ArogyaSewaInteractiveViewer {
  /// Show an interactive viewer dialog with the provided child widget
  /// 
  /// Parameters:
  /// - [context]: BuildContext for showing the dialog
  /// - [child]: The widget to display (typically an Image)
  /// - [title]: Optional title to display at the top of the viewer
  /// - [minScale]: Minimum scale factor (default: 0.5)
  /// - [maxScale]: Maximum scale factor (default: 4.0)
  static Future<void> show({
    required BuildContext context,
    required Widget? child,
    String? title,
    double minScale = 0.5,
    double maxScale = 4.0,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1D255F)
                : ArogyaSewaColors.textColorWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with title and close button
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.zoom_in_rounded,
                          color: ArogyaSewaColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? ArogyaSewaColors.textColorWhite
                                : ArogyaSewaColors.textColorBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          foregroundColor: isDarkMode
                              ? ArogyaSewaColors.textColorWhite
                              : ArogyaSewaColors.textColorBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.1)
                      : ArogyaSewaColors.textColorBlack.withValues(alpha: 0.1),
                ),
              ] else ...[
                // Close button only (no title)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        foregroundColor: isDarkMode
                            ? ArogyaSewaColors.textColorWhite
                            : ArogyaSewaColors.textColorBlack,
                      ),
                    ),
                  ),
                ),
              ],
              // Interactive Viewer
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: InteractiveViewer(
                    minScale: minScale,
                    maxScale: maxScale,
                    scaleEnabled: true,
                    clipBehavior: Clip.antiAlias,
                    trackpadScrollCausesScale: true,
                    panEnabled: true,
                    boundaryMargin: EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                  ),
                ),
              ),
              // Hint text
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pan_tool_rounded,
                      size: 14,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.4)
                          : ArogyaSewaColors.textColorGrey,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Pinch to zoom • Drag to pan',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.4)
                            : ArogyaSewaColors.textColorGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show image from network URL
  static Future<void> showNetworkImage({
    required BuildContext context,
    required String imageUrl,
    String? title,
    double minScale = 0.5,
    double maxScale = 4.0,
  }) {
    return show(
      context: context,
      title: title,
      minScale: minScale,
      maxScale: maxScale,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_rounded,
                  size: 72,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: ArogyaSewaColors.primaryColor,
            ),
          );
        },
      ),
    );
  }

  /// Show image from asset
  static Future<void> showAssetImage({
    required BuildContext context,
    required String assetPath,
    String? title,
    double minScale = 0.5,
    double maxScale = 4.0,
  }) {
    return show(
      context: context,
      title: title,
      minScale: minScale,
      maxScale: maxScale,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_rounded,
                  size: 72,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
