import 'package:hive/hive.dart';
import 'package:tp_3/model/job.dart';

class Boxes {
  static Box<Job> getJob() =>
      Hive.box<Job>('job');
}
