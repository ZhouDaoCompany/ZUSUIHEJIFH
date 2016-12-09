//
//  GovDetailCell.m
//  ZhouDao
//
//  Created by cqz on 16/5/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovDetailCell.h"

@interface GovDetailCell()

@property (nonatomic, strong) UIImageView *organImageView;//司法机关图片
@property (nonatomic, strong) UIImageView *headImgView;//电话 地址标记
@property (nonatomic, strong) UIImageView *reviewImgView;//审查 未审查标记
@property (nonatomic, strong) UILabel *msgLabel;//电话 地址
@property (nonatomic, strong) UILabel *IntroductionLabel;//简介
@property (nonatomic, strong) UILabel *titleLabel;//司法机关名字
@property (nonatomic, strong)  UIView *lineView;

@end

@implementation GovDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _rowHeight = 44.f;
        
        [self.contentView addSubview:self.organImageView];
        [self.contentView addSubview:self.headImgView];
        [self.contentView addSubview:self.reviewImgView];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.IntroductionLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];

    }
    return self;
}

//简介
- (void)setDetailIntroductionText:(NSString *)text {
    
    self.accessoryType = UITableViewCellAccessoryNone;

    _organImageView.hidden = YES;
    _headImgView.hidden = YES;
    _reviewImgView.hidden = YES;
    _msgLabel.hidden = YES;
    _titleLabel.hidden = YES;
    _IntroductionLabel.hidden = NO;
    _lineView.hidden = YES;

    NSDictionary *attribute = @{NSFontAttributeName:Font_13};
    CGSize size = [text boundingRectWithSize:CGSizeMake(kMainScreenWidth - 30,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _rowHeight = size.height +20;
    
    _IntroductionLabel.frame = CGRectMake(15, 15, kMainScreenWidth - 30, size.height);
    _IntroductionLabel.text = text;
}

//司法机关图片
- (void)setGovermentPictureUI:(GovListmodel *)model {
    
    self.accessoryType = UITableViewCellAccessoryNone;

    _organImageView.hidden = NO;
    _reviewImgView.hidden = NO;
    _titleLabel.hidden = NO;
    _msgLabel.hidden = YES;
    _headImgView.hidden = YES;
    _IntroductionLabel.hidden = YES;
    _lineView.hidden = NO;
    
    _lineView.frame = CGRectMake(0, 99.4f, kMainScreenWidth, .6f);
    
    _titleLabel.text = model.name;
    [_organImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"gov_tupian"]];
    _reviewImgView.image =  [model.is_audit isEqualToString:@"1"] ? kGetImage(@"gov_NoReview") : kGetImage(@"gov_Review");
}

//地址电话
- (void)SetPhoneNumberAndAddress:(GovListmodel *)model withIndexRow:(NSUInteger)indexRow {
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    _lineView.frame = CGRectMake(0, 44.4f, kMainScreenWidth, .6f);

    _organImageView.hidden = YES;
    _headImgView.hidden = NO;
    _reviewImgView.hidden = YES;
    _titleLabel.hidden = YES;
    _msgLabel.hidden = NO;
    _IntroductionLabel.hidden = YES;
    _lineView.hidden = NO;
    
    _msgLabel.text = (indexRow == 1) ? model.address : model.phone;
    _headImgView.image = (indexRow == 1) ? kGetImage(@"Gov_location") : kGetImage(@"Gov_phone");
}

#pragma mark - setter and getter

- (UIImageView *)organImageView {
    if (!_organImageView) {
        
        _organImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 73, 60)];
        _organImageView.image = [UIImage imageNamed:@"gov_tupian"];
        _organImageView.userInteractionEnabled = YES;
    }
    return _organImageView;
}
- (UIImageView *)reviewImgView {
    
    if (!_reviewImgView) {
        
        _reviewImgView = [[UIImageView alloc] initWithFrame:CGRectMake(96, 41, 44, 18)];
    }
    return _reviewImgView;
}
- (UIImageView *)headImgView {
    
    if (!_headImgView) {
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 13, 23)];
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        _headImgView.userInteractionEnabled = YES;
    }
    return _headImgView;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 21, kMainScreenWidth - 111, 15)];
        _titleLabel.font = Font_16;
        _titleLabel.textColor = THIRDCOLOR;
    }
    return _titleLabel;
}
- (UILabel *)msgLabel {
    
    if (!_msgLabel) {
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 12, kMainScreenWidth - 55, 20)];
        _msgLabel.textColor = SIXCOLOR;
        _msgLabel.font = Font_13;
        _msgLabel.numberOfLines = 1;
    }
    return _msgLabel;
}
- (UILabel *)IntroductionLabel {
    
    if (!_IntroductionLabel) {
        
        _IntroductionLabel = [[UILabel alloc] init];
        _IntroductionLabel.font = Font_13;
        _IntroductionLabel.textColor = SIXCOLOR;
        _IntroductionLabel.numberOfLines = 0;
    }
    return _IntroductionLabel;
}
- (UIView *)lineView {
    
    if (!_lineView) {
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
