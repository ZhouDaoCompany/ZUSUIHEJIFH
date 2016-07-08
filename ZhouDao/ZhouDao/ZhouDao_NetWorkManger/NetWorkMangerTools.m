//
//  NetWorkMangerTools.m
//  ZhouDao
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NetWorkMangerTools.h"
//擅长领域
#import "AdvantagesModel.h"
//上传
#import "QiniuUploader.h"
//提醒
#import "RemindData.h"
//合同
#import "TemplateData.h"
#import "CompensationData.h"
#import "IndemnityData.h"
//司法机关
#import "GovClassModel.h"
#import "GovListmodel.h"
//法规
#import "LawsDataModel.h"
#import "LawDetailModel.h"
//案例
#import "ExampleData.h"
#import "CaseModel.h"
#import "ExampleDetailData.h"
//收藏
#import "CollectionData.h"
//案件
#import "ManagerData.h"
#import "BasicModel.h"
#import "DetaillistModel.h"
#import "FinanceModel.h"
#import "UMessage.h"
#import "HistoryModel.h"
@implementation NetWorkMangerTools

#pragma mark -获取用户擅长领域
+ (void)getUserDomainRequestSuccess:(void(^)(CGFloat height,NSMutableArray*arr))success
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *userUrl = [NSString  stringWithFormat:@"%@%@uid=%@",kProjectBaseUrl,DomainUser,UID];
        [ZhouDao_NetWorkManger GetJSONWithUrl:userUrl success:^(NSDictionary *jsonDic) {
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
//            NSString *msg = jsonDic[@"info"];
            if (errorcode !=1) {
//                [JKPromptView showWithImageName:nil message:msg];
                return ;
            }
            NSDictionary *dataDic = jsonDic[@"data"];
            
            NSArray *ValuesArr  = [dataDic allValues];
           __block NSMutableArray *domainArrays = [NSMutableArray array];
            
            [ValuesArr enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isEqual:[NSNull null]]) {
                        AdvantagesModel *model = [[AdvantagesModel alloc] initWithDictionary:obj];
                        [domainArrays addObject:model];
                    }
                }];
            }];
            for (NSMutableArray *arr in ValuesArr) {
                if (![arr isEqual:[NSNull null]]) {
                }
            }
            CGFloat height = 44.f;
            if (domainArrays.count  == 0) {
                height = 44.f;
            }else if (domainArrays.count >0 && domainArrays.count <5){
                height = 80.f;
            }else if (domainArrays.count >=5 && domainArrays.count <9){
                height = 125.f;
            }else{
                height = 170.f;
            }
            success(height,domainArrays);
        } fail:^{
        }];
    });
}
#pragma mark -获取用户认证信息
+ (void)getApplyInfoRequestSuccess:(void(^)())success
{
    /**
     *  0 未添加认证信息
     *  1 审核中
     *  2 认证成功
     *  3 认证失败
     */
        NSString *infoUrl = [NSString  stringWithFormat:@"%@%@uid=%@",kProjectBaseUrl,ApplyInfo,UID];
        [ZhouDao_NetWorkManger GetJSONWithUrl:infoUrl success:^(NSDictionary *jsonDic) {
            
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                if (errorcode == 1 || errorcode ==2 || errorcode ==0) {
                    [JKPromptView showWithImageName:nil message:msg];
                    return ;
                }
                success();
        } fail:^{
        }];
}
#pragma mark -修改用户职业
+ (void)resetUserJobInfo:(NSString *)type RequestSuccess:(void(^)())success
{
   /* http://zapi.zhoudao.cc/pro/api_user.php?key=16248ef5&c=uploadJob&uid=用户id&type=职业id */
    NSString *Url = [NSString  stringWithFormat:@"%@%@uid=%@&type=%@",kProjectBaseUrl,UploadJob,UID,type];
    
    [ZhouDao_NetWorkManger GetJSONWithUrl:Url success:^(NSDictionary *jsonDic) {
        
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
      [PublicFunction ShareInstance].m_user.data.type = type;
        success();

    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -更改通讯地址
+ (void)resetUserAddress:(NSString *)address RequestSuccess:(void(^)())success
{
    //http://zapi.zhoudao.cc/pro/api_user.php?key=16248ef5&c=uploadAddress&uid=用户id&address=地址-地址-地址
    NSString *Url = [NSString  stringWithFormat:@"%@%@uid=%@&address=%@",kProjectBaseUrl,UploadUserAddress,UID,address];

    [ZhouDao_NetWorkManger GetJSONWithUrl:Url success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
       [PublicFunction ShareInstance].m_user.data.address = address;
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -获取上传图片的token
+ (void)getQiNiuToken:(BOOL)isPrivate RequestSuccess:(void(^)())success
{
    [SVProgressHUD show];
    NSString *url = nil;
    if (isPrivate == YES) {
        url = [NSString stringWithFormat:@"%@%@&t=2",kProjectBaseUrl,UploadPicToken];
    }else{
        url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,UploadPicToken];
    }
    
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            [SVProgressHUD dismiss];
            return ;
        }
        [PublicFunction ShareInstance].picToken = jsonDic[@"data"];
        success();
        
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 上传用户头像
+ (void)uploadUserHeadImg:(UIImage *)image RequestSuccess:(void(^)())success
{
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(image, .5f)];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];

    [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
        [JKPromptView showWithImageName:nil message:@"上传失败"];
        [SVProgressHUD dismiss];
    }];

    [uploader setUploadAllFilesComplete:^(void){
    }];
    __block int indexCount = 0;
    [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
        DLog(@"index:%ld key:%@",(long)index,key);
        if (indexCount == 0) {
            NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&pic=%@",kProjectBaseUrl,UploadHeadPic,UID,key];
            [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                [SVProgressHUD dismiss];
                [JKPromptView showWithImageName:nil message:msg];
                if (errorcode !=1) {
                    return ;
                }
                [PublicFunction ShareInstance].m_user.data.photo = jsonDic[@"data"];
                success();
                
            } fail:^{
                [SVProgressHUD dismiss];
                [JKPromptView showWithImageName:nil message:AlrertMsg];
            }];
        }
        indexCount ++;
    }];

    [uploader startUpload];
}
 #pragma mark -意见反馈
