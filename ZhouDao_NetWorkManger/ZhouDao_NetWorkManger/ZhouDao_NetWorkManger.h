//
//  ZhouDao_NetWorkManger.h
//  ZhouDao_NetWorkManger
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define ZDAppLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define ZDAppLog(s, ... )
#endif

/*!
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 */
typedef void (^ZDDownloadProgress)(int64_t bytesRead,
int64_t totalBytesRead);

typedef ZDDownloadProgress ZDGetProgress;
typedef ZDDownloadProgress ZDPostProgress;

/*!
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^ZDUploadProgress)(int64_t bytesWritten,
int64_t totalBytesWritten);

typedef NS_ENUM(NSUInteger, ZDResponseType) {
    kZDResponseTypeJSON = 1, // 默认
    kZDResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    kZDResponseTypeData = 3
};

typedef NS_ENUM(NSUInteger, ZDRequestType) {
    kZDRequestTypeJSON = 1, // 默认
    kZDRequestTypePlainText  = 2 // 普通text/html
};

typedef NS_ENUM(NSInteger, ZDNetworkStatus) {
    kZDNetworkStatusUnknown          = -1,//未知网络
    kZDNetworkStatusNotReachable     = 0,//网络无连接
    kZDNetworkStatusReachableViaWWAN = 1,//2，3，4G网络
    kZDNetworkStatusReachableViaWiFi = 2,//WIFI网络
};

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask ZDURLSessionTask;
typedef void(^ZDResponseSuccess)(id response);
typedef void(^ZDResponseFail)(NSError *error);

@interface ZhouDao_NetWorkManger : NSObject

/**
 *	设置请求超时时间，默认为60秒
 *
 *	@param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;


/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *	默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要指定上限。当指定上限>0M时，
 *  若缓存达到了上限值，则每次启动应用则尝试自动去清理缓存。
 *
 *	@param mSize				缓存上限大小，单位为M（兆），默认为0，表示不清理
 */
+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize;

/*
 * 清除缓存
 */
+ (void)clearCaches;

/*!
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSON，
 *  @param shouldAutoEncode YES or NO,默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(ZDRequestType)requestType
             responseType:(ZDResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;

/**
 *	取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的ZDURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/*!
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url      接口路径，如/path/getArticleList
 *  //@param sg_cache 是否需要缓存
 *  @param params   接口中所需要的拼接参数，如@{"categoryid" : @(12)}
 *  @param success  接口成功请求到数据的回调
 *  @param fail     接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
// 多一个params参数
+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                      sg_cache:(BOOL)sg_cache
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail;

+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                      sg_cache:(BOOL)sg_cache
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail;
// 多一个带进度回调
+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                      sg_cache:(BOOL)sg_cache
                           params:(NSDictionary *)params
                         progress:(ZDGetProgress)progress
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail;


/*!
 *  @param url     接口路径，完整的url
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param fail    接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (ZDURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(ZDResponseSuccess)success
                              fail:(ZDResponseFail)fail;

+ (ZDURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(ZDPostProgress)progress
                           success:(ZDResponseSuccess)success
                              fail:(ZDResponseFail)fail;

/**
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image			图片对象
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *	@param success		上传成功回调
 *	@param fail				上传失败回调
 *
 *	@returnd
 */
+ (ZDURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(ZDUploadProgress)progress
                               success:(ZDResponseSuccess)success
                                  fail:(ZDResponseFail)fail;

/**
 *	上传文件操作
 *
 *	@param url						上传路径
 *	@param uploadingFile	待上传文件的路径
 *	@param progress			上传进度
 *	@param success				上传成功回调
 *	@param fail					上传失败回调
 *
 *	@returnd
 */
+ (ZDURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(ZDUploadProgress)progress
                                 success:(ZDResponseSuccess)success
                                    fail:(ZDResponseFail)fail;


/*!
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (ZDURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(ZDDownloadProgress)progressBlock
                               success:(ZDResponseSuccess)success
                               failure:(ZDResponseFail)failure;


@end
