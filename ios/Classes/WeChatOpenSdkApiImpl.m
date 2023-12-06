//
//  WeChatOpenSdkApiImpl.m
//  qq_opensdk_flutter
//
//  Created by PC on 2023/11/1.
//

#import <SDWebImage/SDWebImageDownloader.h>
#import <WechatOpenSDK/WechatAuthSDK.h>
#import <WechatOpenSDK/WXApi.h>
#import "WeChatOpenSdkApiImpl.h"
#import "WeChatOpenSdkConstant.h"
#define KWeChatLoginCompletionCallBack @"kWeChatLoginCompletionCallBackk"

typedef void (^completion_t)(NSString *_Nullable, FlutterError *_Nullable);

@interface WeChatOpenSdkApiImpl()<WXApiDelegate, WechatAuthAPIDelegate>

@property (nonatomic, strong) WxSdkOnRespApi *onRespApi;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *urlSchema;
@property (nonatomic, strong) NSMutableDictionary<NSString*, completion_t> *replyDict;

@end

@implementation WeChatOpenSdkApiImpl

- (NSMutableDictionary<NSString *, completion_t> *)replyDict {
    if (!_replyDict) {
        [self setReplyDict:[NSMutableDictionary dictionary]];
    }

    return _replyDict;
}

- (instancetype)initWithWxSdkOnRespApi:(nonnull WxSdkOnRespApi *)onRespApi {
    self = [super init];
    if (self) {
        self.onRespApi = onRespApi;
    }
    return self;
}

- (void)isWxInstalledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion { 
    if (completion) {
        completion([NSNumber numberWithBool:[WXApi isWXAppInstalled]],nil);
    }
}

- (void)registerAppAppId:(NSString *)appId 
               urlSchema:(NSString *)urlSchema
           universalLink:(NSString *)universalLink 
              completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
    
    if (!appId || appId.length <= 0) {
        if (completion) {
            completion([NSNumber numberWithBool:FALSE],[FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        }
        return;
    }

    if (!universalLink || universalLink.length <= 0) {
        if (completion) {
            completion([NSNumber numberWithBool:FALSE],[FlutterError errorWithCode:@"invalid universal link" message:@"are you sure your universal link is correct ? " details:universalLink]);
        }
        return;
    }
    
    self.appID = appId;
    self.urlSchema = urlSchema;
    
    if (appId && urlSchema && universalLink) {
        [WXApi startLogByLevel:WXLogLevelDetail
                      logBlock:^(NSString *_Nonnull log) {
            if (log) {
                NSLog(@"WeChatSDK: %@", log);
            }
        }];

       BOOL ret = [WXApi registerApp:appId universalLink:universalLink];
        if (completion) {
            completion([NSNumber numberWithBool:ret],nil);
        }
        

        // 微信自测
//        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//            NSLog(@"checkUniversalLinkReady: %@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//        }];
    }

}

- (void)shareWebPageReq:(WxShareWebPage *)req 
             completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
    if(!req) {
        if (completion) {
            completion([NSNumber numberWithBool:NO],nil);
        }
        return;
    }
    
    if (req.base.thumbImageUrl.length) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:req.base.thumbImageUrl]
                          options:SDWebImageDownloaderLowPriority
                         progress:nil
                        completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, BOOL finished) {
            
            [WeChatOpenSdkApiImpl shareWebUrl:req.pageUrl Title:req.base.title Description:req.base.content ThumbImage:image InScene:[self intToWeChatScene:req.base.scene] completion:^(BOOL success) {
                if(completion) {
                    completion([NSNumber numberWithBool:YES],nil);
                }
            }];
        }];
    } else {
        [WeChatOpenSdkApiImpl shareWebUrl:req.pageUrl Title:req.base.title Description:req.base.content ThumbImage:nil InScene:[self intToWeChatScene:req.base.scene] completion:^(BOOL success) {
            if(completion) {
                completion([NSNumber numberWithBool:YES],nil);
            }
        }];
    }
}

- (void)shareImageReq:(WxShareImage *)req 
           completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
    
    if(!req) {
        if (completion) {
            completion([NSNumber numberWithBool:NO],nil);
        }
        return;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:req.base.thumbImageUrl]
                      options:SDWebImageDownloaderLowPriority
                     progress:nil
                    completed:^(UIImage *_Nullable image, NSData *_Nullable data, NSError *_Nullable error, BOOL finished) {
        [WeChatOpenSdkApiImpl sendImageData:req.imageData.data ThumbImage:image InScene:[self intToWeChatScene:req.base.scene] title:req.base.title description:req.base.content completion:^(BOOL success) {
            
        }];
         
    }];
}

