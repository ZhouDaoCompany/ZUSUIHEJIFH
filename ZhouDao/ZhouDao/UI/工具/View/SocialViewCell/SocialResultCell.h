//
//  SocialResultCell.h
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistFileModel.h"

@interface SocialResultCell : UITableViewCell

@property (nonatomic, assign) NSInteger indexRow;

- (void)setShowUIWithDictionary:(PlistFileModel *)fileModel
                   withIndexRow:(NSInteger)indexRow;
@end
