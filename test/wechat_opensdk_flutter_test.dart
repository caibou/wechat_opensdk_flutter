import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_opensdk_flutter/wechat_opensdk_flutter.dart';
import 'package:wechat_opensdk_flutter/wechat_opensdk_flutter_platform_interface.dart';
import 'package:wechat_opensdk_flutter/wechat_opensdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWechatOpensdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements WechatOpensdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WechatOpensdkFlutterPlatform initialPlatform = WechatOpensdkFlutterPlatform.instance;

  test('$MethodChannelWechatOpensdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWechatOpensdkFlutter>());
  });

  test('getPlatformVersion', () async {
    WechatOpensdkFlutter wechatOpensdkFlutterPlugin = WechatOpensdkFlutter();
    MockWechatOpensdkFlutterPlatform fakePlatform = MockWechatOpensdkFlutterPlatform();
    WechatOpensdkFlutterPlatform.instance = fakePlatform;

    expect(await wechatOpensdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
