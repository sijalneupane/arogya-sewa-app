import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_event.dart';
import 'package:patient_app/features/home/presentation/bloc/home_state.dart';
import 'package:patient_app/features/home/presentation/pages/hospital_card.dart';
import 'package:patient_app/features/home/presentation/pages/hospital_search_screen.dart';
import 'package:shared_core/services/location_service.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/search/arogya_sewa_search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() {
    context.read<HomeBloc>().add(const CheckLocationPermissionEvent());
  }

  Future<void> _requestLocationPermission() async {
    context.read<HomeBloc>().add(const RequestLocationPermissionEvent());
  }

  Future<void> _fetchNearestHospitals() async {
    try {
      final locationService = GetIt.instance<LocationService>();
      final position = await locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        context.read<HomeBloc>().add(
              FetchNearestHospitalsEvent(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
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
          homeString,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : ArogyaSewaColors.textColorWhite,
        elevation: 0,
        centerTitle: false,
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is LocationPermissionGranted) {
            _fetchNearestHospitals();
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.vh(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArogyaSewaSearchBar(
                      hintText: searchHospitalsString,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const HospitalSearchScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.vh(3)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.vw(2.5)),
                      child: Text(
                        nearestHospitalsString,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                      ),
                    ),
                    SizedBox(height: context.vh(2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.vw(2.5)),
                      child: _buildHospitalContent(context, state, isDarkMode),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHospitalContent(
    BuildContext context,
    HomeState state,
    bool isDarkMode,
  ) {
    final textColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite
        : ArogyaSewaColors.textColorBlack;

    if (state is LocationPermissionCheckLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: ArogyaSewaColors.primaryColor,
        ),
      );
    }

    if (state is LocationPermissionDenied) {
      return _buildLocationPermissionDenied(context, textColor);
    }

    if (state is NearestHospitalsLoading) {
      return Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: ArogyaSewaColors.primaryColor,
            ),
            SizedBox(height: context.vh(1)),
            Text(
              fetchingHospitalsString,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      );
    }

    if (state is NearestHospitalsError) {
      return _buildErrorWidget(context, state.message);
    }

    if (state is NearestHospitalsLoaded) {
      if (state.hospitals.isEmpty) {
        return Center(
          child: Text(
            noHospitalsFoundString,
            style: TextStyle(color: textColor),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.hospitals.length,
        itemBuilder: (context, index) {
          return HospitalCard(
            hospital: state.hospitals[index],
            onTap: () {
              // Navigate to hospital details page when available.
            },
          );
        },
      );
    }

    return _buildLocationPermissionDenied(context, textColor);
  }

  Widget _buildLocationPermissionDenied(BuildContext context, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 64,
            color: ArogyaSewaColors.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: context.vh(2)),
          Text(
            locationDisabledString,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.vh(1)),
          Text(
            enableLocationDescString,
            style: TextStyle(
              color: ArogyaSewaColors.textColorGrey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.vh(3)),
          ElevatedButton(
            onPressed: _requestLocationPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: ArogyaSewaColors.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: context.vw(8),
                vertical: context.vh(1.5),
              ),
            ),
            child: Text(
              enableLocationString,
              style: const TextStyle(color: ArogyaSewaColors.textColorWhite),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          SizedBox(height: context.vh(2)),
          Text(
            failedToFetchHospitalsString,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.vh(1)),
          Text(
            message,
            style: const TextStyle(
              color: ArogyaSewaColors.textColorGrey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.vh(3)),
          ElevatedButton(
            onPressed: _checkLocationPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: ArogyaSewaColors.primaryColor,
            ),
            child: const Text(
              retryString,
              style: TextStyle(color: ArogyaSewaColors.textColorWhite),
            ),
          ),
        ],
      ),
    );
  }
}
