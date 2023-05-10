import 'package:flutter/material.dart';
import 'package:madad_final/screens/admin/add_psychiatrists.dart';

class ManagePsychiatrists extends StatefulWidget {
  const ManagePsychiatrists({super.key});

  @override
  State<ManagePsychiatrists> createState() => _ManagePsychiatristsState();
}

class _ManagePsychiatristsState extends State<ManagePsychiatrists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage")),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              hoverColor: Colors.blueGrey,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => AddPsy())));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text("Add Psychiatrists "),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
