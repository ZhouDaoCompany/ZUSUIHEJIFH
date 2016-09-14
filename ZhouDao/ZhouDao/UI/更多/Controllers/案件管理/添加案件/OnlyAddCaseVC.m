//
//  OnlyAddCaseVC.m
//  ZhouDao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "OnlyAddCaseVC.h"
#import "LitigationTabVC.h"//诉讼业务
#import "AccusingTheTabVC.h"// 非诉业务
#import "ConsultantTabVC.h"// 法律顾问

@interface OnlyAddCaseVC ()

@end

@implementation OnlyAddCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
}
- (void)initUI
{
    WEAKSELF;
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    if (_addType == AddAccusing) {
        
        [self setupNaviBarWithTitle:@"添加非诉业务"];

        //非诉
        AccusingTheTabVC *accusingVC = [AccusingTheTabVC new];
        accusingVC.accType = AccFromAddCase;
        accusingVC.addSuccess = ^(){
            
            weakSelf.addSuccessBlock();
        };

        [self addChildViewController:accusingVC];

    }else if (_addType == AddConsultant){
        
        [self setupNaviBarWithTitle:@"添加法律顾问"];
        //法律顾问
        ConsultantTabVC *conVC = [ConsultantTabVC new];
        conVC.ConType = ConFromAddCase;
        conVC.addSuccess = ^(){
            
            weakSelf.addSuccessBlock();
        };

        [self addChildViewController:conVC];
        
    }else{
        
        [self setupNaviBarWithTitle:@"添加诉讼业务"];

        //诉讼
        LitigationTabVC *VC = [LitigationTabVC new];
        VC.litEditType = LitiAddCase;
        VC.addSuccess = ^(){
           
            weakSelf.addSuccessBlock();
        };
        [self addChildViewController:VC];
    }
    
    UITableViewController *tableVC = [self.childViewControllers firstObject];
    tableVC.view.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64.f);
    [self.view addSubview:tableVC.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
