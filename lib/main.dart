import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobius_2d_scroll/application/bloc/mobius_bloc.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';
import 'package:mobius_2d_scroll/presentation/screen/data_table_screen.dart';
import 'package:mobius_2d_scroll/presentation/screen/mobius_screen.dart';
import 'package:mobius_2d_scroll/presentation/screen/paginated_table_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _Screen(),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DataTableScreen()),
              ),
              child: const Text('Data table'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PaginatedTableScreen()),
              ),
              child: const Text('Paginated data table'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => MobiusBloc(Mobius.filled()),
                      child: const MobiusScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Mobius schedule view'),
            ),
          ],
        ),
      ),
    );
  }
}