+ (void)feedBackWithImage:(UIImage *)image withPhone:(NSString *)phone withContent:(NSString *)contentStr RequestSuccess:(void(^)())success
{
    [SVProgressHUD show];

    if (!image){
        
        if (contentStr.length== 0)
        {
            [JKPromptView showWithImageName:nil message:@"请您填写内容，或者选择图片!"];
            return;
        }
       
       NSString *url = [NSString stringWithFormat:@"%@%@mobile=%@&content=%@",kProjectBaseUrl,FeedBackAdd,phone,contentStr];
        [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            NSString *msg = jsonDic[@"info"];
            [SVProgressHUD dismiss];
            [JKPromptView showWithImageName:nil message:msg];
            if (errorcode !=1) {
                return ;
            }
            success();
        } fail:^{
            [SVProgressHUD dismiss];
            [JKPromptView showWithImageName:nil message:AlrertMsg];
        }];

    }else{
        
        if (contentStr.length == 0) {
            contentStr = @"用户未填写内容";
        }
        
        QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(image, .5f)];
        QiniuUploader *uploader = [[QiniuUploader alloc] init];
        [uploader addFile:file];
        [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
        
        [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
            [JKPromptView showWithImageName:nil message:@"图片上传失败"];
            [SVProgressHUD dismiss];
        }];
        __block int index = 0;
        [uploader setUploadAllFilesComplete:^(void){
            DLog(@"complete");
            if (index == 0) {
                NSString *urls = [NSString stringWithFormat:@"%@%@mobile=%@&content=%@&file=%@",kProjectBaseUrl,FeedBackAdd,phone,contentStr,[PublicFunction ShareInstance].qiniuKey];
                [ZhouDao_NetWorkManger GetJSONWithUrl:urls success:^(NSDictionary *jsonDic) {
                    NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                    NSString *msg = jsonDic[@"info"];
                    [SVProgressHUD dismiss];
                    [JKPromptView showWithImageName:nil message:msg];
                    if (errorcode !=1) {
                        return ;
                    }
                    success();
                } fail:^{
                    [SVProgressHUD dismiss];
                    [JKPromptView showWithImageName:nil message:AlrertMsg];
                }];
            }
            index ++;
        }];

        [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
            DLog(@"index:%ld key:%@",(long)index,key);
            
            [PublicFunction ShareInstance].qiniuKey = key;
        }];
        [uploader startUpload];
    }
}
#pragma mark - 添加认证
+ (void)uploadCertificateImage:(UIImage *)image RequestSuccess:(void(^)())success;
{
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(image, .5f)];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
    
    [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
        [JKPromptView showWithImageName:nil message:@"上传失败"];
        [SVProgressHUD dismiss];
    }];
    
    [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
        DLog(@"index:%ld key:%@",(long)index,key);
        
        NSString *addUrl = [NSString stringWithFormat:@"%@%@uid=%@&mobile=%@&pic=%@",kProjectBaseUrl,ADDCertification,UID,[PublicFunction ShareInstance].m_user.data.mobile,key];
        [ZhouDao_NetWorkManger GetJSONWithUrl:addUrl success:^(NSDictionary *jsonDic) {
            [SVProgressHUD dismiss];
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            NSString *msg = jsonDic[@"info"];
            [JKPromptView showWithImageName:nil message:msg];
            if (errorcode !=1) {
                return ;
            }
            success();
        } fail:^{
            [SVProgressHUD dismiss];
            [JKPromptView showWithImageName:nil message:AlrertMsg];
        }];
    }];
    
    [uploader startUpload];
}
#pragma mark -验证手机号是否注册
+ (void)validationPhoneNumber:(NSString *)phone RequestSuccess:(void(^)())success
{
    //发个请求验证手机号码
    NSString *phoneUrl = [NSString stringWithFormat:@"%@%@mobile=%@",kProjectBaseUrl,VerifyTheMobile,phone];
    [ZhouDao_NetWorkManger GetJSONWithUrl:phoneUrl success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
    }];
}
#pragma mark -更改手机号
+ (void)resetPhoneNumber:(NSString *)phone RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&oldMobile=%@&NewMobile=%@",kProjectBaseUrl,ResetMobile,UID,[PublicFunction ShareInstance].m_user.data.mobile,phone];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];

        if (errorcode !=1) {
            return ;
        }
        
        [PublicFunction ShareInstance].m_user.data.mobile = phone;

        success();
        
    } fail:^{
        [SVProgressHUD dismiss];

    }];
}
#pragma mark -添加日程
+ (void)addRemindMySchedule:(NSDictionary *)dictionary RequestSuccess:(void (^)(NSString *idStr))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RemindAdd];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:url parameters:dictionary success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        NSString *idStr = dataDic[@"id"];
        success(idStr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -编辑更改日程
+ (void)editRemindMySchedule:(NSDictionary *)dictionary RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RemindEditInfo];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:url parameters:dictionary success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 删除日程
+ (void)deleteSelectRemind:(NSString *)idString RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@",kProjectBaseUrl,RemindDelete,idString,UID];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 赔偿标准首页列表
+ (void)getcompensationList:(NSString *)comId withCity:(NSString *)city withYear:(NSString *)year RequestSuccess:(void (^)(NSArray *arrays))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@type=%@&city=%@&year=%@",kProjectBaseUrl,compensationStandard,comId,city,year];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *contentArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CompensationData *model = [[CompensationData alloc] initWithDictionary:obj];
            [contentArr addObject:model];
        }];

        success(contentArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];

    
}
#pragma mark - 赔偿标准详情
+ (void)getcompensationDetailswith:(NSString *)idstring RequestSuccess:(void (^)(id obj))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,compensationDetails,idstring,UID,standardCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        IndemnityData *tModel = [[IndemnityData alloc] initWithDictionary:jsonDic[@"data"]];
        success(tModel);
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 合同一级分类列表
+ (void)theContractFirstListRequestSuccess:(void (^)(NSArray *arrays, NSArray *nameArr,NSArray *idArrays))success fail:(void (^)())fail;
{
//    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,TheContractFirstList];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        NSMutableArray *nameArr = [NSMutableArray array];
        NSMutableArray *idArr = [NSMutableArray array];

        NSArray *arrays = jsonDic[@"data"];
        
        [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TheContractData *model = [[TheContractData alloc] initWithDictionary:obj];
            [dataArr addObject:model];
            [nameArr addObject:model.ctname];
            [idArr addObject:model.id];
        }];
        
        if (dataArr.count >0) {
            if (dataArr.count%2 ==1) {
                [dataArr addObject:@""];
            }
        }
        success(dataArr,nameArr,idArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 合同分类
+ (void)theContractClassList:(TheContractData *)model withCount:(NSMutableArray *)cidArrays WithName:(NSMutableArray *)nameArr RequestSuccess:(void (^)(NSMutableArray *classArr,NSUInteger classCount,NSString *scid))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,TheContractAllClassList];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        NSArray *arrays = jsonDic[@"data"];
        
        [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TheContractData *model1 = [[TheContractData alloc] initWithDictionary:obj];
            [dataArr addObject:model1];
        }];

        NSMutableArray *classArrays = [NSMutableArray array];
        [cidArrays enumerateObjectsUsingBlock:^(NSString *cid, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *nameArrays = [NSMutableArray array];
            NSMutableArray *scidArr = [NSMutableArray array];
            [dataArr enumerateObjectsUsingBlock:^(TheContractData  *obj, NSUInteger tIdx, BOOL * _Nonnull stop) {
                if ([obj.pid isEqualToString:cid]) {
                    [nameArrays addObject:obj.ctname];
                    [scidArr addObject:obj.id];
                }
            }];
            [nameArrays insertObject:[NSString stringWithFormat:@"%@全部",nameArr[idx]] atIndex:0];
            [scidArr insertObject:@"" atIndex:0];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:nameArr[idx],@"title",cid,@"cid",nameArrays,@"data",scidArr,@"scid", nil];
            [classArrays addObject:dictionary];
        }];
       __block NSUInteger classCurrent = 0;
       __block NSString *scid = @"";
        [classArrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"cid"] isEqualToString:model.id]) {
                classCurrent = idx;
                NSArray *narr = obj[@"scid"];
                if (narr.count>0) {
                    scid = narr[0];
                }
            }
        }];
        
        success(classArrays,classCurrent,scid);
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
/*
 * 合同列表
 */
