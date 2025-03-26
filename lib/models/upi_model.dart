class UpiModel {
  String type;
  String upiId;
  UpiModel({required this.upiId, this.type = 'UPI'});

  factory UpiModel.fromJson(Map<String, dynamic> json) {
    return UpiModel(
      upiId: json['upi_id'] as String,
      type: json['type'] as String? ?? 'UPI',
    );
  }

  Map<String, dynamic> toMap() {
    return {'upi_id': upiId, 'type': type};
  }
}
