import 'package:wechat_opensdk_flutter/src/wechat_opensdk_api.g.dart';
import 'package:wechat_opensdk_flutter/src/wechat_opensdk_resp_callback.dart';

class WeChatOpenSdkPlugin {
  final WeChatOpenSdkApi api = WeChatOpenSdkApi();
  final WeChatOpenSdkRespCallBack _sdkResp = WeChatOpenSdkRespCallBack();
  Stream<WxSdkOnResp> get onRespStream => _sdkResp.onRespStream;

  factory WeChatOpenSdkPlugin() => _instance;
  static final WeChatOpenSdkPlugin _instance = WeChatOpenSdkPlugin._();

  WeChatOpenSdkPlugin._() {
    WxSdkOnRespApi.setup(_sdkResp);
  }

  Future<bool> registerApp(
          {required String appId,
          required String urlSchema,
          required String universalLink}) =>
      api.registerApp(appId, urlSchema, universalLink);

  Future<bool> isWxInstalled() => api.isWxInstalled();

  Future<bool> shareWebPage({required WxShareWebPage req}) =>
      api.shareWebPage(req);

  Future<bool> shareImage({required WxShareImage req}) => api.shareImage(req);
}