+ (void)theContractListView:(NSString *)cid withscid:(NSString *)scid withPage:(NSUInteger)page withOrid:(NSString *)orid RequestSuccess:(void (^)(NSArray *arrays))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@cid=%@&scid=%@&page=%ld&orid=%@",kProjectBaseUrl,TheContractList,cid,scid,(unsigned long)page,orid];
    
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TemplateData *model = [[TemplateData alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        success(dataArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 合同模版详情
+ (void)theContractContent:(NSString *)temolateId RequestSuccess:(void (^)(TemplateData *model))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,TheContractContent,temolateId,UID,templateCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        TemplateData *model = [[TemplateData alloc] initWithDictionary:dataDic];
        success(model);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}

#pragma mark - 添加收藏
+ (void)collectionAddMine:(NSDictionary *)dict RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,collectionAdd];
    [ZhouDao_NetWorkManger PostJSONWithUrl:url parameters:dict success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}

#pragma mark -  删除收藏
+ (void)collectionDelMine:(NSString *)idString withType:(NSString *)type RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,collectionDel,idString,UID,type];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
/*
 * 收藏置顶
 */
+ (void)collectionTopMine:(NSString *)idString RequestSuccess:(void (^)())success{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,collectionTop,idString,UID,templateCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
/*
 * 收藏取消置顶
 */
+ (void)collectionTopDelMine:(NSString *)idString RequestSuccess:(void (^)())success{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,collectionTopDel,idString,UID,templateCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
/*
 * 收藏列表
 */
+ (void)collectionListMine:(NSString *)type withPage:(NSUInteger)page RequestSuccess:(void (^)(NSArray *zdArr,NSArray *comArr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&type=%@&page=%lu",kProjectBaseUrl,CollectionList,UID,type,(unsigned long)page];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            if (page != 0) {
                [JKPromptView showWithImageName:nil message:msg];
            }
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *ZDArrays = [NSMutableArray array];
        NSMutableArray *ComArrays = [NSMutableArray array];

        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CollectionData *model = [[CollectionData alloc] initWithDictionary:obj];
            if ([model.is_top isEqualToString:@"1"]) {
                [ZDArrays addObject:model];
            }else{
                [ComArrays addObject:model];
            }
        }];
        success(ZDArrays,ComArrays);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}
