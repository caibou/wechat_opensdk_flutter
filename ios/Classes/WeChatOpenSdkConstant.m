//
//  WeChatOpenSdkConstant.m
//  qq_opensdk_flutter
//
//  Created by kyros He on 2023/12/6.
//

#import "WeChatOpenSdkConstant.h"

@implementation WeChatOpenSdkConstant

+ (NSString*) NSStringFromWeChatRetCode:(WeChatRetCode) code {
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

@end
