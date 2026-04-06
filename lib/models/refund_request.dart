class RefundRequest {
  String amount;
  String date;
  String route;
  String stop;
  String reason;
  String userId; // To link the refund request to a specific user

  RefundRequest({
    required this.amount,
    required this.date,
    required this.route,
    required this.stop,
    required this.reason,
    required this.userId,
  });

  RefundRequest.fromJson(Map<String, Object?> json)
      : this(
    amount: json['amount']! as String,
    date: json['date']! as String,
    route: json['route']! as String,
    stop: json['stop']! as String,
    reason: json['reason']! as String,
    userId: json['userId']! as String,
  );

  RefundRequest copyWith({
    String? amount,
    String? date,
    String? route,
    String? stop,
    String? reason,
    String? userId,
  }) {
    return RefundRequest(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      route: route ?? this.route,
      stop: stop ?? this.stop,
      reason: reason ?? this.reason,
      userId: userId ?? this.userId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'amount': amount,
      'date': date,
      'route': route,
      'stop': stop,
      'reason': reason,
      'userId': userId,
    };
  }
}
