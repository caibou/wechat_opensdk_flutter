import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/wechat_opensdk_api.g.dart',
  kotlinOut:
      'android/src/main/kotlin/com/dianyun/wechat_opensdk_flutter/GeneratedMediaPluginApi.kt',
  objcSourceOut: 'ios/Classes/GeneratedWeChatOpenSdkPluginApi.g.m',
  objcHeaderOut: 'ios/Classes/GeneratedWeChatOpenSdkPluginApi.g.h',
))
enum WxSceneType {
  friend,
  timeLine,
}

class WxShareBaseModel {
  String title;
  String content;
  WxSceneType scene;
  String thumbImageUrl;
  WxShareBaseModel(
      {required this.title, required this.content,required this.thumbImageUrl, required this.scene});
}

class WxSdkOnResp {
  int errCode;
  int type;
  String? country;
  String? description;
  String? lang;
  String? errorDescription;
  WxSdkOnResp({required this.errCode, required this.type});
}

class WxShareWebPage {
  String pageUrl;
  WxShareBaseModel base;
  WxShareWebPage(
      {required this.pageUrl,
      required this.base});
}

class WxShareImage {
  final Uint8List? imageData;
  WxShareBaseModel base;
  WxShareImage(
      {required this.imageData,
      required this.base});
}

@HostApi()
abstract class WeChatOpenSdkApi {
  @async
  bool registerApp(String appId, String urlSchema, String universalLink);

  @async
  bool isWxInstalled();

  @async
  bool shareWebPage(WxShareWebPage req);

  @async
  bool shareImage(WxShareImage req);
}

@FlutterApi()
 abstract class WxSdkOnRespApi {
   void onResp(WxSdkOnResp resp);
 }

