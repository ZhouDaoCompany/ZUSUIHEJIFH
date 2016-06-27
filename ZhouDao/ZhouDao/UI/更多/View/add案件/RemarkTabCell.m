//
//  RemarkTabCell.m
//  ZhouDao
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RemarkTabCell.h"

@implementation RemarkTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = Font_15;
        titleLab.text = @"备注:";
//        titleLab.backgroundColor = [UIColor blackColor];
        _titLab = titleLab;
        [self.contentView addSubview:_titLab];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, kMainScreenWidth - 30.f, 75)];
        textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        textView.font = Font_14;
        textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
        textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        textView.scrollEnabled = YES;//是否可以拖动
        textView.layer.borderColor = thirdColor.CGColor;
        textView.layer.borderWidth = .6f;
        self.textView = textView;
        [self.contentView addSubview: self.textView];//加入到整个页面中
        
        UILabel *placeHoldlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, kMainScreenWidth - 30.f, 30)];
        placeHoldlab.font = Font_14;
        placeHoldlab.backgroundColor = [UIColor clearColor];
        placeHoldlab.text = @" 请您输入备注";
        placeHoldlab.textColor = sixColor;
        _placeHoldlab = placeHoldlab;
        [self.contentView addSubview:_placeHoldlab];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
