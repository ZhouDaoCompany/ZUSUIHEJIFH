//
//  ToolsIntroduceVC.m
//  ZhouDao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsIntroduceVC.h"
#import "UIWebView+HTML5.h"

@interface ToolsIntroduceVC ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ToolsIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}
#pragma mark - 
- (void)initUI{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupNaviBarWithTitle:@"计算说明"];
    self.titleLabel.font = Font_17;
    self.titleLabel.textColor = [UIColor blackColor];

    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];
    self.statusBarView.backgroundColor = ViewBackColor;//[UIColor colorWithHexString:@"#"];
    self.naviBarView.backgroundColor = ViewBackColor;

    [self.view addSubview:self.textView];
}
- (void)rightBtnAction{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
#pragma mark - setter and getter
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 74, kMainScreenWidth-20, kMainScreenHeight-74)];
        _textView.text = _introContent;
        _textView.backgroundColor =ViewBackColor;
//        LRViewBorderRadius(_textView, 3.f, 1.f, LINECOLOR);
        _textView.editable = NO;
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
