import 'package:flutter/material.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _reports = [
    {
      'id': '#031',
      'title': 'Pothole on Main Street',
      'category': 'Roads',
      'location': 'Main Street, Downtown',
      'status': 'Resolved',
      'statusColor': Color(0xFF22C55E),
      'statusBg': Color(0xFFDCFCE7),
      'date': '2 days ago',
      'confirmations': 13,
      'icon': Icons.warning_amber_rounded,
      'iconColor': Color(0xFFF59E0B),
      'iconBg': Color(0xFFFEF3C7),
    },
    {
      'id': '#028',
      'title': 'Broken Street Light',
      'category': 'Lighting',
      'location': 'Rue Didouche Mourad',
      'status': 'In Progress',
      'statusColor': Color(0xFF3B82F6),
      'statusBg': Color(0xFFEFF6FF),
      'date': '5 days ago',
      'confirmations': 7,
      'icon': Icons.lightbulb_outline,
      'iconColor': Color(0xFF3B82F6),
      'iconBg': Color(0xFFEFF6FF),
    },
    {
      'id': '#020',
      'title': 'Overflowing Trash Bin',
      'category': 'Waste',
      'location': 'Place du 1er Mai',
      'status': 'In Progress',
      'statusColor': Color(0xFF3B82F6),
      'statusBg': Color(0xFFEFF6FF),
      'date': '1 week ago',
      'confirmations': 4,
      'icon': Icons.delete_outline,
      'iconColor': Color(0xFF22C55E),
      'iconBg': Color(0xFFDCFCE7),
    },
    {
      'id': '#015',
      'title': 'Water Pipe Leak',
      'category': 'Water',
      'location': 'Hydra, Algiers',
      'status': 'Pending',
      'statusColor': Color(0xFFF59E0B),
      'statusBg': Color(0xFFFEF3C7),
      'date': '2 weeks ago',
      'confirmations': 2,
      'icon': Icons.water_drop_outlined,
      'iconColor': Color(0xFF60A5FA),
      'iconBg': Color(0xFFDBEAFE),
    },
    {
      'id': '#009',
      'title': 'Damaged Sidewalk',
      'category': 'Roads',
      'location': 'Ben Aknoun',
      'status': 'Resolved',
      'statusColor': Color(0xFF22C55E),
      'statusBg': Color(0xFFDCFCE7),
      'date': '1 month ago',
      'confirmations': 9,
      'icon': Icons.warning_amber_rounded,
      'iconColor': Color(0xFFF59E0B),
      'iconBg': Color(0xFFFEF3C7),
    },
  ];

  List<Map<String, dynamic>> get _filteredReports {
    if (_selectedFilter == 'All') return _reports;
    return _reports.where((r) => r['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterChips(),
          Expanded(
            child: _filteredReports.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) =>
                        _buildReportCard(_filteredReports[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2962FF), Color(0xFF448AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_reports.length} Total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'My Activity',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text(
            'My Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'In Progress', 'Resolved'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2B58E4) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? const Color(0xFF2B58E4).withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: report['iconBg'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(report['icon'], color: report['iconColor'], size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            report['id'],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: report['statusBg'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              report['status'],
                              style: TextStyle(
                                color: report['statusColor'],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        report['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1D1E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Color(0xFF2B58E4), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      report['location'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2B58E4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey[400], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      report['date'],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.thumb_up_outlined,
                        color: Colors.grey[400], size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${report['confirmations']} confirmations',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment_outlined,
                size: 50, color: Color(0xFF2B58E4)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No reports found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No reports match this filter.',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
