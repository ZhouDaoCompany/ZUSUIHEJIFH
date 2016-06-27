//
//  QZManager.h
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//
/**
 *  常用方法管理器
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"   // 单例模板

@interface QZManager : NSObject
singleton_for_header(QZManager)

#pragma mark - 判断字符串是否为空
/**
 *  判断字符串是否为空
 *
 *  @param string 要判断的字符串
 *
 *  @return 返回YES为空，NO为不空
 */
+ (BOOL)isBlankString:(NSString *)string;

#pragma mark-判断是否为纯数字
/**
 *  判断是否为纯数字
 *
 *  @param string 字符串
 *
 *  @return 是纯数字 NO不是纯数字
 */
+ (BOOL)isPureInt:(NSString*)string;

#pragma mark - 系统转json

#pragma mark - 判断是否为真实手机号码
/**
 *  判断是否为真实手机号码
 *
 *  @param mobile 手机号
 *
 *  @return 返回YES为真实手机号码，NO不是纯数字
 */
+ (Boolean)isMobileNum:(NSString *)text;


#pragma mark - 判断email格式是否正确
/**
 *  判断email格式是否正确
 *
 *  @param emailString 邮箱
 *
 *  @return 返回YES为Email格式正确，NO为否
 */
+ (BOOL)isAvailableEmail:(NSString *)emailString;

#pragma mark -隐藏号码中间四位
/**
 *  隐藏号码中间四位
 *
 *  @param mobile 号码
 *
 *  @return 获取中间四位隐藏的号码
 */
+(NSString *)getTheHiddenMobile:(NSString *)mobile;

#pragma mark - 姓名验证
/**
 *  姓名验证
 *
 *  @param name 姓名
 *
 *  @return 返回YES为姓名规格正确，NO为否
 */
+ (BOOL)isValidateName:(NSString *)name;


#pragma mark - 时间戳转时间格式
/**
 *  时间戳转时间格式
 *
 *  @param timestamp    传入时间戳
 *  @param format       格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 普通时间
 */
+ (NSString *)changeTimestampToCommonTime:(long)time
                                   format:(NSString *)format;


#pragma mark - 时间格式转时间戳
/**
 *  时间格式转时间戳
 *
 *  @param time   普通时间
 *  @param format 格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 时间戳
 */
+ (long)changeCommonTimeToTimestamp:(NSString *)time
                             format:(NSString *)format;


#pragma mark - 获取当前使用语言
/**
 *  获取当前使用语言
 *
 *  @return 当前使用语言
 */
+ (NSString *)currentLanguage;


#pragma mark - 打印出项目工程里自定义字体名
/**
 *  打印出项目工程里自定义字体名
 */
+ (void)printCustomFontName;

#pragma mark - 6-14为数字和字母
/**
 *  验证密码格式
 */
+ (BOOL)isValidatePassword:(NSString *)password;

#pragma mark - 根据字符串的长度来计算label的宽
/**
 *  根据字符串的长度来计算label的宽
 *
 *  @param string label上面要显示的字符串
 *  @param font   label上面要显示的字符串的字体大小
 *
 *  @return 返回的是一个CGSize类型的
 */
+ (CGSize)calculationWidthWithStr:(NSString *)string
                         withFont:(CGFloat)font;

#pragma mark - 自适应计算字体长度
/**
 *  自适应计算字体长度
 *
 *  @param tempString 字串
 *  @param font       字号
 *  @param width      label宽度
 *
 *  @return           返回size
 */
+ (CGSize)calculateLengthOfFont:(NSString *)tempString
                       WithFont:(float)font
                   WithlabWidth:(CGFloat)width;

#pragma mark - 获取UILabel宽度

+ (CGFloat)getLabelWidth:(UILabel *)label ;

#pragma mark - 界面pop动画效果
/**
 *  登录界面pop动画效果
 *
 *  @param viewController 旋转的控制器
 */
- (void)popViewControllerAnimatedWithViewController:(UIViewController *)viewController;

#pragma mark - 界面push动画效果
/**
 *  界面push动画效果
 *
 *  @param viewController 旋转的控制器
 */
