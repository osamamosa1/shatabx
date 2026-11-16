import '../../../../core/api/api_response.dart';
import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/end_points.dart';

class SettingItem {
  const SettingItem({
    required this.id,
    required this.key,
    required this.title,
    required this.value,
  });

  final String id;
  final String key;
  final String title;
  final String value;

  factory SettingItem.fromJson(Map<String, dynamic> json) {
    return SettingItem(
      id: json['id']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

abstract class ContentRemoteDataSource {
  Future<List<SettingItem>> getSettings();
  Future<SettingItem?> getSettingByKey(String key);
  Future<List<Map<String, dynamic>>> getPackages();
  Future<List<Map<String, dynamic>>> getSubscriptions();
  Future<List<Map<String, dynamic>>> getBanners();
  Future<List<Map<String, dynamic>>> getCommonQuestions();
  Future<List<Map<String, dynamic>>> getEngineers();
  Future<void> addEngineer({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  Future<void> deleteEngineer(String id);
  Future<List<Map<String, dynamic>>> getCustomers();
  Future<void> addCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  });
  Future<void> deleteCustomer(String id);
  Future<Map<String, dynamic>?> getHomeDashboard();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  ContentRemoteDataSourceImpl(this.client);

  final DioConsumer client;

  List<Map<String, dynamic>> _maps(dynamic raw) {
    return ApiResponse.from(raw)
        .dataList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  @override
  Future<List<SettingItem>> getSettings() async {
    final raw = await client.get(EndPoints.settings);
    return ApiResponse.from(raw)
        .dataList
        .whereType<Map>()
        .map((item) => SettingItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  @override
  Future<SettingItem?> getSettingByKey(String key) async {
    final items = await getSettings();
    for (final item in items) {
      if (item.key == key) return item;
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getPackages() async {
    return _maps(await client.get(EndPoints.allPackages));
  }

  @override
  Future<List<Map<String, dynamic>>> getSubscriptions() async {
    return _maps(await client.get(EndPoints.subscriptions));
  }

  @override
  Future<List<Map<String, dynamic>>> getBanners() async {
    return _maps(await client.get(EndPoints.banners));
  }

  @override
  Future<List<Map<String, dynamic>>> getCommonQuestions() async {
    return _maps(await client.get(EndPoints.commonQuestions));
  }

  @override
  Future<List<Map<String, dynamic>>> getEngineers() async {
    return _maps(await client.get(EndPoints.engineers));
  }

  @override
  Future<void> addEngineer({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    await client.post(
      EndPoints.engineers,
      body: <String, dynamic>{
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'password': password,
        'password_confirmation': password,
      },
    );
  }

  @override
  Future<void> deleteEngineer(String id) async {
    await client.delete(EndPoints.engineer(id));
  }

  @override
  Future<List<Map<String, dynamic>>> getCustomers() async {
    return _maps(await client.get(EndPoints.allCustomer));
  }

  @override
  Future<void> addCustomer({
    required String name,
    required String phone,
    String? email,
    String? address,
  }) async {
    await client.post(
      EndPoints.addCustomer,
      body: <String, dynamic>{
        'name': name.trim(),
        'phone': phone.trim(),
        if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
        if (address != null && address.trim().isNotEmpty)
          'address': address.trim(),
      },
    );
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await client.post(EndPoints.deleteCustomer(id));
  }

  @override
  Future<Map<String, dynamic>?> getHomeDashboard() async {
    final raw = await client.get(EndPoints.home);
    return ApiResponse.from(raw).dataMap;
  }
}
