//
//  AppDelegate.h
//  ZhouDao
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

}
@property (strong, nonatomic) UIWindow *window;

@end

/*
 
 // MARK:应该使用US英语
 UIColor *myColor = [UIColor whiteColor];
 
 // MARK:代码组织
 #pragma mark - Lifecycle
 - (instancetype)init {}
 - (void)dealloc {}
 - (void)viewDidLoad {}
 - (void)viewWillAppear:(BOOL)animated {}
 - (void)didReceiveMemoryWarning {}
 #pragma mark - Custom Accessors
 - (void)setCustomProperty:(id)value {}
 - (id)customProperty {}
 #pragma mark - IBActions
 - (IBAction)submitData:(id)sender {}
 #pragma mark - Public
 - (void)publicMethod {}
 #pragma mark - Private
 - (void)privateMethod {}
 #pragma mark - Protocol conformance
 #pragma mark - UITextFieldDelegate
 #pragma mark - UITableViewDataSource
 #pragma mark - UITableViewDelegate
 #pragma mark - NSCopying
 - (id)copyWithZone:(NSZone *)zone {}
 #pragma mark - NSObject
 - (NSString *)description {}
 
 
 if (user.isHappy) {
 //Do something
 } else {
 //Do something else
 }
 
 [UIView animateWithDuration:1.0 animations:^{
 // something
 } completion:^(BOOL finished) {
 // something
 }];
 
 UIButton *settingsButton;
 
 static NSTimeInterval const RWTTutorialViewControllerNavigationFadeAnimationDuration = 0.3;
 @property (strong, nonatomic) NSString *descriptiveVariableName;
 
 - (void)setExampleText:(NSString *)text image:(UIImage *)image;
 - (void)sendAction:(SEL)aSelector to:(id)anObject forAllCells:(BOOL)flag;
 - (id)viewWithTag:(NSInteger)tag;
 - (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height;
 
 objc
 NSInteger arrayCount = [self.array count];
 view.backgroundColor = [UIColor orangeColor];
 [UIApplication sharedApplication].delegate;
 
 NSArray *names = @[@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul"];
 NSDictionary *productManagers = @{@"iPhone": @"Kate", @"iPad": @"Kamal", @"Mobile Web": @"Bill"};
 NSNumber *shouldUseLiterals = @YES;
 NSNumber *buildingStreetNumber = @10018;
 
 
 static NSString * const RWTAboutViewControllerCompanyName = @"RayWenderlich.com";
 static CGFloat const RWTImageThumbnailHeight = 50.0;
 
 typedef NS_ENUM(NSInteger, RWTGlobalConstants) {
 RWTPinSizeMin = 1,
 RWTPinSizeMax = 5,
 RWTPinCountMin = 100,
 RWTPinCountMax = 500,
 };
 
 switch (condition) {
 case 1:
 // ... break;
 case 2: {
 // ...
 // Multi-line example using braces
 break;
 }
 case 3:
 // ...
 break;
 default:
 // ... break;
 }
 if (someObject) {}
 if (![anotherObject boolValue]) {}
 
 NSInteger value = 5;
 result = (value != 0) ? x : y;
 BOOL isHorizontal = YES;
 result = isHorizontal ? x : y;
 
 - (instancetype)init {
 self = [super init];
 if (self) {
 // ...
 }
 return self;
 }
 
 CGRect frame = self.view.frame;
 CGFloat x = CGRectGetMinX(frame);
 CGFloat y = CGRectGetMinY(frame);
 CGFloat width = CGRectGetWidth(frame);
 CGFloat height = CGRectGetHeight(frame);
 CGRect frame = CGRectMake(0.0, 0.0, width, height);
 
 - (void)someMethod {
 if (![someOther boolValue]) {
 return;
 }
 //Do something important
 }
 
 
 + (instancetype)sharedInstance {
 static id sharedInstance = nil;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 sharedInstance = [[self alloc] init];
 });
 return sharedInstance;
 }
 
 一行很长的代码应该分成两行代码，下一行用两个空格隔开
 self.productsRequest = [[SKProductsRequest alloc]
 initWithProductIdentifiers:productIdentifiers];
 
 
 */
