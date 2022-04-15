import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp_3/model/job.dart';
import 'package:tp_3/page/job_page.dart';

Future <void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(JobAdapter());
  await Hive.openBox<Job>('job');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Offres d\'emploi';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: JobPage(),
  );
}
