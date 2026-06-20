import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? photo;
  final String? role;
  final DateTime? createdAt;

  const DriverEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory DriverEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DriverEntity();
    return DriverEntity(
      id: json['id']?.toString()??json['_id'] as String?,
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString(),
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      photo: json['photo']?.toString(),
      role: json['role']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'photo': photo,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, role];
}
