//
//  ViewController.m
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "ViewController.h"
#import "DefineHeader.h"
#import "Disability_AlertView.h"

@interface ViewController ()<Disability_AlertViewPro>

@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sureBtn];
}
- (void)bindingBtnEvent:(UIButton *)btn
{
    DLog(@"点击");
    Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:DisabilityGradeType withDelegate:self];

//    Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:CaseType withDelegate:self];
    [alertView show];
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(26, 100, kMainScreenWidth - 52, 40);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5.f;
        _sureBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn setTitle:@"点击" forState:0];
        _sureBtn.titleLabel.font = Font_14;
        _sureBtn.tag = 3026;
        [_sureBtn addTarget:self action:@selector(bindingBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
