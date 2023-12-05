#import "WechatOpensdkFlutterPlugin.h"
#import "WeChatOpenSdkApiImpl.h"
#import "GeneratedWeChatOpenSdkPluginApi.g.h"

@implementation WechatOpensdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    WxSdkOnRespApi* onRespApi = [[WxSdkOnRespApi alloc] initWithBinaryMessenger:registrar.messenger];
    WeChatOpenSdkApiImpl* impl = [[WeChatOpenSdkApiImpl alloc] initWithWxSdkOnRespApi:onRespApi];
    [registrar addApplicationDelegate:(NSObject<FlutterPlugin> *)impl];
    WeChatOpenSdkApiSetup(registrar.messenger,impl);
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"WechatOpensdkFlutterPlugin detachFromEngineForRegistrar");
}

@end
