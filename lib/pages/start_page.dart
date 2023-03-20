import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:permission_handler/permission_handler.dart';

import '../dto/localizations.dart';
import '../infrastructure/api_connector.dart';
import 'qr_page.dart';
import 'page_base.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends PageBase<StartPage> {
  @override
  Future<void> onInitPage() async {
    //--Get camera permission--
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (!await Permission.camera.request().isGranted) {
        await FlutterPlatformAlert.showAlert(
          windowTitle: '',
          text: 'No permission for camera',
          alertStyle: AlertButtonStyle.ok,
          iconStyle: IconStyle.information,
        );

        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }

    //--Get field mappings--
    await ApiConnector.getLocalizations();

    //
    setStateOk();
  }

  @override
  Widget view(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  iconColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: onAction(goToQRPage),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                        child: Text(LocalizationDto.scanQrCode)),
                    const Icon(
                      Icons.qr_code_2,
                    ),
                  ],
                ))),
        const SizedBox(
          height: 200,
        ),
      ],
    );
  }

  Future<void> goToQRPage() async {
    await goToNextPage(const QrPage());
  }
}