#pragma mark -  司法机关一级分类
+ (void)goverMentFirstClassListRequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,goverMentFirst];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        success(arrays);
    } fail:^{
        fail();
    }];
}

#pragma mark - 司法机关全部分类
+ (void)goverAllClasslistwithName:(NSString *)name RequestSuccess:(void (^)(NSArray *arr,NSUInteger index))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,goverAllClasslist];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        __block NSUInteger index = 0;
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GovClassModel *model = [[GovClassModel alloc] initWithDictionary:obj];
            if ([model.ctname isEqualToString:name]) {
                index = idx;
            }
            NSDictionary *classDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"classid",@"全部",@"ctname",@"",@"id",@"",@"pic",@"",@"pid",@"",@"sorting", nil];
            GovClassData *dataModel = [[GovClassData alloc] initWithDictionary:classDic];
            
            [model.data insertObject:dataModel atIndex:0];
            
            [allArr addObject:model];
        }];
        success(allArr,index);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 司法机关列表
+ (void)goverListViewWithPid:(NSString *)pid withCid:(NSString *)cid withPage:(NSUInteger)page withProv:(NSString *)prov withCity:(NSString *)city RequestSuccess:(void (^)(NSArray *arr))success  fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = nil;
    if (prov.length == 0) {
        url = [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld",kProjectBaseUrl,judicialList,pid,cid,(unsigned long)page];
    }else{
        url = [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld&prov=%@&city=%@",kProjectBaseUrl,judicialList,pid,cid,(unsigned long)page,prov,city];
    }
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            fail();
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GovListmodel *model = [[GovListmodel alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -  司法机关详情
+ (void)goverDetailWithId:(NSString *)idStr RequestSuccess:(void (^)(id obj))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@&id=%@&uid=%@&type=%@",kProjectBaseUrl,judicialContent,idStr,UID,govCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dict = jsonDic[@"data"];
        GovListmodel *listModel = [[GovListmodel alloc] initWithDictionary:dict];
        success(listModel);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 推荐最新法规列表
+ (void)lawsNewsListRequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,NewLawsList];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LawsDataModel *model = [[LawsDataModel alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -新法速递
+ (void)lawsNewsListWithUrl:(NSString *)url withPage:(NSUInteger)page witheff:(NSString *)eff withTime:(NSString *)time  RequestSuccess:(void (^)(NSArray *arr))success  fail:(void (^)())fail;
{
    [SVProgressHUD show];
    NSString *loadUrl = nil;
    if (eff.length == 0 && time.length == 0) {
         loadUrl = [NSString stringWithFormat:@"%@%@page=%ld",kProjectBaseUrl,url,(unsigned long)page];
    }else if(eff.length == 0 && time.length>0){
         loadUrl = [NSString stringWithFormat:@"%@%@time=%@&page=%ld",kProjectBaseUrl,url,time,(unsigned long)page];
    }else if(eff.length >0 && time.length == 0){
        if ([url isEqualToString:AreaLawsList]) {
            loadUrl = [NSString stringWithFormat:@"%@%@city=%@&page=%ld",kProjectBaseUrl,url,eff,(unsigned long)page];
        }else{
            loadUrl = [NSString stringWithFormat:@"%@%@eff=%@&page=%ld",kProjectBaseUrl,url,eff,(unsigned long)page];
        }
    }else{
        if ([url isEqualToString:AreaLawsList]) {
            loadUrl = [NSString stringWithFormat:@"%@%@city=%@&time=%@&page=%ld",kProjectBaseUrl,url,eff,time,(unsigned long)page];
        }else{
            loadUrl = [NSString stringWithFormat:@"%@%@eff=%@&time=%@&page=%ld",kProjectBaseUrl,url,eff,time,(unsigned long)page];
        }
    }
    [ZhouDao_NetWorkManger GetJSONWithUrl:loadUrl success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LawsDataModel *model = [[LawsDataModel alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -法规详情
+ (void)lawsDetailData:(NSString *)idString RequestSuccess:(void (^)(id obj))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,LawsDetailContent,idString,UID,lawCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        LawDetailModel *model = [[LawDetailModel alloc] initWithDictionary:dataDic];
        success(model);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -相关法规
+ (void)aboutLawsReading:(NSString *)idStr RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@",kProjectBaseUrl,AboutReading,idStr];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LawsDataModel *model = [[LawsDataModel alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -法律法规搜索
+ (void)LawsSearchResultKeyWords:(NSString *)keyStr withPage:(NSUInteger)page RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@%@&page=%ld",kProjectBaseUrl,LawsSearchResult,keyStr,page];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LawsDataModel *model = [[LawsDataModel alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}
 #pragma mark -案例分类
+ (void)loadCutInspectionRequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,CutInspection];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ExampleData *model = [[ExampleData alloc] initWithDictionary:obj];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 案例搜索结果
+ (void)LegalIssuesSelfCheckResult:(NSString *)text withPage:(NSUInteger)page RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@caseDetail=%@&page=%ld",kProjectBaseUrl,ResultInspeList,text,page];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CaseModel *model = [[CaseModel alloc] initWithDictionary:obj];
                [allArr addObject:model];
            }];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - 按类型查询案例
+ (void)inspeTypeList:(NSString *)idString withPage:(NSUInteger)page RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&page=%ld",kProjectBaseUrl,InspeTypeList,idString,(unsigned long)page];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![arr isEqual:[NSNull null]]) {
                [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CaseModel *model = [[CaseModel alloc] initWithDictionary:obj];
                    [allArr addObject:model];
                }];
            }
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 自动登录
+ (void)isAutoLogin
{
    NSString *nameString = [USER_D objectForKey:StoragePhone];
    NSString *passWord = [USER_D objectForKey:StoragePassword];
    if (nameString.length>0)
    {
        NSString *loginurl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,LoginUrlString,nameString,passWord];
        [ZhouDao_NetWorkManger GetJSONWithUrl:loginurl success:^(NSDictionary *jsonDic) {
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            if (errorcode !=1) {
                [USER_D removeObjectForKey:StoragePhone];
                [USER_D removeObjectForKey:StoragePassword];
                [USER_D synchronize];
            }else
            {
                UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
                [PublicFunction ShareInstance].m_user = model;
                [PublicFunction ShareInstance].m_bLogin = YES;
                
                [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
                    
                    DLog(@"添加成功-----%@",responseObject);
                }];
                [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            DLog(@"添加标签成功-----%@",responseObject);
                        }];

//                [NetWorkMangerTools getaWekRemindsRequestSuccess:^{
//                }];
            }
        } fail:^{
        }];
    }
}

#pragma mark - 案例详情
+ (void)loadExampleDetailData:(NSString* )idString RequestSuccess:(void (^)(id obj))success;
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@id=%@&uid=%@&type=%@",kProjectBaseUrl,CaseInspeInfo,idString,UID,aboutCollect];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        
        NSDictionary *dataDic = jsonDic[@"data"];
        ExampleDetailData *model = [[ExampleDetailData alloc] initWithDictionary:dataDic];
        success(model);
    } fail:^{
        [SVProgressHUD dismiss];
    }];
}
#pragma mark -添加案件
+ (void)arrangeAddManagement:(NSDictionary *)dict withUrl:(NSString *)url RequestSuccess:(void (^)())success;
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger PostJSONWithUrl:url parameters:dict success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -案件列表
+ (void)arrangeListWithPage:(NSUInteger)page RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&page=%ld",kProjectBaseUrl,arrangeList,UID,(long)page];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *dataDic, NSUInteger idx, BOOL * _Nonnull stop) {
            ManagerData *model = [[ManagerData alloc] initWithDictionary:dataDic];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -案件搜索  案件筛选
