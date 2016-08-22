//
//  ZhouDao_NetWorkManger.m
//  ZhouDao
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "ZhouDao_NetWorkManger.h"
#import "AFNetworking.h"

@implementation ZhouDao_NetWorkManger

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
        // DLog(@"%d", status);
     }];
}
#pragma mark GET请求
+ (void)GetJSONWithUrl:(NSString *)url success:(void (^)(NSDictionary *jsonDic))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    //增加请求头代码
   // [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"app"];
    
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此不用管在主线程更新UI的事情
    
//    self.removesKeysWithNullValues = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
         [SVProgressHUD dismiss];
    });
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            NSData *data = operation.responseData;
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            DLog(@"success[GET]请求地址[%@]",url);
            DLog(@"success[GET]请求返回数据\n %@",result);
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            DLog(@"%@", dict);
            success(dict);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        DLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
    
//    [manager.operationQueue cancelAllOperations];
}

#pragma mark POST请求
+ (void)PostJSONWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *jsonDic))success fail:(void (^)())fail
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //增加请求头代码
//    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"app"];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //增加请求头代码
    // 设置请求格式
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [manager.requestSerializer setValue:APPTOKENSTR forHTTPHeaderField:@"token"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD dismiss];
    });

    [manager POST:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"success[POST]请求参数[%@]\n %@",urlStr,parameters);
         DLog(@"success[POST]请求返回数据\n %@",result);
         
         if (success)
         {
             NSData *data = operation.responseData;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             success(dict);
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DLog(@"error[POST]请求参数[%@]\n %@",urlStr,parameters);
         DLog(@"error[POST]请求返回数据 %@",error);
         
         if (fail)
         {
             fail(error);
         }
     }];
    
}

#pragma mark 上传多张图片数组
+ (void)postUploadWithUrl:(NSString *)urlStr
               parameters:(NSDictionary *)parameters
               WithImgDic:(NSDictionary *)allImgDic
                  success:(void (^)(NSDictionary * jsonDic))success
                     fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         //上传图片数组 多张图片
         for (NSString *key in [allImgDic allKeys])
         {
             UIImage *image = [allImgDic objectForKey:key];
             NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
             // 上传的 ，FileData二进制数据 ，参数名 name ， 文件名fileName，图片类型mimeType
             //[formData appendPartWithFormData:nil name:nil];
             [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg/png/jpg"];
         }
         
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSData *data = operation.responseData;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         success(dict);
         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         DLog(@"完成 %@", result);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         fail(error);
         DLog(@"错误 %@", error.localizedDescription);
     }];
}

#pragma mark上传单张图片
+(void)postOneImgUrlString:(NSString *)url
                    msgDic:(NSDictionary *)msgDic
                     image:(UIImage *)image
                   success:(void (^)(NSDictionary *))success
                      fail:(void (^)())fail
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //增加请求头代码
//    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"app"];
    
    DLog(@"参数是－－－－－%@",msgDic);
    
    [manager POST:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
       parameters:msgDic
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    
    // 上传图片，以文件流的格式
    [formData appendPartWithFileData:imageData
                                name:@"file"
                            fileName:fileName
                            mimeType:@"image/jpeg/png/jpg"];
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *result = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
    DLog(@"[POST]请求地址[%@]\n %@",url,result);
    NSData *data = operation.responseData;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    success(dict);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    fail(error);
}];
    
}

@end
