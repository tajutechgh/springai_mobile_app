import 'package:springai_mobile_app/endpoints/platform_os.dart';

class BaseUrl {

  static const String _androidBase = "http://10.0.2.2:8080";
  static const String _iosBase = "http://localhost:8080";
  static const String _defaultBase = "https://api.default-app.com";

  static String get base {

    if (PlatformOs.isAndroid) return _androidBase;

    if (PlatformOs.isIOS) return _iosBase;

    return _defaultBase;
  }

  // endpoints
  static String getAskTajuDNChatModel(String prompt) => "$base/tajutechgh/ai/v1/ask/options?prompt=$prompt";
  static String get generateImageModel => "$base/tajutechgh/ai/v1/generate/image/options";
  static String get prepareRecipeModel => "$base/tajutechgh/ai/v1/get/recipe";
}
