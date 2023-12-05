//
//  WecChatOpenSdkConstant.h
//  Pods
//
//  Created by kyros He on 2023/12/5.
//

#ifndef WecChatOpenSdkConstant_h
#define WecChatOpenSdkConstant_h

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

NSString * NSStringFromWeChatRetCode(WeChatRetCode code) {
    switch (code) {
        case RET_SUCCESS:
            return @"RET_SUCCESS";
        case RET_USERCANCEL:
            return @"RET_USERCANCEL";
        case RET_COMMON:
            return @"RET_COMMON";
        case RET_SENTFAIL:
            return @"RET_SENTFAIL";
        case RET_UNSUPPORT:
            return @"RET_UNSUPPORT";
        case RET_AUTHDENY:
            return @"RET_AUTHDENY";
        default:
            return @"Unknown Code";
    }
}

#endif /* WecChatOpenSdkConstant_h */
