import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'component/search_widget.dart';
import 'component/toggle_line.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

final contactSelected = StateProvider((ref) => <Contact?>[]);

class ContactPage extends StatefulHookConsumerWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    final contacts = await ContactsService.getContacts(withThumbnails: true);
    // print("${contacts.length} Contact");
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ToggleLine(),
        const SearchWidget(),
        _contacts == null || _contacts!.isEmpty
            ? const CircularProgressIndicator()
            : Expanded(
                child: ListView.builder(
                  itemCount: _contacts?.length,
                  itemBuilder: (context, index) {
                    // print("CONTACT: ${_contacts?[index]}");
                    String displayName = _contacts?[index].displayName ?? "-";
                    String email = '-';
                    if (_contacts?[index].emails != null) {
                      if (_contacts![index].emails!.isNotEmpty) {
                        email = _contacts?[index].emails![0].value ?? '-';
                      }
                    }
                    return ListTile(
                      onTap: () {
                        List<Contact?> contactList = ref.read(contactSelected);
                        contactList.add(_contacts?[index]);
                        ref
                            .read(contactSelected.notifier)
                            .update((state) => contactList.toList());
                      },
                      leading: CircleAvatar(child: const Icon(Icons.person)),
                      title: Text(displayName),
                      subtitle: Text(email),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class ContactPageBack extends HookConsumerWidget {
  const ContactPageBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print("Images Rebuild");
    final contacts = ref.watch(contactSelected);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: contacts.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                // print("CONTACT: ${contacts[index]}");
                String displayName = contacts[index]?.displayName ?? "-";
                String email = '-';
                if (contacts[index] != null) {
                  if (contacts[index]!.emails!.isNotEmpty) {
                    email = contacts[index]!.emails![0].value ?? '-';
                  }
                }
                // String displayName = "Contact $index";
                return ListTile(
                  onTap: () {},
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(displayName),
                  subtitle: Text(email),
                );
              },
            ),
    );
  }
}
