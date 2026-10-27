import 'package:dartz/dartz.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  static const items = <ProjectEntity>[
    ProjectEntity(
      id: 'p1',
      name: L10n('فيلا النرجس', 'Al Narjis Villa'),
      location: L10n('الرياض، حي النرجس', 'Riyadh, Al Narjis'),
      progress: 0.78,
      status: ProjectStatus.inProgress,
      phase: L10n('التشطيبات الداخلية', 'Interior finishes'),
      engineer: L10n('م. سارة العتيبي', 'Eng. Sarah Alotaibi'),
    ),
    ProjectEntity(
      id: 'p2',
      name: L10n('الملقا ريزيدنس', 'Al Malqa Residence'),
      location: L10n('الرياض، حي الملقا', 'Riyadh, Al Malqa'),
      progress: 0.46,
      status: ProjectStatus.inProgress,
      phase: L10n('الهيكل الإنشائي', 'Structure'),
      engineer: L10n('م. فهد القحطاني', 'Eng. Fahad Alqahtani'),
    ),
    ProjectEntity(
      id: 'p3',
      name: L10n('برج العليا', 'Al Olaya Tower'),
      location: L10n('الرياض، حي العليا', 'Riyadh, Al Olaya'),
      progress: 0.92,
      status: ProjectStatus.inProgress,
      phase: L10n('التسليم الابتدائي', 'Initial handover'),
      engineer: L10n('م. عبدالله الحربي', 'Eng. Abdullah Alharbi'),
    ),
    ProjectEntity(
      id: 'p4',
      name: L10n('مبنى القيروان', 'Al Qirawan Building'),
      location: L10n('الرياض، حي القيروان', 'Riyadh, Al Qirawan'),
      progress: 0.33,
      status: ProjectStatus.onHold,
      phase: L10n('الأعمال الكهربائية', 'Electrical works'),
      engineer: L10n('م. نورة الشمري', 'Eng. Noura Alshammari'),
    ),
    ProjectEntity(
      id: 'p5',
      name: L10n('فيلا السليمانية', 'Al Sulimaniyah Villa'),
      location: L10n('الرياض، حي السليمانية', 'Riyadh, Al Sulimaniyah'),
      progress: 1,
      status: ProjectStatus.completed,
      phase: L10n('مكتمل', 'Completed'),
      engineer: L10n('م. سارة العتيبي', 'Eng. Sarah Alotaibi'),
    ),
  ];

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return const Right(items);
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProject(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final match = items.where((item) => item.id == id);
    if (match.isEmpty) {
      return const Left(ServerFailure(message: 'err_project_missing'));
    }
    return Right(match.first);
  }
}
