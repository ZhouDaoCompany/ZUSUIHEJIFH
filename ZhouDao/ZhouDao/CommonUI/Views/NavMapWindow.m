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
static CGFloat kTransitionDuration = 0.3f;
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

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        [self addSubview:self.zd_superView];
        [self initUI];
        [self bounce0Animation];
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
    [self.zd_superView addSubview:headlab];
    
    _dataArrays = [[NSMutableArray alloc] initWithObjects:@"驾车导航",@"步行导航", nil];
    [self.zd_superView addSubview:self.tableView];
    
    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenCancelTapped:^{
        
        [self zd_Windowclose];
    }];
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,60, zd_width-120, 80) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NavCellIdentifier];
    }
    return _tableView;
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
    cell.textLabel.font = Font_16;
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
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    self.alpha = 0.0;
    [UIView commitAnimations];
}
#pragma mark - setters and getters
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        _zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-120, 160)];
        _zd_superView.backgroundColor = [UIColor whiteColor];
        _zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        _zd_superView.layer.cornerRadius = 3.f;
        _zd_superView.clipsToBounds = YES;
    }
    return _zd_superView;
}
#pragma mark -
#pragma mark animation

- (void)bounce0Animation{
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

- (void)bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}
- (void)bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(bounceDidStop)];
    self.zd_superView.transform = [AnimationTools transformForOrientation];
    [UIView commitAnimations];
}

- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(self.zd_superView)
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
