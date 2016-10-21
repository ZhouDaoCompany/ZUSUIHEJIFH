//
//  ViewController.m
//  ZhouDao_NetWorkManger
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ViewController.h"
#import "ZhouDao_NetWorkManger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    // 配置请求和响应类型，由于部分伙伴们的服务器不接收JSON传过去，现在默认值改成了plainText
    [ZhouDao_NetWorkManger configRequestType:kZDRequestTypePlainText
                        responseType:kZDResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];

    NSString *url = @"http://zapi.zhoudao.cc/pro/api_recom.php?key=16248ef5&c=indexAll";
    
//    [ZhouDao_NetWorkManger cancelRequestWithURL:url];

    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:YES success:^(id response) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"json" message:[NSString stringWithFormat:@"%@",response] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"888888888888888888---------%@",response);

    } fail:^(NSError *error) {
    }];
//    [ZhouDao_NetWorkManger getWithUrl:url sg_cache:YES params:nil progress:^(int64_t bytesRead, int64_t totalBytesRead) {
//            NSLog(@"progress: %f, cur: %lld, total: %lld",
//                  (bytesRead * 1.0) / totalBytesRead,
//                  bytesRead,
//                  totalBytesRead);
//        
//    } success:^(id response) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"json" message:[NSString stringWithFormat:@"%@",response] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//        [alertView show];
//        NSLog(@"888888888888888888---------%@",response);
////        [ZhouDao_NetWorkManger clearCaches];
//    } fail:^(NSError *error) {
//        
//    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
