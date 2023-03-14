import 'dart:convert';
import 'dart:io';

class ClassPrinterNet {
  void scanWifi() async {
    print('Scanning for available Wi-Fi networks...');
    final wifiResult = await Process.run('iwlist', ['scan']);
    final wifiOutput = wifiResult.stdout.toString();
    final regex = RegExp(r'ESSID:"(.*)"');
    final matches = regex.allMatches(wifiOutput);

    if (matches.isEmpty) {
      print('No Wi-Fi networks found.');
    } else {
      print('Available Wi-Fi networks:');
      for (final match in matches) {
        final ssid = match.group(1);
        print('  $ssid');
      }

      final stdin = File('/dev/stdin');
      stdout.write('Enter the name of the Wi-Fi network to connect to: ');
      final ssid = stdin.readAsStringSync();

      stdout.write('Enter the password for the Wi-Fi network: ');
      final password = stdin.readAsStringSync();

      print('Connecting to Wi-Fi network $ssid...');
      await Process.run(
          'nmcli', ['dev', 'wifi', 'connect', ssid, 'password', password]);
      print('Connected to Wi-Fi network $ssid.');
    }
  }


sendPrintJob(String ipAddress, int port, String printData) async {
  try {
    // create a socket connection to the printer
    Socket socket = await Socket.connect(ipAddress, port);

    // write the print data to the socket
    socket.write(utf8.encode(printData));

    // close the socket connection
    socket.close();
  } catch (e) {
    print('Error: $e');
  }
}

// call the sendPrintJob function with the IP address of the printer, the port number, and the print data
//sendPrintJob('192.168.1.100', 9100, 'This is a test print job');

}
