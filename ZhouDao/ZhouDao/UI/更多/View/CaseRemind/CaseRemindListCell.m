//
//  CaseRemindListCell.m
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseRemindListCell.h"

@interface CaseRemindListCell()

@property (nonatomic, strong)  UIView *lineView;
@end

@implementation CaseRemindListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 9.6f, 210.f, .8f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];//lineColor;
    _lineView = lineView;
    [_timeLab addSubview:_lineView];
    
    _titLab.textColor = THIRDCOLOR;
    _remindImg.contentMode = UIViewContentModeScaleAspectFit;
    _timeLab.textColor = THIRDCOLOR;

}
- (void)setDataModel:(RemindData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    [self loadData];

}
- (void)loadData
{
    _titLab.text = _dataModel.title;
    
    _timeLab.text = [QZManager changeTimeMethods:[_dataModel.time doubleValue] withType:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [QZManager timeStampChangeNSDate:[_dataModel.time doubleValue]];

    //比较时间
    if ([QZManager compareOneDay:[NSDate date] withAnotherDay:date] == 1)
    {//失效
        _remindImg.image = [UIImage imageNamed:@"mine_NZUnSelected"];
        _lineView.hidden = NO;
        
        _timeLab.text = [NSString stringWithFormat:@"%@提醒已过期",_timeLab.text];
        
    }else{
        _remindImg.image = [UIImage imageNamed:@"mine_NZSelected"];
        _lineView.hidden = YES;
    }


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
