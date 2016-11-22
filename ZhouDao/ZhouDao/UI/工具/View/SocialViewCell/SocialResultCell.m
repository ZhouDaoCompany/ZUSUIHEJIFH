//
//  SocialResultCell.m
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialResultCell.h"

#define TEXTWIDTH   [UIScreen mainScreen].bounds.size.width/3.f

@interface SocialResultCell()

@property (nonatomic, strong) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation SocialResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.textField1];
        [self.contentView addSubview:self.textField2];
        [self.contentView addSubview:self.lineView];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(TEXTWIDTH , 5, 1, 35)];
        view1.backgroundColor = hexColor(E5E5E5);
        [self.contentView addSubview:view1];
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(TEXTWIDTH*2, 5, 1, 35)];
        view2.backgroundColor = hexColor(E5E5E5);
        [self.contentView addSubview:view2];

    }
    return self;
}

#pragma mark - methods
- (void)setShowUIWithDictionary:(PlistFileModel *)fileModel
                   withIndexRow:(NSInteger)indexRow {
    
    _textField1.row = indexRow;
    _textField2.row = indexRow;
    
    _textField1.section = (indexRow + 1) * 2000 + 1;
    _textField2.section = (indexRow + 1) * 2000 + 2;
    
    NSArray *titleArrays = @[@"养老",@"医疗",@"失业",@"工伤",@"生育",@"公积金"];
    _titleLab.text = titleArrays[indexRow];
    _textField1.text = fileModel.gr_ratio;
    _textField2.text = fileModel.gs_ratio;
    
}

#pragma mark - setter and getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, TEXTWIDTH - 15, 30)];
        _titleLab.font = Font_15;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = hexColor(000000);
    }
    return _titleLab;
}

- (CaseTextField *)textField1 {
    if (!_textField1) {
        _textField1 = [[CaseTextField alloc] initWithFrame:CGRectMake(TEXTWIDTH + 2, 7, TEXTWIDTH - 4, 30)];
        _textField1.borderStyle = UITextBorderStyleNone;
        _textField1.textColor = hexColor(666666);
        [_textField1 setValue:hexColor(ADADAD) forKeyPath:@"_placeholderLabel.textColor"];
        _textField1.font = Font_14;
        _textField1.textAlignment = NSTextAlignmentRight;
        _textField1.keyboardType = UIKeyboardTypeDecimalPad;

    }
    return _textField1;
}
- (CaseTextField *)textField2 {
    if (!_textField2) {
        _textField2 = [[CaseTextField alloc] initWithFrame:CGRectMake(TEXTWIDTH *2 + 2, 7, TEXTWIDTH - 7, 30)];
        _textField2.borderStyle = UITextBorderStyleNone;
        _textField2.textColor = hexColor(666666);
        [_textField2 setValue:hexColor(ADADAD) forKeyPath:@"_placeholderLabel.textColor"];
        _textField2.font = Font_14;
        _textField2.textAlignment = NSTextAlignmentRight;
        _textField2.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _textField2;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f)];
        _lineView.backgroundColor = hexColor(E5E5E5);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
