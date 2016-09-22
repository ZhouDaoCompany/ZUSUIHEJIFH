//
//  DefineHeader.h
//  GNETS
//
//  Created by tcnj on 16/2/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

/**
 *
 * color macros
 *
 **/

#define LRRGBAColor(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define LRRGBColor(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define hexColor(colorV) [UIColor colorWithHexString:@#colorV]

#define hexColorAlpha(colorV,a) [UIColor colorWithHexString:@#colorV alpha:a];

#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1.0f]


/**
 *
 * frame macros
 *
 **/
//设备屏幕frame
#define kMainScreenFrameRect                                 [[UIScreen mainScreen] bounds]
//状态栏高度
#define kMainScreenStatusBarFrameRect                        [[UIApplication sharedApplication] statusBarFrame]
#define kMainScreenHeight                                    kMainScreenFrameRect.size.height
#define kMainScreenWidth                                     kMainScreenFrameRect.size.width
//减去状态栏和导航栏的高度
#define kScreenHeightNoStatusAndNoNaviBarHeight              (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-44.0f)
//减去状态栏和底部菜单栏高度
#define kScreenHeightNoStatusAndNoTabBarHeight               (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-49.0f)
//减去状态栏和底部菜单栏以及导航栏高度
#define kScreenHeightNoStatusAndNoTabBarNoNavBarHeight       (kMainScreenFrameRect.size.height - kMainScreenStatusBarFrameRect.size.height-49.0f - 44.0f)
//底部工具栏高度
#define kTabBarHeight                                        49
//导航栏高度
#define kNavBarHeight                                        44

#define GET(str)                                             (str ? str : @"")

/**
 *
 * font
 macros
 *
 **/
#define Font_12        [UIFont  systemFontOfSize:12]
#define Font_13        [UIFont  systemFontOfSize:13]
#define Font_14        [UIFont  systemFontOfSize:14]
#define Font_15        [UIFont  systemFontOfSize:15]
#define Font_16        [UIFont  systemFontOfSize:16]
#define Font_17        [UIFont  systemFontOfSize:17]
#define Font_18        [UIFont  systemFontOfSize:18]
#define Font_20        [UIFont systemFontOfSize:20]
#define Font_21        [UIFont systemFontOfSize:21]
#define Font_24        [UIFont systemFontOfSize:24]

/**
 *  由角度转换弧度 由弧度转换角度
 */
#define REES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)

#define ImgName(name) [UIImage imageNamed:@#name]
//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define Orgin_y(container)   (container.frame.origin.y+container.frame.size.height)
#define Orgin_x(container)   (container.frame.origin.x+container.frame.size.width)
/**
 *  设置 view 圆角和边框
 */
#define LRViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/**
 *  GCD 的宏定义
 */
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#define line_w 0.5

#define DATE_FORMAT_YMDHMS             @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_YMDHM               @"yyyy-MM-dd HH:mm"

/**
 *  3.判断当前环境(ARC/MRC)
 */
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


/**
 *  判断是真机还是模拟器
 */
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


/**
 *  把是NSNull 类型的值替换成nil
 *  使用方法：contact.contactPhone = VerifyValue(contactDic[@"send_ContactPhone"]);
 */
#define VerifyValue(value)\
({id tmp;\
if ([value isKindOfClass:[NSNull class]])\
tmp = nil;\
else\
tmp = value;\
tmp;\
})\



#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}

//view安全释放
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
__REF = nil;\
}\
}

//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

/**
 * NSLog宏，限定仅在Debug时才打印,release不打印，防止拖慢程序运行
 */
#ifdef DEBUG
#define DLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

//宏定义方法
#define SHOW_ALERT(msg) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\


#define WEAKSELF typeof(self) __weak weakSelf = self;

#define USER_D [NSUserDefaults standardUserDefaults]


//iOS版本
#define CurrentSystemVersion                    ([[[UIDevice currentDevice] systemVersion] floatValue])

#define ProvinceArrays  [NSMutableArray arrayWithObjects:@"北京",@"天津",@"上海",@"江苏省",@"河北省",@"河南省",@"湖南省",@"湖北省",@"浙江省",@"云南省",@"陕西省",@"台湾",@"贵州省",@"广西壮族自治区",@"黑龙江省",@"甘肃省",@"吉林省",@"四川省",@"广东省",@"江西省",@"青海省",@"辽宁省",@"香港特别行政区",@"山东省",@"西藏自治区",@"重庆",@"福建省",@"新疆维吾尔自治区",@"内蒙古自治区",@"山西省",@"海南省",@"宁夏回族自治区",@"澳门特别行政区",@"安徽省", nil]

