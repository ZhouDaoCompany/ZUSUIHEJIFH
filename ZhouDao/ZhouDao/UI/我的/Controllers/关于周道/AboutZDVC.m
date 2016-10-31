//
//  AboutZDVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AboutZDVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <StoreKit/StoreKit.h>
#import "ShareView.h"
#import "MenuLabel.h"

@interface AboutZDVC ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic)  UIImageView *logoImgView;
@property (strong, nonatomic)  UILabel *versionLab;

@end

@implementation AboutZDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNaviBarWithBackAndTitle:@"关于周道"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"" img:@"backVC"];
    
    _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 74.f)/2.f, 134, 74, 74)];
    _logoImgView.image = [UIImage imageNamed:@"login_logo"];
    [self.view addSubview:_logoImgView];

    _versionLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 233, kMainScreenWidth - 120, 20)];
    _versionLab.textColor = THIRDCOLOR;
    _versionLab.font = Font_18;
    _versionLab.textAlignment = NSTextAlignmentCenter;
    _versionLab.numberOfLines = 1;
    _versionLab.text = @"周道慧法";
    [self.view addSubview:_versionLab];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(60, Orgin_y(_versionLab)+2 ,kMainScreenWidth - 120 , 18)];
    lab.textColor = _versionLab.textColor;
    lab.text = [NSString stringWithFormat:@"版本号: V%@",[self getVersion]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = Font_14;
    [self.view addSubview:lab];
    //加阴影
    
    UIImageView *shadowImg = [[UIImageView alloc] init];
    shadowImg.image = [UIImage imageNamed:@"mine_shadow"];
    shadowImg.center =  CGPointMake(kMainScreenWidth/2.f, _logoImgView.center.y + 37);
    shadowImg.bounds = CGRectMake(0, 0, 118, 14.f);
    [self.view addSubview:shadowImg];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,Orgin_y(_versionLab) +45, kMainScreenWidth, 90) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5f, kMainScreenWidth-15.f, .5f)];
    lineView.backgroundColor = LINECOLOR;
    [cell.contentView addSubview:lineView];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"支持我们，打分鼓励";
        lineView.hidden = NO;
    }else{
        cell.textLabel.text = @"分享给小伙伴";
        lineView.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = LRRGBColor(43, 44, 45);
    cell.textLabel.font = Font_15;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self openAppStoreEvent];
    }else{
        NSString *title = @"周道慧法";
        NSString *contentString = @"周道慧法 - 一款律师专属智能化办公工具";
        NSString *url = @"http://www.zhoudao.cc/mobile/pro.html";
        NSString *imgUrlString = @"";

//        NSString *url = @"https://itunes.apple.com/cn/app/zhou-dao-hui-fa/id1105833212?mt=8";
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,imgUrlString, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];
//        NSString *shareText = @"分享的文字";        //分享内嵌文字
//        UIImage *shareImage = [UIImage imageNamed:@"login_logo"];          //分享内嵌图片
//        
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a07545.atobo.com.cn";
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a07545.atobo.com.cn";
//        [UMSocialData defaultData].extConfig.qqData.url = @"http://a07545.atobo.com.cn";
//
//        NSArray *arrays = [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina, nil];
//        
//        //调用快速分享接口
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:UMENG_APPKEY
//                                          shareText:shareText
//                                         shareImage:shareImage
//                                    shareToSnsNames:arrays
//                                           delegate:self];

    }
}
#pragma mark -跳转App Store
- (void)openAppStoreEvent
{
    //第一种方法  直接跳转
    // https://itunes.apple.com/cn/app/zhou-dao-zhi-fa-zui-xin-fa/id1077638513?mt=8
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1105833212"]];
    
//    //第二中方法  应用内跳转
//    //1:导入StoreKit.framework,控制器里面添加框架#import <StoreKit/StoreKit.h>
//    //2:实现代理SKStoreProductViewControllerDelegate
//    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
//    storeProductViewContorller.delegate = self;
//    //        ViewController *viewc = [[ViewController alloc]init];
//    //        __weak typeof(viewc) weakViewController = viewc;
//    
//    //加载一个新的视图展示
//    [storeProductViewContorller loadProductWithParameters:
//     //appId
//     @{SKStoreProductParameterITunesItemIdentifier : @"1077638513"} completionBlock:^(BOOL result, NSError *error) {
//         //回调
//         if(error){
//             NSLog(@"错误%@",error);
//         }else{
//             //AS应用界面
//             [self presentViewController:storeProductViewContorller animated:YES completion:nil];
//         }
//     }];
//
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController __TVOS_PROHIBITED NS_AVAILABLE_IOS(6_0);
{
    //点击取消后的操作
}
-(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    return app_Version;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - UIAlertViewDelegate
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (alertView.tag == 2201) {
 if (buttonIndex == 1) {
 
 [self openAppStoreEvent];
 }
 }
 //    [UMessage sendClickReportForRemoteNotification:self.userInfo];
 
 }
 #pragma mark -跳转App Store
 - (void)openAppStoreEvent
 {
 //第一种方法  直接跳转
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1105833212"]];
 //    exit(0);
 }
 - (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController __TVOS_PROHIBITED NS_AVAILABLE_IOS(6_0);
 {
 //点击取消后的操作
 }
 
 
 //    [NetWorkMangerTools checkHistoryVersionRequestSuccess:^(NSString *desc) {
 //
 //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本了马上更新" message:desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
 //        alert.tag = 2201;
 //        [alert show];
 //    }];

 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
