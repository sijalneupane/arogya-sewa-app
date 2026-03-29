import 'package:flutter/material.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';

class HospitalSearchScreen extends StatefulWidget {
  const HospitalSearchScreen({super.key});

  @override
  State<HospitalSearchScreen> createState() => _HospitalSearchScreenState();
}

class _HospitalSearchScreenState extends State<HospitalSearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          searchHospitalsString,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : ArogyaSewaColors.textColorWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.vw(2.5),
            vertical: context.vh(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: searchString,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDarkMode
                      ? ArogyaSewaColors.primaryColor.withOpacity(0.1)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: context.vh(3)),
              // Placeholder for search results
              Center(
                child: Text(
                  'Search results will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
