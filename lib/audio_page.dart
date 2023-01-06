import 'dart:io' as io;
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'component/search_widget.dart';
import 'component/toggle_line.dart';

final audioSelected = StateProvider((ref) => <io.File>[]);

class AudioPage extends StatefulHookConsumerWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends ConsumerState<AudioPage> {
  String? directory;
  List file = [];

  @override
  void initState() {
    super.initState();
    _listofAudio();
  }

  void _listofAudio() async {
    List<String> photoExt = ['jpg', 'jpeg', 'png'];
    List<String> mediaExt = [...photoExt, '3gp', 'mp4', 'mp3', 'm4a', 'opus'];
    List<String> excludeExt = [...mediaExt, 'nomedia'];
    List<String> storageDirs =
        await ExternalPath.getExternalStorageDirectories();
    directory = storageDirs[0];
    List<io.FileSystemEntity> entities =
        await io.Directory("$directory").list().toList();
    await _getAudios(entities, excludeExt);

    setState(() {});
  }

  _getAudios(
      List<io.FileSystemEntity> entities, List<String> excludeExt) async {
    for (io.FileSystemEntity dt in entities) {
      if (dt is io.File == false) {
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
                if (ext == 'mp3') {
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
                  if (ext == 'mp3') {
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
        if (ext == 'mp3') {
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
        const SearchWidget(),
        file.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Please wait, fetching audios..."),
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
                        List<io.File> audioList = ref.read(audioSelected);
                        audioList.add(file[index]);
                        ref
                            .read(audioSelected.notifier)
                            .update((state) => audioList.toList());
                      },
                      leading:
                          const CircleAvatar(child: Icon(Icons.play_arrow)),
                      title: Text(fileName),
                      subtitle: const Text("-"),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class AudioPageBack extends HookConsumerWidget {
  const AudioPageBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Images Rebuild");
    final audios = ref.watch(audioSelected);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: audios.isEmpty
          ? Container()
          : ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                io.File fileData = audios[index] as io.File;
                String fileName = fileData.path.split('/').last;
                return ListTile(
                  onTap: () {},
                  leading: CircleAvatar(child: Icon(Icons.play_arrow)),
                  title: Text(fileName),
                  subtitle: Text("-"),
                );
              },
            ),
    );
  }
}
