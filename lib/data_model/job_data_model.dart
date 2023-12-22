class Job {
  final String title;
  final String companyName;
  final String locationCity;
  final String description;
  final String url;
  final String imageUrl;
  final String displayCompensation;
  final List<String> skills;
  final String relativeTime;
  final bool isRemote;
  final String postedAtRelative;
  final String name;
  final bool isProfileVerified;
  final double score;
  final String lowerworkex;
  final String upperworkex;

  Job({
    required this.title,
    required this.companyName,
    required this.locationCity,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.displayCompensation,
    required this.skills,
    required this.relativeTime,
    required this.isRemote,
    required this.postedAtRelative,
    required this.name,
    required this.isProfileVerified,
    required this.score,
    required this.lowerworkex,
    required this.upperworkex
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    List<String> skills = (json['skills'] as List? ?? [])
        .map((skillJson) => skillJson['skill'] as String? ?? 'Unknown Skill')
        .toList();

    return Job(
      title: json['title'] ?? 'No title available',
      companyName: json['companyName'] ?? 'No company name available',
      locationCity: json['location_city'] ?? 'No location available',
      description: json['description'] ?? 'No description available',
      url: json['url'] ?? 'No URL available',
      imageUrl: json['userInfo']?['image_id'] ?? 'default_image_url',
      displayCompensation:
          json['displayCompensation'] ?? 'Compensation not disclosed',
      skills: skills,
      relativeTime: json['relativeTime'] ?? 'Time not available',
      isRemote: json['is_remote'] == 1,
      postedAtRelative: json['postedAtRelative'] ?? 'Date not available',
      name: json['userInfo']?['name'] ?? 'Name not available',
      isProfileVerified: json['userInfo']?['isProfileVerified'] ?? false,
      lowerworkex: json['lowerworkex']?.toString() ?? "not available",
      upperworkex: json['upperworkex']?.toString() ?? "not available",
      score: (json['userInfo']?['score'] ?? 0).toDouble(),

    );
  }
}
