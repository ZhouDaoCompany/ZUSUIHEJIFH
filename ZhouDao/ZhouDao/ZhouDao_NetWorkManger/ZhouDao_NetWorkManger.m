//
//  ZhouDao_NetWorkManger.m
//  ZhouDao_NetWorkManger
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZhouDao_NetWorkManger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#import "NSString+MHCommon.h"

static BOOL sg_shouldAutoEncode = NO;
static NSDictionary *sg_httpHeaders = nil;
static ZDResponseType sg_responseType = kZDResponseTypeJSON;
static ZDRequestType  sg_requestType  = kZDRequestTypePlainText;
static ZDNetworkStatus sg_networkStatus = kZDNetworkStatusReachableViaWiFi;
static NSMutableArray *sg_requestTasks;
static BOOL sg_shouldCallbackOnCancelRequest = YES;
static NSTimeInterval sg_timeout = 60.0f;
static BOOL sg_shoulObtainLocalWhenUnconnected = NO;
static AFHTTPSessionManager *sg_sharedManager = nil;
static NSUInteger sg_maxCacheSize = 0;

@implementation ZhouDao_NetWorkManger

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 尝试清除缓存
        if (sg_maxCacheSize > 0 && [self totalCacheSize] > 1024 * 1024 * sg_maxCacheSize) {
            [self clearCaches];
        }
    });
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    sg_timeout = timeout;
}

+ (void)autoToClearCacheWithLimitedToSize:(NSUInteger)mSize {
    sg_maxCacheSize = mSize;
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZDNetworkingCaches"];
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"ZDNetworking clear caches error: %@", error);
        } else {
            NSLog(@"ZDNetworking clear caches ok");
        }
    }
}
+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return sg_requestTasks;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ZDURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ZDURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ZDURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ZDURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (void)configRequestType:(ZDRequestType)requestType
             responseType:(ZDResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    sg_requestType = requestType;
    sg_responseType = responseType;
    sg_shouldAutoEncode = shouldAutoEncode;
    sg_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}
+ (BOOL)shouldEncode {
    return sg_shouldAutoEncode;
}

+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                      sg_cache:(BOOL)sg_cache
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail {
    
    return [self getWithUrl:url
                     params:nil
                sg_cache:sg_cache
                    success:success
                       fail:fail];

}

+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                      sg_cache:(BOOL)sg_cache
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail {
    
    return [self getWithUrl:url
                sg_cache:sg_cache
                     params:params
                   progress:nil
                    success:success
                       fail:fail];
}

+ (ZDURLSessionTask *)getWithUrl:(NSString *)url
                      sg_cache:(BOOL)sg_cache
                           params:(NSDictionary *)params
                         progress:(ZDGetProgress)progress
                          success:(ZDResponseSuccess)success
                             fail:(ZDResponseFail)fail {
    
    return [self _requestWithUrl:url
                     sg_cache:sg_cache
                       httpMedth:1 params:params
                        progress:progress
                         success:success fail:fail];
}

