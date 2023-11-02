// Autogenerated from Pigeon (v11.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum WxSceneType {
  friend,
  timeLine,
}

class WxShareBaseModel {
  WxShareBaseModel({
    required this.title,
    required this.content,
    required this.scene,
    required this.thumbImageUrl,
  });

  String title;

  String content;

  WxSceneType scene;

  String thumbImageUrl;

  Object encode() {
    return <Object?>[
      title,
      content,
      scene.index,
      thumbImageUrl,
    ];
  }

  static WxShareBaseModel decode(Object result) {
    result as List<Object?>;
    return WxShareBaseModel(
      title: result[0]! as String,
      content: result[1]! as String,
      scene: WxSceneType.values[result[2]! as int],
      thumbImageUrl: result[3]! as String,
    );
  }
}

class WxSdkOnResp {
  WxSdkOnResp({
    required this.errCode,
    required this.type,
    this.country,
    this.description,
    this.lang,
    this.errorDescription,
  });

  int errCode;

  int type;

  String? country;

  String? description;

  String? lang;

  String? errorDescription;

  Object encode() {
    return <Object?>[
      errCode,
      type,
      country,
      description,
      lang,
      errorDescription,
    ];
  }

  static WxSdkOnResp decode(Object result) {
    result as List<Object?>;
    return WxSdkOnResp(
      errCode: result[0]! as int,
      type: result[1]! as int,
      country: result[2] as String?,
      description: result[3] as String?,
      lang: result[4] as String?,
      errorDescription: result[5] as String?,
    );
  }
}

class WxShareWebPage {
  WxShareWebPage({
    required this.pageUrl,
    required this.base,
  });

  String pageUrl;

  WxShareBaseModel base;

  Object encode() {
    return <Object?>[
      pageUrl,
      base.encode(),
    ];
  }

  static WxShareWebPage decode(Object result) {
    result as List<Object?>;
    return WxShareWebPage(
      pageUrl: result[0]! as String,
      base: WxShareBaseModel.decode(result[1]! as List<Object?>),
    );
  }
}

class WxShareImage {
  WxShareImage({
    this.imageData,
    required this.base,
  });

  Uint8List? imageData;

  WxShareBaseModel base;

  Object encode() {
    return <Object?>[
      imageData,
      base.encode(),
    ];
  }

  static WxShareImage decode(Object result) {
    result as List<Object?>;
    return WxShareImage(
      imageData: result[0] as Uint8List?,
      base: WxShareBaseModel.decode(result[1]! as List<Object?>),
    );
  }
}

class _WeChatOpenSdkApiCodec extends StandardMessageCodec {
  const _WeChatOpenSdkApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is WxShareBaseModel) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is WxShareImage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is WxShareWebPage) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return WxShareBaseModel.decode(readValue(buffer)!);
      case 129: 
        return WxShareImage.decode(readValue(buffer)!);
      case 130: 
        return WxShareWebPage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class WeChatOpenSdkApi {
  /// Constructor for [WeChatOpenSdkApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  WeChatOpenSdkApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _WeChatOpenSdkApiCodec();

  Future<bool> registerApp(String arg_appId, String arg_urlSchema, String arg_universalLink) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.registerApp', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_appId, arg_urlSchema, arg_universalLink]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> isWxInstalled() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.isWxInstalled', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(null) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> shareWebPage(WxShareWebPage arg_req) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.shareWebPage', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_req]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }

  Future<bool> shareImage(WxShareImage arg_req) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.shareImage', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_req]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as bool?)!;
    }
  }
}

class _WxSdkOnRespApiCodec extends StandardMessageCodec {
  const _WxSdkOnRespApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is WxSdkOnResp) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return WxSdkOnResp.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class WxSdkOnRespApi {
  static const MessageCodec<Object?> codec = _WxSdkOnRespApiCodec();

  void onResp(WxSdkOnResp resp);

  static void setup(WxSdkOnRespApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.wechat_opensdk_flutter.WxSdkOnRespApi.onResp', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.wechat_opensdk_flutter.WxSdkOnRespApi.onResp was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final WxSdkOnResp? arg_resp = (args[0] as WxSdkOnResp?);
          assert(arg_resp != null,
              'Argument for dev.flutter.pigeon.wechat_opensdk_flutter.WxSdkOnRespApi.onResp was null, expected non-null WxSdkOnResp.');
          api.onResp(arg_resp!);
          return;
        });
      }
    }
  }
}
