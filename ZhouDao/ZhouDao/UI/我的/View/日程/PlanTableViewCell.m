//
//  PlanTableViewCell.m
//  ZhouDao
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PlanTableViewCell.h"
#import "NSDate+Category.h"

@implementation PlanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //_nameLab.textColor = [UIColor colorWithHexString:@"#d7d7d7"];
    _alertLab.textColor = [UIColor colorWithHexString:@"#D7B690"];
    //_contentLab.textColor = [UIColor colorWithHexString:@"#d7d7d7"];
    //[UIImage imageNamed:@"mine_NZUnSelected"];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 86.5f, kMainScreenWidth, .5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d7d7d7"];
    [self.contentView addSubview:lineView];
    
}
- (void)setModel:(RemindData *)model
{
    _model = model;
    [self loadData];
}
- (void)loadData
{
    _nameLab.text = _model.title;
    NSDate *date = [QZManager timeStampChangeNSDate:[_model.time doubleValue]];
    _nameLab.textColor = THIRDCOLOR;
    _contentLab.textColor = THIRDCOLOR;

    if (_isToday == YES) {
        _contentLab.text = [QZManager changeTime:[_model.time doubleValue]];
        //比较时间
        if ([QZManager compareOneDay:[NSDate date] withAnotherDay:date] == 1)
        {//失效
            _iconImgView.image = [UIImage imageNamed:@"mine_NZUnSelected"];
            _nameLab.textColor = NINEColor;
            _contentLab.textColor = NINEColor;
            _alertLab.text = @"提醒已过期";
        }else{
            _alertLab.text = [QZManager timeToShow:date];
            _iconImgView.image = [UIImage imageNamed:@"mine_NZSelected"];
        }
    }else{
        _alertLab.text = [QZManager changeTimeMethods:[_model.time doubleValue] withType:@"HH:mm"];
        _contentLab.text = [QZManager changeTime:[_noDayString doubleValue]];
        
        if (_model.spacing.length >0) {
            
            if ([_model.spacing floatValue] <0) {
                _iconImgView.image = [UIImage imageNamed:@"mine_NZUnSelected"];
                _nameLab.textColor = NINEColor;
                _contentLab.textColor = NINEColor;
                _alertLab.text = @"提醒已过期";
            }else{
                _iconImgView.image = [UIImage imageNamed:@"mine_NZSelected"];

            }

        }else {
            _iconImgView.image = [UIImage imageNamed:@"mine_NZSelected"];
        }
        
    }
    
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
