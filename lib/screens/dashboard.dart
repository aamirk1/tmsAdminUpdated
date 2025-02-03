import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ticket_management_system/model/dashboardModel.dart';
import 'package:ticket_management_system/provider/dashboard_provider.dart';
import 'package:ticket_management_system/utils/colors.dart';
import 'package:ticket_management_system/utils/loading_page.dart';

import '../datasource/dashboard_datasource.dart';
import '../utils/String.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<GridColumn> columns = [];
  List<String> currentColumnNames = dashboardColumnName;
  List<String> currentColumnLabels = dashboardLabelName;
  late DashboardDatasource _dashboardDatasource;
  List<DashboardModel> _dashboardModel = [];
  late DataGridController _dataGridController;
  dashboardProvider provider = dashboardProvider();
  Stream? _stream;

  @override
  void initState() {
    super.initState();
    _dashboardDatasource = DashboardDatasource(_dashboardModel);
    _dataGridController = DataGridController();
    provider = Provider.of<dashboardProvider>(context, listen: false);
    provider.fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    columns.clear();

    for (String columnName in currentColumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: true,
          allowEditing: false,
          width: MediaQuery.of(context).size.width *
              0.11, // You can adjust this width as needed
          label: createColumnLabel(
            currentColumnLabels[currentColumnNames.indexOf(columnName)],
          ),
        ),
      );
    }
    return Consumer<dashboardProvider>(
      builder: (context, value, child) {
        // Initialize the dashboardDatasource and dataGridController only once
        if (value.allticketCountsList.isNotEmpty) {
          // Map the allticketCountsList to _dashboardModel only once if it's not done
          if (_dashboardModel.isEmpty) {
            _dashboardModel = value.allticketCountsList.map((map) {
              return DashboardModel.fromjson({
                'serviceProvider': map['serviceProvider'] ?? '',
                'pendingTicket': map['pendingTicket'] ?? 0,
                'firstDate': map['firstDate'] ?? 0,
                'secondDate': map['secondDate'] ?? 0,
                'thirdDate': map['thirdDate'] ?? 0,
                'fourthDate': map['fourthDate'] ?? 0,
                'fifthDate': map['fifthDate'] ?? 0,
                'sixthDate': map['sixthDate'] ?? 0,
              });
            }).toList();

            // Calculate totals
            int totalPendingTicket = 0;
            int totalFirstDate = 0;
            int totalSecondDate = 0;
            int totalThirdDate = 0;
            int totalFourthDate = 0;
            int totalFifthDate = 0;
            int totalSixthDate = 0;

            for (var item in _dashboardModel) {
              totalPendingTicket += item.pendingTickets;
              totalFirstDate += item.firstDate!;
              totalSecondDate += item.secondDate!;
              totalThirdDate += item.thirdDate!;
              totalFourthDate += item.fourthDate!;
              totalFifthDate += item.fifthDate!;
              totalSixthDate += item.sixthDate!;

              print(item.firstDate!);
              print(totalPendingTicket);
            }

            _dashboardModel.insert(
                0,
                DashboardModel.fromjson({
                  'serviceProvider': 'Total Ticket Tally',
                  'pendingTicket': totalPendingTicket,
                  'firstDate': totalFirstDate,
                  'secondDate': totalSecondDate,
                  'thirdDate': totalThirdDate,
                  'fourthDate': totalFourthDate,
                  'fifthDate': totalFifthDate,
                  'sixthDate': totalSixthDate,
                }));

            // Update the dashboardDatasource with the mapped data
            _dashboardDatasource = DashboardDatasource(_dashboardModel);
          }
          // Return the DataGrid directly
          return Scaffold(
            appBar: AppBar(
              title: const Center(
                  child: Text(
                'Dashboard (Pending Tickets in Days)',
                style: TextStyle(color: white),
              )),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [lightMarron, marron]),
                ),
              ),
            ),
            body: SfDataGridTheme(
              data: const SfDataGridThemeData(
                headerColor: marron,
                gridLineColor: marron,
              ),
              child: SfDataGrid(
                source: _dashboardDatasource,
                allowEditing: true,
                frozenColumnsCount: 2,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                editingGestureType: EditingGestureType.tap,
                rowHeight: 50,
                controller: _dataGridController,
                onQueryRowHeight: (details) {
                  return details.getIntrinsicRowHeight(details.rowIndex);
                },
                columns: columns,
              ),
            ),
            // floatingActionButton: Container(
            //   width: 150,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 5), // Set the padding around the button
            //     child: FloatingActionButton(
            //       backgroundColor: marron,
            //       child: const Text(
            //         'Proceed',
            //         style: TextStyle(
            //             color: white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => customSide(),
            //           ),
            //         );
            //       },
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(
            //             8.0), // This will give it rounded corners
            //       ),
            //     ),
            //   ),
            // ),
          );
        }

        // If allticketCountsList is empty, show a loading screen or a placeholder
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Dashboard')),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [lightMarron, marron]),
              ),
            ),
          ),
          body: const Center(child: LoadingPage()),
        );
        // Scaffold(
        //     appBar: AppBar(
        //       title: const Center(child: Text('Dashboard')),
        //       flexibleSpace: Container(
        //         decoration: const BoxDecoration(
        //           gradient: LinearGradient(colors: [lightMarron, marron]),
        //         ),
        //       ),
        //     ),
        //     body: const Center(
        //       child: Text(
        //         'All Tickets are closed',
        //         style: TextStyle(color: marron, fontSize: 20),
        //       ), // Loading indicator
        //     ));
      },
    );

    // return Consumer<dashboardProvider>(
    //   builder: (context, value, child) {
    //     _dashboardModel = value.allticketCountsList.map((map) {
    //       return DashboardModel.fromjson({
    //         'serviceProvider': map['serviceProvider'] ?? '',
    //         'pendingTicket': map['pendingTicket'] ?? 0,
    //         'firstDate': map['firstDate'] ?? 0,
    //         'secondDate': map['secondDate'] ?? 0,
    //         'thirdDate': map['thirdDate'] ?? 0,
    //         'fourthDate': map['fourthDate'] ?? 0,
    //         'fifthDate': map['fifthDate'] ?? 0,
    //         'sixthDate': map['sixthDate'] ?? 0,
    //       });
    //     }).toList();

    //     _dashboardDatasource = DashboardDatasource(_dashboardModel);
    //     _dataGridController = DataGridController();
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: const Center(child: Text('Dashboard')),
    //         flexibleSpace: Container(
    //           decoration: const BoxDecoration(
    //               gradient: LinearGradient(colors: [lightMarron, marron])),
    //         ),
    //       ),
    //       body: Padding(
    //         padding: const EdgeInsets.only(left: 10, right: 10),
    //         child: SfDataGridTheme(
    //           data: const SfDataGridThemeData(
    //               headerColor: white, gridLineColor: marron),
    //           child: StreamBuilder(
    //             stream: FirebaseFirestore.instance
    //                 .collection('tickets')
    //                 .snapshots(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 return const Center(child: LoadingPage());
    //               } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //                 return SfDataGrid(
    //                     source: _dashboardDatasource,
    //                     allowEditing: true,
    //                     frozenColumnsCount: 0,
    //                     gridLinesVisibility: GridLinesVisibility.both,
    //                     headerGridLinesVisibility: GridLinesVisibility.both,
    //                     selectionMode: SelectionMode.single,
    //                     navigationMode: GridNavigationMode.cell,
    //                     columnWidthMode: ColumnWidthMode.fitByCellValue,
    //                     editingGestureType: EditingGestureType.tap,
    //                     rowHeight: 50,
    //                     controller: _dataGridController,
    //                     onQueryRowHeight: (details) {
    //                       return details
    //                           .getIntrinsicRowHeight(details.rowIndex);
    //                     },
    //                     columns: columns);
    //               } else {
    //                 return SfDataGrid(
    //                     source: _dashboardDatasource,
    //                     allowEditing: true,
    //                     frozenColumnsCount: 2,
    //                     gridLinesVisibility: GridLinesVisibility.both,
    //                     headerGridLinesVisibility: GridLinesVisibility.both,
    //                     selectionMode: SelectionMode.single,
    //                     navigationMode: GridNavigationMode.cell,
    //                     editingGestureType: EditingGestureType.tap,
    //                     rowHeight: 50,
    //                     controller: _dataGridController,
    //                     onQueryRowHeight: (details) {
    //                       return details
    //                           .getIntrinsicRowHeight(details.rowIndex);
    //                     },
    //                     columns: columns);
    //               }
    //             },
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

Widget createColumnLabel(String labelText) {
  return Container(
    alignment: Alignment.center,
    child: Text(labelText,
        overflow: TextOverflow.values.first,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: white)),
  );
}
