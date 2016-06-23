//
//  SetCollectionViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SetCollectionViewCell.h"

@implementation SetCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;

        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.frame = CGRectMake(0, 0,width , height);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.numberOfLines = 1;
        _titleLab.text = @"Aa";
        _titleLab.font = Font_12;
        [self.contentView addSubview:_titleLab];
    }
    return self;
}
- (void)setSection:(NSUInteger)section
{
    _section = section;
}
- (void)setRow:(NSUInteger)row
{
    _row = row;
    [self loadData];
}
- (void)loadData
{
    if (_section == 0)
    {
        switch (_row) {
            case 0:
            {
                _titleLab.font = Font_12;
            }
                break;
            case 1:
            {
                _titleLab.font = Font_15;

            }
                break;
            case 2:
            {
                _titleLab.font = Font_18;

            }
                break;
            case 3:
            {
                _titleLab.font = Font_21;

            }
                break;
            case 4:
            {
                _titleLab.font = Font_24;

            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    if (_section == 1)
    {
        switch (_row) {
            case 0:
            {
                self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            }
                break;
            case 1:
            {
                self.backgroundColor = [UIColor colorWithHexString:@"#9DD6CA"];

            }
                break;
            case 2:
            {
                self.backgroundColor = [UIColor colorWithHexString:@"#E0EACB"];

            }
                break;
            case 3:
            {
                self.backgroundColor = [UIColor colorWithHexString:@"#E7D8BE"];
            }
                break;
            case 4:
            {
                self.backgroundColor = [UIColor colorWithHexString:@"#273C32"];
                _titleLab.textColor = [UIColor whiteColor];

            }
                break;
                
            default:
                break;
        }
        
    }

    
}
@end
