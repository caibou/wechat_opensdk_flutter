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
}
