//
//  HomeTableViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titlab.textColor = thirdColor;
    _contentLab.numberOfLines = 0;
    _headImgView.contentMode = UIViewContentModeScaleToFill;
    _contentLab.textColor = [UIColor colorWithHexString:@"#999999"];
}
- (void)setMdoel:(BasicModel *)mdoel
{
    _mdoel = nil;
    _mdoel = mdoel;
    _titlab.text = _mdoel.title;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_mdoel.pic] placeholderImage:[UIImage imageNamed:@"home_palcehold"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_mdoel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        _contentLab.text = attrStr.string;
//        _contentLab.attributedText = attrStr;
    });
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
