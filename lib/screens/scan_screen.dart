import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:snack_food/screens/search_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool flash = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Stack(
          children: [
            Expanded(
              flex: 4,
              child: _buildQrView(context),
            ),
            const Align(
              alignment: Alignment(0, -0.65),
              child: Text(
                "Scan a barcode",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Align(
                alignment: const Alignment(0, .75),
                child: FloatingActionButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      flash = !flash;
                    });
                  },
                  elevation: flash ? 6 : 0,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: Icon(
                    (flash ? Icons.flash_on_rounded : Icons.flash_off_rounded),
                    color: flash ? Colors.lightBlue : Colors.grey,
                    size: 32,
                    // black shadow
                    shadows: const [
                      BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(0, 1),
                          spreadRadius: 2,
                          blurRadius: 4)
                    ],
                  ),
                )
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.flash_off_rounded,
                //     color: Colors.white,
                //   ),
                //   color: Colors.white,
                //   iconSize: 32,
                //   padding: EdgeInsets.all(16),
                // )
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For setting the width and height of the QR view.
    var scanArea = MediaQuery.of(context).size.width * 0.75;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        // cutOutSize: scanArea,
        cutOutWidth: scanArea,
        cutOutHeight: scanArea * 0.65,
        overlayColor: Colors.lightBlue.withOpacity(.95),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        controller.pauseCamera();
        controller.dispose();
        Navigator.of(context).pop(scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
