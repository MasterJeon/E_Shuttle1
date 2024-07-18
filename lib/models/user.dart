class User {
  String email_student_id;
  String password;

  User({
    required this.email_student_id,
    required this.password,
  });

  User.fromJson(Map<String, Object?> json) : this(
    email_student_id: json['email_student_id']! as String,
    password: json['password']! as String,
  );

  User copyWith({
    String? email_student_id,
    String? password,
  }) {
    return User(email_student_id: email_student_id ?? this.email_student_id,
      password: password ?? this.password);
  }

  Map<String, Object?> toJson(){
    return{
      'email_student_id': email_student_id,
      'password': password,
    };
  }


}