import 'dart:async';

import 'package:log_manager/src/shared/log_printer.dart';

abstract class ZoneSpecs {
  static ZoneSpecification defaultZoneSpecification({bool logToFile = false, bool prettyPrint = false}) {
    return ZoneSpecification(
      print: (self, parent, zone, message) async {
        // Override print to handle log messages
        LogPrinter.print(message, delegate: parent, zone: zone, pretty: prettyPrint);
        //final writeDir = await getDownloadsDirectory();
        //parent.print(zone, 'PATH: ${writeDir?.path}/logs.d');
        //FileLogger('${writeDir?.path}/logs.d').log('Zoned: $message');
        //debugPrint('Zoned: $message $self $parent $zone');
      },
    );
  }
}
