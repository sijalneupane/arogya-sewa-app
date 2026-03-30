import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_app/core/constants/patient_app_strings_const.dart';
import 'package:shared_core/shared_core.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_bloc.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_event.dart';
import 'package:patient_app/features/doctors/presentation/bloc/doctor_detail_state.dart';
import 'package:shared_core/domain/entities/doctor_detail_entity.dart';
import 'package:shared_core/domain/enums/doctor_status_enum.dart';
import 'package:shared_ui/colors/arogya_sewa_color.dart';
import 'package:shared_ui/widgets/arogya_sewa_app_bar.dart';
import 'package:shared_ui/widgets/arogya_sewa_interactive_viewer.dart';

class DoctorDetailPage extends StatefulWidget {
  final String doctorId;

  const DoctorDetailPage({super.key, required this.doctorId});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorDetailBloc>().add(
      FetchDoctorDetailEvent(doctorId: widget.doctorId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = isDarkMode
        ? const Color(0xFF0F1338)
        : ArogyaSewaColors.scaffoldBackgroundColorLight;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: BlocBuilder<DoctorDetailBloc, DoctorDetailState>(
        builder: (context, state) {
          if (state is DoctorDetailLoading) {
            return _buildLoadingShimmer(isDarkMode);
          }

          if (state is DoctorDetailError) {
            return _buildErrorState(state.message, isDarkMode);
          }

          if (state is DoctorDetailLoaded) {
            return _buildDoctorDetailContent(state.doctor, isDarkMode);
          }

          return _buildErrorState(somethingWrongString, isDarkMode);
        },
      ),
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return CustomScrollView(
      slivers: [
        ArogyaSewaAppBar.createLoadingSliverAppBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(height: 28, width: 220),
                SizedBox(height: 12),
                _buildShimmerContainer(height: 18, width: 180),
                SizedBox(height: 24),
                _buildShimmerContainer(height: 120, width: double.infinity),
                SizedBox(height: 16),
                _buildShimmerContainer(height: 100, width: double.infinity),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? ArogyaSewaColors.shimmerBaseDark
            : ArogyaSewaColors.shimmerBaseLight,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildErrorState(String message, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 72,
              color: isDarkMode
                  ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.3)
                  : ArogyaSewaColors.textColorGrey.withValues(alpha: 0.3),
            ),
            SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                    : ArogyaSewaColors.textColorBlack.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DoctorDetailBloc>().add(
                  RetryFetchDoctorDetailEvent(doctorId: widget.doctorId),
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(retryString),
              style: ElevatedButton.styleFrom(
                backgroundColor: ArogyaSewaColors.primaryColor,
                foregroundColor: ArogyaSewaColors.textColorWhite,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorDetailContent(DoctorDetailEntity doctor, bool isDarkMode) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(doctor, isDarkMode),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorNameAndTitle(doctor, isDarkMode),
                SizedBox(height: 12),
                _buildStatusCard(doctor, isDarkMode),
                SizedBox(height: 16),
                _buildSectionTitle(professionalInformationString, isDarkMode),
                SizedBox(height: 8),
                _buildInfoCard(doctor, isDarkMode),
                SizedBox(height: 16),
                _buildSectionTitle(departmentDetailsString, isDarkMode),
                SizedBox(height: 8),
                _buildDepartmentCard(doctor, isDarkMode),
                SizedBox(height: 16),
                _buildSectionTitle(hospitalInformationString, isDarkMode),
                SizedBox(height: 8),
                _buildHospitalCard(doctor, isDarkMode),
                SizedBox(height: 16),
                _buildSectionTitle(contactInformationString, isDarkMode),
                SizedBox(height: 8),
                _buildContactCard(doctor, isDarkMode),
                if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
                  SizedBox(height: 16),
                  _buildSectionTitle(aboutString, isDarkMode),
                  SizedBox(height: 8),
                  _buildBioCard(doctor, isDarkMode),
                ],
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorNameAndTitle(DoctorDetailEntity doctor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.user.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? ArogyaSewaColors.textColorWhite
                : ArogyaSewaColors.textColorBlack,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    size: 14,
                    color: ArogyaSewaColors.primaryColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    doctor.department.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ArogyaSewaColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            if (doctor.experience.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.work_outline_rounded,
                      size: 14,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.6)
                          : ArogyaSewaColors.textColorGrey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      doctor.experience,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                            : ArogyaSewaColors.textColorGrey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar(DoctorDetailEntity doctor, bool isDarkMode) {
    final profileImage = doctor.user.profileImage;
    final hasProfileImage = profileImage != null && profileImage.fileUrl.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      backgroundColor: isDarkMode
          ? ArogyaSewaColors.primaryColor
          : ArogyaSewaColors.textColorWhite,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDarkMode
                ? ArogyaSewaColors.textColorWhite
                : ArogyaSewaColors.textColorBlack,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [
                      ArogyaSewaColors.primaryColor,
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.85),
                    ]
                  : [
                      ArogyaSewaColors.primaryColor.withValues(alpha: 0.08),
                      ArogyaSewaColors.textColorWhite,
                    ],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (hasProfileImage) {
                          ArogyaSewaInteractiveViewer.showNetworkImage(
                            context: context,
                            imageUrl: profileImage.fileUrl,
                            title: doctor.user.name,
                            maxScale: 5.0,
                          );
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ArogyaSewaColors.primaryColor.withValues(alpha: 0.2)
                              : ArogyaSewaColors.primaryColor.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.3),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.1),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: hasProfileImage
                              ? Image.network(
                                  profileImage.fileUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person_rounded,
                                      size: 50,
                                      color: isDarkMode
                                          ? ArogyaSewaColors.textColorWhite
                                          : ArogyaSewaColors.textColorBlack,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: isDarkMode
                                      ? ArogyaSewaColors.textColorWhite
                                      : ArogyaSewaColors.textColorBlack,
                                ),
                        ),
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

  Widget _buildStatusCard(DoctorDetailEntity doctor, bool isDarkMode) {
    final isAvailable = doctor.status == DoctorStatusEnum.available;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable
              ? Colors.green.withValues(alpha: 0.15)
              : Colors.orange.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isAvailable
                ? Colors.green.withValues(alpha: 0.04)
                : Colors.orange.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green.withValues(alpha: 0.08)
                  : Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isAvailable
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              color: isAvailable ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentStatusString,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode
                        ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.45)
                        : ArogyaSewaColors.textColorGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  doctor.status.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          if (doctor.licenseCertificate != null)
            GestureDetector(
              onTap: () {
                ArogyaSewaInteractiveViewer.showNetworkImage(
                  context: context,
                  imageUrl: doctor.licenseCertificate!.fileUrl,
                  title: licenseCertificateString,
                  maxScale: 5.0,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: ArogyaSewaColors.primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      licenseString,
                      style: TextStyle(
                        color: ArogyaSewaColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
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

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: isDarkMode
            ? ArogyaSewaColors.textColorWhite
            : ArogyaSewaColors.textColorBlack,
      ),
    );
  }

  Widget _buildInfoCard(DoctorDetailEntity doctor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.15 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.badge_rounded,
            label: doctorIdString,
            value: doctor.doctorId,
            isDarkMode: isDarkMode,
            showDivider: true,
          ),
          _buildInfoRow(
            icon: Icons.medical_services_rounded,
            label: experienceString,
            value: doctor.experience,
            isDarkMode: isDarkMode,
            showDivider: true,
          ),
          _buildInfoRow(
            icon: Icons.person_rounded,
            label: fullNameString,
            value: doctor.user.name,
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: ArogyaSewaColors.primaryColor,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.4)
                          : ArogyaSewaColors.textColorGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite
                          : ArogyaSewaColors.textColorBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDarkMode
                ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.06)
                : ArogyaSewaColors.textColorBlack.withValues(alpha: 0.06),
          ),
          SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildDepartmentCard(DoctorDetailEntity doctor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: ArogyaSewaColors.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 14),
              Text(
                departmentString,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : ArogyaSewaColors.primaryColor.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.department.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ArogyaSewaColors.primaryColor,
                    letterSpacing: -0.3,
                  ),
                ),
                if (doctor.department.description != null &&
                    doctor.department.description!.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text(
                    doctor.department.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.65)
                          : ArogyaSewaColors.textColorGrey,
                      height: 1.6,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(DoctorDetailEntity doctor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.business_rounded,
                  color: Colors.teal,
                  size: 24,
                ),
              ),
              SizedBox(width: 14),
              Text(
                hospitalString,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              if (doctor.hospital.logo != null &&
                  doctor.hospital.logo!.fileUrl.isNotEmpty)
                Container(
                  width: 64,
                  height: 64,
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ArogyaSewaColors.primaryColor.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      doctor.hospital.logo!.fileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDarkMode
                              ? Colors.grey.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          child: Icon(
                            Icons.business_rounded,
                            color: isDarkMode
                                ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.3)
                                : ArogyaSewaColors.textColorGrey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.hospital.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite
                            : ArogyaSewaColors.textColorBlack,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: isDarkMode
                              ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.4)
                              : ArogyaSewaColors.textColorGrey,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            doctor.hospital.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.55)
                                  : ArogyaSewaColors.textColorGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: ArogyaSewaColors.primaryColor,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      establishedString,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.45)
                            : ArogyaSewaColors.textColorGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      DateFormatter.formatDateStandard(doctor.hospital.openedDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode
                            ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.7)
                            : ArogyaSewaColors.textColorGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(DoctorDetailEntity doctor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              SizedBox(width: 14),
              Text(
                contactString,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          _buildContactTile(
            icon: Icons.email_rounded,
            title: emailAddressString,
            subtitle: doctor.user.email,
            onTap: () => UrlLauncher.launchEmail(doctor.user.email),
            isDarkMode: isDarkMode,
          ),
          Divider(
            height: 24,
            color: isDarkMode
                ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.08)
                : ArogyaSewaColors.textColorBlack.withValues(alpha: 0.08),
          ),
          _buildContactTile(
            icon: Icons.phone_rounded,
            title: phoneNumberString,
            subtitle: doctor.user.phoneNumber,
            onTap: () => UrlLauncher.launchPhone(doctor.user.phoneNumber),
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: ArogyaSewaColors.primaryColor,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.45)
                          : ArogyaSewaColors.textColorGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? ArogyaSewaColors.textColorWhite
                          : ArogyaSewaColors.textColorBlack,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: isDarkMode
                  ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.3)
                  : ArogyaSewaColors.textColorGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioCard(DoctorDetailEntity doctor, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D255F)
            : ArogyaSewaColors.textColorWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.info_rounded,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              SizedBox(width: 14),
              Text(
                aboutDoctorString,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ArogyaSewaColors.textColorWhite
                      : ArogyaSewaColors.textColorBlack,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              doctor.bio!,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? ArogyaSewaColors.textColorWhite.withValues(alpha: 0.75)
                    : ArogyaSewaColors.textColorBlack.withValues(alpha: 0.8),
                height: 1.7,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
