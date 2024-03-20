import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:annette_app_x/providers/connection_provider.dart';
import 'package:flutter/services.dart';

import 'package:annette_app_x/models/file_format.dart';
import 'package:annette_app_x/providers/api/files_provider.dart';
import 'package:flutter/material.dart';

class TimetableTimeSlots extends StatefulWidget {
  const TimetableTimeSlots({Key? key}) : super(key: key);

  @override
  State<TimetableTimeSlots> createState() => _TimetableTimeSlotsState();
}

class _TimetableTimeSlotsState extends State<TimetableTimeSlots> {
  ///Die URL des Zeitplans
  final String address =
      "https://plaene.annettegymnasium.de/Pausenregelung.jpg";
  
  ///Der Pfad, in dem der Zeitplan lokal gespeichert wird
  final String path = "timetable/time_slots.jpg";
  
  ///Wenn true, kann man den Zeitplan aktualisieren, indem man nach unten zieht.
  ///Nina hat aber gerechtfertigterweise darauf hingewiesen, dass der Plan in den letzten Jahren nicht geändert wurde 
  final bool updateable = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage(),
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          //Solange der Zeitplan geladen wird, wird ein Ladeindikator angezeigt (ist aber kaum nötig)
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      getImage(forceReload: true);
                    });
                  },
                  child: SingleChildScrollView(
                      physics: updateable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                      child: Image(image: snapshot.data!.image)));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<Image> getImage({bool forceReload = false}) async {
    File? file = await FilesProvider.getFile("time_slots", FileFormat.JPG);
    if (file != null && await file.exists() && !forceReload) {
      return Image.file(file);
    } else {
      if (!ConnectionProvider.hasDownloadConnection()){
        //TODO: Fehlermeldung anzeigen
        throw PlatformException(code: "no_connection", message: "No connection");
      }
      final ByteData data =
          await NetworkAssetBundle(Uri.parse(address)).load(address);
      final Int8List bytes = data.buffer.asInt8List();
      print("Downloading image");
      Image image = Image.memory(Uint8List.fromList(bytes));

      await FilesProvider.storeFile("time_slots", bytes, FileFormat.JPG);
      return image;
    }
  }
}
