//
//  DisabilityViewCell.m
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "DisabilityViewCell.h"

#define kContentLabelWidth     4.f/5.f*([UIScreen mainScreen].bounds.size.width)
#define LabelX                 13.f/80.f*([UIScreen mainScreen].bounds.size.width)

@interface DisabilityViewCell()

@property (nonatomic, strong) UIView *lineView;
@end
@implementation DisabilityViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initUI];
    }
    return self;
}
- (void)initUI
{WEAKSELF;
    
    [self.contentView addSubview:self.titlelabel];
    [self.contentView addSubview:self.numberButtons];
    [self.contentView addSubview:self.lineView];
    _numberButtons.numberBlock = ^(NSString *num){
        DLog(@"%@",num);
        
        if ([weakSelf.delegate respondsToSelector:@selector(toObtainSeveralDisabilityLevel:withRow:)]) {
            
            [weakSelf.delegate toObtainSeveralDisabilityLevel:num withRow:weakSelf.row];
        }
    };
}

#pragma mark -  methods
- (void)setCaseTypeUIwithArrays:(NSMutableArray *)sourceArrays withSection:(NSInteger)section withRow:(NSInteger)row
{
    _numberButtons.hidden = YES;
    _titlelabel.frame = CGRectMake(44, 12, kContentLabelWidth - 44, 20);
    _titlelabel.font = Font_13;
    NSArray *arr = sourceArrays[section];
    _titlelabel.text = arr[row];
    
}
- (void)settingUIWithLevel:(NSInteger)row withDelegate:(id<DisabilityViewDelegate>)delegate
{
    _delegate = delegate;
    _row = row;
    NSArray *arr = @[@"一级",@"二级",@"三级",@"四级",@"五级",@"六级",@"七级",@"八级",@"九级",@"十级"];
    _titlelabel.text = arr[row];

}
- (void)selectOnlyUI:(NSInteger)row
{
    _row = row;
    _numberButtons.hidden = YES;
    _titlelabel.frame = CGRectMake(0, 12, kContentLabelWidth, 20);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    NSArray *arr = @[@"一级",@"二级",@"三级",@"四级",@"五级",@"六级",@"七级",@"八级",@"九级",@"十级"];
    _titlelabel.text = arr[row];

}
#pragma mark - setter and getter
- (UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(LabelX, 12, 60, 20)];
        _titlelabel.textColor = hexColor(333333);
        _titlelabel.font = Font_14;
        _titlelabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titlelabel;
}

- (PPNumberButton *)numberButtons
{
    if (!_numberButtons) {
        _numberButtons = [[PPNumberButton alloc] initWithFrame:CGRectMake(kContentLabelWidth - 115, 7.5f, 90, 30)];
        //设置边框颜色
        _numberButtons.borderColor = hexColor(E5E5E5);
    }
    return _numberButtons;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.4f, kContentLabelWidth, .6f)];
        _lineView.backgroundColor = hexColor(E5E5E5);
    }
    return _lineView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
