//
//  TingShiListVC.m
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiListVC.h"
#import "AddTingShiVC.h"
#import "CollectEmptyView.h"

@interface TingShiListVC ()<CollectEmptyViewPro>

@property (nonatomic, strong) CollectEmptyView *emptyView;
@end

@implementation TingShiListVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}
#pragma mark - methods

- (void)initUI {
    
    [self setupNaviBarWithTitle:@"庭室信息"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];
    
    [self.view addSubview:self.emptyView];

}
- (void)rightBtnAction {
    
    //添加庭室信息
    
    AddTingShiVC *addVC = [AddTingShiVC new];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - CollectEmptyViewPro
- (void)clickAddText {
    
    [self rightBtnAction];
}
#pragma mark - setter and getter

- (CollectEmptyView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[CollectEmptyView alloc] initTingShiTheDefaultWithDelegate:self];
    }
    return _emptyView;
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
