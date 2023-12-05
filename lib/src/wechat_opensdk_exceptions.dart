import 'package:flutter/services.dart';

abstract class SignInWithWeChatException implements Exception {
  factory SignInWithWeChatException.fromPlatformException(
    PlatformException exception,
  ) {
    switch (exception.code) {
      case 'RET_AUTHDENY':
        return SignInWithWeChatAuthorizationException(
            code: WeChatAuthorizationErrorCode.authDeny,
            message: exception.message ?? 'no message provided');
      case 'RET_USERCANCEL':
        return SignInWithWeChatAuthorizationException(
            code: WeChatAuthorizationErrorCode.userCancel,
            message: exception.message ?? 'no message provided');
      case 'RET_FAILED':
        return SignInWithWeChatAuthorizationException(
            code: WeChatAuthorizationErrorCode.failed,
            message: exception.message ?? 'no message provided');
      case 'RET_COMMON':
        return SignInWithWeChatAuthorizationException(
            code: WeChatAuthorizationErrorCode.common,
            message: exception.message ?? 'no message provided');
      default:
        return UnknownSignInWithWeChatException(platformException: exception);
    }
  }
}

class SignInWithWeChatAuthorizationException
    implements SignInWithWeChatException {
  const SignInWithWeChatAuthorizationException({
    required this.code,
    required this.message,
  });

  /// A more exact code of what actually went wrong
  final WeChatAuthorizationErrorCode code;

  /// A localized message of the error
  final String message;

  @override
  String toString() => 'SignInWithWeChatAuthorizationError($code, $message)';
}

class UnknownSignInWithWeChatException extends PlatformException
    implements SignInWithWeChatException {
  UnknownSignInWithWeChatException({
    required PlatformException platformException,
  }) : super(
          code: platformException.code,
          message: platformException.message,
          details: platformException.details,
        );

  @override
  String toString() =>
      'UnknownSignInWithWeChatException($code, $message, $details)';
}

// 对应sdk中的error code, 登录页点取消算做授权失败
//enum  WXErrCode {
//    WXSuccess           = 0,    /**< 成功    */
//    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//    WXErrCodeSentFail   = -3,   /**< 发送失败    */
//    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
//};
enum WeChatAuthorizationErrorCode {
  success,
  userCancel,
  Unsupport,
  authDeny,
  failed,
  common,
  unknown,
}
