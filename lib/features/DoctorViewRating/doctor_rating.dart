import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DoctorRating extends StatefulWidget {
  final int doctorId;

  const DoctorRating({super.key, required this.doctorId});

  @override
  State<DoctorRating> createState() => _DoctorRatingState();
}

class _DoctorRatingState extends State<DoctorRating> {
  Map<String, dynamic>? _ratingData;
  bool _isLoading = true;
  String _errorMessage = '';
  final Color _primaryColor = const Color(0xFF1976D2);
  final Color _backgroundColor = const Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    _fetchRatingData();
  }

  Future<void> _fetchRatingData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.diavan-valuation.asia/api/Professor/feedback/${widget.doctorId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            _ratingData = data['data'];
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load rating data');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Đánh Giá Bác Sĩ'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRatingData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_ratingData == null || _ratingData!['listOfRating'] == null) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _fetchRatingData,
      color: _primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallRating(),
            const SizedBox(height: 24),
            _buildRatingList(),
          ],
        ),
      ),
    );
  }

  // Loading placeholder widgets with shimmer effect
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall rating card placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            // Title placeholder
            Container(
              height: 24,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            // Rating cards placeholders
            ...List.generate(
                3,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Không thể tải đánh giá',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchRatingData,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có đánh giá nào',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bác sĩ này chưa nhận được đánh giá từ bệnh nhân',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallRating() {
    final totalRating = _ratingData!['totalRating'] ?? 0;
    final ratings = _ratingData!['listOfRating'] as List;

    // Calculate average rating
    double averageRating = 0;
    if (ratings.isNotEmpty) {
      averageRating =
          ratings.map((r) => r['star'] as int).reduce((a, b) => a + b) /
              ratings.length;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Average rating circle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getColorForRating(averageRating).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    averageRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getColorForRating(averageRating),
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đánh giá trung bình',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < averageRating.floor()
                                ? Icons.star
                                : index < averageRating
                                    ? Icons.star_half
                                    : Icons.star_outline,
                            color: Colors.amber[700],
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalRating đánh giá từ bệnh nhân',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildStarDistribution(ratings),
          ],
        ),
      ),
    );
  }

  Color _getColorForRating(double rating) {
    if (rating >= 4.5) return Colors.green[700]!;
    if (rating >= 4.0) return Colors.green[500]!;
    if (rating >= 3.5) return Colors.lime[700]!;
    if (rating >= 3.0) return Colors.amber[700]!;
    if (rating >= 2.0) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  Widget _buildStarDistribution(List<dynamic> ratings) {
    // Count star distribution
    final starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final rating in ratings) {
      final star = rating['star'] as int;
      starCounts[star] = starCounts[star]! + 1;
    }

    return Column(
      children: [5, 4, 3, 2, 1].map((star) {
        final count = starCounts[star]!;
        final percentage = ratings.isEmpty ? 0 : (count / ratings.length * 100);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Text(
                '$star',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.star, color: Colors.amber[700], size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStarColor(star),
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 48,
                child: Text(
                  '(${percentage.toStringAsFixed(0)}%)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getStarColor(int star) {
    switch (star) {
      case 5:
        return Colors.green[600]!;
      case 4:
        return Colors.green[400]!;
      case 3:
        return Colors.amber[600]!;
      case 2:
        return Colors.orange[600]!;
      case 1:
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildRatingList() {
    final ratings = _ratingData!['listOfRating'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.rate_review, size: 24, color: _primaryColor),
            const SizedBox(width: 8),
            Text(
              'Tất cả đánh giá',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...ratings.map((rating) => _buildRatingCard(rating)).toList(),
      ],
    );
  }

  Widget _buildRatingCard(Map<String, dynamic> rating) {
    final star = rating['star'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Rating header with star count

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info row
                Row(
                  children: [
                    _buildUserAvatar(rating),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rating['createdBy'] ?? 'Khách hàng',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < star
                                          ? Icons.star
                                          : Icons.star_outline,
                                      color: Colors.amber[700],
                                      size: 18,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  star == 5
                                      ? 'Tuyệt vời'
                                      : star == 4
                                          ? 'Rất tốt'
                                          : star == 3
                                              ? 'Bình thường'
                                              : star == 2
                                                  ? 'Không tốt'
                                                  : 'Rất tệ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getStarColor(star),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Rating content with quote styling
                if (rating['content'] != null &&
                    rating['content'].toString().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote,
                            color: Colors.grey[400], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rating['content'],
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Appointment info card
                _buildAppointmentInfo(rating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(Map<String, dynamic> rating) {
    final avatarUrl = rating['createdByAvatar'] ?? rating['avatar'] ?? '';

    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: Colors.grey),
              )
            : const Icon(Icons.person, color: Colors.grey, size: 28),
      ),
    );
  }

  Widget _buildAppointmentInfo(Map<String, dynamic> rating) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue[100]?.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.medical_services_outlined,
                    size: 16, color: _primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Chi tiết cuộc hẹn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Info details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAppointmentDetailItem(
                  icon: Icons.person,
                  label: 'Bệnh nhân:',
                  value: rating['fullName'] ?? 'Không xác định',
                ),
                const SizedBox(height: 8),
                _buildAppointmentDetailItem(
                  icon: Icons.access_time,
                  label: 'Thời gian:',
                  value:
                      '${rating['timeOfAppointment']} • ${_formatDate(rating['dateOfAppointment'])}',
                ),
                const SizedBox(height: 8),
                _buildAppointmentDetailItem(
                  icon: Icons.info_outline,
                  label: 'Lý do:',
                  value: rating['reasonOfMeeting'] ?? 'Không có thông tin',
                  lastItem: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool lastItem = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 14, color: _primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dateParts = dateStr.split('-');
      if (dateParts.length != 3) return dateStr;

      final date = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