//#define FUNDARRAYS      [NSMutableArray arrayWithObjects:@"20151024",@"20150301",@"20141122",@"20120706",@"20120608",@"20110707",@"20110406",@"20110209",@"20101226",@"20101020",@"20081223",@"20081127",@"20081030",@"20081027",@"20081009",@"20080916",@"20071221",@"20070915",@"20070822",@"20070721",@"20070519",];

//#define FUNDDICTIONARY   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20151024" ,@[ @"2.75", @"3.25"],@"20150301" ,@[ @"3.50", @"4.00"],@"20141122" ,@[ @"3.75", @"4.25"],@"20120706" ,@[ @"4.00", @"4.50"],@"20120608" ,@[ @"4.20", @"4.70"],@"20110707" ,@[ @"4.45", @"4.90"],@"20110406" ,@[ @"4.20", @"4.70"],@"20110209" ,@[ @"4.00", @"4.50"],@"20101226" ,@[ @"3.75", @"4.30"],@"20101020" ,@[ @"3.50", @"4.05"],@"20081223" ,@[ @"3.33", @"3.87"],@"20081127" ,@[ @"3.51", @"4.05"],@"20081030" ,@[ @"4.05", @"4.59"],@"20081027" ,@[ @"4.05", @"4.59"],@"20081009" ,@[ @"4.32", @"4.86"],@"20080916" ,@[ @"4.59", @"5.13"],@"20071221" ,@[ @"4.77", @"5.22"],@"20070915" ,@[ @"4.77", @"5.22"],@"20070822" ,@[ @"4.59", @"5.04"],@"20070721" ,@[ @"4.50", @"4.95"],@"20070519" ,@[ @"4.41", @"4.86"], nil];
#define AVERAGESALARYARRAYS          [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5793",@"北京",@"4260",@"天津",@"5036",@"上海",@"5105.25",@"江苏省",@"3638",@"河北省",@"3718.5",@"河南省",@"4699",@"湖南省",@"4478.8",@"湖北省",@"3902.58",@"浙江省",@"4254.92",@"云南省",@"4233",@"陕西省",@"3918.08",@"贵州省",@"4015.67",@"广西壮族自治区",@"3934.08",@"黑龙江省",@"3203.33",@"甘肃省",@"4297",@"吉林省",@"3970.33",@"四川省",@"5808",@"广东省",@"3895.33",@"江西省",@"4013.75",@"青海省",@"4371.83",@"辽宁省",@"3873",@"山东省",@"4000",@"西藏自治区",@"4252",@"重庆",@"4444",@"福建省",@"3817",@"新疆维吾尔自治区",@"4052.92",@"内蒙古自治区",@"4253",@"山西省",@"3848",@"海南省",@"4348.67",@"宁夏回族自治区",@"4583.83",@"安徽省", nil]

#define TIMEARRAYS      [NSMutableArray arrayWithObjects:@"19890201",@"19900821",@"19910321",@"19910421",@"19930515",@"19930711",@"19950101",@"19950701",@"19960501",@"19960823",@"19971023",@"19980325",@"19980701",@"19981207",@"19990610",@"20020221",@"20041029",@"20050317",@"20060428",@"20060819",@"20070318",@"20070519",@"20070721",@"20070822",@"20070915",@"20071221",@"20080916",@"20081009",@"20081027",@"20081030",@"20081127",@"20081223",@"20101020",@"20101226",@"20110209",@"20110406",@"20110707",@"20120608",@"20120706",@"20141122",@"20150301",@"20150511",@"20150628",@"20150826",@"20151024",nil]