+ (ZDURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(ZDResponseSuccess)success
                              fail:(ZDResponseFail)fail {
    
    return [self postWithUrl:url
                      params:params
                    progress:nil
                     success:success
                        fail:fail];
}

+ (ZDURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(ZDPostProgress)progress
                           success:(ZDResponseSuccess)success
                              fail:(ZDResponseFail)fail {
    
    return [self _requestWithUrl:url
                     sg_cache:NO
                       httpMedth:2
                          params:params
                        progress:progress
                         success:success
                            fail:fail];
}


+ (ZDURLSessionTask *)_requestWithUrl:(NSString *)url
                           sg_cache:(BOOL)sg_cache
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                              progress:(ZDDownloadProgress)progress
                               success:(ZDResponseSuccess)success
                                  fail:(ZDResponseFail)fail {
    
//    if ([self shouldEncode]) {
//        url = [self encodeUrl:url];
//    }
    url = [self encodeUrl:url];

    AFHTTPSessionManager *manager = [self manager];
    NSString *absolute = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//[self absoluteUrlWithPath:url];
    
    NSURL *absoluteURL = [NSURL URLWithString:absolute];
    
    if (absoluteURL == nil) {
        DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
    });

    ZDURLSessionTask *session = nil;
    
    if (httpMethod == 1) {
        if (sg_cache) {
            if (sg_shoulObtainLocalWhenUnconnected) {
                if (sg_networkStatus == kZDNetworkStatusNotReachable ||  sg_networkStatus == kZDNetworkStatusUnknown ) {
                    id response = [ZhouDao_NetWorkManger cahceResponseWithURL:absolute
                                                           parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                        return nil;
                    }
                }
            }
            
        }

        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            
            if (sg_cache) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            
            [[self allTasks] removeObject:task];
            
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:params];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            
            if ([error code] < 0 && sg_cache) {// 获取缓存
                id response = [ZhouDao_NetWorkManger cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        [self logWithSuccessResponse:response
                                                 url:absolute
                                              params:params];
                    }
                } else {
                    [self handleCallbackWithError:error fail:fail];
                    
                    [self logWithFailError:error url:absolute params:params];
                }
            } else {
                [self handleCallbackWithError:error fail:fail];
                
                [self logWithFailError:error url:absolute params:params];
            }
        }];
    } else if (httpMethod == 2) {

        
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
            
            
            [[self allTasks] removeObject:task];
            
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:params];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            
            [self handleCallbackWithError:error fail:fail];
            
            [self logWithFailError:error url:absolute params:params];
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (ZDURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(ZDUploadProgress)progress
                                 success:(ZDResponseSuccess)success
                                    fail:(ZDResponseFail)fail {
    if ([NSURL URLWithString:uploadingFile] == nil) {
        DLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    uploadURL = [NSURL URLWithString:url];
    
    if (uploadURL == nil) {
        DLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    ZDURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            
            [self logWithFailError:error url:response.URL.absoluteString params:nil];
        } else {
            [self logWithSuccessResponse:responseObject
                                     url:response.URL.absoluteString
                                  params:nil];
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (ZDURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(ZDUploadProgress)progress
                               success:(ZDResponseSuccess)success
                                  fail:(ZDResponseFail)fail {
    if ([NSURL URLWithString:url] == nil) {
        DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = url;
    
    AFHTTPSessionManager *manager = [self manager];
    ZDURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
        [self logWithSuccessResponse:responseObject
                                 url:absolute
                              params:parameters];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        
        [self handleCallbackWithError:error fail:fail];
        
        [self logWithFailError:error url:absolute params:nil];
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}
+ (ZDURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(ZDDownloadProgress)progressBlock
                               success:(ZDResponseSuccess)success
                               failure:(ZDResponseFail)failure {
    if ([NSURL URLWithString:url] == nil) {
        DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
    
    ZDURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            
            DLog(@"Download success for url %@",url);
            
        } else {
            [self handleCallbackWithError:error fail:failure];
            
            DLog(@"Download fail for url %@, reason : %@",url,[error description]);
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private methods
+ (AFHTTPSessionManager *)manager {
    @synchronized (self) {
        // 只要不切换baseurl，就一直使用同一个session manager
        if (sg_sharedManager == nil) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            AFHTTPSessionManager *manager = nil;;
            manager = [AFHTTPSessionManager manager];
            
            switch (sg_requestType) {
                case kZDRequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case kZDRequestTypePlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (sg_responseType) {
                case kZDResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case kZDResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case kZDResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            
            for (NSString *key in sg_httpHeaders.allKeys) {
                if (sg_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = sg_timeout;
            
            // 设置允许同时最大并发数量，过大容易出问题
            manager.operationQueue.maxConcurrentOperationCount = 3;
            sg_sharedManager = manager;
        }
    }
    
    return sg_sharedManager;
}

+ (void)detectNetwork {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            sg_networkStatus = kZDNetworkStatusNotReachable;
        } else if (status == AFNetworkReachabilityStatusUnknown){
            sg_networkStatus = kZDNetworkStatusUnknown;
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            sg_networkStatus = kZDNetworkStatusReachableViaWWAN;
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            sg_networkStatus = kZDNetworkStatusReachableViaWiFi;
        }
    }];
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    DLog(@"\n");
    DLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              params,
              [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    DLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        DLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
                  [self generateGETAbsoluteURL:url params:params],
                  format,
                  params);
    } else {
        DLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
                  [self generateGETAbsoluteURL:url params:params],
                  format,
                  params,
                  [error localizedDescription]);
    }
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

+ (NSString *)encodeUrl:(NSString *)url {
    return [self ZD_URLEncode:url];
}

+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
}

+ (void)successResponse:(id)responseData callback:(ZDResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}

+ (NSString *)ZD_URLEncode:(NSString *)url {
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 采用下面的方式反而不能请求成功
    //  NSString *newString =
    //  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                                            (CFStringRef)url,
    //                                                            NULL,
    //                                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    //  if (newString) {
    //    return newString;
    //  }
    //
    //  return url;
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [absoluteURL md5];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            DLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                DLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                DLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                DLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}


+ (void)handleCallbackWithError:(NSError *)error fail:(ZDResponseFail)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (sg_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}

@end
