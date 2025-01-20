class Complaint {
  final String title;
  final String description;
  final String location;
  final String date;
  final String userId;



  Complaint({
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.userId,
  });

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      title: map['title'] ?? 'No title provided',
      description: map['description'] ?? 'No description provided',
      location: map['location'] ?? 'No location provided',
      date: map['date'] ?? 'No date provided',
      userId: map['userId'] ?? 'No id provided',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date,
      'userId': userId,
    };
  }
}
