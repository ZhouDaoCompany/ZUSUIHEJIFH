//
//  AccusingTheCell.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AccusingTheCell.h"

@implementation AccusingTheCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = Font_15;
        [self.contentView addSubview:self.titleLab];
        
        self.deviceLabel = [[UILabel alloc] init];
        self.deviceLabel.textAlignment = NSTextAlignmentRight;
        self.deviceLabel.font = Font_14;
        self.deviceLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.deviceLabel];
        
        
        self.textField = [[UITextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = Font_14;
        [self.contentView addSubview:self.textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = lineColor;
        [self.contentView addSubview:lineView];
        
        _imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _imgview1.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _imgview1.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgview1];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLab.frame = CGRectMake(15, 15, 140, 20);
    
    
    if (_rowIndex ==5 || _rowIndex == 6)
    {
        _deviceLabel.hidden = NO;
        _imgview1.hidden = NO;
        _textField.hidden = YES;
        _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 10, 150, 30);
    }else{
        _deviceLabel.hidden = YES;
        _imgview1.hidden = YES;
        _textField.hidden = NO;
        _textField.frame = CGRectMake(kMainScreenWidth - 151.f, 10, 130, 30);
    }
        
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
