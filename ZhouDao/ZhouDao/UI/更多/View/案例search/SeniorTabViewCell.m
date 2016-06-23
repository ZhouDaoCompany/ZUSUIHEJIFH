//
//  SeniorTabViewCell.m
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SeniorTabViewCell.h"

@implementation SeniorTabViewCell

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
    self.titleLab.frame = CGRectMake(15, 15, 130, 20);
    
    
    if (_rowIndex ==0 || _rowIndex == 6 || _rowIndex == 7 || _rowIndex == 8 || _rowIndex == 9 || _rowIndex == 14 || _rowIndex == 15)
    {
        _deviceLabel.hidden = NO;
        _imgview1.hidden = NO;
        _textField.hidden = YES;
        _deviceLabel.frame = CGRectMake(kMainScreenWidth - 171.f, 10, 150, 30);
    }else{
        _deviceLabel.hidden = YES;
        _imgview1.hidden = YES;
        _textField.hidden = NO;
        _textField.frame = CGRectMake(kMainScreenWidth - 151.f, 10, 130, 30);
    }
    
    switch (_rowIndex) {
        case 1:
        {
            _textField.placeholder = @"请输入关键字";
        }
            break;
        case 2:
        {
            _textField.placeholder = @"请输入案号";

        }
            break;
        case 3:
        {
            _textField.placeholder = @"请输入案由";

        }
            break;
        case 4:
        {
            _textField.placeholder = @"请输入案件名称";

        }
            break;
        case 5:
        {
            _textField.placeholder = @"请输入法院名称";

        }
            break;
        case 10:
        {
            _textField.placeholder = @"请输入审判人员";

        }
            break;
        case 11:
        {
            _textField.placeholder = @"请输入当事人";

        }
            break;
        case 12:
        {
            _textField.placeholder = @"请输入律所";
            
        }
            break;
        case 13:
        {
            _textField.placeholder = @"请输入律师";

        }
            break;
        case 16:
        {
            _textField.placeholder = @"请输入涉案罪名";
            
        }

            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
