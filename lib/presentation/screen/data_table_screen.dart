import 'package:flutter/material.dart';

class DataTableScreen extends StatelessWidget {
  const DataTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns:
                List.generate(200, (i) => DataColumn(label: Text('Column $i'))),
            rows: List.generate(
              100,
              (i) => DataRow(
                cells: List.generate(
                  200,
                  (j) => DataCell(Text('Cell $i, $j')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
