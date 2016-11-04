//
//  NetWorkMangerTools.h
//  ZhouDao
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheContractData.h"
#import "TemplateData.h"

@interface NetWorkMangerTools : NSObject

/*
 *获取用户擅长领域
 */
+ (void)getUserDomainRequestSuccess:(void(^)(CGFloat height,NSMutableArray*arr))success;
/*
 *获取用户认证信息
 */
+ (void)getApplyInfoRequestSuccess:(void(^)())success;
/*
 *修改用户职业
 */
+ (void)resetUserJobInfo:(NSString *)type
          RequestSuccess:(void(^)())success;
/*
 *更改通讯地址
 */
+ (void)resetUserAddress:(NSString *)address
          RequestSuccess:(void(^)())success;
/*
 *获取上传图片的token
 */
+ (void)getQiNiuToken:(BOOL)isPrivate
          RequestSuccess:(void(^)())success;
/*
 *上传用户头像
 */
+ (void)uploadUserHeadImg:(UIImage *)image
          RequestSuccess:(void(^)())success
                     fail:(void (^)())fail;

/*
 *意见反馈
 */
+ (void)feedBackWithImage:(UIImage *)image
                withPhone:(NSString *)phone
              withContent:(NSString *)contentStr
           RequestSuccess:(void(^)())success;
/*
 *添加认证
 */
+ (void)uploadCertificateImage:(UIImage *)image
                RequestSuccess:(void(^)())success;
/*
 *验证手机号是否注册
 */
+ (void)validationPhoneNumber:(NSString *)phone
               RequestSuccess:(void(^)())success
                         fail:(void (^)(NSString *msg))fail;

/*
 *更改手机号
 */
+ (void)resetPhoneNumber:(NSString *)phone
          RequestSuccess:(void (^)())success;
/*
 *添加日程
 */
+ (void)addRemindMySchedule:(NSDictionary *)dictionary
             RequestSuccess:(void (^)(NSString *idStr))success;
/*
 *编辑更改日程
 */
+ (void)editRemindMySchedule:(NSDictionary *)dictionary
              RequestSuccess:(void (^)())success;

/*
 *删除日程
 */
+ (void)deleteSelectRemind:(NSString *)idString
            RequestSuccess:(void (^)())success;

/*
 * 赔偿标准首页列表
 */
+ (void)getcompensationList:(NSString *)comId
                   withCity:(NSString *)city
                   withYear:(NSString *)year
             RequestSuccess:(void (^)(NSArray *arrays))success
                       fail:(void (^)())fail;
/*
 * 赔偿标准详情
 */
+ (void)getcompensationDetailswith:(NSString *)idstring
                    RequestSuccess:(void (^)(id obj))success;
/*
 * 合同一级分类列表
 */
+ (void)theContractFirstListRequestSuccess:(void (^)(NSArray *arrays, NSArray *nameArr,NSArray *idArrays))success
                                      fail:(void (^)())fail;
/*
 * 合同分类
 */
+ (void)theContractClassList:(TheContractData *)model
                   withCount:(NSMutableArray *)cidArrays
                    WithName:(NSMutableArray *)nameArr
              RequestSuccess:(void (^)(NSMutableArray *classArr,NSUInteger classCount,NSString *scid))success;
/*
 * 合同列表
 */
+ (void)theContractListView:(NSString *)cid
                   withscid:(NSString *)scid
                   withPage:(NSUInteger)page
                   withOrid:(NSString *)orid
             RequestSuccess:(void (^)(NSArray *arrays))success
                       fail:(void (^)())fail;
/*
 * 合同模版详情
 */
+ (void)theContractContent:(NSString *)temolateId
            RequestSuccess:(void (^)(TemplateData *model))success
                      fail:(void (^)())fail;
/*
 * 添加收藏
 */
+ (void)collectionAddMine:(NSDictionary *)dict
           RequestSuccess:(void (^)())success;
/*
 * 删除收藏
 */
+ (void)collectionDelMine:(NSString *)idString
                 withType:(NSString *)type
           RequestSuccess:(void (^)())success;
/*
 * 收藏置顶
 */
+ (void)collectionTopMine:(NSString *)idString
           RequestSuccess:(void (^)())success;
/*
 * 收藏取消置顶
 */
+ (void)collectionTopDelMine:(NSString *)idString
              RequestSuccess:(void (^)())success;
/*
 * 收藏列表
 */
+ (void)collectionListMine:(NSString *)type
                  withPage:(NSUInteger)page
            RequestSuccess:(void (^)(NSArray *zdArr,NSArray *comArr))success
                      fail:(void (^)())fail;
