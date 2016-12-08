//
//  LawsTableViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawsTableViewCell.h"

@implementation LawsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _unitLab.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)setDataModel:(LawsDataModel *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    [self loadData];
}
- (void)loadData{
    _titleLab.text = _dataModel.name;
    _unitLab.text = _dataModel.enacted_by;
//    NSString *str = [NSString stringWithFormat:@"执行时间: %@",[QZManager changeTimeMethods:[_dataModel.execute_date doubleValue] withType:@"yyyy-MM-dd"]];//@"执行时间: 1991-01-10";

    NSString *str = [NSString stringWithFormat:@"%@",[QZManager changeTimeMethods:[_dataModel.execute_date doubleValue] withType:@"yyyy-MM-dd"]];//@"执行时间: 1991-01-10";
    NSDictionary *attribute = @{NSFontAttributeName:Font_12};
    CGSize size = [str boundingRectWithSize:CGSizeMake(200,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if (_dateLab) {
        [_dateLab removeFromSuperview];
    }
    _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15.f-size.width, 38, size.width, 21)];
    _dateLab.font = Font_12;
    _dateLab.text = str;
    [self.contentView   addSubview:_dateLab];
    _dateLab.textColor = [UIColor colorWithHexString:@"#999999"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
