import 'package:drive_mate_dash_board/core/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.columns, required this.rows});

  final List<String> columns;
  final List<List<Widget>> rows;

  @override
  Widget build(BuildContext context) {
    return CardSurface(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns.map((column) => DataColumn(label: Text(column))).toList(),
          rows: rows
              .map(
                (cells) => DataRow(
                  cells: cells.map((cell) => DataCell(cell)).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
