//
//  SelectProvinceCell.m
//  ZhouDao
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectProvinceCell.h"
@interface SelectProvinceCell()

@end
@implementation SelectProvinceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLab];

    }
    
    return self;
}
#pragma mark - methods
- (void)setHotCityUI
{
    self.backgroundColor = [UIColor clearColor];
    NSArray *hotCity = @[@"北京",@"上海",@"重庆",@"天津"];
    for (NSInteger i = 0; i<hotCity.count; i++) {
        
        NSString *titString = hotCity[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 3000+i;
        [btn setTitle:titString forState:0];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3.f;
        float hotWidth = (kMainScreenWidth- 70)/4.f;
        btn.frame = CGRectMake( 10 + (hotWidth +10)* i, 7 , hotWidth, 34);
        btn.titleLabel.font = Font_14;
        [btn setTitleColor:hexColor(333333) forState:0];
        [btn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
- (void)setOtherCitySelect:(NSString *)name wihSection:(NSInteger)section
{

    for (NSInteger i = 0; i<3004; i++) {
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:i];
        if (section == 0) {
            btn.hidden = NO;
        }else {
            btn.hidden = YES;
        }
    }
    DLog(@"name----%@",name);

    self.nameLab.text = name;
}
#pragma mark - event response
- (void)hotBtnClick:(UIButton *)btn
{
    NSInteger index = btn.tag;
    NSArray *hotCity = @[@"北京",@"上海",@"重庆",@"天津"];
    if ([self.delegate respondsToSelector:@selector(getSeletyCityName:)]) {
        [self.delegate getSeletyCityName:hotCity[index - 3000]];
    }
    
}
#pragma mark -setters and getters
- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 160, 20)];
        _nameLab.font = Font_15;
        _nameLab.backgroundColor = [UIColor redColor];
        _nameLab.textColor = hexColor(333333);
    }
    return _nameLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
