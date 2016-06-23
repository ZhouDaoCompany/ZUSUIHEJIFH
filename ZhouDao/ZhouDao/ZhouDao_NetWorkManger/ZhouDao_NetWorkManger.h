//
//  ZhouDao_NetWorkManger.h
//  ZhouDao
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhouDao_NetWorkManger : NSObject

/**检测网路状态**/
+ (void)netWorkStatus;

/*!
 *  GET请求        不缓存数据
 *
 *  @param url     url
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)GetJSONWithUrl:(NSString *)url
               success:(void (^)(NSDictionary *jsonDic))success
                  fail:(void (^)())fail;

/*!
 *  POST请求          不缓存数据
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param fail       失败的回调
 */
+ (void)PostJSONWithUrl:(NSString *)urlStr
             parameters:(NSDictionary *)parameters
                success:(void (^)(NSDictionary *jsonDic))success
                   fail:(void (^)())fail;

/*!
 *  POST请求              上传多张图片
 *
 *  @param urlStr         url
 *  @param parameters     post参数
 *  @param allImageArrays 装图片的数组
 *  @param success        成功的回调
 *  @param fail           失败的回调
 */
+ (void)postUploadWithUrl:(NSString *)urlStr
               parameters:(NSDictionary *)parameters
               WithImgDic:(NSDictionary *)allImgDic
                  success:(void (^)(NSDictionary * jsonDic))success
                     fail:(void (^)())fail;
/*!
 *  POST请求       上传单张图片
 *
 *  @param url     url
 *  @param msgDic  post参数
 *  @param image   图片
 *  @param success 成功的回调
 *  @param fail    失败的回调
 */
+ (void)postOneImgUrlString:(NSString *)url
                     msgDic:(NSDictionary *)msgDic
                      image:(UIImage *)image
                    success:(void (^)(NSDictionary *))success
                       fail:(void (^)())fail;
@end
