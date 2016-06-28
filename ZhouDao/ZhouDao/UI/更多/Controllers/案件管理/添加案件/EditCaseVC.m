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
{
    BOOL _isEdit;
}

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
    
//    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"case_edit"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"编辑" img:nil];

    self.fd_interactivePopDisabled = YES;//禁止滑回

    if (_editType == EditAccusing) {
        //非讼业务
        AccusingTheTabVC *accusingVC = [AccusingTheTabVC new];
        accusingVC.accType = AccFromManager;
        
        NSArray *detailArr = _dataDict[@"detailed"];
        accusingVC.basicModel = [[BasicModel alloc] initWithDictionary:detailArr[0]];
        
        accusingVC.editSuccess = ^(NSString *name){
            weakSelf.editSuccess(name);
        };
        accusingVC.caseId = _caseId;
        [self addChildViewController:accusingVC];
    }else if(_editType == EditConsultant){
        //法律顾问
        ConsultantTabVC *conVC = [ConsultantTabVC new];
        conVC.ConType = ConFromManager;
        
        NSArray *arr = _dataDict[@"more"];
        NSMutableArray *moreArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MoreModel *moreModel = [[MoreModel alloc] initWithDictionary:objDic];
            [moreArr addObject:moreModel];
        }];
        
        conVC.moreArr = moreArr;
        NSArray *detailArr = _dataDict[@"detailed"];
        conVC.basicModel = [[BasicModel alloc] initWithDictionary:detailArr[0]];

        
        conVC.editSuccess = ^(NSString *name){
            weakSelf.editSuccess(name);
        };
        conVC.caseId = _caseId;
        [self addChildViewController:conVC];
    }else{
        //诉讼业务
        LitigationTabVC *litigationVC = [LitigationTabVC new];
        litigationVC.litEditType = LitiDetails;
        litigationVC.caseId = _caseId;
//        litigationVC.moreModel = _dataDict[@"more"];
        
        NSArray *arr = _dataDict[@"more"];
        NSMutableArray *moreArr = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MoreModel *moreModel = [[MoreModel alloc] initWithDictionary:objDic];
            [moreArr addObject:moreModel];
        }];
        
        litigationVC.editSuccess = ^(NSString *name){
            weakSelf.editSuccess(name);
        };
        litigationVC.moreArr = moreArr;
        NSArray *detailArr = _dataDict[@"detailed"];
        litigationVC.basicModel = [[BasicModel alloc] initWithDictionary:detailArr[0]];
        [self addChildViewController:litigationVC];
    }
    
    UITableViewController *tableVC = [self.childViewControllers firstObject];
    tableVC.view.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64.f);
    [self.view addSubview:tableVC.view];

}
- (void)rightBtnAction
{
    _isEdit = !_isEdit;
    
    if (_isEdit == YES) {
        [self.rightBtn setTitle:@"完成" forState:0];
    }else {
        [self.rightBtn setTitle:@"编辑" forState:0];
    }
    
    if (_editType == EditAccusing) {
        
        AccusingTheTabVC *vc = (AccusingTheTabVC *)[self.childViewControllers firstObject];
        vc.isEdit = _isEdit;
        
    }else if(_editType == EditConsultant){
        
        ConsultantTabVC *vc = (ConsultantTabVC *)[self.childViewControllers firstObject];
        vc.isEdit = _isEdit;

    }else{
        LitigationTabVC *vc = (LitigationTabVC *)[self.childViewControllers firstObject];
        vc.isEdit = _isEdit;
    }
    
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
