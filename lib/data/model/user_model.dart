class UserModel {
  final String name;

  final String phoneNumber;
  final String profilePicture;
  final String uid;
  final bool isOnline;
  final List<String> groupIds;

  UserModel(
      {required this.name,
      required this.phoneNumber,
      required this.profilePicture,
      required this.uid,
      required this.isOnline,
      required this.groupIds});

  Map<String,dynamic>  toJson(){
    return{
      'name':name,
      'phoneNumber':phoneNumber,
      'profilePicture':profilePicture,
      'uid':uid,
      'isOnline':isOnline,
      'groupIds':groupIds,

    };
  }

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      name: json['name']??"",
      phoneNumber: json['phoneNumber']??"",
      profilePicture: json['profilePicture']??"",
      uid: json['uid']??"",
      isOnline: json['isOnline']??false,
      groupIds: List<String>.from(json['groupIds']),

    );
  }
}
