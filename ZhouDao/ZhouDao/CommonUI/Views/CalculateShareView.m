//
//  CalculateShareView.m
//  ZhouDao
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CalculateShareView.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

#define kContentLabelWidth     4.f/5.f*([UIScreen mainScreen].bounds.size.width)

static NSString *const CALCULATECellID = @"CalculateShareViewCellIdentifier";

@interface CalculateShareView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, strong) UIButton *cancleButtons;

@end

@implementation CalculateShareView

- (id)initWithDelegate:(id<CalculateShareDelegate>)delegate
{
    self = [super initWithFrame:kMainScreenFrameRect];
    
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        _delegate = delegate;
        [self initUI];
        
    }
    return self;
}

#pragma mark - private methods

- (void)initUI{WEAKSELF;
    
    [self addSubview:self.zd_superView];
    [self.zd_superView addSubview:self.tableView];
    [self.zd_superView addSubview:self.cancleButtons];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.4f, kContentLabelWidth, .6f)];
    lineView.backgroundColor = LINECOLOR;
    [_zd_superView addSubview:lineView];


    [UIView animateWithDuration:1.f delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
    } completion:^(BOOL finished) {
    }];

}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CALCULATECellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CALCULATECellID];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.4f, kContentLabelWidth - 15, .6f)];
    lineView.backgroundColor = LINECOLOR;
    [cell.contentView addSubview:lineView];
    lineView.hidden = (indexPath.row == 2)?YES:NO;
    
    cell.textLabel.font = Font_14;
    cell.textLabel.textColor = hexColor(333333);
    
    NSArray *titleArrays = @[@"分享计算器",@"分享计算结果",@"导出为Word文档"];
    cell.textLabel.text = titleArrays[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(clickIsWhichOne:)]) {
        
        [self.delegate clickIsWhichOne:indexPath.row];
    }
    [self zd_Windowclose];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - event response
- (void)cancelButtonEvent:(UIButton *)btn
{
    [self zd_Windowclose];
}
- (void)zd_Windowclose
{WEAKSELF;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:3.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        weakSelf.zd_superView.center = CGPointMake(self.center.x, self.center.y + self.frame.size.height);
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}
- (void)show
{
    UIWindow *window = [QZManager getWindow];
    [window addSubview:self];
}

#pragma mark - setter and getter 

- (UIView *)zd_superView
{
    if (!_zd_superView) {
        _zd_superView = [[UIView alloc] initWithFrame:CGRectMake((kMainScreenWidth - kContentLabelWidth)/2.f,kMainScreenHeight, kContentLabelWidth,185)];
        _zd_superView.backgroundColor = [UIColor whiteColor];
        _zd_superView.layer.cornerRadius = 3.f;
        _zd_superView.clipsToBounds = YES;
    }
    return _zd_superView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, kContentLabelWidth, self.zd_superView.frame.size.height - 50.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (UIButton *)cancleButtons
{
    if (!_cancleButtons) {
        _cancleButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButtons.frame = CGRectMake(15,10, 40, 40);
        _cancleButtons.backgroundColor  = [UIColor whiteColor];
        [_cancleButtons setTitleColor:hexColor(333333) forState:0];
        [_cancleButtons setTitle:@"取消" forState:0];
        _cancleButtons.titleLabel.font = Font_15;
        _cancleButtons.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cancleButtons.tag = 3133;
        [_cancleButtons addTarget:self action:@selector(cancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButtons;
}
@end