- (void)pushViewControllerAnimatedWithViewController:(UIViewController *)viewController;

#pragma mark - 设置旋转中心
/**
 *  设置旋转中心
 *
 */
+ (void)setAnchorPoint:(CGPoint)anchorPoint
               forView:(UIView *)view;
#pragma mark - 判断iOS 版本
/**
 *  判断系统版本
 *
 *  @return 是否是iOS8
 */
+ (BOOL)isSystemVersioniOS8;

#pragma mark - 判断截屏
/**
 *  截屏
 *
 *  @return 图片
 */
+ (UIImage *)capture;
#pragma mark - 判断时间
/**
 *  判断时间
 *
 *  @return 多少分钟前
 */
+ (NSString *)stringForAgoFromDate:(NSDate *)fdate
                            toDate:(NSDate *)tdate;
#pragma mark - 获取方向
/**
 *  获取方向
 *
 *  @return 正北方向
 */
+ (NSString *)getHeadingDes:(CGFloat )heading;
#pragma mark - 得到window
/**
 *得到window
 */
+ (UIWindow*)getWindow;
#pragma mark - 比较两个时间的大小
/*
 *比较两个时间的大小
 */
+(int)compareOneDay:(NSDate *)oneDay
     withAnotherDay:(NSDate *)anotherDay;

+(int)compareOneDay:(NSDate *)oneDay
     withAnotherDay:(NSDate *)anotherDay
     withDateFormat:(NSString *)formatString;
#pragma mark - 输入的日期字符串形如：@"1992-05-21"
/**
 *  输入的日期字符串形如：@"1992-05-21"
 */
+ (NSDate *)caseDateFromString:(NSString *)dateString;

#pragma mark - 时间戳转换NSDate
/*
 *时间戳转换NSDate
 */
+ (NSString *)changeTime:(NSTimeInterval)time;
+ (NSString *)changeTimeMethods:(NSTimeInterval)time
                       withType:(NSString *)type;

+ (NSDate *)changeTimeForDate:(NSTimeInterval)time;
#pragma mark - 时间描述
/*
 *时间描述
 */
+ (NSString *)timeToShow:(NSDate *)date02;

#pragma mark - NSDate转换时间戳
/*
 * NSDate转换时间戳
 */
+ (NSDate *)timeStampChangeNSDate:(NSTimeInterval)time;

#pragma mark -判断日期是今天，昨天还是明天
+(NSString *)compareDate:(NSDate *)date;

#pragma mark - 返回数据错误时之行
/**
 *  返回数据错误时之行
 */
+ (void)wrongInformationWithDic:(NSDictionary *)dic
                        Success:(void (^)())success;
+ (NSString *)stringFromDate:(NSDate *)date;

#pragma mark - 获取磁盘总空间大小
/**
 *  获取磁盘总空间大小
 */
+ (CGFloat)diskOfAllSizeMBytes;

#pragma mark - 获取磁盘可用空间大小
/**
 *   获取磁盘可用空间大小
 */
+ (CGFloat)diskOfFreeSizeMBytes;

#pragma mark - 获取指定路径下某个文件的大小
/**
 *   获取指定路径下某个文件的大小
 */
+ (long long)fileSizeAtPath:(NSString *)filePath;

#pragma mark - 获取字符串(或汉字)首字母
/**
 *   获取字符串(或汉字)首字母
 */
+ (NSString *)firstCharacterWithString:(NSString *)string;

#pragma mark - 将字符串数组按照元素首字母顺序进行排序分组
/**
 *  将字符串数组按照元素首字母顺序进行排序分组
 */
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;

#pragma mark - 查询字符串中是否包含某个字符

/**
 *  查询字符串中是否包含某个字符
 *
 *  @param oriString 原始字符串
 *  @param str       包含的字符
 *
 *  @return 是包含   no不包含
 */
+ (BOOL)isString:(NSString *)oriString withContainsStr:(NSString *)str;

