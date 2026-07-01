import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_pagination.dart';
import 'package:drive_mate_dash_board/core/widgets/custom_search_field.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/empty_state_widget.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:drive_mate_dash_board/features/dataset/data/model/dataset_model.dart';
import 'package:drive_mate_dash_board/features/dataset/data/repo/dataset_repo.dart';
import 'package:drive_mate_dash_board/features/dataset/manager/dataset_cubit.dart';
import 'package:drive_mate_dash_board/features/dataset/manager/dataset_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatasetsPage extends StatelessWidget {
  const DatasetsPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DatasetsCubit(DatasetsRepoImpl())..loadSamples(),
      child: _DatasetsView(adminType: adminType),
    );
  }
}

// ── Internal view ──────────────────────────────────────────────────────────

class _DatasetsView extends StatefulWidget {
  const _DatasetsView({required this.adminType});

  final AdminType adminType;

  @override
  State<_DatasetsView> createState() => _DatasetsViewState();
}

class _DatasetsViewState extends State<_DatasetsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Datasets',
      selectedRoute: RouteNames.datasets,
      adminType: widget.adminType,
      child: BlocConsumer<DatasetsCubit, DatasetsState>(
        // Show a snackbar when export finishes
        listener: (context, state) {
          if (state is DatasetsLoaded &&
              context.read<DatasetsCubit>().state is! DatasetsExporting) {
            // no-op — export success snackbar handled below via previous state
          }
        },
        builder: (context, state) {
          // Resolve shared fields across loaded / action states
          final samples = switch (state) {
            DatasetsLoaded(:final samples) => samples,
            DatasetsActionLoading(:final samples) => samples,
            DatasetsExporting(:final samples) => samples,
            _ => <AudioSample>[],
          };

          final stats = switch (state) {
            DatasetsLoaded(:final stats) => stats,
            DatasetsActionLoading(:final stats) => stats,
            DatasetsExporting(:final stats) => stats,
            _ => null,
          };

          final page = switch (state) {
            DatasetsLoaded(:final page) => page,
            DatasetsActionLoading(:final page) => page,
            DatasetsExporting(:final page) => page,
            _ => 1,
          };

          final actionSampleId = switch (state) {
            DatasetsActionLoading(:final sampleId) => sampleId,
            _ => null,
          };

          final isExporting = state is DatasetsExporting;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search + filter
              Row(
                children: [
                  Expanded(
                    child: CustomSearchField(
                      hintText: 'Search samples...',
                      controller: _searchController,
                      onChanged: (v) => context.read<DatasetsCubit>().search(v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _IconBtn(icon: Icons.filter_list_rounded, onTap: () {}),
                ],
              ),
              const SizedBox(height: 16),

              // Stats row
              if (stats != null) ...[
                _StatsRow(stats: stats),
                const SizedBox(height: 20),
              ],

              // List header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Samples List',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: isExporting
                        ? null
                        : () => context.read<DatasetsCubit>().exportMetadata(),
                    icon: isExporting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : const Icon(
                            Icons.download_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                    label: Text(
                      isExporting ? 'Exporting...' : 'Export Metadata',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Body
              if (state is DatasetsLoading)
                const LoadingWidget()
              else if (state is DatasetsError)
                _ErrorRetry(message: state.message)
              else if (samples.isEmpty)
                const EmptyStateWidget(
                  title: 'No Samples Found',
                  message: 'No audio samples match your search.',
                )
              else
                ...samples.map(
                  (s) => _SampleCard(
                    sample: s,
                    isActionLoading: actionSampleId == s.id,
                  ),
                ),

              const SizedBox(height: 8),
              CustomPagination(currentPage: page),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

// ── Icon button ────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.muted, size: 20),
        onPressed: onTap,
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final DatasetsStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'TOTAL', value: '${stats.total}', dark: true),
        const SizedBox(width: 12),
        _StatCard(label: 'PROCESSED', value: '${stats.processed}'),
        const SizedBox(width: 12),
        _StatCard(
          label: 'LABELED',
          value: '${stats.labeled}',
          valueColor: AppColors.teal,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.dark = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool dark;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: dark ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dark ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white60 : AppColors.muted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: dark ? Colors.white : (valueColor ?? AppColors.text),
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sample card ────────────────────────────────────────────────────────────

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.sample, required this.isActionLoading});

  final AudioSample sample;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final isLabeled = sample.label == SampleLabel.labeled;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CardSurface(
        onTap: () => _showDetail(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID + date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sample.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    sample.date,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Car model
              Text(
                sample.carModel,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Tags + optional action spinner
              Row(
                children: [
                  _Tag(
                    label: 'Raw',
                    bgColor: AppColors.background,
                    textColor: AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  _Tag(
                    label: isLabeled ? 'Labeled' : 'Unlabeled',
                    bgColor: isLabeled
                        ? AppColors.softBlue
                        : Colors.orange.withValues(alpha: 0.08),
                    textColor: isLabeled
                        ? AppColors.primary
                        : Colors.orange.shade700,
                    borderColor: isLabeled
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                  if (!sample.isProcessed) ...[
                    const SizedBox(width: 8),
                    _Tag(
                      label: 'Unprocessed',
                      bgColor: Colors.red.withValues(alpha: 0.07),
                      textColor: Colors.red.shade600,
                      borderColor: Colors.red.withValues(alpha: 0.2),
                    ),
                  ],
                  if (isActionLoading) ...[
                    const Spacer(),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final cubit = context.read<DatasetsCubit>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(sample.id),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Car Model', value: sample.carModel),
            _DetailRow(label: 'Date', value: sample.date),
            _DetailRow(
              label: 'Label',
              value: sample.label == SampleLabel.labeled
                  ? 'Labeled'
                  : 'Unlabeled',
            ),
            _DetailRow(
              label: 'Processed',
              value: sample.isProcessed ? 'Yes' : 'No',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (sample.label == SampleLabel.unlabeled)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                cubit.markAsLabeled(sample.id);
              },
              child: const Text('Mark as Labeled'),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          Text(value, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.borderColor,
  });

  final String label;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Error + retry ──────────────────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 44),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<DatasetsCubit>().loadSamples(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
