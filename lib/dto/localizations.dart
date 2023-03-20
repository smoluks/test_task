class LocalizationDto {
  static String qrLink = "";
  static String scanQrCode = "";
  static String alert = "";

  static fromJson(Map<String, dynamic> json) {
    qrLink = json['qrLink'];
    scanQrCode = json['scanQRCode'];
    alert = json['alert'];
  }
}
