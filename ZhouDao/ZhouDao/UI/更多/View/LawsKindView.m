//
//  LawsKindView.m
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawsKindView.h"

@implementation LawsKindView
@synthesize imgView;
@synthesize titleLab;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //图片
        imgView = [[UIImageView alloc] init];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 3.f;
        [self addSubview:imgView];
        
        //标题
        titleLab = [[UILabel alloc] init];
        titleLab.font = Font_14;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = [UIColor darkGrayColor];
        [self addSubview:titleLab];
        
        WEAKSELF;
        [self whenCancelTapped:^{
            [weakSelf tapClick];
        }];
        
        
    }
    return self;
}

-(void)setImgViewImageName:(NSString *)imageName WithLabelText:(NSString *)text;
{
    imgView.image = [UIImage imageNamed:imageName];
    titleLab.text = text;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    //float height = self.bounds.size.height;
    
    float x = (width -60.f)/2.f;
    float y = self.center.y - 40;
    
    imgView.frame = CGRectMake(x, y, 60, 60);
    titleLab.frame = CGRectMake(10, Orgin_y(imgView) +5, width-20, 20);
}
- (void)tapClick{
    NSString *name = titleLab.text;
    NSUInteger index = 0;

    if (_type == HomeFrom)
    {
        if ([name isEqualToString:@"法规"]) {
            index = 0;
        }else if ([name isEqualToString:@"案例查询"]){
            index = 1;
        }else if ([name isEqualToString:@"司法机关"]){
            index = 2;
        }else if ([name isEqualToString:@"赔偿标准"]){
            index = 3;
        }
        
    }else if (_type == LawsFrom){
        
        if ([name isEqualToString:@"新法速递"]) {
            index = 0;
        }else if ([name isEqualToString:@"常用法规"]){
            index = 1;
        }else if ([name isEqualToString:@"法规库"]){
            index = 2;
        }else if ([name isEqualToString:@"我的收藏"]){
            index = 3;
        }

    }
    _indexBlock(index);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
