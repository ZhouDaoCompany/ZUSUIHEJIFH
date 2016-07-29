//
//  NavMapWindow.m
//  ZhouDao
//
//  Created by cqz on 16/3/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NavMapWindow.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

static NSString *const NavCellIdentifier = @"NavCellIdentifier";

@interface NavMapWindow()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArrays;

@end

@implementation NavMapWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-120, 180)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.borderWidth = 1.f;
        self.zd_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.zd_superView.layer.cornerRadius = 5.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        [self initUI];
        [self makeKeyAndVisible];
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-120, 60)];
    headView.backgroundColor  = [UIColor clearColor];
    [self.zd_superView addSubview:headView];
    
    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, zd_width-150, 20)];
    headlab.text = @"选择导航方式";
    headlab.textAlignment = NSTextAlignmentLeft;
    headlab.font = Font_18;
//    headlab.textColor = [UIColor whiteColor];
    [self.zd_superView addSubview:headlab];
    
    
    _dataArrays = [[NSMutableArray alloc] initWithObjects:@"驾车导航",@"步行导航", nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,80, zd_width-120, 80) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.zd_superView addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NavCellIdentifier];
    
    
    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenCancelTapped:^{
        
        [self zd_Windowclose];
    }];

    
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:NavCellIdentifier];
    if (_dataArrays.count >0){
        cell.textLabel.text = _dataArrays[indexPath.row];
    }
    cell.textLabel.textColor = thirdColor;
    cell.textLabel.font = Font_15;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = _dataArrays[indexPath.row];
    
    self.navBlock(str);
    
    [self zd_Windowclose];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}
- (void)startNavEvent:(id)sender
{
    DLog(@"点击去导航按钮");
    
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.zd_superView.center = CGPointMake(zd_width/2.0,-230);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
