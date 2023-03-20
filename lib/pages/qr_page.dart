import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import '../dto/localizations.dart';
import '../infrastructure/api_connector.dart';
import 'page_base.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPage();
}

class _QrPage extends PageBase<QrPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget view(BuildContext context) {
    return Stack(children: [
      QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.white,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: 250),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      ),
      Column(children: [
        const SizedBox(height: 50),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            icon: const Icon(Icons.close),
            onPressed: onAction(goToMainPage),
          )
        ]),
        const SizedBox(height: 500),
        Text(LocalizationDto.qrLink,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
      ])
    ]);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen(
        (data) => {processActionWithParam(sendQRAndGoToMainPage, data)});
  }

  Future<void> _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool p) async {
    if (!p) {
      await FlutterPlatformAlert.showAlert(
        windowTitle: '',
        text: 'No permission for camera',
        alertStyle: AlertButtonStyle.ok,
        iconStyle: IconStyle.information,
      );

      await goBack(null);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> sendQRAndGoToMainPage(Barcode data) async {
    if (data.code == null) return;

    await ApiConnector.sendQR(data.code!);

    await FlutterPlatformAlert.showAlert(
      windowTitle: '',
      text: LocalizationDto.alert,
      alertStyle: AlertButtonStyle.ok,
      iconStyle: IconStyle.information,
    );

    await goBack(null);
  }

  Future<void> goToMainPage() async {
    await goBack(null);
  }
}
