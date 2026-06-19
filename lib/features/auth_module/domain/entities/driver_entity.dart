import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? role;

  const DriverEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
  });

  factory DriverEntity.fromJson(Map<String, dynamic> json) {
    return DriverEntity(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, phone, role];
}
