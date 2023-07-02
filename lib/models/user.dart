// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username ": username,
        "uid ": uid,
        "email ": email,
        "photoUrl ": photoUrl,
        "bio ": bio,
        "followers ": followers,
        "following ": following,
      };
}
