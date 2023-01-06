import 'dart:io';
import 'dart:math';

extension FileSize on File {
  String getFileSize() {
    // length().then((value) {});
    // int bytes = await file.length();
    // if (bytes <= 0) return "0 B";
    // const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    // var i = (log(bytes) / log(1024)).floor();
    // return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
    // final file = File('pickedVid.mp4');
    int sizeInBytes = lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toStringAsFixed(2);
  }
}
