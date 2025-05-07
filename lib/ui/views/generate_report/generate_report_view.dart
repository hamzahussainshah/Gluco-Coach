import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';

import 'generate_report_viewmodel.dart';

class GenerateReportView extends StackedView<GenerateReportViewModel> {
  const GenerateReportView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      GenerateReportViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1A3C6D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with Shimmer Effect
                  Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.blueAccent,
                    child: Text(
                      "Generate Exercise Report",
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  20.verticalSpace,

                  // Glassmorphic Card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10.r,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Label
                        Text(
                          "Select Period:",
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        10.verticalSpace,

                        // Styled Dropdown Button
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.blue[900],
                            value: viewModel.selectedPeriod,
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            items: ['Weekly', 'Monthly']
                                .map(
                                  (period) => DropdownMenuItem<String>(
                                value: period,
                                child: Text(
                                  period,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                viewModel.setPeriod(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,

                  // Generate Report Button with Hover Effect
                  Center(
                    child: InkWell(
                      onTap: viewModel.isBusy
                          ? null
                          : () async {
                        await viewModel.generateAndSavePDF(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            viewModel.isBusy
                                ? const CircularProgressIndicator(
                              color: Colors.blue,
                            )
                                : const Icon(Icons.picture_as_pdf, color: Colors.blue),
                            10.horizontalSpace,
                            Text(
                              "Generate PDF Report",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  @override
  GenerateReportViewModel viewModelBuilder(BuildContext context) =>
      GenerateReportViewModel();
}
