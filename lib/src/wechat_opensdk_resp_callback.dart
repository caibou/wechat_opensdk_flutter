
import 'dart:async';

import 'wechat_opensdk_api.g.dart';

class WeChatOpenSdkRespCallBack extends WxSdkOnRespApi { 
final StreamController<WxSdkOnResp> wxSdkOnRespController =
      StreamController.broadcast();
  Stream<WxSdkOnResp> get onRespStream => wxSdkOnRespController.stream;

  @override
  void onResp(WxSdkOnResp resp) {
    wxSdkOnRespController.add(resp);
  }

}
