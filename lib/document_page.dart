import 'dart:io' as io;

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_app/component/search_widget.dart';
import 'package:media_app/component/toggle_line.dart';
import 'package:media_app/utils/file.dart';

final documentSelected = StateProvider((ref) => <io.File>[]);

class DocumentPage extends StatefulHookConsumerWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> {
  String? directory;
  List file = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    List<String> photoExt = ['jpg', 'jpeg', 'png'];
    List<String> mediaExt = [...photoExt, '3gp', 'mp4', 'mp3', 'm4a', 'opus'];
    List<String> excludeExt = [...mediaExt, 'nomedia'];
    List<String> storageDirs =
        await ExternalPath.getExternalStorageDirectories();
    directory = storageDirs[0];
    List<io.FileSystemEntity> entities =
        await io.Directory("$directory").list().toList();
    await _getFiles(entities, excludeExt);

    setState(() {});
  }

  _getFiles(List<io.FileSystemEntity> entities, List<String> excludeExt) async {
    for (io.FileSystemEntity dt in entities) {
      if (dt is io.File == false) {
        // List<io.FileSystemEntity> entitiesSecond
        // print("PATH: ${dt.path}");
        if (dt.path != '/storage/emulated/0/Android') {
          List<io.FileSystemEntity> entities2 =
              io.Directory(dt.path).listSync(recursive: true).toList();
          for (io.FileSystemEntity dt2 in entities2) {
            if (dt.path.split('/').length > 5 &&
                dt.path.split('/')[5][0] != '.') {
              if (dt2 is io.File) {
                String ext = dt2.path.split('.').last;
                ext = ext.trim();
                if (!excludeExt.contains(ext)) {
                  // print("EXT 1: ${dt2.path}");
                  if (file.length > 400) break;
                  file.add(dt2);
                }
              }
            }
          }
        } else {
          List<io.FileSystemEntity> entities3 =
              await io.Directory(dt.path).list().toList();
          for (var dt3 in entities3) {
            // print(
            //     "PATH Split: ${dt3.path.split('/')} -- ${dt3.path.split('/')[5]} -- ${dt3.path.split('/')[5][0]}");
            if (dt3.path.split('/')[5] != "data" &&
                dt3.path.split('/')[5] == "media" &&
                dt3.path.split('/')[5][0] != '.') {
              List<io.FileSystemEntity> entities4 =
                  io.Directory(dt3.path).listSync(recursive: true).toList();
              for (io.FileSystemEntity dt4 in entities4) {
                if (dt4 is io.File) {
                  String ext = dt4.path.split('.').last;
                  ext = ext.trim();
                  if (!excludeExt.contains(ext)) {
                    // print("EXT 2: ${dt4.path}");
                    if (file.length > 400) break;
                    file.add(dt4);
                  }
                }
              }
            }
          }
        }
      } else {
        String ext = dt.path.split('.').last;
        ext = ext.trim();
        if (!excludeExt.contains(ext)) {
          // print("EXT 3: ${dt.path}");
          if (file.length > 400) break;
          file.add(dt);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ToggleLine(),
        const ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.menu)),
          title: Text("Internal Storage"),
          subtitle: Text("Cari sistem data anda"),
        ),
        const Divider(color: Colors.grey, height: 1.0),
        const ListTile(
          leading: SizedBox(height: double.infinity, child: Icon(Icons.photo)),
          title: Text("Gallery"),
          subtitle: Text("Kirim gambar tanpa kompresi"),
        ),
        const Divider(color: Colors.grey, height: 1.0),
        file.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Please wait, fetching documents..."),
                  Text("This may take a long time due to your data"),
                ],
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: file.length,
                  itemBuilder: (context, index) {
                    // print(file[index].toString());
                    io.File fileData = file[index] as io.File;
                    String fileName = fileData.path.split('/').last;
                    return ListTile(
                      onTap: () {
                        List<io.File> documentList = ref.read(documentSelected);
                        documentList.add(file[index]);
                        ref
                            .read(documentSelected.notifier)
                            .update((state) => documentList.toList());
                      },
                      leading: Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.file_copy),
                      ),
                      title: Text(fileName),
                      subtitle: Text("${fileData.getFileSize()} MB"),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class DocumentPageBack extends HookConsumerWidget {
  const DocumentPageBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Images Rebuild");
    final documents = ref.watch(documentSelected);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: documents.length == 0
          ? Container()
          : ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                io.File fileData = documents[index] as io.File;
                String fileName = fileData.path.split('/').last;
                return ListTile(
                  onTap: () {},
                  leading: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.file_copy),
                  ),
                  title: Text(fileName),
                  subtitle: Text("${fileData.getFileSize()} MB"),
                );
              },
            ),
    );
  }
}
