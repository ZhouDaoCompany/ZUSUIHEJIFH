//
//  Disability_AlertView.m
//  ZhouDao
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "Disability_AlertView.h"

@interface Disability_AlertView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *zd_superView;

@end

@implementation Disability_AlertView

- (id)initWithFrame:(CGRect)frame
           withType:(NSUInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma mark - private

#pragma mark - setter and getter
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        
    }
    return _zd_superView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        
    }
    return _tableView;
}
@end
