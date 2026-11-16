import '../../../../core/api/api_response.dart';
import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/params/create_project_params.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDataSource {
  Future<List<ProjectEntity>> getProjects();
  Future<ProjectEntity> getProject(String id);
  Future<ProjectEntity> createProject(CreateProjectParams params);
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  ProjectsRemoteDataSourceImpl(this.client);

  final DioConsumer client;

  @override
  Future<List<ProjectEntity>> getProjects() async {
    final raw = await client.get(EndPoints.locations);
    final response = ApiResponse.from(raw);
    return response.dataList
        .whereType<Map>()
        .map(
          (item) => ProjectModel.fromLocation(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  @override
  Future<ProjectEntity> getProject(String id) async {
    final raw = await client.get(EndPoints.location(id));
    final response = ApiResponse.from(raw);
    final map = response.dataMap;
    if (map == null) {
      throw const ServerException(message: 'err_project_missing');
    }
    return ProjectModel.fromLocation(map);
  }

  @override
  Future<ProjectEntity> createProject(CreateProjectParams params) async {
    Object? customerId = params.customerId;
    Object? engineerId = params.engineerId;

    if (customerId == null || engineerId == null) {
      final customersRaw = await client.get(EndPoints.allCustomer);
      final customers =
          ApiResponse.from(customersRaw).dataList.whereType<Map>();
      final engineersRaw = await client.get(EndPoints.engineers);
      final engineers =
          ApiResponse.from(engineersRaw).dataList.whereType<Map>();

      if (customerId == null) {
        Map? customer;
        for (final item in customers) {
          final name = item['name']?.toString() ?? '';
          if (name == params.clientName.trim()) {
            customer = item;
            break;
          }
        }
        customer ??= customers.isEmpty ? null : customers.first;
        customerId = customer?['id'];
      }

      if (engineerId == null) {
        Map? engineer;
        for (final item in engineers) {
          final name = item['name']?.toString() ?? '';
          if (name == params.engineerName.trim()) {
            engineer = item;
            break;
          }
        }
        engineer ??= engineers.isEmpty ? null : engineers.first;
        engineerId = engineer?['id'];
      }
    }

    if (customerId == null) {
      throw const ValidationException(message: 'لا يوجد عميل مرتبط لإنشاء المشروع');
    }

    final notes = [
      params.location.trim(),
      if (params.startDate != null && params.startDate!.isNotEmpty)
        'start:${params.startDate}',
      if (params.endDate != null && params.endDate!.isNotEmpty)
        'end:${params.endDate}',
    ].join(' | ');

    final body = <String, dynamic>{
      'user_id': customerId,
      'name': params.name.trim(),
      'type': params.type,
      'area': params.area.trim(),
      'notes': notes,
      'engineers[]': ?engineerId,
    };

    final raw = await client.post(EndPoints.locations, body: body);
    final response = ApiResponse.from(raw);
    final map = response.dataMap;
    if (map != null) {
      return ProjectModel.fromLocation(map);
    }
    // Some APIs return the created row nested or only a message.
    final list = await getProjects();
    if (list.isNotEmpty) return list.first;
    throw const ServerException(message: 'تعذر إنشاء المشروع');
  }
}
