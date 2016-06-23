//
//  CaseFIViewController.m
//  ZhouDao
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseFIViewController.h"
#import "CollectEmptyView.h"

@interface CaseFIViewController ()


@property (nonatomic,strong) CollectEmptyView *emptyView;//收藏为空时候

@end

@implementation CaseFIViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:nil img:@"mine_addNZ"];

    [self.view addSubview:_emptyView];
    
}
#pragma mark -UITableViewDataSource

#pragma mark - event response
-(void)rightBtnAction
{
    
    
}
#pragma mark - private methods

#pragma mark - getters and setters 
- (CollectEmptyView *)emptyView
{
    if (_emptyView == nil) {
        
        _emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64.f)
                                                    WithText:@"暂无财务信息"];
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
