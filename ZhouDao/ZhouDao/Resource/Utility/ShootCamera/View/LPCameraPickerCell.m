//
//  LPCameraPickerCell.m
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LPCameraPickerCell.h"

@implementation LPCameraPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.pics];
        [self.contentView addSubview:self.removeBtn];
    }
    return self;
}
//载入数据
-(void)loadPhotoDatas:(UIImage *)image {
    
    _pics.image = image;
}

-(void)clickRemoveButtonMethod:(UIButton *)button {
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - setter and getter
- (UIImageView *)pics {
    
    if (!_pics) {
        
        _pics = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (kMainScreenWidth - 60) / 5, (kMainScreenHeight - 60) / 5)];
        _pics.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pics;
}
- (UIButton *)removeBtn {
    
    if (!_removeBtn) {
        
        _removeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kMainScreenWidth - 60) / 5 -20, 0, 20, 20)];
        [_removeBtn setImage:kGetImage(@"remove_btn_pic") forState:UIControlStateNormal];
        [_removeBtn addTarget:self action:@selector(clickRemoveButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeBtn;
}
@end
