//
//  ZD_DeleteWindow.m
//  ZhouDao
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZD_DeleteWindow.h"


#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

#define delWidth 260.f
@interface ZD_DeleteWindow()<UITextFieldDelegate>

@property (nonatomic, copy) NSString *title;
@end
@implementation ZD_DeleteWindow

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(WindowType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _cusType = type;
        _title = title;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, delWidth, 100)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.cornerRadius = 1.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        [self initUI];
//        [self makeKeyAndVisible];
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    float heiht = 100.f;
    
    if (_cusType == DelType) {
        UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, delWidth, 50)];
        headlab.text = _title;
        headlab.textAlignment = NSTextAlignmentCenter;
        headlab.font = Font_14;
        headlab.numberOfLines = 0;
        headlab.textColor = LRRGBColor(96, 101, 111);
        [self.zd_superView addSubview:headlab];
    }else{
//        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
//        
//        CGPoint superPoint = self.zd_superView.center;
//        superPoint.y = superPoint.y -25;
        self.zd_superView.center = CGPointMake(zd_width/2.0, self.center.y-25.f);

        _nameTextF =[[UITextField alloc] initWithFrame:CGRectMake(15, 10, delWidth - 30, 30)];
        [self.zd_superView addSubview:_nameTextF];
        _nameTextF.placeholder = @"请输入名字";
        _nameTextF.delegate = self;
        _nameTextF.borderStyle = UITextBorderStyleNone;
        _nameTextF.returnKeyType = UIReturnKeyDone; //设置按键类型
        [_nameTextF becomeFirstResponder];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_nameTextF];
    }
    
    

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, delWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.zd_superView addSubview:lineView];
    
    //按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = Font_15;
    cancelBtn.tag = 3001;
    cancelBtn.frame = CGRectMake(0, Orgin_y(lineView), delWidth/2.f-0.3f , heiht - Orgin_y(lineView));
    [cancelBtn setTitleColor:KNavigationBarColor forState:0];
    [cancelBtn setTitle:@"取消" forState:0];
    //    navBtn.layer.masksToBounds = YES;
    //    navBtn.layer.cornerRadius = 5.f;
    //点击事件
//    [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    cancelBtn.showsTouchWhenHighlighted = YES;
    [cancelBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.zd_superView addSubview:cancelBtn];


    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(cancelBtn), Orgin_y(lineView), 0.6, heiht - Orgin_y(lineView))];
    lineView1.backgroundColor = lineColor    ;
    [self.zd_superView addSubview:lineView1];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor whiteColor];
    [sureBtn setTitleColor:KNavigationBarColor forState:0];
    sureBtn.titleLabel.font = Font_15;
    sureBtn.tag = 3002;
    sureBtn.frame = CGRectMake(Orgin_x(lineView1), Orgin_y(lineView), delWidth/2.f-0.3f , heiht - Orgin_y(lineView));
    [sureBtn setTitle:@"确定" forState:0];
    sureBtn.showsTouchWhenHighlighted = YES;
    [sureBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.zd_superView addSubview:sureBtn];
    
    [self.zd_superView whenCancelTapped:^{
        
    }];

//    [self whenTapped:^{
//
//        [self zd_Windowclose];
//        
//    }];

}
#pragma mark -UIButtonEvent
- (void)cancelOrSureEvent:(id)sender
{
    [self endEditing:YES];

    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    [btn setTitleColor:[UIColor colorWithHexString:@"#00c8aa"] forState:0];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者

    if (index == 3002)
    {
        if (_cusType == DelType) {
            _DelBlock();
        }else{
            if (_nameTextF.text.length >0) {
                _renameBlock(_nameTextF.text);
            }else{
                [JKPromptView showWithImageName:nil message:@"请您填写名字"];
                return;
            }
        }
    }
    [self zd_Windowclose];
}
//- (void)buttonClick:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    [button setBackgroundColor:[UIColor colorWithHexString:@"#00c8aa"]];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    
}

#pragma mark -关闭
- (void)zd_Windowclose {WEAKSELF;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,-230);
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(self.zd_superView)
    TTVIEW_RELEASE_SAFELY(self.titleLab)
    TTVIEW_RELEASE_SAFELY(self.nameTextF)
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