- (void)weChatAuthWithCompletion:(nonnull void (^)(NSString *_Nullable, FlutterError *_Nullable))completion {

    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    [sendAuthReq setScope:@"snsapi_userinfo"];

    if (![WXApi isWXAppInstalled]) {
        UIViewController *viewController =
            [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [WXApi sendAuthReq:sendAuthReq
            viewController:viewController
                  delegate:nil
                completion:nil];
    } else {
        // 防止 retain cycle
        __weak typeof(self) _self = self;
        [WXApi sendReq:sendAuthReq
            completion:^(bool success) {
            __strong typeof(_self) self = _self;
            if (success) {
                NSLog(@"weChat sendReq true");
                    [[self replyDict] setValue:completion forKey:KWeChatLoginCompletionCallBack];
                    // 如果登录间隔超过30s 超时, 清除回调
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __strong typeof(_self) self = _self;
                        if(self) {
                            [self authCallBack:nil error:[self authRet:RET_COMMON]];
                        }
                    });
            } else {
                NSLog(@"weChat sendReq fail");
                [self authCallBack:nil error:[self authRet:RET_SENTFAIL]];
            }
        }];
    }
}

- (enum WXScene)intToWeChatScene:(WxSceneType)sceneType {
    if (sceneType == WxSceneTypeFriend) {
        return WXSceneSession;
    } else if (sceneType == WxSceneTypeTimeLine)  {
        return WXSceneTimeline;
    } else {
        return WXSceneSession;
    }
}

#pragma mark -class
+ (void)sendImageData:(NSData *)imageData
           ThumbImage:(UIImage *)thumbImage
              InScene:(int)scene
                title:(NSString *)title
          description:(NSString *)description
           completion:(void (^ __nullable)(BOOL success))completion {
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;
    

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = scene;
    req.message = message;

    [WXApi sendReq:req completion:completion];
}


+ (void)shareWebUrl:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene
         completion:(void (^ __nullable)(BOOL success))completion {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;

    
    WXMediaMessage *message = [WXMediaMessage message];
     message.title = title;
     message.description = description;
     message.mediaObject = ext;
     [message setThumbImage:thumbImage];
    

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = scene;
    req.message = message;
    [WXApi sendReq:req completion:completion];
}

- (void)authCallBack:(NSString *)response error:(FlutterError *_Nullable)error {
    completion_t reply = [[self replyDict] objectForKey:KWeChatLoginCompletionCallBack];

    if (reply) {
        reply(response, error);
        [[self replyDict] removeObjectForKey:KWeChatLoginCompletionCallBack];
    }
}

- (FlutterError *_Nullable) authRet:(WeChatRetCode) code {
    FlutterError *_Nullable error = [FlutterError errorWithCode:[WeChatOpenSdkConstant NSStringFromWeChatRetCode:code] message:nil details:nil];
    return error;
}

#pragma mark -WXApiDelegate
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)onReq:(BaseReq *)req {
    
}

// flutter 调用相关requst接口之后,此处得到对应的回调
- (void)onResp:(BaseReq *)resp {
    if (!self.onRespApi) {
        return;
    }

    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *wxResp = ((SendMessageToWXResp *)resp);
        WxSdkOnResp *onResp = [WxSdkOnResp makeWithErrCode:@(wxResp.errCode)
                                                      type:@(wxResp.type)
                                                   country:wxResp.country == nil ? @"" : wxResp.country
                                                      lang:wxResp.lang == nil ? @"" : wxResp.lang
                                          errorDescription:wxResp.errStr == nil ? @"" : wxResp.errStr];

        [self.onRespApi onRespResp:onResp completion:^(FlutterError *_Nullable err) {}];
    }

    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *senAnthR = (SendAuthResp *)resp;
        NSString* weChatToken = senAnthR.code;
        if(weChatToken != nil && weChatToken.length > 0) {
            // 接上 上面sendAuthReq的后面, 返回wechat token给flutter层
            [self authCallBack:weChatToken error:nil];
        } else {
            if(senAnthR.errCode == WXErrCodeAuthDeny) {
                [self authCallBack:nil error:[self authRet:RET_AUTHDENY]];
            } else if(senAnthR.errCode == WXErrCodeUserCancel) {
                [self authCallBack:nil error:[self authRet:RET_USERCANCEL]];
            } else {
                [self authCallBack:nil error:[self authRet:RET_COMMON]];
            }
        }
    }
}

#pragma mark -FlutterApplicationLifeCycleDelegate
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}

- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return NO;
}


- (BOOL)application:(UIApplication*)application
    continueUserActivity:(NSUserActivity*)userActivity
 restorationHandler:(void (^)(NSArray*))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSString *strUrl = url.absoluteString;
        if (self.appID && [strUrl containsString:self.appID]) {
            return [WXApi handleOpenUniversalLink:userActivity delegate:self];
        }
    }
    return NO;
}

@end
