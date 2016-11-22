//
//  SocialResultCell.h
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistFileModel.h"
#import "CaseTextField.h"

@interface SocialResultCell : UITableViewCell

@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) CaseTextField *textField1;
@property (nonatomic, strong) CaseTextField *textField2;

- (void)setShowUIWithDictionary:(PlistFileModel *)fileModel
                   withIndexRow:(NSInteger)indexRow;
@end
