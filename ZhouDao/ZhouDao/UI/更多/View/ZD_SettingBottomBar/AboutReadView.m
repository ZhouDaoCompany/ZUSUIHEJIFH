//
//  AboutReadView.m
//  ZhouDao
//
//  Created by cqz on 16/4/4.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AboutReadView.h"
#import "LawsDataModel.h"
static NSString *const aboutIdentifier = @"aboutIdentifier";
@interface AboutReadView()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;//背景view
@property (nonatomic, strong) UIView *botomView;

@end

@implementation AboutReadView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (void)setAboutArrays:(NSMutableArray *)aboutArrays
{
    _aboutArrays = nil;
    _aboutArrays = aboutArrays;
    [_tableView reloadData];
}
- (void)initView
{
    _aboutArrays = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    UIView *views = [[UIView alloc] initWithFrame:self.bounds];
    views.backgroundColor = [UIColor blackColor];
    views.alpha = .3f;
    _bgView = views;
    [self addSubview:_bgView];
    [_bgView whenCancelTapped:^{
        [self selfDismiss];
    }];
    
    UIView * botomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 266.f)];
    botomView.backgroundColor = [UIColor whiteColor];
    _botomView = botomView;
    [self addSubview:_botomView];
    [_botomView whenCancelTapped:^{
        
    }];
    
    //head
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, botomView.frame.size.width, 66.f)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *listLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 23, 100, 20.f)];
    listLab.text = @"相关阅读";
    listLab.font = [UIFont boldSystemFontOfSize:17.f];
    listLab.textColor = thirdColor;
    [headView  addSubview:listLab];
    [_botomView addSubview:headView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
    closeBtn.titleLabel.font = Font_15;
    closeBtn.frame = CGRectMake(botomView.frame.size.width -45, 18, 30, 30);
    [closeBtn addTarget:self action:@selector(clostListEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Orgin_y(headView),botomView.frame.size.width , 180.f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_botomView addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:aboutIdentifier];
    
    [UIView animateWithDuration:0.35 animations:^{
        _botomView.frame = CGRectMake(0, height-266.f, width,266.f);
    }];
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_aboutArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:aboutIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = Font_15;
    cell.textLabel.textColor = sixColor;
    if (_aboutArrays.count >0) {
         LawsDataModel *model = _aboutArrays[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawsDataModel *model = _aboutArrays[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(lookAboutLawsWith:)])
    {
        [self.delegate lookAboutLawsWith:model.id];
    }
}
#pragma mark -UIButtonEvent
- (void)clostListEvent:(id)sender
{
    [self selfDismiss];
}

- (void)selfDismiss
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    [UIView animateWithDuration:0.35f animations:^{
        _botomView.frame = CGRectMake(0, height, width, 266.f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)dealloc
{
    self.tableView = nil;
    self.bgView = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
