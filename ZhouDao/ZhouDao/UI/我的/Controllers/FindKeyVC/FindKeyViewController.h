//
//  FindKeyViewController.h
//  ZhouDao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JKCountDownButton.h"

@interface FindKeyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@property (weak, nonatomic) IBOutlet UIImageView *eyeImg;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (nonatomic, copy) ZDStringBlock findBlock;
@property (nonatomic, copy) NSString *navTitle;//导航栏标题

- (IBAction)getCodeOrResetEvent:(id)sender;

@end
