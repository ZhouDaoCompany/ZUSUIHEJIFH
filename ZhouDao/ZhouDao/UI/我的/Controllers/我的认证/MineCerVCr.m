//
//  MineCerVCr.m
//  ZhouDao
//
//  Created by cqz on 16/3/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MineCerVCr.h"
#import "ImmediatelyVC.h"

static NSString *const cellIdentifer = @"cellIdentifer";
@interface MineCerVCr ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView *cerImgView;//认证图片
@property (nonatomic,copy)  NSString *navTitle;//标题
@property (nonatomic,copy)  NSString *cerImage;
@property (nonatomic,strong) NSArray *titleArrays;//标题数组

@end

@implementation MineCerVCr
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
//    self.statusBarView.backgroundColor = [UIColor whiteColor];
//    self.naviBarView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = ViewBackColor;

    _titleArrays = [NSArray arrayWithObjects:@"1、参与新功能的产品设计；",@"2、优先体验新的产品服务;",@"3、直送1000兆案件管理免费存储空间；",@"4、优先适配优质客户资源。", nil];
    _cerImage = nil;
    _navTitle = nil;
    if ([[PublicFunction ShareInstance].m_user.data.is_certification isEqualToString:@"1"])
    {
        [self setupNaviBarWithBtn:NaviRightBtn title:@"立即认证" img:nil];
        self.rightBtn.titleLabel.font = Font_14;
//        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#00c8aa"] forState:0];
        _cerImage = @"mine_nobanner.jpg";
        _navTitle = @"我的认证";
    }else{
        _cerImage = @"mine_banner.jpg";
        _navTitle = @"已认证";
    }
//    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self setupNaviBarWithTitle:_navTitle];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

//    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"blackBack"];
    
    _cerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenWidth*8/15.f)];
    _cerImgView.image = [UIImage imageNamed:_cerImage];
    [self.view addSubview:_cerImgView];
    
    //特权说明
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(_cerImgView) +10, kMainScreenWidth-30, 20)];
    lab.text = @"特权说明";
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:lab];
    
    //表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(15,Orgin_y(lab) + 10, kMainScreenWidth-30.f, 180.f) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifer];
    
//    tableView.layer.masksToBounds = YES;
//    tableView.layer.cornerRadius = .5f;
    tableView.layer.borderColor = [UIColor colorWithHexString:@"#D7D7D7"].CGColor;
    tableView.layer.borderWidth = 1.f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = Font_15;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.textLabel.text = _titleArrays[indexPath.row];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, kMainScreenWidth-30.f, .5f)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    [cell.contentView addSubview:line];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
#pragma UIButtonEvent
- (void)rightBtnAction
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[PublicFunction ShareInstance].m_user.data.is_certification isEqualToString:@"1"])
    {
     [NetWorkMangerTools getApplyInfoRequestSuccess:^{
         ImmediatelyVC *vc = [ImmediatelyVC new];
         vc.cerType = FrommMineSetting;
         [self.navigationController pushViewController:vc animated:YES];
     }];
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
