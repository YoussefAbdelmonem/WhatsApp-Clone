
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/select_contacts/repo/select_contacts_repo.dart';

final getContactsController = FutureProvider((ref) {
  final selectContactsRepo = ref.watch(selectContactsRepoProvider);
  return selectContactsRepo.getContacts();
});

final selectContactsControllerProvider = Provider((ref) {
 final selectContactsRepo = ref.watch(selectContactsRepoProvider);
 return SelectContactsController(ref: ref, selectContactsRepo: selectContactsRepo);
});
class SelectContactsController
{
  final ProviderRef ref ;
  final SelectContactsRepo selectContactsRepo;
  SelectContactsController({required this.ref,required this.selectContactsRepo});

  void selectContacts(Contact selectedContact,BuildContext context){
    selectContactsRepo.selectContacts(selectedContact,context);

  }
}