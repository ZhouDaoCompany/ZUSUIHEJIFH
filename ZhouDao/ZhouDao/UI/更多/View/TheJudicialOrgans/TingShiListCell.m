//
//  TingShiListCell.m
//  ZhouDao
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiListCell.h"
#import "Courtroom_linkman.h"

@interface TingShiListCell()

@property (nonatomic, strong) UILabel *addressLabel;//地址信息
@property (nonatomic, strong) UILabel *conaddressLabel;

@property (nonatomic, strong) UILabel *lXLabel;//联系人
@property (nonatomic, strong) UILabel *conlXLabel;

@property (nonatomic, strong) UILabel *phoneLabel;//联系电话
@property (nonatomic, strong) UILabel *conphoneLabel;

@property (nonatomic, strong)  UIWebView *PhoneWebView;//拨打电话

@property (nonatomic, strong) UIView *lineView;

@end

@implementation TingShiListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.conaddressLabel];
        [self.contentView addSubview:self.lXLabel];
        [self.contentView addSubview:self.conlXLabel];
        [self.contentView addSubview:self.phoneLabel];
        [self.contentView addSubview:self.conphoneLabel];
        [self.contentView addSubview:self.lineView];

    }
    return self;
}

- (void)setAddressUIWithIndexRow:(NSUInteger)indexRow withCourtroom_base:(Courtroom_base *)baseModel {
    
    _addressLabel.hidden = NO;
    _conaddressLabel.hidden = NO;
    _lXLabel.hidden = YES;
    _conlXLabel.hidden = YES;
    _phoneLabel.hidden = YES;
    _conphoneLabel.hidden = YES;
    
    _lineView.frame = CGRectMake(39, 44.4f, kMainScreenWidth - 39, .6f);
    _addressLabel.text = @"地址信息";
    _conaddressLabel.text = baseModel.address;
    
}

- (void)setContactUIWithIndexRow:(NSUInteger)indexRow withCourtroom_base:(Courtroom_base *)baseModel {WEAKSELF;
    
    _addressLabel.hidden = YES;
    _conaddressLabel.hidden = YES;
    _lXLabel.hidden = NO;
    _conlXLabel.hidden = NO;
    _phoneLabel.hidden = NO;
    _conphoneLabel.hidden = NO;
    
    _lineView.frame = CGRectMake(39, 69.4f, kMainScreenWidth - 39, .6f);

    Courtroom_linkman *linkManModel = baseModel.courtroom_linkman[indexRow - 1];
    _lXLabel.text = @"联系人";
    _conlXLabel.text = linkManModel.name;
    _phoneLabel.text = @"联系电话";
    _conphoneLabel.text = linkManModel.phone;
    
    [_conphoneLabel whenTapped:^{
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",linkManModel.phone]]];
        [weakSelf.PhoneWebView loadRequest:request];
    }];
}

#pragma mark - setter and getter

- (UILabel *)addressLabel {
    
    if (!_addressLabel) {
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 12, 70, 20)];
        _addressLabel.textColor = SIXCOLOR;
        _addressLabel.font = [UIFont systemFontOfSize:11.f];
        _addressLabel.numberOfLines = 1;
    }
    return _addressLabel;
}
- (UILabel *)conaddressLabel {
    
    if (!_conaddressLabel) {
        
        _conaddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 225, 12, 210, 20)];
        _conaddressLabel.textColor = SIXCOLOR;
        _conaddressLabel.font = [UIFont systemFontOfSize:11.f];
        _conaddressLabel.textAlignment = NSTextAlignmentRight;
    }
    return _conaddressLabel;
}
- (UILabel *)lXLabel {
    
    if (!_lXLabel) {
        
        _lXLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 15, 70, 20)];
        _lXLabel.textColor = SIXCOLOR;
        _lXLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _lXLabel;
}
- (UILabel *)conlXLabel {
    
    if (!_conlXLabel) {
        
        _conlXLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 225, 15, 210, 20)];
        _conlXLabel.textColor = SIXCOLOR;
        _conlXLabel.font = [UIFont systemFontOfSize:11.f];
        _conlXLabel.textAlignment = NSTextAlignmentRight;
    }
    return _conlXLabel;
}

- (UILabel *)phoneLabel {
    
    if (!_phoneLabel) {
        
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 35, 70, 20)];
        _phoneLabel.textColor = SIXCOLOR;
        _phoneLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _phoneLabel;
}
- (UILabel *)conphoneLabel {
    
    if (!_conphoneLabel) {
        
        _conphoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 225, 35, 210, 20)];
        _conphoneLabel.textColor = hexColor(00c8aa);
        _conphoneLabel.font = [UIFont systemFontOfSize:11.f];
        _conphoneLabel.textAlignment = NSTextAlignmentRight;
    }
    return _conphoneLabel;
}

- (UIView *)lineView {
    
    if (!_lineView) {
       
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (UIWebView *)PhoneWebView {
    if (!_PhoneWebView) {
        _PhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _PhoneWebView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
