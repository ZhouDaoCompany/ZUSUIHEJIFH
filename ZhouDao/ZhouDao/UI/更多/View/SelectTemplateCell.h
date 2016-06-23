//
//  SelectTemplateCell.h
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateData.h"

@interface SelectTemplateCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (nonatomic, strong) TemplateData *dataModel;
@end
