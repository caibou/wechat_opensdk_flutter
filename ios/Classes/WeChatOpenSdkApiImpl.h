//
//  WeChatOpenSdkApiImpl.h
//  qq_opensdk_flutter
//
//  Created by PC on 2023/11/1.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "GeneratedWeChatOpenSdkPluginApi.g.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeChatOpenSdkApiImpl : NSObject<WeChatOpenSdkApi,FlutterApplicationLifeCycleDelegate>

- (instancetype)initWithWxSdkOnRespApi:(WxSdkOnRespApi *)onRespApi;

@end

NS_ASSUME_NONNULL_END
