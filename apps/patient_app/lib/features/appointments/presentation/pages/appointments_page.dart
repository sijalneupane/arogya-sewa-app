import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_bloc.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_event.dart';
import 'package:patient_app/features/appointments/presentation/bloc/patient_appointment_state.dart';
import 'package:patient_app/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:patient_app/features/appointments/presentation/widgets/appointment_filter_sheet.dart';
import 'package:patient_app/features/appointments/presentation/widgets/appointments_shimmer_widget.dart';
import 'package:shared_core/constants/arogya_sewa_string_const.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_feature/auth/presentation/bloc/auth_state.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';
import 'package:shared_ui/widgets/arogya_sewa_app_bar.dart';
import 'package:shared_ui/widgets/arogya_sewa_login_prompt.dart';
import 'package:shared_ui/widgets/arogya_sewa_retry_widget.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  static const int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Only fetch appointments if user is authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<AuthBloc>().state is AuthAuthenticated) {
        _fetchAppointments(page: 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchAppointments({required int page}) {
    final bloc = context.read<PatientAppointmentBloc>();
    bloc.add(
      FetchPatientAppointmentsEvent(
        page: page,
        size: _pageSize,
        status: bloc.currentStatus,
        dateFrom: bloc.currentDateFrom,
        dateTo: bloc.currentDateTo,
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_scrollController.position.outOfRange) {
      final state = context.read<PatientAppointmentBloc>().state;
      if (state is PatientAppointmentLoaded) {
        _loadMore(state);
      }
    }
  }

  void _loadMore(PatientAppointmentLoaded state) {
    if (state.hasReachedMax) return;

    context.read<PatientAppointmentBloc>().add(
          LoadMorePatientAppointmentsEvent(
            currentPage: state.currentPage + 1,
            size: _pageSize,
            status: context.read<PatientAppointmentBloc>().currentStatus,
            dateFrom: context.read<PatientAppointmentBloc>().currentDateFrom,
            dateTo: context.read<PatientAppointmentBloc>().currentDateTo,
          ),
        );
  }

  void _onRefresh() async {
    final bloc = context.read<PatientAppointmentBloc>();
    bloc.add(
      RefreshPatientAppointmentsEvent(
        page: 1,
        size: _pageSize,
        status: bloc.currentStatus,
        dateFrom: bloc.currentDateFrom,
        dateTo: bloc.currentDateTo,
      ),
    );
  }

  void _showFilterSheet() {
    final bloc = context.read<PatientAppointmentBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentFilterSheet(
        currentStatus: bloc.currentStatus,
        currentDateFrom: bloc.currentDateFrom,
        currentDateTo: bloc.currentDateTo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isAuthenticated = context.select<AuthBloc, bool>(
      (bloc) => bloc.state is AuthAuthenticated,
    );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous is! AuthAuthenticated && current is AuthAuthenticated,
      listener: (context, state) {
        _fetchAppointments(page: 1);
      },
      child: Scaffold(
        appBar: ArogyaSewaAppBar.create(
          context: context,
          title: 'My Appointments',
          actions: [
            IconButton(
              onPressed: _showFilterSheet,
              icon: Icon(
                Icons.filter_list_rounded,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite
                    : ArogyaSewaColors.textColorBlack,
              ),
              tooltip: 'Filter',
            ),
          ],
        ),
        body: isAuthenticated
            ? BlocBuilder<PatientAppointmentBloc, PatientAppointmentState>(
                builder: (context, state) {
                  return _buildBody(context, state, isDarkMode);
                },
              )
            : ArogyaSewaLoginPrompt(
                message: loginToAccessAppointmentsString,
                loginRouteName: RoutesName.loginScreen,
                onLoginSuccess: () {
                  _fetchAppointments(page: 1);
                },
              ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PatientAppointmentState state,
    bool isDarkMode,
  ) {
    if (state is PatientAppointmentInitial ||
        state is PatientAppointmentLoading) {
      return _buildShimmerLoading();
    }

    if (state is PatientAppointmentError) {
      return _buildErrorState(context, state);
    }

    if (state is PatientAppointmentLoaded ||
        state is PatientAppointmentLoadingMore ||
        state is PatientAppointmentRefreshing) {
      return _buildLoadedState(context, state, isDarkMode);
    }

    return const SizedBox.shrink();
  }

  Widget _buildShimmerLoading() {
    return const AppointmentsShimmerWidget();
  }

  Widget _buildErrorState(
    BuildContext context,
    PatientAppointmentError state,
  ) {
    return ArogyaSewaRetryWidget(
      message: state.message,
      onRetry: () {
        context.read<PatientAppointmentBloc>().add(
              RetryFetchPatientAppointmentsEvent(
                page: 1,
                size: _pageSize,
              ),
            );
      },
      useCard: false,
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    PatientAppointmentState state,
    bool isDarkMode,
  ) {
    final loadedState = state as PatientAppointmentLoaded;
    final appointments = loadedState.appointments;

    if (appointments.isEmpty && state is! PatientAppointmentRefreshing) {
      return _buildEmptyState(context, isDarkMode);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _onRefresh();
        // Wait for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: ArogyaSewaColors.primaryColor,
      backgroundColor: isDarkMode
          ? ArogyaSewaColors.cardBackgroundColorDark
          : ArogyaSewaColors.cardBackgroundColorLight,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// Active Filters Indicator
          if (loadedState.currentPage == 1 &&
              (context.read<PatientAppointmentBloc>().currentStatus != null ||
                  context.read<PatientAppointmentBloc>().currentDateFrom !=
                      null ||
                  context.read<PatientAppointmentBloc>().currentDateTo !=
                      null))
            SliverToBoxAdapter(
              child: _buildActiveFiltersBar(context, isDarkMode),
            ),

          /// Appointments List
          SliverPadding(
            padding: EdgeInsets.all(context.vw(4)),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= appointments.length) {
                    return _buildLoadingMoreIndicator(isDarkMode);
                  }
                  return AppointmentCard(
                    appointment: appointments[index],
                    onTap: () => _navigateToAppointmentDetail(
                      context,
                      appointments[index].appointmentId,
                    ),
                  );
                },
                childCount: appointments.length +
                    (loadedState.isLoadingMore ? 1 : 0),
              ),
            ),
          ),

          /// Loading More Indicator
          if (loadedState.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ),

          /// End of List Indicator
          if (loadedState.hasReachedMax && appointments.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'You\'ve reached the end',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.5)
                        : ArogyaSewaColors.textColorGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveFiltersBar(BuildContext context, bool isDarkMode) {
    final bloc = context.read<PatientAppointmentBloc>();
    final hasFilters = bloc.currentStatus != null ||
        bloc.currentDateFrom != null ||
        bloc.currentDateTo != null;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.15)
            : ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.4)
              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt_rounded,
            color: isDarkMode
                ? ArogyaSewaColors.textColorWhite
                : ArogyaSewaColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Filters active',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite
                        : ArogyaSewaColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              bloc.add(const ClearFiltersPatientAppointmentsEvent());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.red.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.red.withValues(alpha: 0.4)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.clear_rounded,
                    size: 14,
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite
                        : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Clear',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    final bloc = context.read<PatientAppointmentBloc>();
    final hasFilters = bloc.currentStatus != null ||
        bloc.currentDateFrom != null ||
        bloc.currentDateTo != null;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.vw(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(context.vw(5)),
              decoration: BoxDecoration(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 64,
                color: ArogyaSewaColors.primaryColor,
              ),
            ),
            SizedBox(height: context.vh(2)),
            Text(
              hasFilters ? 'No appointments match your filters' : 'No appointments yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite
                        : ArogyaSewaColors.textColorBlack,
                  ),
            ),
            SizedBox(height: context.vh(1)),
            Text(
              hasFilters
                  ? 'Try adjusting your filters to see more results'
                  : 'You haven\'t booked any appointments yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                        : ArogyaSewaColors.textColorGrey,
                  ),
            ),
            if (hasFilters) ...[
              SizedBox(height: context.vh(3)),
              ElevatedButton.icon(
                onPressed: () {
                  bloc.add(const ClearFiltersPatientAppointmentsEvent());
                },
                icon: const Icon(Icons.filter_list_off_rounded),
                label: const Text('Clear Filters'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ArogyaSewaColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            ArogyaSewaColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void _navigateToAppointmentDetail(BuildContext context, String appointmentId) {
    
  }
}
