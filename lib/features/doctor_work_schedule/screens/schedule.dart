import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Future<Map<String, dynamic>> _scheduleData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _scheduleData = _fetchScheduleData();
  }

  Future<Map<String, dynamic>> _fetchScheduleData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.diavan-valuation.asia/api/Professor/schedule/1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        return json.decode(response.body);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load schedule: ${response.statusCode}';
        });
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professor Schedule',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : FutureBuilder<Map<String, dynamic>>(
                  future: _scheduleData,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = snapshot.data!['data'] as List;
                    return _buildScheduleTable(data);
                  },
                ),
    );
  }

  Widget _buildScheduleTable(List<dynamic> scheduleData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Weekly Schedule',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.separated(
                  itemCount: scheduleData.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final day = scheduleData[index];
                    return _buildDayRow(
                      day['dayOfWeek'] as String,
                      day['times'] as List,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, List<dynamic> times) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: times.isEmpty
                ? const Text(
                    'No scheduled hours',
                    style: TextStyle(
                        color: Colors.grey, fontStyle: FontStyle.italic),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: times.map((time) {
                      return Chip(
                        backgroundColor: Colors.blue[50],
                        label: Text(
                          '${time['start']} - ${time['end']}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
