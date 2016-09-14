//
//  FilterCollectionViewCell.m
//  UItext
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@implementation FilterCollectionViewCell
@synthesize titleLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
        self.layer.borderWidth = .5f;
        
        titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.numberOfLines = 1;
        titleLab.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:titleLab];
    }
    return self;
}
- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = nil;
    _isSelected = isSelected;
    
    if (_isSelected == YES) {
        titleLab.textColor = [UIColor whiteColor];
//        self.layer.borderColor = [UIColor colorWithHexString:@"#00c8aa"].CGColor;
        titleLab.backgroundColor = KNavigationBarColor;
        titleLab.alpha= 0.6f;

    }else{
        titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLab.backgroundColor = [UIColor whiteColor];
        titleLab.alpha= 1.f;

//        self.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;

    }
    
}
- (void)layoutSubviews{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    titleLab.frame = CGRectMake(0, 0,width , height);
}

@end
