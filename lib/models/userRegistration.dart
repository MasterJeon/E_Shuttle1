class UserRegistration {
  String password;
  String contact_no;
  String email;
  String full_name;
  String guardian_contact_no;
  String password_confirm;
  String student_id;
  final double wallet_balance;
  final String routeno;

  UserRegistration({
    required this.password,
    required this.contact_no,
    required this.email,
    required this.full_name,
    required this.guardian_contact_no,
    required this.password_confirm,
    required this.student_id,
    this.wallet_balance = 0.0,
    this.routeno = ' ',
  });

  UserRegistration.fromJson(Map<String, Object?> json)
      : this(
    student_id: json['student_id']! as String,
    password: json['password']! as String,
    password_confirm: json['password_confirm']! as String,
    contact_no: json['contact_no']! as String,
    email: json['email']! as String,
    full_name: json['full_name']! as String,
    guardian_contact_no: json['guardian_contact_no']! as String,
    wallet_balance: (json['wallet_balance'] as num?)?.toDouble() ?? 0.0,
    routeno: (json['routeno'] as String?).toString() ?? ' ',
  );

  UserRegistration copyWith({
    String? password,
    String? contact_no,
    String? email,
    String? full_name,
    String? guardian_contact_no,
    String? password_confirm,
    String? student_id,
    double? wallet_balance,
    String? routeno,
  }) {
    return UserRegistration(
      student_id: student_id ?? this.student_id,
      password: password ?? this.password,
      password_confirm: password_confirm ?? this.password_confirm,
      contact_no: contact_no ?? this.contact_no,
      email: email ?? this.email,
      full_name: full_name ?? this.full_name,
      guardian_contact_no: guardian_contact_no ?? this.guardian_contact_no,
      wallet_balance: wallet_balance ?? this.wallet_balance,
      routeno: routeno ?? this.routeno,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'student_id': student_id,
      'password': password,
      'contact_no': contact_no,
      'email': email,
      'full_name': full_name,
      'guardian_contact_no': guardian_contact_no,
      'password_confirm': password_confirm,
      'wallet_balance': wallet_balance,
      'routeno': routeno,
    };
  }
}
