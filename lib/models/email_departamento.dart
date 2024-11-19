class EmailDpto {
  String qb_email;

  EmailDpto({
    required this.qb_email,
  });

  EmailDpto.empty()
      : qb_email = '';

  EmailDpto.fromMap(Map<String, dynamic> map)
      : qb_email = map['qb_email'];

  @override
  String toString() {
    return "email: $qb_email";
  }

  Map<String, dynamic> toMap() {
    return {
      'qb_email': qb_email,
    };
  }
}