/*
 * 司法机关一级分类
 */
+ (void)goverMentFirstClassListRequestSuccess:(void (^)(NSArray *arr))success
                                         fail:(void (^)())fail;
/*
 * 司法机关全部分类
 */
+ (void)goverAllClasslistwithName:(NSString *)name
                   RequestSuccess:(void (^)(NSArray *arr,NSInteger index))success;
/*
 * 司法机关列表
 */
+ (void)goverListViewWithPid:(NSString *)pid
                     withCid:(NSString *)cid
                    withPage:(NSUInteger)page
                    withProv:(NSString *)prov
                    withCity:(NSString *)city
                    withareas:(NSString *)areas
              RequestSuccess:(void (^)(NSArray *arr))success
                        fail:(void (^)())fail;
/*
 * 司法机关详情
 */
+ (void)goverDetailWithId:(NSString *)idStr
           RequestSuccess:(void (^)(id obj))success;
/*
 * 推荐最新法规列表
 */
+ (void)lawsNewsListRequestSuccess:(void (^)(NSArray *arr))success
                              fail:(void (^)())fail;
/*
 * 新法速递
 */
+ (void)lawsNewsListWithUrl:(NSString *)url
                   withPage:(NSUInteger)page
                    witheff:(NSString *)eff
                   withTime:(NSString *)time
             RequestSuccess:(void (^)(NSArray *arr))success
                       fail:(void (^)())fail;
/*
 * 法规详情
 */
+ (void)lawsDetailData:(NSString *)idString
        RequestSuccess:(void (^)(id obj))success;
/**
 *  相关法规
 */
+ (void)aboutLawsReading:(NSString *)idStr
          RequestSuccess:(void (^)(NSArray *arr))success
                    fail:(void (^)())fail;
/*
 *法律法规搜索
 */
+ (void)LawsSearchResultKeyWords:(NSString *)keyStr
                        withPage:(NSUInteger)page
                  RequestSuccess:(void (^)(NSArray *arr))success
                            fail:(void (^)())fail;
/*
 *案例分类
 */
+ (void)loadCutInspectionRequestSuccess:(void (^)(NSArray *arr))success
                                   fail:(void (^)())fail;
/*
 *案例搜索结果
 */
+ (void)LegalIssuesSelfCheckResult:(NSString *)text
                          withPage:(NSUInteger)page
                    RequestSuccess:(void (^)(NSArray *arr))success
                              fail:(void (^)())fail;
/*
 *按类型查询案例
 */
+ (void)inspeTypeList:(NSString *)idString
             withPage:(NSUInteger)page
       RequestSuccess:(void (^)(NSArray *arr))success
                 fail:(void (^)())fail;
/*
 *案例详情
 */
+ (void)loadExampleDetailData:(NSString* )idString
               RequestSuccess:(void (^)(id obj))success;
/*
 * 添加案件
 */
+ (void)arrangeAddManagement:(NSDictionary *)dict
                     withUrl:(NSString *)url
              RequestSuccess:(void (^)())success;
/**
 * 案件列表
 */
+ (void)arrangeListWithPage:(NSUInteger)page
             RequestSuccess:(void (^)(NSArray *arr))success
                       fail:(void (^)())fail;
/**
 * 案件搜索  案件筛选
 */
+ (void)arrangeSearchUrl:(NSString *)url
          RequestSuccess:(void (^)(NSArray *arr))success
                    fail:(void (^)())fail;
/**
 * 案件详情
 */
+ (void)arrangeInfoWithIdString:(NSString* )idString
                 RequestSuccess:(void (^)(NSDictionary *dict))success;
/**
 *  热词搜索
 */
+ (void)lawsHotsSearchRequestSuccess:(void (^)(NSArray *arr))success
                                fail:(void (^)())fail;
/**
 *  推荐页 新法速递
 */
+ (void)recomViewNewLawsRequestSuccess:(void (^)(NSArray *arr))success;
/**
 *推荐页全部
 */
+ (void)recomViewAllRequestSuccess:(void (^)(NSArray *hdArr,NSArray *xfArr,NSArray *jdArr,NSArray *hotArr))success
                              fail:(void (^)())fail;
/**
 * 首页全部
 */
+ (void)homeViewAllDataRequestSuccess:(void (^)(NSArray *hdArr,NSArray *hotArr))success
                                 fail:(void (^)())fail;
/**
 *  案件管理 创建文件夹 及文件
 */