+ (void)arrangeSearchUrl:(NSString *)url RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *allArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *dataDic, NSUInteger idx, BOOL * _Nonnull stop) {
            ManagerData *model = [[ManagerData alloc] initWithDictionary:dataDic];
            [allArr addObject:model];
        }];
        success(allArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -案件详情
+ (void)arrangeInfoWithIdString:(NSString* )idString
                 RequestSuccess:(void (^)(NSDictionary *dict))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&id=%@",kProjectBaseUrl,arrangeInfo,UID,idString];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dataDict= jsonDic[@"data"];
        success(dataDict);

    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 热词搜索
+ (void)lawsHotsSearchRequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,lawsHotsSearch];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *dataArr= jsonDic[@"data"];
        NSMutableArray *nameArr = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *nameStr = obj[@"name"];
            [nameArr addObject:nameStr];
        }];
        success(nameArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 工具
+ (void)apiToolsWith:(NSString *)url RequestSuccess:(void (^)(NSString *htmlString))success
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSString *dataUrl = jsonDic[@"data"];
        success(dataUrl);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 推荐页 新法速递
+ (void)recomViewNewLawsRequestSuccess:(void (^)(NSArray *arr))success
{    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,recomNewLaws];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *dataArr = jsonDic[@"data"];
        NSMutableArray *arrays = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GovListmodel *model = [[GovListmodel alloc] initWithDictionary:obj];
            [arrays addObject:model];
        }];
        success(arrays);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -推荐页全部
