import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/common/widgets/hospital_card.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_event.dart';
import 'package:patient_app/features/home/presentation/bloc/home_state.dart';
import 'package:patient_app/features/home/presentation/pages/hospital_search_screen.dart';
import 'package:patient_app/features/home/presentation/widgets/hospitals_empty_state_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/hospitals_shimmer_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/location_permission_widget.dart';
import 'package:shared_core/services/location_service.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/app_toast.dart';
import 'package:shared_ui/widgets/arogya_sewa_retry_widget.dart';
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
        AppToast.error(
          context,
          'Error getting location: $e',
          title: 'Location Error',
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
                    SizedBox(
                      height: context.vh(28),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: context.vw(2.5)),
                            child: _buildNearestHospitalsSection(context, state, isDarkMode, constraints),
                          );
                        },
                      ),
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

  Widget _buildNearestHospitalsSection(
    BuildContext context,
    HomeState state,
    bool isDarkMode,
    BoxConstraints constraints,
  ) {
    if (state is LocationPermissionCheckLoading) {
      return const HospitalsShimmerWidget();
    }

    if (state is LocationPermissionDenied) {
      return LocationPermissionWidget(
        onRequestPermission: _requestLocationPermission,
      );
    }

    if (state is NearestHospitalsLoading) {
      return const HospitalsShimmerWidget();
    }

    if (state is NearestHospitalsError) {
      return _buildErrorWidget(context, state.message);
    }

    if (state is NearestHospitalsLoaded) {
      if (state.hospitals.isEmpty) {
        return const HospitalsEmptyStateWidget();
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: state.hospitals.length,
        itemBuilder: (context, index) {
          final hospital = state.hospitals[index];
          return HospitalCard(
            hospital: hospital,
            onTap: () {
              // Navigate to hospital details page when available.
              AppToast.success(context, 'Tapped on ${hospital.name}');
            },
          );
        },
      );
    }

    return LocationPermissionWidget(
      onRequestPermission: _requestLocationPermission,
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return ArogyaSewaRetryWidget(
      message: message,
      onRetry: _checkLocationPermission,
      useCard: false,
      buttonText: retryString,
    );
  }
}
