//
//  WeChatOpenSdkApiImpl.m
//  qq_opensdk_flutter
//
//  Created by PC on 2023/11/1.
//

#import <WechatOpenSDK/WXApi.h>
#import "WeChatOpenSdkApiImpl.h"
#import <WechatOpenSDK/WechatAuthSDK.h>
#import <SDWebImage/SDWebImageDownloader.h>


@interface WeChatOpenSdkApiImpl()<WXApiDelegate>

@property (nonatomic, strong) WxSdkOnRespApi *onRespApi;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *urlSchema;

@end

@implementation WeChatOpenSdkApiImpl

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

       BOOL ret = [WXApi registerApp:appId universalLink:universalLink];
        if (completion) {
            completion([NSNumber numberWithBool:ret],nil);
        }
        
        [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
            if (log) {
                NSLog(@"WeChatSDK: %@", log);
            }
        }];
        
        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
            NSLog(@"checkUniversalLinkReady: %@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
        }];
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

#pragma mark -WXApiDelegate
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseReq *)resp {
    if (!self.onRespApi) return;
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *wxResp = ((SendMessageToWXResp *)resp);
        
        WxSdkOnResp *onResp = [WxSdkOnResp makeWithErrCode:@(wxResp.errCode)
                                                      type:@(wxResp.type)
                                                   country:wxResp.country == nil ? @"" : wxResp.country
                                                      lang:wxResp.lang == nil ? @"" : wxResp.lang
                                          errorDescription:wxResp.errStr == nil ? @"" : wxResp.errStr];
        
        [self.onRespApi onRespResp:onResp completion:^(FlutterError * _Nullable err) {}];
    }
}

#pragma mark -FlutterApplicationLifeCycleDelegate
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    if (self.urlSchema && [[url scheme] isEqualToString: self.urlSchema]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
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
    return YES;
}

@end