+ (void)recomViewAllRequestSuccess:(void (^)(NSArray *hdArr,NSArray *xfArr,NSArray *jdArr,NSArray *hotArr))success fail:(void (^)())fail
{    //[SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RecomViewfocusAll];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {

        [SVProgressHUD dismiss];
        NSArray *dataArr = jsonDic[@"data"];
        __block NSMutableArray *arr1 = [NSMutableArray array];
        __block NSMutableArray *arr2 = [NSMutableArray array];
        __block NSMutableArray *arr3 = [NSMutableArray array];
        __block NSMutableArray *arr4 = [NSMutableArray array];
        __block NSMutableArray *cacheArr1 = [NSMutableArray array];
        __block NSMutableArray *cacheArr2 = [NSMutableArray array];
        __block NSMutableArray *cacheArr3 = [NSMutableArray array];
        __block NSMutableArray *cacheArr4 = [NSMutableArray array];

        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            [QZManager wrongInformationWithDic:objDic Success:^{
                NSArray *twoDataArr = objDic[@"data"];
                if (idx == 0) {
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
                        [arr1 addObject:model];
                        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr1 addObject:data1];
                    }];
                }else if (idx == 1){
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        GovListmodel *model = [[GovListmodel alloc] initWithDictionary:obj];
                        [arr2 addObject:model];
                        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr2 addObject:data2];

                    }];
                }else if (idx == 2){
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
                        [arr3 addObject:model];
                        NSData *data3 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr3 addObject:data3];
                    }];

                }else{
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
                        [arr4 addObject:model];
                        NSData *data4 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr4 addObject:data4];
                    }];
                }
            }];
        }];
        if (arr1.count>0 && arr2.count>0 && arr3.count >0 && arr4.count>0) {
            [USER_D setObject:cacheArr1 forKey:RecomStorage];
            [USER_D setObject:cacheArr2 forKey:RECOMNEWS];
            [USER_D setObject:cacheArr3 forKey:RECOMJDPIC];
            [USER_D setObject:cacheArr4 forKey:RECOMHOT];

            [USER_D synchronize];
        }
        success(arr1,arr2,arr3,arr4);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -推荐缓存
+ (void)recomTheCacheSuccess:(void (^)(NSArray *hdArr,NSArray *xfArr,NSArray *jdArr,NSArray *hotArr))success
{
    __block NSMutableArray *arr1 = [USER_D objectForKey:RecomStorage];
    __block NSMutableArray *arr2 = [USER_D objectForKey:RECOMNEWS];
    __block NSMutableArray *arr3 = [USER_D objectForKey:RECOMJDPIC];
    __block NSMutableArray *arr4 = [USER_D objectForKey:RECOMHOT];
    __block NSMutableArray *cacheArr1 = [NSMutableArray array];
    __block NSMutableArray *cacheArr2 = [NSMutableArray array];
    __block NSMutableArray *cacheArr3 = [NSMutableArray array];
    __block NSMutableArray *cacheArr4 = [NSMutableArray array];
    
    if (arr1.count >0) {
        [arr1 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr1 addObject:model];
        }];
    }
    
    if (arr2.count >0) {
        [arr2 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GovListmodel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr2 addObject:model];
        }];
    }
    if (arr3.count >0) {
        [arr3 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr3 addObject:model];
        }];
    }
    
    if (arr4.count >0) {
        [arr4 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr4 addObject:model];
        }];
    }
