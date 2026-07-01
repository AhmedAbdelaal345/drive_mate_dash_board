import 'package:drive_mate_dash_board/core/network/api_helper.dart';
import 'package:drive_mate_dash_board/features/dataset/data/model/dataset_model.dart';

abstract class DatasetsRepo {
  Future<List<AudioSample>> fetchSamples({String? query, int page});
  Future<DatasetsStats> fetchStats();
  Future<void> markAsLabeled(String sampleId);
  Future<void> exportMetadata();
  Future<String> importCatalog(List<CatalogImportItem> items);
}

class DatasetsRepoImpl implements DatasetsRepo {
  @override
  Future<List<AudioSample>> fetchSamples({String? query, int page = 1}) async {
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
    await Future.delayed(const Duration(milliseconds: 300));
    return const DatasetsStats(total: 35, processed: 16, labeled: 12);
  }

  @override
  Future<void> markAsLabeled(String sampleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> exportMetadata() async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<String> importCatalog(List<CatalogImportItem> items) async {
    final response = await ApiHelper().postRequest(
      endpoint: 'admin/catalog/import',
      isAuthorized: true,
      isForm: false,
      data: {'items': items.map((item) => item.toJson())},
    );

    return response.data;
  }

  static const List<AudioSample> _mockSamples = [
    AudioSample(
      id: 'AUD-1001',
      carModel: 'Ford Mustang',
      date: '6/11/2026',
      label: SampleLabel.labeled,
      audioPath: "",
      createdAt: "",
      isLabeled: true,
      isProcessed: true,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "Failour Engin",
      status: "s",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1030',
      carModel: 'Nissan Patrol',
      date: '6/11/2026',
      label: SampleLabel.unlabeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1022',
      carModel: 'Tesla Model 3',
      date: '6/10/2026',
      label: SampleLabel.unlabeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1027',
      carModel: 'Tesla Model 3',
      date: '6/9/2026',
      label: SampleLabel.unlabeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1015',
      carModel: 'Toyota Camry 2024',
      date: '6/8/2026',
      label: SampleLabel.labeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1009',
      carModel: 'Hyundai Tucson',
      date: '6/7/2026',
      label: SampleLabel.labeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-1003',
      carModel: 'Nissan Patrol',
      date: '6/7/2026',
      label: SampleLabel.unlabeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
    AudioSample(
      id: 'AUD-0998',
      carModel: 'Ford Mustang',
      date: '6/6/2026',
      label: SampleLabel.labeled,
      audioPath: "",
      createdAt: "",
      isLabeled: false,
      isProcessed: false,
      deviceHash: "Abh-jjius-8aqeq-8ssa",
      result: "",
      status: "",
      userId: "1",
    ),
  ];
}
