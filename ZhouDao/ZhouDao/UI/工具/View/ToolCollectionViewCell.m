//
//  TollCollectionViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolCollectionViewCell.h"

@interface ToolCollectionViewCell()

@property (nonatomic, strong) NSMutableDictionary *dataSourceDictionary;
@end

@implementation ToolCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLab];
        
    }
    return self;
}
- (void)setModel:(TheContractData *)model
{
    _model = nil;
    _model = model;
    [self loadData];
}
- (void)settingToolsUIWithName:(NSString *)name
{
    if (name.length >0) {
        _iconImgView.hidden = NO;
        _titleLab.hidden = NO;
        _titleLab.text = name;
        _iconImgView.image = kGetImage(self.dataSourceDictionary[name]);
        NSDictionary *attribute = @{NSFontAttributeName:Font_15};
        float width = self.bounds.size.width;
        CGSize size = [_titleLab.text boundingRectWithSize:CGSizeMake(width-60,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _titleLab.frame =CGRectMake(50.f, 24, size.width, size.height);
    }else {
        _iconImgView.hidden = YES;
        _titleLab.hidden = YES;
    }
}
- (void)loadData
{
    _iconImgView.hidden = NO;
    _titleLab.hidden = NO;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@"law_placeHold"]];
    _titleLab.text = _model.ctname;
    NSDictionary *attribute = @{NSFontAttributeName:Font_15};
    float width = self.bounds.size.width;
    CGSize size = [_titleLab.text boundingRectWithSize:CGSizeMake(width-60,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _titleLab.frame =CGRectMake(50.f, 24, size.width, size.height);
}
#pragma mark - setters and getters
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 21.5, 25, 24)];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        CGFloat width = self.frame.size.width;
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +10.f, 24, width- Orgin_x(_iconImgView) - 10.f, 20)];
        _titleLab.textColor = THIRDCOLOR;
        //        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:15.f];
    }
    return _titleLab;
}
- (NSMutableDictionary *)dataSourceDictionary
{
    if (!_dataSourceDictionary) {
        _dataSourceDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Tools_riqi",@"日期计算器",@"Tools_sunhai",@"人身损害赔偿计算器",@"Tools_weiyue",@"违约金计算器",@"Tools_lixi",@"利息计算器",@"Tools_lawerFees",@"律师费计算器",@"Tools_lihun",@"离婚房产分割计算器",@"Tools_peichang",@"劳动补偿金计算器",@"Tools_gongshang",@"工伤赔偿计算器",@"Tools_fangwu",@"房屋还贷计算器",@"Tools_fayuan",@"法院受理费计算器",@"Tools_caijueshu",@"裁决书逾期利息计算器", nil];
    }
    return _dataSourceDictionary;
}

@end