//    if (arr1.count>0 && arr2.count>0 && arr3.count >0 && arr4.count>0) {

    success(cacheArr1,cacheArr2,cacheArr3,cacheArr4);
}
#pragma mark -首页缓存
+ (void)readHomeTheCacheSuccess:(void (^)(NSArray *hdArr,NSArray *hotArr))success
{
    __block NSMutableArray *arr1 = [USER_D objectForKey:HomeStorage];
    __block NSMutableArray *arr2 = [USER_D objectForKey:HomeHotMsg];
    __block NSMutableArray *cacheArr1 = [NSMutableArray array];
    __block NSMutableArray *cacheArr2 = [NSMutableArray array];

    if (arr1.count >0) {
        [arr1 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr1 addObject:model];
        }];
    }
    
    if (arr2.count >0) {
        [arr2 enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [cacheArr2 addObject:model];
        }];
    }
    
    success(cacheArr1,cacheArr2);
}
#pragma mark - 首页全部
+ (void)homeViewAllDataRequestSuccess:(void (^)(NSArray *hdArr,NSArray *hotArr))success fail:(void (^)())fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,HomeViewIndexAll];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSArray *dataArr = jsonDic[@"data"];
        __block NSMutableArray *arr1 = [NSMutableArray array];
        __block NSMutableArray *arr2 = [NSMutableArray array];
        __block NSMutableArray *cacheArr1 = [NSMutableArray array];
        __block NSMutableArray *cacheArr2 = [NSMutableArray array];

        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            [QZManager wrongInformationWithDic:objDic Success:^{
                NSArray *twoDataArr = objDic[@"data"];
                if (idx == 0) {
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
                        [arr1 addObject:model];
                         NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr1 addObject:data1];
                    }];
                }else{
                    [twoDataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
                        [arr2 addObject:model];
                        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:model];
                        [cacheArr2 addObject:data2];
                    }];
                }
            }];
        }];
        if (arr1.count>0 && arr2.count>0) {
            [USER_D setObject:cacheArr1 forKey:HomeStorage];
            [USER_D setObject:cacheArr2 forKey:HomeHotMsg];

            [USER_D synchronize];
        }
        success(arr1,arr2);
        } fail:^{
            [SVProgressHUD dismiss];
            [JKPromptView showWithImageName:nil message:AlrertMsg];
        }];
}
#pragma mark - 工具分类
+ (void)toolsClassRequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,toolsClass];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *dataArr = [NSMutableArray array];

        [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        if (dataArr.count >0) {
            if (dataArr.count%2 ==1) {
                [dataArr addObject:@""];
            }
        }
        success(dataArr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -
#pragma mark - 案件管理 创建文件夹 及文件
+ (void)arrangeFileAddwithPid:(NSString *)pid withName:(NSString *)name withFileType:(NSString *)fileType withtformat:(NSString *)format withqiniuName:(NSString *)qnName withCid:(NSString *)cid RequestSuccess:(void (^)(id obj))success
{    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&pid=%@&name=%@&type_file=%@&type_format=%@&qiniu_name=%@&cid=%@",kProjectBaseUrl,arrangeFileAdd,UID,pid,name,fileType,format,qnName,cid];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSDictionary *dataDic = jsonDic[@"data"];
        DetaillistModel *model = [[DetaillistModel alloc] initWithDictionary:dataDic];
        success(model);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}

#pragma mark - 查询案件目录
+ (void)arrangeFileListWithType:(NSString *)caseId withCid:(NSString *)cid RequestSuccess:(void (^)(NSArray *arr))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&id=%@&cid=%@",kProjectBaseUrl,arrangeFileList,UID,caseId,cid];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
//        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
//            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *arrays = jsonDic[@"data"];
        NSMutableArray *dataArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DetaillistModel *model = [[DetaillistModel alloc] initWithDictionary:obj];
            [dataArr addObject:model];
        }];
        success(dataArr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 案件目录 文件删除
+ (void)arrangeFileDelWithid:(NSString *)idStr withCaseId:(NSString *)caseId RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&id=%@&cid=%@",kProjectBaseUrl,arrangeFileDel,UID,idStr,caseId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -目录文件重命名
+ (void)arrangeFileRenameWithid:(NSString *)idStr withCaseId:(NSString *)caseId withName:(NSString *)name RequestSuccess:(void (^)())success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&id=%@&cid=%@&name=%@",kProjectBaseUrl,arrangeFileRename,UID,idStr,caseId,name];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        success();
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 案件查看详情
+ (void)arrangeFileInfoWithid:(NSString *)idStr withCaseId:(NSString *)caseId RequestSuccess:(void (^)(NSString *htmlString))success
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&id=%@&cid=%@",kProjectBaseUrl,arrangeFileInfo,UID,idStr,caseId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSString *htmlStr = jsonDic[@"data"];
        success(htmlStr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark -案件上传 图片 文本
+ (void)uploadarrangeFile:(NSData *)fileData withFormatType:(NSString *)formatType RequestSuccess:(void(^)(NSString *key))success fail:(void (^)())fail
{
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:fileData withKey:timeSJC withMimeType:formatType];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];
    [uploader addFile:file];
    [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
    [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
        fail();
        [JKPromptView showWithImageName:nil message:@"上传失败"];
        [SVProgressHUD dismiss];
    }];
    [uploader setUploadAllFilesComplete:^(void){
        DLog(@"complete");
    }];

    __block int sindex = 0;
    [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
        DLog(@"index:%ld key:%@",(long)index,key);
        if (sindex == 0) {
            [PublicFunction ShareInstance].qiniuKey = key;
            success([PublicFunction ShareInstance].qiniuKey);
        }
        sindex ++;
    }];
    [uploader startUpload];
}
#pragma mark - 下载格式
+ (NSString *)getFileFormat:(NSString *)idString
{// 1 word ,2 pdf,3 txt,4 photo
    if ([idString isEqualToString:@"1"]) {
        return @"word";
    }else if ([idString isEqualToString:@"2"]){
        return @"pdf";
    }else if ([idString isEqualToString:@"3"]){
        return @"txt";
    }else{
        return @"jpg";
    }
}
#pragma mark- 沙盒文件是否
+ (NSString *)whetheFileExists:(NSString *)caseId
{
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return casePath;
}
//文件夹是否已经存在
+ (void)creatFilePathEvent:(NSString *)filePath
{
    if (![FILE_M fileExistsAtPath:filePath]) {
        [FILE_M createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
#pragma mark -首页更多
+ (void)loadMoreDataHomePage:(NSString *)url RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            fail();
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSArray *dataArr = jsonDic[@"data"];
       __block NSMutableArray *arr = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BasicModel *model = [[BasicModel alloc] initWithDictionary:obj];
            [arr addObject:model];
        }];
        success(arr);
    } fail:^{
        fail();
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}

