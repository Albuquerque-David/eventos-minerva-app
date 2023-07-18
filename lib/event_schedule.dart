import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_page.dart';

class ProgrammingPage extends StatefulWidget {
  final List<Schedule> schedules;

  ProgrammingPage({required this.schedules});

  @override
  _ProgrammingPageState createState() => _ProgrammingPageState();
}

class _ProgrammingPageState extends State<ProgrammingPage> {
  List<String> uniqueDescriptions = [];
  List<bool> isSelected = [];
  Set<String> selectedDescriptions = Set<String>();

  @override
  void initState() {
    super.initState();
    _generateUniqueDescriptions();
    _initializeSelectedDescriptions();
    _sortSchedules();
  }

  void _generateUniqueDescriptions() {
    Set<String> descriptionsSet = Set<String>();

    for (var schedule in widget.schedules) {
      descriptionsSet.add(schedule.scheduleDescription);
    }

    uniqueDescriptions = descriptionsSet.toList();
  }

  void _initializeSelectedDescriptions() {
    isSelected = List<bool>.filled(uniqueDescriptions.length, false);
  }

  void _sortSchedules() {
    widget.schedules.sort((a, b) => a.scheduleHour.compareTo(b.scheduleHour));
  }

  List<Schedule> get filteredSchedules {
    if (selectedDescriptions.isEmpty) {
      return widget.schedules;
    }

    List<Schedule> filteredList = [];

    for (var schedule in widget.schedules) {
      if (selectedDescriptions.contains(schedule.scheduleDescription)) {
        filteredList.add(schedule);
      }
    }

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Programação'),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Color(0xffd08c22)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: uniqueDescriptions.map((description) {
                  final index = uniqueDescriptions.indexOf(description);
                  return Container(
                    margin: EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(description),
                      selected: isSelected[index],
                      onSelected: (selected) {
                        setState(() {
                          isSelected[index] = selected;
                          if (selected) {
                            selectedDescriptions.add(description);
                          } else {
                            selectedDescriptions.remove(description);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[300],
                      selectedColor: Color(0xFFD08C22),
                      labelStyle: TextStyle(color: Colors.black),
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSchedules.length,
              itemBuilder: (context, index) {
                final schedule = filteredSchedules[index];
                final hour = schedule.scheduleHour.substring(11, 16);
                final date = schedule.scheduleHour.substring(8, 10) +
                    '/' +
                    schedule.scheduleHour.substring(5, 7) +
                    '/' +
                    schedule.scheduleHour.substring(0, 4);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Color(0xFFECEFF1), // Cor de fundo do card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0), // Aumentar a altura do card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.scheduleName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                '$hour - $date',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFD08C22), // Cor de fundo da descrição
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              schedule.scheduleDescription,
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
