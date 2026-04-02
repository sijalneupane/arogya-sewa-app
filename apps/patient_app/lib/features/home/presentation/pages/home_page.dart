import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/common/widgets/hospital_card.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_event.dart';
import 'package:patient_app/features/home/presentation/bloc/home_doctor_state.dart';
import 'package:patient_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:patient_app/features/home/presentation/bloc/home_event.dart';
import 'package:patient_app/features/home/presentation/bloc/home_state.dart';
import 'package:patient_app/features/home/presentation/widgets/doctor_card.dart';
import 'package:patient_app/features/home/presentation/widgets/doctors_error_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/doctors_shimmer_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/hospitals_empty_state_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/hospitals_shimmer_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/location_permission_widget.dart';
import 'package:shared_core/services/location_service.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';
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
  final ScrollController _doctorsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchDoctors();
    _doctorsScrollController.addListener(_onDoctorsScroll);
  }

  @override
  void dispose() {
    _doctorsScrollController.removeListener(_onDoctorsScroll);
    _doctorsScrollController.dispose();
    super.dispose();
  }

  void _checkLocationPermission() {
    context.read<HomeBloc>().add(const CheckLocationPermissionEvent());
  }

  void _requestLocationPermission() {
    context.read<HomeBloc>().add(const RequestLocationPermissionEvent());
  }

  Future<void> _onLocationPermissionGranted() async {
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

  void _fetchDoctors() {
    context.read<HomeDoctorBloc>().add(const FetchHomeDoctorEvent());
  }

  void _onDoctorsScroll() {
    if (_doctorsScrollController.position.pixels >=
        _doctorsScrollController.position.maxScrollExtent - 200) {
      final state = context.read<HomeDoctorBloc>().state;
      if (state is HomeDoctorLoaded && !state.hasReachedMax) {
        context.read<HomeDoctorBloc>().add(
          LoadMoreHomeDoctorEvent(currentPage: state.currentPage + 1),
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
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : ArogyaSewaColors.textColorWhite,
        elevation: 0,
        centerTitle: false,
        actions: [
          // User name from AuthBloc
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Padding(
                  padding: EdgeInsets.only(right: context.vw(2)),
                  child: Row(
                    children: [
                      // User name
                      Text(
                        state.userData.name,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: context.vw(1)),
                      // User avatar icon
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: ArogyaSewaColors.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: ArogyaSewaColors.textColorWhite,
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Show login prompt or empty container when not authenticated
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is LocationPermissionGranted) {
            _onLocationPermissionGranted();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.vh(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Search Bar
                ArogyaSewaSearchBar(
                  hintText: searchHospitalsString,
                  onTap: () {
                    context.pushNamed(RoutesName.hospitalSearchScreen);
                  },
                ),
                SizedBox(height: context.vh(2)),

                /// Nearest Hospitals Section
                Text(
                  nearestHospitalsString,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: context.vh(1)),
                SizedBox(
                  height: context.vh(30),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return _buildNearestHospitalsSection(
                        context,
                        state,
                        isDarkMode,
                      );
                    },
                  ),
                ),
                SizedBox(height: context.vh(3)),

                /// Top Doctors Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topDoctorsString,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(RoutesName.doctorsScreen),
                      child: Text(
                        viewAllString,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ArogyaSewaColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.vh(1)),
                BlocBuilder<HomeDoctorBloc, HomeDoctorState>(
                  builder: (context, state) {
                    return _buildDoctorsSection(context, state, isDarkMode);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearestHospitalsSection(
    BuildContext context,
    HomeState state,
    bool isDarkMode,
  ) {
    if (state is LocationPermissionDenied) {
      return LocationPermissionWidget(
        onRequestPermission: _requestLocationPermission,
      );
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
              AppToast.success(context, 'Tapped on ${hospital.name}');
            },
          );
        },
      );
    }

    // For initial/transient states (initial, checking permission, granted, loading),
    // keep a stable loading UI to avoid flickering between permission and retry widgets.
    return const HospitalsShimmerWidget();
  }

  Widget _buildDoctorsSection(
    BuildContext context,
    HomeDoctorState state,
    bool isDarkMode,
  ) {
    if (state is HomeDoctorLoading) {
      return const DoctorsShimmerWidget();
    }

    if (state is HomeDoctorError) {
      return DoctorsErrorWidget(onRetry: _fetchDoctors);
    }

    if (state is HomeDoctorLoaded) {
      if (state.doctors.isEmpty) {
        return _buildNoDoctorsWidget(context, isDarkMode);
      }

      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.69,
            ),
            itemCount: state.doctors.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == state.doctors.length) {
                return _buildLoadMoreButton(context, state, isDarkMode);
              }
              return DoctorCard(
                doctor: state.doctors[index],
                onTap: () {
                  AppToast.success(
                    context,
                    'Tapped on Dr. ${state.doctors[index].user.name}',
                  );
                },
              );
            },
          ),
        ],
      );
    }

    return const DoctorsShimmerWidget();
  }

  Widget _buildLoadMoreButton(
    BuildContext context,
    HomeDoctorLoaded state,
    bool isDarkMode,
  ) {
    final isLoadingMore = context.select<HomeDoctorBloc, bool>(
      (bloc) => bloc.state is HomeDoctorLoadingMore,
    );

    return GestureDetector(
      onTap: () {
        context.read<HomeDoctorBloc>().add(
          LoadMoreHomeDoctorEvent(currentPage: state.currentPage + 1),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.1)
              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: isLoadingMore
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ArogyaSewaColors.primaryColor,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_more_rounded,
                      color: ArogyaSewaColors.primaryColor,
                      size: 32,
                    ),
                    Text(
                      viewMoreString,
                      style: TextStyle(
                        color: ArogyaSewaColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildNoDoctorsWidget(BuildContext context, bool isDarkMode) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(context.vw(4)),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.vw(4)),
              decoration: BoxDecoration(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: context.vw(10),
                color: ArogyaSewaColors.primaryColor,
              ),
            ),
            SizedBox(height: context.vh(2)),
            Text(
              noDoctorsFoundString,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite
                    : ArogyaSewaColors.textColorBlack,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.vh(1)),
            Text(
              noDoctorsFoundDescString,
              style: TextStyle(
                color: ArogyaSewaColors.textColorGrey,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
