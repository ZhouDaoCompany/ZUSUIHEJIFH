//
//  HomeTableViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "FMUString.h"
@implementation HomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.titlab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.headImgView];
    }
    return self;
}

#pragma mark - getters and setters
- (UILabel *)titlab
{
    if (!_titlab)
    {
        _titlab = [[UILabel alloc] initWithFrame:CGRectMake(105, 18, kMainScreenWidth - 115.f, 20)];
        _titlab.font  = Font_15;
//        _titlab.lineBreakMode = NSLineBreakByTruncatingTail;
        _titlab.textColor = thirdColor;
    }
    return _titlab;
}
- (UILabel *)contentLab
{
    if (!_contentLab)
    {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 40,kMainScreenWidth - 115.f, 35)];
        _contentLab.font  = Font_14;
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLab.textColor = NINEColor;
    }
    return _contentLab;
}
- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 65)];
        _headImgView.image = [UIImage imageNamed:@"home_palcehold"];
        _headImgView.contentMode = UIViewContentModeScaleToFill;
        _headImgView.userInteractionEnabled = YES;
    }
    return _headImgView;
}
- (void)setHistoryModel:(HistoryModel *)historyModel
{
    _historyModel = nil;
    _historyModel = historyModel;
    _titlab.text = _historyModel.title;
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_historyModel.pic] placeholderImage:[UIImage imageNamed:@"home_palcehold"]];
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        
        _contentLab.text = [FMUString filterHtml:_historyModel.content];
    });
}
- (void)setMdoel:(BasicModel *)mdoel
{
    _mdoel = nil;
    _mdoel = mdoel;
    _titlab.text = _mdoel.title;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_mdoel.pic] placeholderImage:[UIImage imageNamed:@"home_palcehold"]];
    
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        
        _contentLab.text = [FMUString filterHtml:_mdoel.content];
    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[_mdoel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        _contentLab.text = attrStr.string;
////        _contentLab.attributedText = attrStr;
//    });
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
