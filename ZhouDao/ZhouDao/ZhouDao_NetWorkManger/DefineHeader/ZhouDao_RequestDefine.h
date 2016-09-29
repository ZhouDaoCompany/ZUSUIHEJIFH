//
//  ZhouDao_RequestDefine.h
//  ZhouDao
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#ifndef ZhouDao_RequestDefine_h
#define ZhouDao_RequestDefine_h

#endif /* ZhouDao_RequestDefine_h */

//线上
#define kProjectBaseUrl         @"http://zapi.zhoudao.cc/pro/"
//测试地址
//#define kProjectBaseUrl         @"http://testapi.zhoudao.cc/pro/"

/*
 1 验证手机号
 */
#define  VerifyTheMobile        @"api_reg.php?c=vm&key=16248ef5&"
/*
 2 登录
 */
#define LoginUrlString          @"api_login.php?key=16248ef5&c=login&"
/*
 3 注册
 */
#define RegisterUrlString       @"api_reg.php?c=reg&key=16248ef5&"
/*
 4 忘记密码
 */
#define ForgetKey               @"api_login.php?key=16248ef5&c=forget&"
/*
 5 添加认证
 */
#define ADDCertification        @"api_certification.php?key=16248ef5&c=apply&"
/*
 6 认证信息
 */
#define ApplyInfo               @"api_certification.php?key=16248ef5&c=applyInfo&"
/*
 7 领域列表
 */
#define DomainList              @"api_field.php?key=16248ef5&c=domainList"
/*
 8 修改领域
 */
#define DomainAdd               @"api_field.php?key=16248ef5&c=domainAdd&"
/*
 9 查询用户擅长领域
 */
#define DomainUser              @"api_field.php?key=16248ef5&c=domainUser&"

/*
 10 首页幻灯
 */
#define HomeFocusIndex          @"api_recom.php?key=16248ef5&c=focusIndex"

/*
 11 时事热点（5条）
 */
#define HomeHotSpot             @"api_recom.php?key=16248ef5&c=hotspot"

/*
 12 当前热点详情
 */
#define HotSpotInfo             @"api_recom.php?key=16248ef5&c=hotspotInfo&"

/*
 13 意见反馈
 */
#define FeedBackAdd             @"api_user.php?key=16248ef5&c=feedbackAdd&"

/*
 14 上传头像
 */
#define UploadHeadPic           @"api_user.php?key=16248ef5&c=uploadPic&"
/*
 15 通讯地址
 */
#define UploadUserAddress       @"api_user.php?key=16248ef5&c=uploadAddress&"
/*
 16 律师职业
 */
#define UploadJob               @"api_user.php?key=16248ef5&c=uploadJob&"

/*
 17 获取上传图片的token
 */
#define UploadPicToken          @"api_user.php?key=16248ef5&c=tokenValue"
/*
 18 更改手机号
 */
#define ResetMobile             @"api_user.php?key=16248ef5&c=uploadMobile&"
/*
 19 添加提醒
 */
#define RemindAdd               @"api_user.php?key=16248ef5&c=remindAdd"
/*
 20 删除提醒
 */
#define RemindDelete            @"api_user.php?key=16248ef5&c=remindDel&"
/*
 21 日程列表
 */
#define RemindList              @"api_user.php?key=16248ef5&c=remindList&"
/*
 22 获取七天日程
 */
#define RemindAWeek             @"api_user.php?key=16248ef5&c=remindExecute&"
/*
 23 日程详情
 */
#define RemindDetailInfo        @"api_user.php?key=16248ef5&c=remindInfo&"
/*
 24 更改日程
 */
#define RemindEditInfo          @"api_user.php?key=16248ef5&c=remindEdit"
/*
 25 赔偿标准首页列表
 */
#define compensationStandard    @"api_compensation.php?key=16248ef5&c=compensateList&"
/*
 26 赔偿标准详情
 */
#define compensationDetails     @"api_compensation.php?key=16248ef5&c=compensateInfo&"
/*
 27 合同一级分类列表
 */
#define TheContractFirstList    @"api_contract.php?key=16248ef5&c=firstclasslist"
/*
 28 合同分类
 */
#define TheContractAllClassList @"api_contract.php?key=16248ef5&c=allclasslist"

/*
 29 合同列表
 */
#define TheContractList         @"api_contract.php?key=16248ef5&c=contractlist&"

/*
 30 合同模板详情
 */
#define TheContractContent      @"api_contract.php?key=16248ef5&c=contractcontent&"

/*
 31 添加收藏
 */
#define collectionAdd           @"api_collection.php?key=16248ef5&c=collectionAdd"
/*
 31 删除收藏
 */
#define collectionDel           @"api_collection.php?key=16248ef5&c=collectionDel&"
/*
 32 收藏置顶
 */
