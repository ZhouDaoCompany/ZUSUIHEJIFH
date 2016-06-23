//
//  SelectTemplateCell.m
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectTemplateCell.h"

@implementation SelectTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titLab.textColor = thirdColor;
    _countLab.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)setDataModel:(TemplateData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    [self loadData];
}
- (void)loadData
{
    _countLab.text = [NSString stringWithFormat:@"%@人阅读",_dataModel.view];
    
    NSDictionary *attribute = @{NSFontAttributeName:Font_12};
    CGSize size = [_countLab.text boundingRectWithSize:CGSizeMake(100,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    _countLab.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-size.width -15.f, 20, size.width, 20.f);
    _iconImgView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 36.f - size.width, 25.f, 15, 12);

    _titLab.text = _dataModel.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
