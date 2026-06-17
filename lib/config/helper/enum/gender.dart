enum Gender {
  male("male"),
  female("female");

  final String value;
  const Gender(this.value);
  static Gender fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return Gender.male;
      case "female":
        return Gender.female;
      default:
        return Gender.male;
    }
  }
}
