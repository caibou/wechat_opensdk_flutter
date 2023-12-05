// Autogenerated from Pigeon (v11.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class WxSceneType(val raw: Int) {
  FRIEND(0),
  TIMELINE(1);

  companion object {
    fun ofRaw(raw: Int): WxSceneType? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class WxShareBaseModel (
  val title: String,
  val content: String,
  val scene: WxSceneType,
  val thumbImageUrl: String

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): WxShareBaseModel {
      val title = list[0] as String
      val content = list[1] as String
      val scene = WxSceneType.ofRaw(list[2] as Int)!!
      val thumbImageUrl = list[3] as String
      return WxShareBaseModel(title, content, scene, thumbImageUrl)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      title,
      content,
      scene.raw,
      thumbImageUrl,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class WxSdkOnResp (
  val errCode: Long,
  val type: Long,
  val country: String? = null,
  val lang: String? = null,
  val errorDescription: String? = null

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): WxSdkOnResp {
      val errCode = list[0].let { if (it is Int) it.toLong() else it as Long }
      val type = list[1].let { if (it is Int) it.toLong() else it as Long }
      val country = list[2] as String?
      val lang = list[3] as String?
      val errorDescription = list[4] as String?
      return WxSdkOnResp(errCode, type, country, lang, errorDescription)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      errCode,
      type,
      country,
      lang,
      errorDescription,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class WxShareWebPage (
  val pageUrl: String,
  val base: WxShareBaseModel

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): WxShareWebPage {
      val pageUrl = list[0] as String
      val base = WxShareBaseModel.fromList(list[1] as List<Any?>)
      return WxShareWebPage(pageUrl, base)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      pageUrl,
      base.toList(),
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class WxShareImage (
  val imageData: ByteArray? = null,
  val base: WxShareBaseModel

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): WxShareImage {
      val imageData = list[0] as ByteArray?
      val base = WxShareBaseModel.fromList(list[1] as List<Any?>)
      return WxShareImage(imageData, base)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      imageData,
      base.toList(),
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object WeChatOpenSdkApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          WxShareBaseModel.fromList(it)
        }
      }
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          WxShareImage.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          WxShareWebPage.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is WxShareBaseModel -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      is WxShareImage -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is WxShareWebPage -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface WeChatOpenSdkApi {
  fun registerApp(appId: String, urlSchema: String, universalLink: String, callback: (Result<Boolean>) -> Unit)
  fun isWxInstalled(callback: (Result<Boolean>) -> Unit)
  fun shareWebPage(req: WxShareWebPage, callback: (Result<Boolean>) -> Unit)
  fun shareImage(req: WxShareImage, callback: (Result<Boolean>) -> Unit)
  fun weChatAuth(callback: (Result<String>) -> Unit)

  companion object {
    /** The codec used by WeChatOpenSdkApi. */
    val codec: MessageCodec<Any?> by lazy {
      WeChatOpenSdkApiCodec
    }
    /** Sets up an instance of `WeChatOpenSdkApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: WeChatOpenSdkApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.registerApp", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val appIdArg = args[0] as String
            val urlSchemaArg = args[1] as String
            val universalLinkArg = args[2] as String
            api.registerApp(appIdArg, urlSchemaArg, universalLinkArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.isWxInstalled", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.isWxInstalled() { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.shareWebPage", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val reqArg = args[0] as WxShareWebPage
            api.shareWebPage(reqArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.shareImage", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val reqArg = args[0] as WxShareImage
            api.shareImage(reqArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WeChatOpenSdkApi.weChatAuth", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.weChatAuth() { result: Result<String> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
@Suppress("UNCHECKED_CAST")
private object WxSdkOnRespApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          WxSdkOnResp.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is WxSdkOnResp -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class WxSdkOnRespApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by WxSdkOnRespApi. */
    val codec: MessageCodec<Any?> by lazy {
      WxSdkOnRespApiCodec
    }
  }
  fun onResp(respArg: WxSdkOnResp, callback: () -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.wechat_opensdk_flutter.WxSdkOnRespApi.onResp", codec)
    channel.send(listOf(respArg)) {
      callback()
    }
  }
}