#define RATEDICTIONARY  [NSMutableDictionary dictionaryWithObjectsAndKeys:@[@"0.1134",@"0.1134",@"0.1278",@"0.1440",@"0.1926"],@"19890201",@[@"0.0864",@"0.0936",@"0.1008",@"0.1080",@"0.1116"],@"19900821",@[@"0.0900",@"0.1008",@"0.1080",@"0.1152",@"0.1188"],@"19910321",@[@"0.0810",@"0.0864",@"0.0900",@"0.0954",@"0.0972"],@"19910421",@[@"0.0882",@"0.0936",@"0.1080",@"0.1206",@"0.1224"],@"19930515",@[@"0.0900",@"0.1098",@"0.1224",@"0.1386",@"0.1404"],@"19930711",@[@"0.0900",@"0.1098",@"0.1296",@"0.1458",@"0.1476"],@"19950101",@[@"0.1008",@"0.1206",@"0.1305",@"0.1512",@"0.1530"],@"19950701",@[@"0.0972",@"0.1098",@"0.1314",@"0.1494",@"0.1512"],@"19960501",@[@"0.0918",@"0.1008",@"0.1098",@"0.1170",@"0.1242"],@"19960823",@[@"0.0765",@"0.0864",@"0.0936",@"0.0990",@"0.1053"],@"19971023",@[@"0.0702",@"0.0792",@"0.0900",@"0.0972",@"0.1035"],@"19980325",@[@"0.0657",@"0.0693",@"0.0711",@"0.0765",@"0.0801"],@"19980701",@[@"0.0612",@"0.0639",@"0.0666",@"0.0720",@"0.0756"],@"19981207",@[@"0.0558",@"0.0585",@"0.0594",@"0.0603",@"0.0621"],@"19990610",@[@"0.0504",@"0.0531",@"0.0549",@"0.0558",@"0.0576"],@"20020221",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20041029",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20050317",@[@"0.0540",@"0.0585",@"0.0603",@"0.0612",@"0.0639"],@"20060428",@[@"0.0558",@"0.0612",@"0.0630",@"0.0648",@"0.0684"],@"20060819",@[@"0.0567",@"0.0639",@"0.0657",@"0.0675",@"0.0711"],@"20070318",@[@"0.0585",@"0.0657",@"0.0675",@"0.0693",@"0.0720"],@"20070519",@[@"0.0603",@"0.0684",@"0.0702",@"0.0720",@"0.0738"],@"20070721",@[@"0.0621",@"0.0702",@"0.0720",@"0.0738",@"0.0756"],@"20070822",@[@"0.0648",@"0.0729",@"0.0747",@"0.0765",@"0.0783"],@"20070915",@[@"0.0657",@"0.0747",@"0.0756",@"0.0774",@"0.0783"],@"20071221",@[@"0.0621",@"0.0720",@"0.0729",@"0.0756",@"0.0774"],@"20080916",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081009",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081027",@[@"0.0603",@"0.0666",@"0.0675",@"0.0702",@"0.0720"],@"20081030",@[@"0.0504",@"0.0558",@"0.0567",@"0.0594",@"0.0612"],@"20081127",@[@"0.0486",@"0.0531",@"0.0540",@"0.0576",@"0.0594"],@"20081223",@[@"0.0510",@"0.0556",@"0.0560",@"0.0596",@"0.0614"],@"20101020",@[@"0.0535",@"0.0581",@"0.0585",@"0.0622",@"0.0640"],@"20101226",@[@"0.0560",@"0.0606",@"0.0610",@"0.0645",@"0.0660"],@"20110209",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20110406",@[@"0.0610",@"0.0656",@"0.0665",@"0.0690",@"0.0705"],@"20110707",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20120608",@[@"0.0560",@"0.0600",@"0.0615",@"0.0640",@"0.0655"],@"20120706",@[@"0.0560",@"0.0560",@"0.0600",@"0.0600",@"0.0615"],@"20141122",@[@"0.0535",@"0.0535",@"0.0575",@"0.0575",@"0.0590"],@"20150301",@[@"0.0510",@"0.0510",@"0.0550",@"0.0550",@"0.0565"],@"20150511",@[@"0.0485",@"0.0485",@"0.0525",@"0.0525",@"0.0540"],@"20150628",@[@"0.0460",@"0.0460",@"0.0500",@"0.0500",@"0.0515"],@"20150826",@[@"0.0435",@"0.0435",@"0.0475",@"0.0475",@"0.0490"],@"20151024", nil]

typedef void(^ZDBlock)(void);
typedef void(^ZDBlockBlock)(ZDBlock block);
typedef void(^ZDObjectBlock)(id obj);
typedef void(^ZDArrayBlock)(NSArray *array);
typedef void(^ZDMutableArrayBlock)(NSMutableArray *array);
typedef void(^ZDDictionaryBlock)(NSDictionary *dic);
typedef void(^ZDErrorBlock)(NSError *error);
typedef void(^ZDIndexBlock)(NSInteger index);
typedef void(^ZDFloatBlock)(CGFloat afloat);
typedef void(^ZDStringBlock)(NSString *string);
typedef void(^ZDCancelBlock)(id viewController);
typedef void(^ZDFinishedBlock)(id viewController, id object);
typedef void(^ZDSendRequestAndResendRequestBlock)(id sendBlock, id resendBlock);


#endif /* DefineHeader_h */
