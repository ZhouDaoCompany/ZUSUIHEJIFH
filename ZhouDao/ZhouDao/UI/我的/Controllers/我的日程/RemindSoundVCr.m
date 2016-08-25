//
//  RemindSoundVCr.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RemindSoundVCr.h"
#import "SoundManager.h"
static NSString *const ReindCellIdentifier = @"ReindCellIdentifier";

@interface RemindSoundVCr ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger _currentRow;
}
@property (nonatomic, strong) NSMutableArray *titArrays;//铃声标题
@property (nonatomic, strong) NSMutableArray *nameArrays;//铃声名字
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation RemindSoundVCr
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [[SoundManager sharedSoundManager] musicStop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    self.fd_interactivePopDisabled = YES;

    _currentRow = 0;
    [self setupNaviBarWithTitle:@"提醒音效"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _titArrays = [NSMutableArray arrayWithObjects:@"系统音效",@"合同到期(女声)",@"开会提醒(女声)",@"开庭提醒(女声)",@"合同到期(男声)",@"开会提醒(男声)",@"开庭提醒(男声)", nil];
    _nameArrays = [NSMutableArray arrayWithObjects:@"defaultSound",@"woman_contract",@"woman_meeting",@"woman_court",@"man_contract",@"man_meeting",@"man_court", nil];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,84, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReindCellIdentifier];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReindCellIdentifier];
    cell.textLabel.text = _titArrays[indexPath.row];
    cell.textLabel.font = Font_15;
    cell.textLabel.textColor = THIRDCOLOR;
    if (_currentRow == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameStr = _nameArrays[indexPath.row];
    [[SoundManager sharedSoundManager] setMusicName:nameStr];

    _currentRow = indexPath.row;
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (void)leftBtnAction
{
    _stringBlock(_titArrays[_currentRow]);
    [self.navigationController popViewControllerAnimated:YES];
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
