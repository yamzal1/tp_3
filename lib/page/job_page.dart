import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tp_3/boxes.dart';
import 'package:tp_3/model/job.dart';
import 'package:tp_3/widget/delete_dialog.dart';
import 'package:tp_3/widget/job_dialog.dart';

class JobPage extends StatefulWidget {
  const JobPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<JobPage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return CupertinoPageScaffold(
        // navigationBar : CupertinoNavigationBar(
        //   title: const Text('Offres d\'emploi'),
        //   centerTitle: true,
        // ),
        navigationBar: CupertinoNavigationBar(
          // Try removing opacity to observe the lack of a blur effect and of sliding content.
          backgroundColor: CupertinoColors.systemGrey.withOpacity(0.2),
          middle: const Text('Offres d\'emploi'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add, size: 35,),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => JobDialog(
                onClickedDone: addJob,
              ),
            ),
          ),
        ),
        child : ValueListenableBuilder<Box<Job>>(
          valueListenable: Boxes.getJob().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Job>();

            return buildContent(transactions);
          },
        ),


    );
}
  Widget buildContent(List<Job> jobs) {
    if (jobs.isEmpty) {
      return const Center(
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 24),
            child: Text('Cliquez sur + pour ajouter une offre'),
          )

      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: jobs.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = jobs[index];

                return buildJob(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildJob(BuildContext context, Job job,) {
    final name = job.name;
    final brut = job.brut.toString();

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          job.name,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          job.comment.toString(),
        ),
        trailing: Text(job.net.toString() + " €"),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text(
                          "Salaire brut : "+ job.brut.toString() + " €",

                          style: TextStyle(fontSize: 18),
                        )

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text(
                          "Salaire net : " + job.net.toString() + " €",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        Text(
                          "Statut : " + job.statut.toString(),

                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
          buildButtons(context, job),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Job job) => Row(
        children: [

          Expanded(
            child: TextButton.icon(
              label: const Text('Supprimer'),
              icon: const Icon(Icons.delete),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) =>DeleteDialog(
                    job: job,
                    onClickedDelete: () => deleteJob(job)),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: const Text('Modifier'),
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => JobDialog(
                    job: job,
                    onClickedDone: (name, brut, net, statut, comment) =>
                        editJob(job, name, brut, net, statut, comment),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Future addJob(String name, double brut, double net, String statut, String comment,) async {
    final job = Job()
      ..name = name
      ..brut = brut
      ..net = net
      ..statut = statut
      ..comment = comment;

    final box = Boxes.getJob();
    box.add(job);
  }

  void editJob(Job job, String name, double brut, double net, String statut, String comment,) {


    job.name = name;
    job.brut = brut;
    job.net = net;
    job.statut = statut;
    job.comment = comment;

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    job.save();
  }

  void deleteJob(Job job) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    job.delete();
    //setState(() => transactions.remove(transaction));
  }
}
