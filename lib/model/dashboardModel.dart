import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DashboardModel {
  String? serviceProvider;
  int pendingTickets;
  int? firstDate;
  int? secondDate;
  int? thirdDate;
  int? fourthDate;
  int? fifthDate;
  int? sixthDate;

  DashboardModel({
    required this.serviceProvider,
    required this.pendingTickets,
    required this.firstDate,
    required this.secondDate,
    required this.thirdDate,
    required this.fourthDate,
    required this.fifthDate,
    required this.sixthDate,
  });

  factory DashboardModel.fromjson(Map<String, dynamic> json) {
    return DashboardModel(
        serviceProvider: json['serviceProvider'],
        pendingTickets: json['pendingTicket'],
        firstDate: json['firstDate'],
        secondDate: json['secondDate'],
        thirdDate: json['thirdDate'],
        fourthDate: json['fourthDate'],
        fifthDate: json['fifthDate'],
        sixthDate: json['sixthDate']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'serviceProvider', value: serviceProvider),
      DataGridCell(columnName: 'pendingTicket', value: pendingTickets),
      DataGridCell(columnName: 'firstDate', value: firstDate),
      DataGridCell(columnName: 'secondDate', value: secondDate),
      DataGridCell(columnName: 'thirdDate', value: thirdDate),
      DataGridCell(columnName: 'fourthDate', value: fourthDate),
      DataGridCell(columnName: 'fifthDate', value: fifthDate),
      DataGridCell(columnName: 'sixthDate', value: sixthDate),
    ]);
  }
}