#pragma mark - 查找替换字符串
/**
 *  查找替换字符串
 *
 *  @param search  查找的字符
 *  @param replace 要替换为的字符
 *  @param aStr    传入的可变字串
 *
 *  @return 最后的结果
 */
+ (NSString *)trimStringMethodsWithSearch:(NSString *)search
                              withReplace:(NSString *)replace
                                 withTrim:(NSMutableString *)aStr;

#pragma mark - 对图片进行滤镜处理

/**
 *  对图片进行滤镜处理
 */
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image
                          filterName:(NSString *)name;

#pragma mark - 对图片进行模糊处理
/**
 *  对图片进行模糊处理
 */
+ (UIImage *)blurWithOriginalImage:(UIImage *)image
                          blurName:(NSString *)name
                            radius:(NSInteger)radius;

#pragma mark - 调整图片饱和度, 亮度, 对比度
/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

#pragma mark - 截取一张 view 生成图片
/**
 *  截取一张 view 生成图片
 */
+ (UIImage *)shotWithView:(UIView *)view;

#pragma mark - 截取view中某个区域生成一张图片
/**
 *   截取view中某个区域生成一张图片
 */
+ (UIImage *)shotWithView:(UIView *)view
                    scope:(CGRect)scope;

#pragma mark - 压缩图片到指定尺寸大小
/**
 *  压缩图片到指定尺寸大小
 */
+ (UIImage *)compressOriginalImage:(UIImage *)image
                            toSize:(CGSize)size;

#pragma mark - 压缩图片到指定文件大小
/**
 *  压缩图片到指定文件大小
 */
+ (NSData *)compressOriginalImage:(UIImage *)image
              toMaxDataSizeKBytes:(CGFloat)size;

#pragma mark - 返回颜色的图片
/**
 *  返回颜色的图片
 *
 *  @param color        颜色
 *
 *  @return 返回图片
 */
+ (UIImage*) createImageWithColor:(UIColor*)color
                             size:(CGSize)size;

#pragma mark - 获取设备 IP 地址
/**
 *  获取设备 IP 地址
 */
+ (NSString *)getIPAddress;

#pragma mark - 判断字符串中是否含有空格
/**
 *   判断字符串中是否含有空格
 */
+ (BOOL)isHaveSpaceInString:(NSString *)string;

#pragma mark -  判断字符串中是否含有某个字符串
/**
 *  判断字符串中是否含有某个字符串
 */
+ (BOOL)isHaveString:(NSString *)string1
            InString:(NSString *)string2;

#pragma mark -过滤特殊字符
+(BOOL)isIncludeSpecialCharact: (NSString *)aStr;

#pragma mark - 判断字符串中是否含有中文
/**
 *  判断字符串中是否含有中文
 */
+ (BOOL)isHaveChineseInString:(NSString *)string;

#pragma mark - 判断字符串是否全部为数字
/**
 *  判断字符串是否全部为数字
 */
+ (BOOL)isAllNum:(NSString *)string;

#pragma mark - 绘制虚线
/**
 *  绘制虚线
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineCol:(UIColor *)color;

#pragma mark - 获取icon
/**
 *  获取icon
 */
+ (UIImage *)getAppIcon;

#pragma mark - 画线
/**
 *  画线
 */
+(UIView *)createLineframe:(CGRect)frame;
#pragma mark - 获得版本号
/**
 *  获得版本号
 *  @return 版本号Version
 */
+ (NSString *)getBuildVersion;

#pragma mark -六位随机数
/**
 *  @return 六位随机数
 */
+ (NSString *)getSixEvent;


@end

/**
 * NSMutableDictionary扩展-防止字典被塞入nil而崩溃
 */
@interface NSMutableDictionary (setObjectWithNullValidate)

/**
 * 取代setObject:forKey
 */
- (BOOL)setObjectWithNullValidate:(id)anObject forKey:(id <NSCopying>)aKey;

@end
/**
 * NSMutableArray扩展-防止数组被塞入nil而崩溃
 */
@interface NSMutableArray (addObjectWithNullValidate)

/**
 * 取代addObject:
 */
- (BOOL)addObjectWithNullValidate:(id)object;

@end