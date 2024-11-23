import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:ticket_management_system/model/dashboardModel.dart';

class DashboardDatasource extends DataGridSource {
  DashboardDatasource(this._dailyproject) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DashboardModel> _dailyproject = [];

  List<DataGridRow> dataGridRows = [];

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  Map<String, int> ticketCounts = {};

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // final int dataRowIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            dataGridCell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ));
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return Future.value();
    }
    if (column.columnName == 'serviceProvider') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'serviceProvider', value: newCellValue);
      _dailyproject[dataRowIndex].serviceProvider = newCellValue;
    } else if (column.columnName == 'pendingTicket') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'pendingTicket', value: newCellValue);
      _dailyproject[dataRowIndex].pendingTickets = newCellValue;
    } else if (column.columnName == 'firstDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'firstDate', value: newCellValue);
      _dailyproject[dataRowIndex].firstDate = newCellValue;
    } else if (column.columnName == 'secondDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'secondDate', value: newCellValue);
      _dailyproject[dataRowIndex].secondDate = newCellValue;
    } else if (column.columnName == 'thirdDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'thirdDate', value: newCellValue);
      _dailyproject[dataRowIndex].thirdDate = newCellValue;
    } else if (column.columnName == 'fourthDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'fourthDate', value: newCellValue);
      _dailyproject[dataRowIndex].fourthDate = newCellValue;
    } else if (column.columnName == 'fifthDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'fifthDate', value: newCellValue);
      _dailyproject[dataRowIndex].fifthDate = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'sixthDate', value: newCellValue);
      _dailyproject[dataRowIndex].sixthDate = newCellValue;
    }

    return Future.value();
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Example: You can validate values asynchronously if needed. For now, let's return the result synchronously.

    final dynamic newValue =
        dataGridRow.getCells()[rowColumnIndex.columnIndex].value;

    if (newValue == null || newValue == '') {
      // If the value is null or empty, prevent submission.
      return Future.value(false);
    }

    // You can also add more asynchronous checks here if necessary.
    // For example, validating a value from an API or database.

    // If there are no issues with the value, allow submission.
    return Future.value(true);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'sfuNo';

    final bool isDateTimeType = column.columnName == 'StartDate';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        // style: tablefonttext,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }
}

RegExp _getRegExp(
    bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
  return isNumericKeyBoard
      ? RegExp('[0-9]')
      : isDateTimeBoard
          ? RegExp('[0-9/]')
          : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
}
