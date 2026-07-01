import 'package:drive_mate_dash_board/core/routing/route_names.dart';
import 'package:drive_mate_dash_board/core/theme/app_colors.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:drive_mate_dash_board/core/widgets/dashboard_shell.dart';
import 'package:drive_mate_dash_board/core/widgets/loading_widget.dart';
import 'package:drive_mate_dash_board/features/articls/data/model/article_model.dart';
import 'package:drive_mate_dash_board/features/articls/data/repo/article_repo.dart';
import 'package:drive_mate_dash_board/features/articls/manager/articl_cubit.dart';
import 'package:drive_mate_dash_board/features/articls/manager/articl_stat.dart';
import 'package:drive_mate_dash_board/features/auth/data/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key, required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit(AnalyticsRepoImpl())
        ..loadSummary(AnalyticsPeriod.sevenDays),
      child: _AnalyticsView(adminType: adminType),
    );
  }
}

// ── Internal stateless view ────────────────────────────────────────────────

class _AnalyticsView extends StatelessWidget {
  const _AnalyticsView({required this.adminType});

  final AdminType adminType;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      title: 'Analytics',
      selectedRoute: RouteNames.analytics,
      adminType: adminType,
      maxContentWidth: 760,
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          return switch (state) {
            AnalyticsInitial() || AnalyticsLoading() => const Padding(
                padding: EdgeInsets.only(top: 80),
                child: LoadingWidget(),
              ),
            AnalyticsError(:final message) => _ErrorBody(message: message),
            AnalyticsLoaded(:final summary, :final period) => _LoadedBody(
                summary: summary,
                period: period,
              ),
          };
        },
      ),
    );
  }
}

// ── Error body ─────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
            const SizedBox(height: 12),
            Text(
              'Failed to load analytics',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<AnalyticsCubit>().loadSummary(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loaded body ────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.summary, required this.period});

  final AnalyticsSummary summary;
  final AnalyticsPeriod period;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PeriodSelector(selected: period),
        const SizedBox(height: 20),
        _HighlightGrid(summary: summary),
        const SizedBox(height: 24),
        _TopCarsCard(entries: summary.topCars),
        const SizedBox(height: 20),
        _MostChangedPartsCard(parts: summary.mostChangedParts),
        const SizedBox(height: 20),
        _TopServiceCentersCard(centers: summary.topServiceCenters),
        const SizedBox(height: 20),
        _AudioDatasetCard(dataset: summary.audioDataset),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Period selector ────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected});

  final AnalyticsPeriod selected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              ...AnalyticsPeriod.values.map((p) {
                final isSel = selected == p;
                return GestureDetector(
                  onTap: () => cubit.changePeriod(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.navy : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      p.label,
                      style: TextStyle(
                        color: isSel ? Colors.white : AppColors.muted,
                        fontWeight:
                            isSel ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 4),
              _IconBtn(icon: Icons.filter_list_rounded, onTap: () {}),
              const SizedBox(width: 4),
              _IconBtn(icon: Icons.download_rounded, onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.muted),
      ),
    );
  }
}

class _EmptyAnalyticsCard extends StatelessWidget {
  const _EmptyAnalyticsCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CardSurface(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
// ── Highlight 2×2 grid ─────────────────────────────────────────────────────

class _HighlightGrid extends StatelessWidget {
  const _HighlightGrid({required this.summary});

  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.directions_car_rounded, 'Top Car', summary.topCar,
          summary.topCarCount, AppColors.primary),
      (Icons.build_rounded, 'Top Part', summary.topPart, summary.topPartCount,
          Colors.orange.shade700),
      (Icons.location_on_rounded, 'Top Center', summary.topCenter,
          summary.topCenterCount, Colors.teal.shade700),
      (Icons.mic_rounded, 'Audio Data', summary.audioSamples, 'samples',
          Colors.purple.shade700),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items
          .map(
            (item) => CardSurface(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(item.$1, color: item.$5, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.$2,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.$4,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Top added cars ─────────────────────────────────────────────────────────

class _TopCarsCard extends StatelessWidget {
  const _TopCarsCard({required this.entries});

  final List<TopCarEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const _EmptyAnalyticsCard(
        title: 'Top Added Cars',
        message: 'No car analytics for this period.',
      );
    }

    final max =
        entries.map((e) => e.count).reduce((a, b) => a > b ? a : b);
    final safeMax = max == 0 ? 1 : max;

    return CardSurface(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Added Cars',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                Icon(Icons.bar_chart_rounded, color: AppColors.muted, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            ...entries.asMap().entries.map((e) {
              final car = e.value;
              final frac = car.count / safeMax;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '#${e.key + 1}',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: frac,
                              backgroundColor: AppColors.border,
                              color: AppColors.teal,
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${car.count}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Most changed parts ─────────────────────────────────────────────────────

class _MostChangedPartsCard extends StatelessWidget {
  const _MostChangedPartsCard({required this.parts});

  final List<PartEntry> parts;

  @override
  Widget build(BuildContext context) {
    return CardSurface(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Most Changed Parts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                Icon(Icons.build_outlined, color: AppColors.muted, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: parts
                  .map(
                    (p) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softBlue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${p.count}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top service centers ────────────────────────────────────────────────────

class _TopServiceCentersCard extends StatelessWidget {
  const _TopServiceCentersCard({required this.centers});

  final List<ServiceCenterEntry> centers;

  @override
  Widget build(BuildContext context) {
    if (centers.isEmpty) {
      return const _EmptyAnalyticsCard(
        title: 'Top Service Centers',
        message: 'No service center analytics for this period.',
      );
    }

    final maxVisits =
        centers.map((c) => c.visits).reduce((a, b) => a > b ? a : b);
    final safeMaxVisits = maxVisits == 0 ? 1 : maxVisits;

    return CardSurface(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Service Centers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                Icon(
                  Icons.show_chart_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...centers.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.text,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${c.visits}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const TextSpan(
                                text: ' visits',
                                style: TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: c.bookings / safeMaxVisits,
                        backgroundColor: AppColors.border,
                        color: Colors.blue.shade600,
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: c.emergency / safeMaxVisits,
                        backgroundColor: AppColors.border,
                        color: Colors.red.shade400,
                        minHeight: 7,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Dot(color: Colors.blue.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Bookings: ${c.bookings}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(width: 14),
                        _Dot(color: Colors.red.shade400),
                        const SizedBox(width: 4),
                        Text(
                          'Emergency: ${c.emergency}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ── Audio dataset card ─────────────────────────────────────────────────────

class _AudioDatasetCard extends StatelessWidget {
  const _AudioDatasetCard({required this.dataset});

  final AudioDataset dataset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Audio Dataset',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _AudioStat(label: 'TOTAL', value: '${dataset.total}'),
              const SizedBox(width: 12),
              _AudioStat(label: 'PROCESSED', value: '${dataset.processed}'),
              const SizedBox(width: 12),
              _AudioStat(
                label: 'LABELED',
                value: '${dataset.labeled}',
                valueColor: AppColors.teal,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Processing Progress',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '${(dataset.processingProgress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: dataset.processingProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              color: AppColors.teal,
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioStat extends StatelessWidget {
  const _AudioStat({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