+ (void)arrangeFileAddwithPid:(NSString *)pid
                     withName:(NSString *)name
                 withFileType:(NSString *)fileType
                  withtformat:(NSString *)format
                withqiniuName:(NSString *)qnName
                      withCid:(NSString *)cid
               RequestSuccess:(void (^)(id obj))success;
/**
 *  案件管理 案件目录
 */
+ (void)arrangeFileListWithType:(NSString *)caseId
                        withCid:(NSString *)cid
                 RequestSuccess:(void (^)(NSArray *arr))success;
/**
 * 案件目录 文件删除
 */
+ (void)arrangeFileDelWithid:(NSString *)idStr
                  withCaseId:(NSString *)caseId
              RequestSuccess:(void (^)())success;
/**
 * 案件目录重命名
 */
+ (void)arrangeFileRenameWithid:(NSString *)idStr
                     withCaseId:(NSString *)caseId
                       withName:(NSString *)name
                 RequestSuccess:(void (^)())success;
/**
 * 案件查看详情
 */
+ (void)arrangeFileInfoWithid:(NSString *)idStr
                   withCaseId:(NSString *)caseId
               RequestSuccess:(void (^)(NSString *htmlString))success;
/**
 * 案件上传图片 文本
 */
+ (void)uploadarrangeFile:(NSData *)fileData
           withFormatType:(NSString *)formatType
           RequestSuccess:(void(^)(NSString *key))success
                     fail:(void (^)())fail;
/**
 * 下载格式
 */
+ (NSString *)getFileFormat:(NSString *)idString;
/**
 * 沙盒文件是否
 */
+ (NSString *)whetheFileExists:(NSString *)caseId;
//文件夹是否已经存在
+ (void)creatFilePathEvent:(NSString *)filePath;
/**
 * 首页更多
 */
+ (void)loadMoreDataHomePage:(NSString *)url
              RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail;
/**
 * 合同下载
 */
+ (void)downLoadTheContract:(NSString *)url
             RequestSuccess:(void (^)(NSString *htmlString))success;
/**
 * 版本更新
 */
+ (void)checkHistoryVersionRequestSuccess:(void (^)(NSString *desc))success;
/**
 * 查看全部日程
 */
+ (void)lookAllScheduleRequestSuccess:(void (^)(NSArray *arr))success;

/**
 *  查看案件财务列表
 */
+ (void)financialListToCheckTheCaseWithCaseID:(NSString *)caseId RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail;
/**
 *  案件整理 财务管理删除
 *
 */
+ (void)arrangeFinanceDelWithUrl:(NSString *)url RequestSuccess:(void (^)())success;

/**
 *  案件整理 提醒列表
 *
 */
+ (void)arrangeRemindListWithUrl:(NSString *)url RequestSuccess:(void (^)(NSArray *arrays))success;
/**
 *  焦点历史记录
 *
 */
+ (void)FocusOnTheHistoryWithUrl:(NSString *)url RequestSuccess:(void (^)(NSArray *arrays))success fail:(void (^)())fail;

/**
 *  85 第三方授权后判断是否已经绑定手机号
 */
+ (void)LoginWithThirdPlatformwithPlatform:(NSString *)platform
                                  withUsid:(NSString *)usid
                             withURLString:(NSString *)urlString
                             RequestSuccess:(void (^)(NSString *state, id obj))success;

+ (void)whetherAccountBindingOnImmediatelyWithURLString:(NSString *)urlString
                                         RequestSuccess:(void (^)())success;
/**
 *  87 解绑账号
 */
+ (void)UnboundAccountwithURLString:(NSString *)urlString
                     RequestSuccess:(void (^)())success
                               fail:(void (^)())fail;

/**
 *  88 绑定账号
 */
+ (void)auBindingwithPlatform:(NSString *)platform
                     withUsid:(NSString *)usid
                withURLString:(NSString *)urlString
            RequestSuccess:(void (^)())success
                      fail:(void (^)())fail;
/**
 *  88 单纯绑定账号 不登录
 */

+ (void)pureAuBindingURLString:(NSString *)urlString
                RequestSuccess:(void (^)())success
                          fail:(void (^)())fail;

/**
 89 分享计算结果

 @param urlString urlString
 @param success   成功回调
 @param fail      失败回调
 */
+ (void)shareTheResultsWithDictionary:(NSDictionary *)dictionary
                       RequestSuccess:(void (^)(NSString *urlString,NSString *idString))success
                                 fail:(void (^)())fail;

/*
 * 自动登录
 */
+ (void)isAutoLogin;
/**
 *  判断铃声
 */
+ (NSString *)getSoundName:(NSString *)bell;


@end
