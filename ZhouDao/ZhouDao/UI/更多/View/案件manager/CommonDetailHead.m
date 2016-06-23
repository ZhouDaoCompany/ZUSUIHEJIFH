//
//  CommonDetailHead.m
//  ZhouDao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

#import "CommonDetailHead.h"
#import "CaseDetailHeadView.h"
#import "FaLvGuWenView.h"
#import "LitigationHeadView.h"
@interface CommonDetailHead()

@property (nonatomic, strong) UIView *botomView;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (strong,nonatomic)  CaseDetailHeadView *headView0;//非诉讼业务
@property (strong,nonatomic)  LitigationHeadView *headView2;//诉讼业务
@property (strong,nonatomic)  FaLvGuWenView *headView1; //法律顾问

@end
@implementation CommonDetailHead

- (id)initWithFrame:(CGRect)frame withArr:(NSArray *)arrays withType:(HeadType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _type = type;
        _contentArr =[NSMutableArray  array];
        [_contentArr addObjectsFromArray:arrays];
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    float height = self.frame.size.height;
    float width = self.frame.size.width;

    if (_type == AccusingHead) {
        _headView0 = [[CaseDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _headView0.conArrays  = _contentArr;
        WEAKSELF;
        _headView0.caseBlock = ^(){
            _isExpand = !_isExpand;
            float height;
            if (_isExpand == YES) {
                weakSelf.headView0.frame = CGRectMake(0, 0, kMainScreenWidth, 362.f);
                weakSelf.headView0.expandLab.text = @"点此收缩";
                height = 362.f;
            }else{
                weakSelf.headView0.frame = CGRectMake(0, 0, kMainScreenWidth, 125.f);
                weakSelf.headView0.expandLab.text = @"点此展开";
                height = 125.f;
            }
            
            weakSelf.comBlock(height);
            
        };

        [self addSubview:_headView0];
        
    }else if (_type == ConsultantHead){
        
        _headView1 = [[FaLvGuWenView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _headView1.conArrays  = _contentArr;
        WEAKSELF;
        _headView1.caseBlock = ^(){
            _isExpand = !_isExpand;
            float height;
            if (_isExpand == YES) {
                weakSelf.headView1.frame = CGRectMake(0, 0, kMainScreenWidth, 499.f);
                weakSelf.headView1.expandLab.text = @"点此收缩";
                height = 499.f;
            }else{
                weakSelf.headView1.frame = CGRectMake(0, 0, kMainScreenWidth, 125.f);
                weakSelf.headView1.expandLab.text = @"点此展开";
                height = 125.f;
            }
            
            weakSelf.comBlock(height);
            
        };
        
        [self addSubview:_headView1];

        
    }else{
        
        _headView2 = [[LitigationHeadView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _headView2.conArrays  = _contentArr;
        WEAKSELF;
        _headView2.caseBlock = ^(){
            _isExpand = !_isExpand;
            float height;
            if (_isExpand == YES) {
                weakSelf.headView2.frame = CGRectMake(0, 0, kMainScreenWidth, 863.f);
                weakSelf.headView2.expandLab.text = @"点此收缩";
                height = 863.f;
            }else{
                weakSelf.headView2.frame = CGRectMake(0, 0, kMainScreenWidth, 125.f);
                weakSelf.headView2.expandLab.text = @"点此展开";
                height = 125.f;
            }
            weakSelf.comBlock(height);
        };
        
        [self addSubview:_headView2];
        
    }
}
- (void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _botomView.frame = CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
