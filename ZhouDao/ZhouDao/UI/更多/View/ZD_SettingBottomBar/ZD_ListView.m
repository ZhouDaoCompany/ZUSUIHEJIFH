//
//  ZD_ListView.m
//  ZhouDao
//
//  Created by cqz on 16/3/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZD_ListView.h"
static NSString *const listIdentifier = @"listIdentifier";
@interface ZD_ListView()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;//背景view
@property (nonatomic, strong) UIView *botomView;

@end

@implementation ZD_ListView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initView];
    }
    
    return self;
}
- (void)setListArrays:(NSMutableArray *)listArrays
{
    _listArrays = nil;
    _listArrays = listArrays;
    
}

- (void)initView
{
    
    _listArrays = [NSMutableArray array];
    
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
    
    UIView * botomView = [[UIView alloc] initWithFrame:CGRectMake(width, 64, width-125, height -64)];
    botomView.backgroundColor = [UIColor whiteColor];
    _botomView = botomView;
    [self addSubview:_botomView];
    [_botomView whenCancelTapped:^{
        
    }];
    
    //head
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, botomView.frame.size.width, 46.f)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *listLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 46.f)];
    listLab.text = @"目录";
    listLab.font = [UIFont boldSystemFontOfSize:18.f];
    listLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [headView  addSubview:listLab];
    [_botomView addSubview:headView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
    closeBtn.titleLabel.font = Font_15;
    closeBtn.frame = CGRectMake(botomView.frame.size.width -45, 8, 30, 30);
    [closeBtn addTarget:self action:@selector(clostListEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Orgin_y(headView),botomView.frame.size.width , botomView.frame.size.height -46.f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_botomView addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:listIdentifier];
    
    [UIView animateWithDuration:0.35 animations:^{
        _botomView.frame = CGRectMake(125, 64, width-125, height -64);
    }];
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:listIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = Font_14;
    if (_listArrays.count >0) {
        cell.textLabel.text = _listArrays[indexPath.row];
    }
    return cell;
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
        _botomView.frame = CGRectMake(width, 64, width-125, height -64);
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
