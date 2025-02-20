import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardProvider extends ChangeNotifier {
  List<String> ticketData = [];
  List<String> alldates = [];
  List<String> pendingTickets = [];
  // Your original field (ticketPendingData is a Map)
  Map<String, dynamic> _ticketPendingData = {};
  List<Map<String, dynamic>> _ticketCountsList = [];

  // Getter for ticketPendingData
  Map<String, dynamic> get ticketPendingData => _ticketPendingData;
  List<Map<String, dynamic>> ticketCountsList = [];

  // Getter for ticketCountsList
  List<Map<String, dynamic>> get allticketCountsList => _ticketCountsList;

  Map<String, dynamic> ticketCounts = {
    'memberName': '',
    '0-1': 0,
    '1-7': 0,
    '8-14': 0,
    '15-21': 0,
    '22-28': 0,
    '29-31': 0,
  };

  set setTicketCountsList(List<Map<String, dynamic>> newData) {
    _ticketCountsList = newData;
    notifyListeners();
  }

  // Setter for ticketPendingData
  set ticketPendingData(Map<String, dynamic> newData) {
    _ticketPendingData = newData;
    notifyListeners();
  }

  Future<void> fetchTickets() async {
    try {
      // Step 1: Aggregate data by service provider and date range
      Map<String, Map<String, int>> aggregatedData = {};
      List<String>? dateIds = [];
      List<String>? memberName = [];
      var raisedTicketsSnapshot =
          await FirebaseFirestore.instance.collection('raisedTickets').get();

      DateTime? lastDayOfMonth;
      DateTime? today;
      for (var doc in raisedTicketsSnapshot.docs) {
        String todayDateString = doc.id;
        today = DateFormat('dd-MM-yyyy').parse(todayDateString);

        lastDayOfMonth = DateTime(today.year, today.month + 1, 0);
      }

      var memberNameSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('role', isGreaterThanOrEqualTo: []).get();

      for (var doc in raisedTicketsSnapshot.docs) {
        String todayDateString = doc.id;
        today = DateFormat('dd-MM-yyyy').parse(todayDateString);

        lastDayOfMonth = DateTime(
            today.year, today.month + 1, 0); // Works fine for all months
      }
      for (var doc in memberNameSnapshot.docs) {
        var roles = doc['role'];
        if (roles != null && roles.isNotEmpty) {
          memberName.add(doc.id);
        }
      }

      List<DateRange> dateRanges = [
        DateRange(0, 1),
        DateRange(1, 7),
        DateRange(8, 14),
        DateRange(15, 21),
        DateRange(22, 28),
        DateRange(29, lastDayOfMonth!.day)
      ];
      // Loop through each document (date)
      for (var doc in raisedTicketsSnapshot.docs) {
        dateIds.add(doc.id);

        // Fetch open tickets for today
        QuerySnapshot todayTicketsSnapshot = await FirebaseFirestore.instance
            .collection('raisedTickets')
            .doc(doc.id)
            .collection('tickets')
            .where('status', isEqualTo: 'Open')
            // .where('date',
            //     isEqualTo: todayDate) // Filter tickets by today's date
            .get();

        // Update the count for today

        ticketCounts['Today'] = todayTicketsSnapshot.docs.length;
      }

      for (var dateId in dateIds) {
        for (var range in dateRanges) {
          // Format the dates in 'dd-MM-yyyy' format for Firestore
          String startDate = DateFormat('dd-MM-yyyy')
              .format(DateTime(today!.year, today.month, range.start));
          String endDate = DateFormat('dd-MM-yyyy')
              .format(DateTime(today.year, today.month, range.end));

          Set<String> printedDates = Set(); // A Set to track printed dateIds
          DateTime todaysDate = DateTime.now();
          try {
            QuerySnapshot snapshot = await FirebaseFirestore.instance
                .collection('raisedTickets')
                .doc(dateId)
                .collection('tickets')
                .where('date', isGreaterThanOrEqualTo: startDate)
                .where('date', isLessThanOrEqualTo: endDate)
                .get();

            for (var doc in snapshot.docs) {
              // Access document data (fields)

              var ticketData =
                  doc.data() as Map<String, dynamic>; // Cast to a map
              DateFormat dateFormat = DateFormat('dd-MM-yyyy');

              if (!printedDates.contains(ticketData['tickets'])) {
                if (ticketData['status'] == 'Open' &&
                    memberName.contains(ticketData['serviceProvider'])) {
                  printedDates.add(ticketData['tickets']);

                  String date = ticketData['date'];
                  DateTime parsedDate = dateFormat.parse(date);

                  // Calculate the difference between today and the parsed date
                  Duration difference = todaysDate.difference(parsedDate);

                  // Get the difference in days
                  int day = difference.inDays;

                  // Get the service provider and date range for this ticket
                  String serviceProvider = ticketData['serviceProvider'];

                  // Determine the correct date range based on the day
                  String dateRangeKey;

                  if (day <= 0) {
                    dateRangeKey = '0-1';
                  } else if (day >= 1 && day <= 7) {
                    dateRangeKey = '1-7';
                  } else if (day >= 8 && day <= 14) {
                    dateRangeKey = '8-14';
                  } else if (day >= 15 && day <= 21) {
                    dateRangeKey = '15-21';
                  } else if (day >= 22 && day <= 28) {
                    dateRangeKey = '22-28';
                  } else {
                    dateRangeKey = '29-31'; // for days 29, 30, and 31
                  }

                  if (!aggregatedData.containsKey(serviceProvider)) {
                    aggregatedData[serviceProvider] = {};
                  }

                  // Update ticket count for this service provider and date range
                  aggregatedData[serviceProvider]![dateRangeKey] =
                      (aggregatedData[serviceProvider]![dateRangeKey] ?? 0) + 1;
                }
              }
            }
          } catch (e) {
            print('Error fetching tickets: $e');
          }
        }
      }

      // Step 4: Prepare the final ticketCountsList to store aggregated data
      List<Map<String, dynamic>> ticketCountsList = [];

      aggregatedData.forEach((serviceProvider, dateRangesMap) {
        // Sum up the total pending tickets for this service provider across all date ranges
        int totalPendingTickets = (dateRangesMap['0-1'] ?? 0) +
            (dateRangesMap['1-7'] ?? 0) +
            (dateRangesMap['8-14'] ?? 0) +
            (dateRangesMap['15-21'] ?? 0) +
            (dateRangesMap['22-28'] ?? 0) +
            (dateRangesMap['29-31'] ?? 0) +
            (dateRangesMap['seventhDate'] ?? 0);

        // Add the aggregated data to the list
        ticketCountsList.add({
          'serviceProvider': serviceProvider,
          'pendingTicket':
              totalPendingTickets, // Total of all counts for this service provider
          'firstDate': dateRangesMap['0-1'] ?? 0,
          'secondDate': dateRangesMap['1-7'] ?? 0, // Ticket count for '1-7'
          'thirdDate': dateRangesMap['8-14'] ?? 0, // Ticket count for '8-14'
          'fourthDate': dateRangesMap['15-21'] ?? 0, // Ticket count for '15-21'
          'fifthDate': dateRangesMap['22-28'] ?? 0, // Ticket count for '22-28'
          'sixthDate': dateRangesMap['29-31'] ?? 0, // Ticket count for '29-31'
          'seventhDate': 0, // Placeholder if needed
        });
      });

      // Step 5: Set the aggregated ticket counts list
      setTicketCountsList = ticketCountsList;
      ticketPendingData = aggregatedData;

    } catch (e) {
      print('Error fetching tickets: $e');
    }
  }
}

class DateRange {
  final int start;
  final int end;

  // Constructor to initialize the range with start and end
  DateRange(this.start, this.end);

  // Getter to get the start date as a DateTime object
  DateTime get startDate =>
      DateTime(DateTime.now().year, DateTime.now().month, start);

  // Getter to get the end date as a DateTime object
  DateTime get endDate =>
      DateTime(DateTime.now().year, DateTime.now().month, end);
}
