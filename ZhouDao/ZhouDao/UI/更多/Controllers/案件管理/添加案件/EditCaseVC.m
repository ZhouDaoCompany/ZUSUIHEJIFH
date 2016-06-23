//
//  EditCaseVC.m
//  ZhouDao
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "EditCaseVC.h"
#import "LitigationTabVC.h"//诉讼业务
#import "AccusingTheTabVC.h"// 非诉业务
#import "ConsultantTabVC.h"// 法律顾问

@interface EditCaseVC ()

@end

@implementation EditCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{WEAKSELF;
    [self setupNaviBarWithTitle:@"案件编辑"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    self.fd_interactivePopDisabled = YES;//禁止滑回

    if (_editType == EditAccusing) {
        //非讼业务
        AccusingTheTabVC *accusingVC = [AccusingTheTabVC new];
        accusingVC.accType = AccFromManager;
        accusingVC.msgArr = _msgArrays;
        accusingVC.editSuccess = ^(NSMutableArray *arr){
            weakSelf.editSuccess(arr);
        };
        accusingVC.caseId = _caseId;
        [self addChildViewController:accusingVC];
    }else if(_editType == EditConsultant){
        //法律顾问
        ConsultantTabVC *conVC = [ConsultantTabVC new];
        conVC.ConType = ConFromManager;
        conVC.editSuccess = ^(NSMutableArray *arr){
            weakSelf.editSuccess(arr);
        };
        conVC.msgArr = _msgArrays;
        conVC.caseId = _caseId;
        [self addChildViewController:conVC];
    }else{
        //诉讼业务
        LitigationTabVC *litigationVC = [LitigationTabVC new];
        litigationVC.litEditType = FromManager;
        litigationVC.caseId = _caseId;
        litigationVC.editSuccess = ^(NSMutableArray *arr){
            weakSelf.editSuccess(arr);
        };
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:_msgArrays[0]];
        [tempArr addObject:_msgArrays[2]];
        [tempArr addObject:_msgArrays[3]];
        [tempArr addObject:_msgArrays[5]];
        [tempArr addObject:_msgArrays[4]];
        [tempArr addObject:_msgArrays[1]];
        
        for (NSUInteger i=6; i<_msgArrays.count; i++) {
            NSString *obj = _msgArrays[i];
            [tempArr addObject:obj];
        }

        litigationVC.msgArr = tempArr;
        [self addChildViewController:litigationVC];
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
