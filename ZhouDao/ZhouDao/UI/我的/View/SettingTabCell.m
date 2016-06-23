//
//  SettingTabCell.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SettingTabCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface SettingTabCell()
@property (nonatomic, strong) UIView *lineView;

@end
@implementation SettingTabCell

//- (void)awakeFromNib {
//    // Initialization code
//
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [self initUI];
    }
    
    return self;
}
- (void)initUI
{
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.font = Font_15;
    _nameLab.textColor = thirdColor;
    [self.contentView addSubview:_nameLab];
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90, 10, 60, 60)];
    _headImg.layer.masksToBounds = YES;
    _headImg.userInteractionEnabled = YES;
    _headImg.layer.cornerRadius = 30.f;
    [self.contentView addSubview:_headImg];
    
    NSString *mineImg = [PublicFunction ShareInstance].m_user.data.photo;
    if ([PublicFunction ShareInstance].m_user.data.photo.length >0)
    {
        //放大头像
        [_headImg whenTapped:^{
            
            NSMutableArray *photos = [NSMutableArray array];
            // 替换为中等尺寸图片
            NSString *url = [mineImg stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; // 图片路径
            photo.srcImageView = _headImg; // 来源于哪个UIImageView
            [photos addObject:photo];
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
//            browser.urlPhotos = arr;
            [browser show];
        }];
    }

    
    _addresslab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -200, 12, 170, 20)];
    _addresslab.textColor = [UIColor colorWithHexString:@"#666666"];
    _addresslab.font = Font_12;
    _addresslab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_addresslab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = lineColor;
    [self.contentView addSubview:_lineView];

}
- (void)setRow:(NSUInteger)row
{
    _row = row;
    if (_row == 0) {
        
        _nameLab.frame = CGRectMake(15, 30, 120, 20);
        _lineView.frame = CGRectMake(15, 79.5, kMainScreenWidth-15, .5f);
        _headImg.hidden = NO;
        _addresslab.hidden = YES;
    }else{
        
        _nameLab.frame = CGRectMake(15, 12, 120, 20);
        _lineView.frame = CGRectMake(15, 43.5, kMainScreenWidth-15, .5f);
        _headImg.hidden = YES;
        _addresslab.hidden = NO;
        _row ==5?[_lineView setHidden:YES]:[_lineView setHidden:NO];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
