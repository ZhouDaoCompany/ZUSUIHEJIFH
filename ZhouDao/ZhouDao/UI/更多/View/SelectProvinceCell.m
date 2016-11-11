//
//  SelectProvinceCell.m
//  ZhouDao
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectProvinceCell.h"
@interface SelectProvinceCell()

@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UIButton *oneButton;
@property (strong, nonatomic) UIButton *twoButton;
@property (strong, nonatomic) UIButton *thirdButton;
@property (strong, nonatomic) UIButton *fourButton;

@end
@implementation SelectProvinceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.oneButton];
        [self.contentView addSubview:self.twoButton];
        [self.contentView addSubview:self.thirdButton];
        [self.contentView addSubview:self.fourButton];
        [self.contentView addSubview:self.lineView];
    }
    
    return self;
}
#pragma mark - methods
- (void)setOtherCitySelect:(NSString *)name wihSection:(NSInteger)section {
    
    if (section == 0) {
        self.backgroundColor = hexColor(F0F0F0);
        _oneButton.hidden = NO;
        _twoButton.hidden = NO;
        _thirdButton.hidden = NO;
        _fourButton.hidden = NO;
        _nameLab.hidden = YES;
        
        NSArray *hotCity;
        if (_isCity) {
           hotCity = @[@"北京市",@"上海市",@"天津市",@"重庆市"];
        } else {
            hotCity = @[@"北京",@"上海",@"天津",@"重庆"];
        }

        [_oneButton setTitle:hotCity[0] forState:0];
        [_twoButton setTitle:hotCity[1] forState:0];
        [_thirdButton setTitle:hotCity[2] forState:0];
        [_fourButton setTitle:hotCity[3] forState:0];

    }else {
        self.backgroundColor = [UIColor whiteColor];
        _oneButton.hidden = YES;
        _twoButton.hidden = YES;
        _thirdButton.hidden = YES;
        _fourButton.hidden = YES;
        _nameLab.hidden = NO;
        _nameLab.text = name;
    }
}
#pragma mark - event response
- (void)hotBtnClick:(UIButton *)btn {
    
    NSInteger index = btn.tag;
    NSArray *hotCity;
    if (_isCity) {
        hotCity = @[@"北京市",@"上海市",@"天津市",@"重庆市"];
    } else {
        hotCity = @[@"北京",@"上海",@"天津",@"重庆"];
    }

    if ([self.delegate respondsToSelector:@selector(getSeletyCityName:)]) {
        [self.delegate getSeletyCityName:hotCity[index - 3000]];
    }
}
#pragma mark -setters and getters
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 160, 20)];
        _nameLab.font = Font_15;
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textColor = hexColor(333333);
    }
    return _nameLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43.4f, kMainScreenWidth - 15, .6f)];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (UIButton *)oneButton {
    if (!_oneButton) {
        _oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneButton.backgroundColor = [UIColor whiteColor];
        _oneButton.tag = 3000;
    
        _oneButton.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        _oneButton.layer.borderWidth = 1.f;
        _oneButton.layer.masksToBounds = YES;
        _oneButton.layer.cornerRadius = 3.f;
        float hotWidth = (kMainScreenWidth- 70)/4.f;
        _oneButton.frame = CGRectMake( 10, 7 , hotWidth, 34);
        _oneButton.titleLabel.font = Font_14;
        [_oneButton setTitleColor:hexColor(333333) forState:0];
        [_oneButton addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneButton;
}
- (UIButton *)twoButton {
    if (!_twoButton) {
        _twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoButton.backgroundColor = [UIColor whiteColor];
        _twoButton.tag = 3001;
       
        _twoButton.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        _twoButton.layer.borderWidth = 1.f;
        _twoButton.layer.masksToBounds = YES;
        _twoButton.layer.cornerRadius = 3.f;
        float hotWidth = (kMainScreenWidth- 70)/4.f;
        _twoButton.frame = CGRectMake( 20 + hotWidth, 7 , hotWidth, 34);
        _twoButton.titleLabel.font = Font_14;
        [_twoButton setTitleColor:hexColor(333333) forState:0];
        [_twoButton addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _twoButton;
}
- (UIButton *)thirdButton {
    if (!_thirdButton) {
        _thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _thirdButton.backgroundColor = [UIColor whiteColor];
        _thirdButton.tag = 3002;
      
        _thirdButton.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        _thirdButton.layer.borderWidth = 1.f;
        _thirdButton.layer.masksToBounds = YES;
        _thirdButton.layer.cornerRadius = 3.f;
        float hotWidth = (kMainScreenWidth- 70)/4.f;
        _thirdButton.frame = CGRectMake( 30 + hotWidth*2, 7 , hotWidth, 34);
        _thirdButton.titleLabel.font = Font_14;
        [_thirdButton setTitleColor:hexColor(333333) forState:0];
        [_thirdButton addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdButton;
}
- (UIButton *)fourButton {
    if (!_fourButton) {
        _fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fourButton.backgroundColor = [UIColor whiteColor];
        _fourButton.tag = 3003;
        _fourButton.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        _fourButton.layer.borderWidth = 1.f;
        _fourButton.layer.masksToBounds = YES;
        _fourButton.layer.cornerRadius = 3.f;
        float hotWidth = (kMainScreenWidth- 70)/4.f;
        _fourButton.frame = CGRectMake( 40 + hotWidth*3, 7 , hotWidth, 34);
        _fourButton.titleLabel.font = Font_14;
        [_fourButton setTitleColor:hexColor(333333) forState:0];
        [_fourButton addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _fourButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