#define collectionTop           @"api_collection.php?key=16248ef5&c=collectionTop&"
/*
 33 收藏取消置顶
 */
#define collectionTopDel        @"api_collection.php?key=16248ef5&c=collectionTopDel&"
/*
 34 收藏列表
 */
#define CollectionList          @"api_collection.php?key=16248ef5&c=collectionList&"
/*
 35 司法机关一级分类
 */
#define goverMentFirst          @"api_judicial.php?key=16248ef5&c=firstclasslist"
/*
 36 司法机关全部分类
 */
#define goverAllClasslist       @"api_judicial.php?key=16248ef5&c=allclasslist"
/*
 37 司法机关列表
 */
//#define judicialList            @"api_judicial.php?key=16248ef5&c=judiciallist&"
#define judicialList            @"api_judicial.php?key=16248ef5&c=judiciallistNew&"

/*
 38 司法机关详情
 */
#define judicialContent         @"api_judicial.php?key=16248ef5&c=judicialcontent&"
/*
 39 最新法规列表
 */
#define NewLawsList             @"api_laws.php?key=16248ef5&c=newlawslist"
/*
 40 新法速递
 */
#define NewLawSDList            @"api_laws.php?key=16248ef5&c=newlawsdlist&"
/*
 41 常用法规
 */
#define CommonLawsList          @"api_laws.php?key=16248ef5&c=commonlawslist&"
/*
 42 地方法规
 */
#define AreaLawsList            @"api_laws.php?key=16248ef5&c=arealawslist&"
/*
 43 法规详情
 */
#define LawsDetailContent       @"api_laws.php?key=16248ef5&c=lawscontent&"
/*
 44 法律法规搜索
 */
#define LawsSearchResult        @"api_laws.php?key=16248ef5&c=lawssou&keyword="
/*
 45 法规是否已收藏
 */
#define LawsIsCollection        @"api_laws.php?key=16248ef5&c=lawsiscollection&"
/*
 46 法律法规_相关阅读
 */
#define AboutReading            @"api_laws.php?key=16248ef5&c=relatedreading&"
/*
 47 案例分类
 */
#define CutInspection           @"api_case.php?key=16248ef5&c=inspection"
/*
 48 法律问题自检结果
 */
#define ResultInspeList         @"api_case.php?key=16248ef5&c=inspeList&caseDetail="
/*
 49 查询更多案例
 */
#define LookInspeListMore       @"api_case.php?key=16248ef5&c=inspeListMore&"
/*
 50 按类型查询案例
 */
#define InspeTypeList           @"api_case.php?key=16248ef5&c=inspeTypeList&"
/*
 51 案例详情
 */
#define CaseInspeInfo           @"api_case.php?key=16248ef5&c=inspeInfo&"
/*
 52 案件整理 添加案件整理 post
 */
#define arrangeAdd              @"api_user.php?key=16248ef5&c=arrangeAdd"
/**
 *  53 案件整理 案件修改
 */
#define arrangeEdit             @"api_user.php?key=16248ef5&c=arrangeEdit"
/**
 *  54 案件整理 案件列表
 */
#define arrangeList             @"api_user.php?key=16248ef5&c=arrangeList&"
/**
 *  55 案件整理 案件筛选
 */
#define arrangeScreen           @"api_user.php?key=16248ef5&c=arrangeScreen&"
/**
 *  56 案件整理 案件搜索
 */
#define arrangeSearch           @"api_user.php?key=16248ef5&c=arrangeSearch&"
/**
 *  57 案件详情
 */
#define arrangeInfo             @"api_user.php?key=16248ef5&c=arrangeInfo&"
/**
 *  58 热词搜索
 */
#define lawsHotsSearch          @"api_laws.php?key=16248ef5&c=lawsHotsSearch"
/**
 *  59 案件目录 创建文件
 */
#define arrangeFileAdd          @"api_user.php?key=16248ef5&c=arrangeFileAdd&"
/**
 *  60 案件目录 删除文件
 */
#define arrangeFileDel          @"api_user.php?key=16248ef5&c=arrangeFileDel&"
/**
 *  61 案件目录 文件列表
 */
#define arrangeFileList         @"api_user.php?key=16248ef5&c=arrangeFileList&"
/**
 *  62 案件目录 单文件详情
 */
#define arrangeFileInfo         @"api_user.php?key=16248ef5&c=arrangeFileInfo&"
/**
 *  63 案件目录 重命名
 */
#define arrangeFileRename       @"api_user.php?key=16248ef5&c=arrangeFileRename&"
/**
 *  64 工具详情
 */
#define api_tools               @"api_tools.php?key=16248ef5&c=toolsInfo&py="
/**
 *  65 推荐页 新法速递
 */
