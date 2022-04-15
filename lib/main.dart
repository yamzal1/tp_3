import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp_3/model/job.dart';
import 'package:tp_3/page/job_page.dart';

Future <void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(JobAdapter());
  await Hive.openBox<Job>('job');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Offres d\'emploi';

  const MyApp({Key? key}) : super(key: key);

  //TODO Remplacer MaterialApp par son équivalent cupertino
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: JobPage(),
  );
}
