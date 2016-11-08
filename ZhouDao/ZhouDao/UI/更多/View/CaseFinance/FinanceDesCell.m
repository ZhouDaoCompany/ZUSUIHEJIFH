//
//  FinanceDesCell.m
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FinanceDesCell.h"
#import "GBTagListView.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

//static float const DefaultCellHeight = 34;
@interface FinanceDesCell()
{
    NSString *_desString;
    
}
@property (nonatomic, strong) GBTagListView *TagView;

@end

@implementation FinanceDesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 5.f)];
        headView.backgroundColor = ViewBackColor;
        [self.contentView addSubview:headView];
        
        
        [self titlab];
        [_TagView removeFromSuperview];
        
        [self TagView];
        [self lab];
        [self showAllButton];

    }
    return self;
}
- (UIButton *)showAllButton
{
    if (_showAllButton == nil)
    {
        _showAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showAllButton setTitleColor:[UIColor blackColor] forState:0];
        //        [_showAllButton setTitle:@"显示全部" forState:0];
        //        [_showAllButton setBackgroundImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        [_showAllButton setImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        [_showAllButton addTarget:self action:@selector(didClickExpandOrCollapse:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showAllButton];
    }
    
    return _showAllButton;
}
- (UILabel *)titlab
{
    if (_titlab == nil)
    {
        _titlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15.f, 140, 20)];
        _titlab.textAlignment = NSTextAlignmentLeft;
        _titlab.textColor = THIRDCOLOR;
        _titlab.font = Font_15;
        [self.contentView addSubview:_titlab];
    }
    
    return _titlab;
}
- (GBTagListView *)TagView
{
    if (_TagView == nil)
    {
        _TagView=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 42, SCREENWIDTH, 0)];
        /**允许点击 */
        _TagView.canTouch=NO;
        /**可以控制允许点击的标签数 */
        _TagView.canTouchNum = 1;
        /**控制是否是单选模式 */
        _TagView.isSingleSelect=YES;
        _TagView.signalTagColor=[UIColor clearColor];
        [_TagView setMarginBetweenTagLabel:5.f AndBottomMargin:5.f];
        [self.contentView addSubview:_TagView];

    }
    
    return _TagView;
}

- (UILabel *)lab
{
    if (_lab == nil)
    {
        _lab = [[UILabel alloc] init];
        _lab.numberOfLines = 0;
        _lab.textColor = NINEColor;
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.lineBreakMode =  NSLineBreakByTruncatingTail;;
        [self.contentView addSubview:_lab];
    }
    return _lab;
}
- (void)setFinanceFrameItem:(FinanceFrameItem *)financeItem
{
    _financeItem = financeItem;
    
    // 1> 设置数据
    [self settingData];
    // 2> 设置位置
    [self settingFrame];

}
- (void)settingData
{
    FinanceModel *model = self.financeItem.financeModel;
    
        NSInteger index = 0;
        NSArray *titArr = [NSMutableArray arrayWithObjects:@"律师费(与客户)",@"提成(与律所)",@"差旅费",@"第三方费用",@"自定义", nil];
    
        if ([model.type isEqualToString:@"9"]) {
            index = 4;
        }else {
            index = [model.type integerValue] -1;
        }
    
        _titlab.text = titArr[index];
    
   [_TagView setTagWithTagArray:_financeItem.labArrays];
    
    _lab.text = _financeItem.desString;
}
- (void)settingFrame
{
    _TagView.frame = _financeItem.tagViewF;
    
    if (_financeItem.financeModel.isExpanded == YES) {
        _lab.frame = _financeItem.ContentF2;
    }else {
        _lab.frame = _financeItem.ContentF1;
    }
    
    if (_financeItem.cellHeight1 != _financeItem.cellHeight2) {
        _showAllButton.hidden = NO;
        
        if (_financeItem.financeModel.isExpanded == YES) {
            [_showAllButton setImage:[UIImage imageNamed:@"case_up"] forState:0];
        }else {
            [_showAllButton setImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        }
         _showAllButton.frame = CGRectMake(SCREENWIDTH-45, Orgin_y(_lab), 30, 20);
    }else{
        _showAllButton.hidden = YES;
    }
    
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//
//    //    [self calculateLabelHeight:_desString];
//    
//}
#pragma mark -UIButtonEvent
- (void)didClickExpandOrCollapse:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(expandOrClose:)]) {
        
        [self.delegate expandOrClose:self];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
