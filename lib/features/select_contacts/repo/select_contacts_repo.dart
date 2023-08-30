import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/data/model/user_model.dart';
import 'package:whats_app_clone/screens/mobile_chat_screen.dart';
import 'package:whats_app_clone/utils/utils.dart';

final selectContactsRepoProvider = Provider((ref) => SelectContactsRepo(
  firestore: FirebaseFirestore.instance,
));
class SelectContactsRepo {
  final FirebaseFirestore firestore;

  SelectContactsRepo({required this.firestore});


Future<List<Contact>> getContacts() async {
  List<Contact> contacts =[];
 try{
   if ( await FlutterContacts.requestPermission()) {
     // Get all contacts (lightly fetched)
     contacts  = await FlutterContacts.getContacts(
       withProperties: true,
     );

     // // Get all contacts (fully fetched)
     // contacts = await FlutterContacts.getContacts(
     //     withProperties: true)

   }
 }catch(e){
   print(e);
 }

  return contacts;

}
void selectContacts (Contact selectedContact,BuildContext context)async{
  try{
   var userCollection=await firestore.collection("users").get();
   bool isFund=false;
   for(var document in userCollection.docs){
  var userData =UserModel.fromJson(document.data());
 String selectedNumber =selectedContact.phones[0].number.replaceAll(" ", "");
  if(userData.phoneNumber==selectedNumber){
    isFund=true;
    /// navigate to chat screen
    Navigator.pushNamed(context, MobileChatScreen.routeName);
  }
  if(!isFund){
    showSnackBar(context, "User not found in the App");
  }

   }

  }catch (e){
    showSnackBar(context, e.toString());
  }
}



}