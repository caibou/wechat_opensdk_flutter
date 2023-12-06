//
//  WeChatOpenSdkConstant.h
//  qq_opensdk_flutter
//
//  Created by kyros He on 2023/12/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//enum  WXErrCode {
//    WXSuccess           = 0,    /**< 成功    */
//    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//    WXErrCodeSentFail   = -3,   /**< 发送失败    */
//    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
//};
typedef NS_ENUM(NSInteger, WeChatRetCode) {
    RET_SUCCESS    = 0,
    RET_COMMON     = -1,
    RET_USERCANCEL = -2,
    RET_SENTFAIL   = -3,
    RET_AUTHDENY   = -4,
    RET_UNSUPPORT  = -5,
};


@interface WeChatOpenSdkConstant : NSObject

+ (NSString*)NSStringFromWeChatRetCode:(WeChatRetCode)code;

@end

NS_ASSUME_NONNULL_END
