class UserEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? phone;
  final String? photo;
  final String? role;
  final List? addresses;
  final List? wishlist;
  final DateTime? createdAt;

  UserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.id,
    this.createdAt,
    this.addresses,
    this.wishlist,
    this.photo,
    this.gender,
  });
}
