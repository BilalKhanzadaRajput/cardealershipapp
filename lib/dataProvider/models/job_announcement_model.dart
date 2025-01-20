class JobAnnouncement {
  final String title;
  final String description;
  final String numberOfPositions;
  final String role;
  final String timing;
  final String salary;
  final String company;
  final String location;
  final String date;

  JobAnnouncement(
      this.title,
      this.description,
      this.numberOfPositions,
      this.role,
      this.timing,
      this.salary,
      this.company,
      this.location,
      this.date,
      );

  factory JobAnnouncement.fromMap(Map<String, dynamic> map) {
    return JobAnnouncement(
      map['title'],
      map['description'],
      map['numberOfPositions'],
      map['role'],
      map['timing'],
      map['salary'],
      map['company'],
      map['location'],
      map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'numberOfPositions': numberOfPositions,
      'role': role,
      'timing': timing,
      'salary': salary,
      'company': company,
      'location': location,
      'date': date,
    };
  }
}
