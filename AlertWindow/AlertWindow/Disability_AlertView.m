//
//  Disability_AlertView.m
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "Disability_AlertView.h"
#import "DisabilityViewCell.h"
#import "ConsultantHeadView.h"
#import "DefineHeader.h"
#import "UIColor+Helper.h"

#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height
#define LabelX                 13.f/80.f*([UIScreen mainScreen].bounds.size.width)

#define kContentLabelWidth     4.f/5.f*([UIScreen mainScreen].bounds.size.width)
static NSString *const DISABLITYCellID = @"DisabilityCellIdentifier";

@interface Disability_AlertView()<UITableViewDataSource,UITableViewDelegate,DisabilityViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, strong) UILabel *headlab ;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@end

@implementation Disability_AlertView

- (id)initWithType:(DisabilityType)type withDelegate:(id<Disability_AlertViewPro>)delegate
{
    self = [super initWithFrame:kMainScreenFrameRect];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];

        if (type == DisabilityGradeType) {
            
            _type = DisabilityGradeType;
            [self disabilityGradeSelectUI];
        }else {
            _type = CaseType;
            [self caseTypeSelectUI];
        }
    }
    return self;
}
#pragma mark -  methods
#pragma mark - 伤残等级选择
- (void)disabilityGradeSelectUI
{WEAKSELF;
    
    [self addSubview:self.zd_superView];
    [UIView animateWithDuration:1.f delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
    } completion:^(BOOL finished) {
    }];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(LabelX, 45, 60, 30)];
    lab1.backgroundColor = [UIColor clearColor];
    lab1.text = @"等级";
    lab1.textColor = hexColor(999999);
    lab1.font = Font_13;
    [self.zd_superView addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(kContentLabelWidth - 115, 45.f, 90, 30)];
    lab2.backgroundColor = [UIColor clearColor];
    lab2.text = @"几处";
    lab2.textColor = hexColor(999999);
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = Font_13;
    [self.zd_superView addSubview:lab2];


    [self.zd_superView addSubview:self.headlab];
    [self.zd_superView addSubview:self.tableView];
    [self.zd_superView addSubview:self.sureBtn];
    
    _headlab.text = @"设置伤残等级";
    
}
#pragma mark - 案件类型选择
- (void)caseTypeSelectUI
{WEAKSELF;
    
    [self addSubview:self.zd_superView];
    [UIView animateWithDuration:1.f delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
    } completion:^(BOOL finished) {
    }];
    [self.zd_superView addSubview:self.headlab];
    [self.zd_superView addSubview:self.tableView];
    
    _tableView.frame = CGRectMake(0,45, kContentLabelWidth, self.zd_superView.frame.size.height - 109.f);
    [self.zd_superView addSubview:self.sureBtn];
    _headlab.text = @"选择案件类型";
    
    _dataSourceArrays = [NSMutableArray arrayWithObjects:@[@"财产案件"],@[@"离婚案件",@"人格权案件",@"知识产权案件",@"劳动争议案件",@"财产保全案件",@"管辖权异议不成立的案件"],@[@"商标、专利、海事行政案件",@"其他行政案件"],@[@"支付令",@"公示催告"],nil];
    
}
#pragma mark - event response
- (void)sureButtonEvent:(UIButton *)btn
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
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:self];
}
#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (_type == DisabilityGradeType)?1:[_dataSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == DisabilityGradeType) {
        return 10;
    }
    NSArray *arr = _dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView registerClass:[DisabilityViewCell class] forCellReuseIdentifier:DISABLITYCellID];
    
    DisabilityViewCell *cell = (DisabilityViewCell *)[tableView dequeueReusableCellWithIdentifier:DISABLITYCellID];
    (_type == DisabilityGradeType)?[cell settingUIWithLevel:indexPath.row withDelegate:self]:[cell setCaseTypeUIwithArrays:_dataSourceArrays withSection:indexPath.section withRow:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  (_type == DisabilityGradeType)?0.1f:36.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_type == DisabilityGradeType) {
        return nil;
    }
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 36.f) withSection:section];
    headView.delBtn.hidden = YES;
    headView.label.textColor = hexColor(ADADAD);
    headView.label.font = Font_14;
    NSArray *arr = @[@"财产案件",@"非财产案件",@"行政案件",@"申请费"];
    [headView setLabelText:arr[section]];
    return headView;
}

#pragma mark - DisabilityViewDelegate
- (void)toObtainSeveralDisabilityLevel:(NSString *)text withRow:(NSInteger)row
{
    DLog(@"响应代理方法");
}

#pragma mark - setter and getter
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        CGFloat height = (kMainScreenHeight >667)?(kMainScreenHeight - 142.f):(kMainScreenHeight - 60.f);
        _zd_superView = [[UIView alloc] initWithFrame:CGRectMake((kMainScreenWidth - kContentLabelWidth)/2.f,kMainScreenHeight, kContentLabelWidth, height)];
        _zd_superView.backgroundColor = hexColor(F2F2F2);
        _zd_superView.layer.cornerRadius = 3.f;
        _zd_superView.clipsToBounds = YES;
    }
    return _zd_superView;
}
- (UILabel *)headlab
{
    if (!_headlab) {
        _headlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kContentLabelWidth, 45.f)];
        _headlab.textAlignment = NSTextAlignmentCenter;
        _headlab.textColor = [UIColor whiteColor];
        _headlab.backgroundColor = hexColor(00c8aa);
        _headlab.font = Font_18;
    }
    return _headlab;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,75, kContentLabelWidth, self.zd_superView.frame.size.height - 139.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(20, Orgin_y(_tableView) + 12, kContentLabelWidth - 40, 40);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 2.f;
        _sureBtn.backgroundColor  = hexColor(00C8aa);
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn setTitle:@"确定" forState:0];
        _sureBtn.titleLabel.font = Font_14;
        _sureBtn.tag = 3026;
        [_sureBtn addTarget:self action:@selector(sureButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
