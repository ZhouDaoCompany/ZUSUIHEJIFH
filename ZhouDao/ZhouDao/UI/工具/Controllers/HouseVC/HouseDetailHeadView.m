//
//  HouseDetailHeadView.m
//  ZhouDao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HouseDetailHeadView.h"

@interface HouseDetailHeadView()

@property (weak, nonatomic) IBOutlet UILabel *totalPaymentLabel;//总还款
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;//总利息
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;//总贷款
@property (weak, nonatomic) IBOutlet UILabel *monthCount;//总月数

@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation HouseDetailHeadView

+ (HouseDetailHeadView *)instanceHouseDetailHeadViewPaymentMoney:(NSString *)PaymentMoney withInterest:(NSString *)interestMoney withLoan:(NSString *)loanMoney withMonths:(NSString *)monthCount
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HouseDetailHeadView" owner:self options:nil];
    HouseDetailHeadView *detailView = [nibView objectAtIndex:0];
    [detailView initUIPaymentMoney:PaymentMoney withInterest:interestMoney withLoan:loanMoney withMonths:monthCount];
    return detailView;
}
#pragma mark -  methods
- (void)initUIPaymentMoney:(NSString *)PaymentMoney withInterest:(NSString *)interestMoney withLoan:(NSString *)loanMoney withMonths:(NSString *)monthCount

{
    _totalPaymentLabel.text = PaymentMoney;
    _interestLabel.text = interestMoney;
    _loanLabel.text =loanMoney;
    _monthCount.text = monthCount;
}
+ (HouseDetailHeadView *)setOtherSetionTitle:(NSString *)title
{
    return [[HouseDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 30) withTitle:title];
}
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];

    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        _titleLabel.text = title;
    }
    return self;
}
#pragma mark - setter and getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 160, 20)];
        _titleLabel.font = Font_12;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = hexColor(00C8AA);
    }
    return _titleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