#define recomNewLaws            @"api_recom.php?key=16248ef5&c=newLaws"
/**
 *  66工具分类
 */
#define toolsClass              @"api_tools.php?key=16248ef5&c=toolsClass"
/**
 *  67 推荐页全部
 */
#define RecomViewfocusAll       @"api_recom.php?key=16248ef5&c=focusAll"
/**
 *  68 首页全部
 */
#define HomeViewIndexAll        @"api_recom.php?key=16248ef5&c=indexAll"
/**
 *  69 时事热点详情
 */
#define DetailsEventHotSpot     @"api_recom.php?key=16248ef5&c=hotspotInfo&id="
/**
 *  70 首页加载更多
 */
#define hotspotAll              @"api_recom.php?key=16248ef5&c=hotspotAll&page="
/**
 *  71 合同下载
 */
#define contractDownload        @"api_contract.php?key=16248ef5&c=contractDownload&id="
/**
 *  72 合同下载前缀
 */
#define DownloadThePrefix       @"http://o7ns23gwb.bkt.clouddn.com/"

/**
 *  73 版本更新
 */
#define historyVersion          @"api_user.php?key=16248ef5&c=history&type=2"
/**
 *  74 工具 分享链接
 */
#define toolsShareUrl           @"api_tools.php?key=16248ef5&c=toolsShareUrl"
/**
 *  75 推荐页幻灯 详情
 */
#define focusGroomInfo          @"api_recom.php?key=16248ef5&c=focusGroomInfo&id="

/**
 *  76 气质文章
 */
#define dailyInfo               @"api_recom.php?key=16248ef5&c=dailyInfo&id="
/**
 *  77 用户所有提醒
 */
#define remindAllList           @"api_user.php?key=16248ef5&c=remindAllList&uid="
/**
 *  78 案件财务管理添加
 */
#define arrangeFinanceAdd       @"api_user.php?key=16248ef5&c=arrangeFinanceAdd"

/**
 *  79 案件整理 财务管理列表
 */
#define arrangeFinanceList      @"api_user.php?key=16248ef5&c=arrangeFinanceList&uid="
/**
 *  80 案件整理 财务管理删除
 */
#define arrangeFinanceDel       @"api_user.php?key=16248ef5&c=arrangeFinanceDel&uid="
/**
 *  81 案件整理 财务管理编辑
 */
#define arrangeFinanceEdit      @"api_user.php?key=16248ef5&c=arrangeFinanceEdit"
/**
 *  82 案件整理 添加提醒
 */
#define arrangeRemindAdd        @"api_user.php?key=16248ef5&c=arrangeRemindAdd"
/**
 *  83 案件整理 提醒列表
 */
#define arrangeRemindList       @"api_user.php?key=16248ef5&c=arrangeRemindList&uid="
/**
 *  84 焦点历史记录
 */
#define dailyHistory            @"api_recom.php?key=16248ef5&c=dailyHistory"

/**
 *  85 第三方授权后判断是否已经绑定手机号
 */
#define ThirdPartyLogin         @"api_login.php?key=16248ef5&c=otherLogin&au="

/**
 *  86 绑定账号
 */
#define AuBindingURLString      @"api_login.php?key=16248ef5&c=auBinding&"

/**
 *  87 解绑账号
 */
#define AuBindingOCURL          @"api_user.php?key=16248ef5&c=auBindingOc&"
/**
 *  88 资料纠错
 */
#define ErrorCorrectionURL      @"api_judicial.php?key=16248ef5&c=ErrorCorrection&id="

/**
 *  89 分享计算 post
 */
#define SHARECALCulate          @"api_tools.php?key=16248ef5&c=toolsShareNew"


/**************************分享的链接***************************/
//法律法规
#define LawShareUrl                    @"share_laws.php?id="
//赔偿标准
#define CompensationShareUrl           @"share_compensation.php?id="
//案例
#define CaseShareUrl                   @"share_case.php?id="
//合同模版
#define TheContractShareUrl            @"share_contract.php?id="

/*************************文章阅读和提示信息****************************/

/*
 *字体大小
 */
#define   ReadFont                     @"readFont"
/*
 *背景色
 */
#define   ReadColor                    @"ReadColor"
/*
 *字体颜色
 */
#define   ReadFontColor                @"ReadFontColor"

/*
 登录账号
 */
#define   StoragePhone                 @"storagePhone"
/*
 登录密码
 */
#define   StoragePassword              @"storageKey"
/*
 三方登录方式QQ 微信 新浪微博
 */
#define   StorageTYPE                  @"loginType"
/*
 三方登录uSid
 */
#define   StorageUSID                  @"otherLoginUSid"

/*
 请求失败 提示语
 */
#define AlrertMsg                      @"请求失败，请您检查网络"

#define REQUESTV                       @"3ee1bcf667"
