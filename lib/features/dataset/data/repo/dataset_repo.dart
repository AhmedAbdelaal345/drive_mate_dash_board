import 'package:drive_mate_dash_board/features/dataset/data/model/dataset_model.dart';

abstract class DatasetsRepo {
  Future<List<AudioSample>> fetchSamples({String? query, int page});
  Future<DatasetsStats> fetchStats();
  Future<void> markAsLabeled(String sampleId);
  Future<void> exportMetadata();
}

class DatasetsRepoImpl implements DatasetsRepo {
  // final Dio _dio;
  // DatasetsRepoImpl(this._dio);

  @override
  Future<List<AudioSample>> fetchSamples({String? query, int page = 1}) async {
    // TODO: replace with real API call:
    // final res = await _dio.get('/datasets/samples', queryParameters: {
    //   'page': page,
    //   if (query != null && query.isNotEmpty) 'q': query,
    // });
    // return (res.data['samples'] as List)
    //     .map((e) => AudioSample.fromJson(e as Map<String, dynamic>))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));

    var samples = _mockSamples;

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      samples = samples
          .where(
            (s) =>
                s.id.toLowerCase().contains(q) ||
                s.carModel.toLowerCase().contains(q),
          )
          .toList();
    }

    return samples;
  }

  @override
  Future<DatasetsStats> fetchStats() async {
    // TODO: await _dio.get('/datasets/stats')
    await Future.delayed(const Duration(milliseconds: 300));
    return const DatasetsStats(total: 35, processed: 16, labeled: 12);
  }

  @override
  Future<void> markAsLabeled(String sampleId) async {
    // TODO: await _dio.patch('/datasets/samples/$sampleId/label');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> exportMetadata() async {
    // TODO: await _dio.get('/datasets/export');
    await Future.delayed(const Duration(milliseconds: 400));
  }

  // ── Mock data ──────────────────────────────────────────────────────────────

  static const List<AudioSample> _mockSamples = [
    AudioSample(
      id: 'AUD-1001',
      carModel: 'Ford Mustang',
      date: '6/11/2026',
      label: SampleLabel.labeled,
    ),
    AudioSample(
      id: 'AUD-1030',
      carModel: 'Nissan Patrol',
      date: '6/11/2026',
      label: SampleLabel.unlabeled,
    ),
    AudioSample(
      id: 'AUD-1022',
      carModel: 'Tesla Model 3',
      date: '6/10/2026',
      label: SampleLabel.unlabeled,
    ),
    AudioSample(
      id: 'AUD-1027',
      carModel: 'Tesla Model 3',
      date: '6/9/2026',
      label: SampleLabel.unlabeled,
    ),
    AudioSample(
      id: 'AUD-1015',
      carModel: 'Toyota Camry 2024',
      date: '6/8/2026',
      label: SampleLabel.labeled,
    ),
    AudioSample(
      id: 'AUD-1009',
      carModel: 'Hyundai Tucson',
      date: '6/7/2026',
      label: SampleLabel.labeled,
    ),
    AudioSample(
      id: 'AUD-1003',
      carModel: 'Nissan Patrol',
      date: '6/7/2026',
      label: SampleLabel.unlabeled,
      isProcessed: false,
    ),
    AudioSample(
      id: 'AUD-0998',
      carModel: 'Ford Mustang',
      date: '6/6/2026',
      label: SampleLabel.labeled,
    ),
  ];
}
