class HomeHealthIndicator {
  String tabs;
  String evaluation;
  String dateTime;
  String indicator;
  String averageIndicator;

  HomeHealthIndicator({
    required this.tabs,
    required this.evaluation,
    required this.dateTime,
    required this.indicator,
    required this.averageIndicator,
  });

  factory HomeHealthIndicator.fromJson(Map<String, dynamic> json) {
    return HomeHealthIndicator(
      tabs: json['tabs'],
      evaluation: json['evaluation'],
      dateTime: json['dateTime'],
      indicator: json['indicator'],
      averageIndicator: json['averageIndicator'],
    );
  }
}