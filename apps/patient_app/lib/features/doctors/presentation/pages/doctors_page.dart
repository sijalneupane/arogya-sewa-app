import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:patient_app/config/routes/routes_name.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_bloc.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_event.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_state.dart';
import 'package:patient_app/features/home/presentation/widgets/doctor_card.dart';
import 'package:patient_app/features/home/presentation/widgets/doctors_error_widget.dart';
import 'package:patient_app/features/home/presentation/widgets/doctors_shimmer_widget.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/utils/screen_size.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  static const int _pageSize = 10;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  String? _name;
  String? _departmentName;
  bool _freeUpcomingOnly = false;
  DoctorStatusEnum? _status;

  @override
  void initState() {
    super.initState();
    _fetchDoctors(page: 1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _fetchDoctors({required int page}) {
    context.read<DoctorBloc>().add(
      FetchDoctorEvent(
        page: page,
        size: _pageSize,
        name: _name,
        departmentName: _departmentName,
        freeUpcomingOnly: _freeUpcomingOnly ? true : null,
        status: _status,
      ),
    );
  }

  void _loadMore(DoctorLoaded state) {
    if (state.hasReachedMax) return;

    context.read<DoctorBloc>().add(
      LoadMoreDoctorEvent(
        currentPage: state.currentPage + 1,
        size: _pageSize,
        name: _name,
        departmentName: _departmentName,
        freeUpcomingOnly: _freeUpcomingOnly ? true : null,
        status: _status,
      ),
    );
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _name = value.trim().isEmpty ? null : value.trim();
    });
    _fetchDoctors(page: 1);
  }

  Future<void> _showFilterSheet() async {
    _departmentController.text = _departmentName ?? '';
    bool localFreeUpcomingOnly = _freeUpcomingOnly;
    DoctorStatusEnum? localStatus = _status;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final sheetBgColor = isDarkMode
        ? const Color(0xFF1D255F)
        : ArogyaSewaColors.textColorWhite;
    final sheetBorderColor = isDarkMode
        ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.6)
        : ArogyaSewaColors.primaryColor.withValues(alpha: 0.2);
    final mutedTextColor = isDarkMode
        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.75)
        : ArogyaSewaColors.textColorGrey;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              margin: EdgeInsets.only(top: context.vh(2.8)),
              padding: EdgeInsets.fromLTRB(
                context.vw(4),
                context.vh(0.9),
                context.vw(4),
                MediaQuery.of(context).viewInsets.bottom + context.vh(1.4),
              ),
              decoration: BoxDecoration(
                color: sheetBgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: sheetBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 22,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ArogyaSewaColors.primaryColor.withValues(
                          alpha: 0.35,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  SizedBox(height: context.vh(1.1)),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: ArogyaSewaColors.primaryColor.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: ArogyaSewaColors.primaryColor,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: context.vw(1.8)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filterString,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                          ),
                          Text(
                            'Refine your doctor list',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: mutedTextColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.vh(1.2)),
                  TextField(
                    controller: _departmentController,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: departmentNameString,
                      labelStyle: const TextStyle(fontSize: 12),
                      prefixIcon: const Icon(
                        Icons.local_hospital_outlined,
                        size: 18,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.vw(2.5),
                        vertical: context.vh(1),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: sheetBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: sheetBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ArogyaSewaColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.vh(0.8)),
                  DropdownButtonFormField<DoctorStatusEnum?>(
                    value: localStatus,
                    isExpanded: true,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Status',
                      labelStyle: const TextStyle(fontSize: 12),
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        size: 18,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.vw(2.5),
                        vertical: context.vh(1),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: sheetBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: sheetBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ArogyaSewaColors.primaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<DoctorStatusEnum?>(
                        value: null,
                        child: Text('Any status', style: TextStyle(fontSize: 12)),
                      ),
                      ...DoctorStatusEnum.values.map(
                        (status) => DropdownMenuItem<DoctorStatusEnum?>(
                          value: status,
                          child: Text(
                            status.value,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setModalState(() {
                        localStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: context.vh(0.8)),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : ArogyaSewaColors.primaryColor.withValues(
                              alpha: 0.04,
                            ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.vw(2.5),
                      ),
                      title: const Text(
                        freeUpcomingOnlyString,
                        style: TextStyle(fontSize: 12),
                      ),
                      dense: true,
                      value: localFreeUpcomingOnly,
                      activeColor: ArogyaSewaColors.primaryColor,
                      onChanged: (value) {
                        setModalState(() {
                          localFreeUpcomingOnly = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: context.vh(1.1)),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(42),
                            side: BorderSide(color: sheetBorderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _departmentName = null;
                              _freeUpcomingOnly = false;
                              _status = null;
                            });
                            _departmentController.clear();
                            Navigator.of(context).pop();
                            _fetchDoctors(page: 1);
                          },
                          child: const Text(clearFilterString),
                        ),
                      ),
                      SizedBox(width: context.vw(2.4)),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(42),
                            backgroundColor: ArogyaSewaColors.primaryColor,
                            foregroundColor: ArogyaSewaColors.textColorWhite,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _departmentName =
                                  _departmentController.text.trim().isEmpty
                                  ? null
                                  : _departmentController.text.trim();
                              _freeUpcomingOnly = localFreeUpcomingOnly;
                              _status = localStatus;
                            });
                            Navigator.of(context).pop();
                            _fetchDoctors(page: 1);
                          },
                          child: const Text(applyFilterString),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
          doctorsString,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode
            ? ArogyaSewaColors.primaryColor
            : ArogyaSewaColors.textColorWhite,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(context.vh(2)),
        child: Column(
          children: [
            _buildSearchAndFilterBar(context, isDarkMode),
            SizedBox(height: context.vh(1.5)),
            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading || state is DoctorInitial) {
                    return const DoctorsShimmerWidget();
                  }

                  if (state is DoctorError) {
                    return DoctorsErrorWidget(
                      onRetry: () => _fetchDoctors(page: 1),
                    );
                  }

                  if (state is DoctorLoaded) {
                    final isLoadingMore = state is DoctorLoadingMore;

                    if (state.doctors.isEmpty) {
                      return const Center(child: Text(noDoctorsFoundString));
                    }

                    return GridView.builder(
                      itemCount:
                          state.doctors.length + (state.hasReachedMax ? 0 : 1),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.69,
                          ),
                      itemBuilder: (context, index) {
                        if (index == state.doctors.length) {
                          return GestureDetector(
                            onTap: () => _loadMore(state),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? ArogyaSewaColors.primaryColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : ArogyaSewaColors.primaryColor.withValues(
                                        alpha: 0.05,
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: ArogyaSewaColors.primaryColor
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Center(
                                child: state.hasReachedMax
                                    ? const SizedBox.shrink()
                                    : isLoadingMore
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: ArogyaSewaColors.primaryColor,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.expand_more_rounded,
                                            color:
                                                ArogyaSewaColors.primaryColor,
                                            size: 32,
                                          ),
                                          Text(
                                            viewMoreString,
                                            style: TextStyle(
                                              color:
                                                  ArogyaSewaColors.primaryColor,
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

                        return DoctorCard(
                          doctor: state.doctors[index],
                          onTap: () {
                            context.pushNamed(
                              RoutesName.doctorDetailScreen,
                              pathParameters: {
                                'doctorId': state.doctors[index].doctorId,
                              },
                            );
                          },
                        );
                      },
                    );
                  }

                  return const DoctorsShimmerWidget();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar(BuildContext context, bool isDarkMode) {
    final hasActiveFilters =
        (_departmentName?.isNotEmpty ?? false) ||
        _freeUpcomingOnly ||
        _status != null;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1B245F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode
              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.55)
              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.22 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.vw(2.2),
        vertical: context.vh(0.4),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.search_rounded,
              color: ArogyaSewaColors.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: context.vw(2.4)),
          Expanded(
            child: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.search,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: searchDoctorsString,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.65)
                      : ArogyaSewaColors.textColorGrey,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          SizedBox(width: context.vw(1.5)),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ArogyaSewaColors.primaryColor.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: ArogyaSewaColors.primaryColor,
                  ),
                ),
                if (hasActiveFilters)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? const Color(0xFF1B245F)
                              : ArogyaSewaColors.textColorWhite,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