#pragma mark - 合同下载
+ (void)downLoadTheContract:(NSString *)url RequestSuccess:(void (^)(NSString *htmlString))success
{
    [SVProgressHUD show];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSString *htmlStr = jsonDic[@"data"];
        success(htmlStr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 版本更新
+ (void)checkHistoryVersionRequestSuccess:(void (^)(NSString *desc))success
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,historyVersion];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        
        NSDictionary *dataDic = jsonDic[@"data"];
        NSString *version = dataDic[@"version"];
        NSString *desc = dataDic[@"desc"];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app build版本
        NSString *app_build = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];

        if ([version floatValue] > [app_build floatValue]) {
            success(desc);
        }
        
//        if (![version isEqualToString:[QZManager getBuildVersion]]) {
//            success(desc);
//        }
    } fail:^{
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];

}
#pragma mark - 工具分享链接
+ (void)toolsSharewithParaDic:(NSDictionary *)dict
               RequestSuccess:(void (^)(NSString *shareUrl))success
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,toolsShareUrl];
    
    [ZhouDao_NetWorkManger PostJSONWithUrl:url parameters:dict
                                   success:^(NSDictionary *jsonDic) {
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        NSString *strUrl = jsonDic[@"data"];
        success(strUrl);
    } fail:^{
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
 #pragma mark -  查看全部日程
+ (void)lookAllScheduleRequestSuccess:(void (^)(NSArray *arr))success
{
    [SVProgressHUD show];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,remindAllList,[PublicFunction ShareInstance].m_user.data.uid];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        if (errorcode !=1) {
            return ;
        }
        NSMutableArray *arrays = jsonDic[@"data"];
        NSMutableArray *modelArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            RemindData *model = [[RemindData alloc] initWithDictionary:dict];
            [modelArr addObject:model];
        }];
        success(modelArr);
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}

#pragma mark - 案件整理 财务管理列表
+ (void)financialListToCheckTheCaseWithCaseID:(NSString *)caseId RequestSuccess:(void (^)(NSArray *arr))success fail:(void (^)())fail
{
    [SVProgressHUD show];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@&aid=%@",kProjectBaseUrl,arrangeFinanceList,UID,caseId];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
            fail();
            return ;
        }
        NSMutableArray *arrays = jsonDic[@"data"];
        NSMutableArray *modelArr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            FinanceModel *model = [[FinanceModel alloc] initWithDictionary:dict];
            [modelArr addObject:model];
        }];
        success(modelArr);
        
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 案件整理 财务管理删除
+ (void)arrangeFinanceDelWithUrl:(NSString *)url RequestSuccess:(void (^)())success
{
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
        if (errorcode !=1) {
            return ;
        }
        success();
        
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
    
}

#pragma mark - 案件整理 提醒列表

+ (void)arrangeRemindListWithUrl:(NSString *)url RequestSuccess:(void (^)(NSArray *arrays))success
{
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
        if (errorcode !=1) {
            
            return ;
        }
        
        NSArray *dataArr = jsonDic[@"data"];
        __block NSMutableArray *arr = [NSMutableArray array];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            RemindData *model = [[RemindData alloc] initWithDictionary:dic];
            
            [arr addObject:model];
        }];
        success(arr);
        
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];
}
#pragma mark - 焦点历史记录
+ (void)FocusOnTheHistoryWithUrl:(NSString *)url RequestSuccess:(void (^)(NSArray *arrays))success fail:(void (^)())fail
{
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        [JKPromptView showWithImageName:nil message:jsonDic[@"info"]];
        if (errorcode !=1) {
            fail();
            return ;
        }
        NSArray *dataArr = jsonDic[@"data"];
        
        if ([dataArr isEqual:[NSNull null]]) {
            fail();
            return;
        }
        __block NSMutableArray *arr = [NSMutableArray array];
        
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HistoryModel *model = [[HistoryModel alloc] initWithDictionary:dic];
            [arr addObject:model];
        }];
        success(arr);
        
    } fail:^{
        [SVProgressHUD dismiss];
        [JKPromptView showWithImageName:nil message:AlrertMsg];
    }];

    
}



/**
 *  判断铃声
 */
+ (NSString *)getSoundName:(NSString *)bell
{
    NSString *bellName = nil;
    
    if ([bell isEqualToString:@"1"]) {
        bellName = @"defaultSound";
    }else if ([bell isEqualToString:@"2"]){
        bellName = @"woman_contract";
    }else if ([bell isEqualToString:@"3"]){
        bellName = @"woman_meeting";
    }else if ([bell isEqualToString:@"4"]){
        bellName = @"woman_court";
    }else if ([bell isEqualToString:@"5"]){
        bellName = @"man_contract";
    }else if ([bell isEqualToString:@"6"]){
        bellName = @"man_meeting";
    }else{
        bellName = @"man_court";
    }

    return bellName;
}

//+ (NetWorkMangerTools *)sharedInstance
//{
//    static NetWorkMangerTools *toos;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        toos = [[NetWorkMangerTools alloc] init];
//    });
//    
//    return toos;
//}
@end
