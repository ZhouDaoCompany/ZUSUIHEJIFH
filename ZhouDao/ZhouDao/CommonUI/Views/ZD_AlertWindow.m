//
//  ZD_AlertWindow.m
//  ZhouDao
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZD_AlertWindow.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height
#define kContentLabelWidth     13.f/16.f*([UIScreen mainScreen].bounds.size.width)

static CGFloat kTransitionDuration = 0.3f;
static NSString *const ALERTCELLIDENTIFER = @"alertCellIdentifer";


@interface ZD_AlertWindow()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    CGRect _tableViewFrame;
}
@property (nonatomic, strong) UIView *zd_superView;
@property (nonatomic, strong) UILabel *headlab ;
@property (nonatomic, copy)   NSString *titleString;//标题
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *verticalLineView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableView *tableView;//表
@property (nonatomic, strong) NSArray *textArrays;
@end

@implementation ZD_AlertWindow
/**
 *  审查 导航 弹出框
 */
- (id)initWithStyle:(ZD_AlertViewStyle)style
  withTextAlignment:(NSTextAlignment)contentAlignment
              Title:(NSString *)title WithOptionArrays:(NSArray *)textArrays
{
    self = [super initWithFrame:kMainScreenFrameRect];

    if (self)
    {
        _style = style;
        _contentAlignment = contentAlignment;
        _titleString = title;
        _textArrays = textArrays;
        [self initData];
        [self bounce0Animation];

    }
    return self;
}
- (id)initWithStyle:(ZD_AlertViewStyle)style
          withTitle:(NSString *)title
  withTextAlignment:(NSTextAlignment)contentAlignment
           delegate:(id <ZD_AlertWindowPro>)delegate withIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithFrame:kMainScreenFrameRect];
    
    if (self) {
        _style = style;
        _contentAlignment = contentAlignment;
        _titleString = title;
        _indexPath = indexPath;
        _delegate = delegate;
        [self initUI];
        [self bounce0Animation];
    }
    return self;

}
#pragma mark - private methods
- (void)initData {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self addSubview:self.zd_superView];
    [self.zd_superView addSubview:self.headlab];
    self.headlab.frame = CGRectMake(15, 20, kContentLabelWidth - 50, 20);
    
    if (_style == ZD_AlertViewStyleReview) {
        
        _zd_superView.frame = CGRectMake(0, 0, kContentLabelWidth, 179);
        _zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        UILabel *msgLab = [[UILabel alloc] init];
        msgLab.center = self.zd_superView.center;
        msgLab.frame = CGRectMake(15, 54, kContentLabelWidth -30, 100);
        msgLab.font = Font_14 ;
        msgLab.numberOfLines = 0;
        msgLab.text = @"已审查：信息已和官方网站信息核对一致。\n \n未审查：信息正在马不停蹄的审核中，请您耐心等待。";
        [self.zd_superView addSubview:msgLab];

    } else {
        
        _zd_superView.frame = CGRectMake(0, 0, kContentLabelWidth, 50 + 55 * [_textArrays count]);
        _zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        
        _tableViewFrame = (55 * [_textArrays count] > 220) ? CGRectMake(0, 50, kContentLabelWidth, 270) : CGRectMake(0, 50, kContentLabelWidth, 55*[_textArrays count]);
        [self.zd_superView addSubview:self.tableView];

    }

    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenTapped:^{
        
        [self zd_Windowclose];
    }];

}
- (void)initUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self addSubview:self.zd_superView];
    self.zd_superView.frame = CGRectMake(0, 0, kContentLabelWidth, 110);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kContentLabelWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [self.zd_superView addSubview:lineView];

    [self.zd_superView addSubview:self.cancelBtn];
    [self.zd_superView addSubview:self.verticalLineView];
    [self.zd_superView addSubview:self.sureBtn];
    
    if (_style == ZD_AlertViewStyleDEL) {//删除
        
        [self.zd_superView addSubview:self.headlab];
        self.zd_superView.center =CGPointMake(zd_width/2.0,zd_height/2.0);
        self.headlab.frame = CGRectMake(0, 0, kContentLabelWidth, 50);
        _headlab.text = _titleString;
        _headlab.font = Font_14;
        _headlab.textColor = LRRGBColor(96, 101, 111);
    }else {//重命名
        [self.zd_superView addSubview:self.nameTextF];

        if ((kMainScreenHeight - self.center.y) < 271.f) {
            _zd_superView.center = CGPointMake(zd_width/2.0, kMainScreenHeight - 326.f);
        }else {
            _zd_superView.center = CGPointMake(zd_width/2.0, self.center.y-25.f);
        }
    }
}
- (void)selectButtonEvent:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:index];
    }
    [self implementationBlockwithIndex:index];
}
- (void)implementationBlockwithIndex:(NSInteger)index {
    if (index == 0) {
        
        if (_cancelBlock) {
            _cancelBlock();
        }
    } else {
        
        if (_confirmBlock) {
            _confirmBlock();
        }
    }
    [self zd_Windowclose];
}
#pragma mark -UIButtonEvent
- (void)cancelOrSureEvent:(UIButton *)sender {
    
    [self endEditing:YES];
    NSInteger index = sender.tag - 3001;
    if (index == 1) {
        if (_style == ZD_AlertViewStyleDEL) {

            if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:withName:withIndexPath:)]) {
                [self.delegate alertView:self clickedButtonAtIndex:index withName:_nameTextF.text withIndexPath:_indexPath];
            }

        }else {
            
            if (_nameTextF.text.length == 0) {
                [JKPromptView showWithImageName:nil message:LOCFILENAME];
                return;
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
            if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:withName:withIndexPath:)]) {
                [self.delegate alertView:self clickedButtonAtIndex:index withName:_nameTextF.text withIndexPath:_indexPath];
            }
        }
    }
    [self implementationBlockwithIndex:index];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_textArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ALERTCELLIDENTIFER];
    cell.textLabel.text = _textArrays[indexPath.row];
    cell.textLabel.font = Font_16;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = THIRDCOLOR;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSString *textTitle = _textArrays[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:indexPath.row];
    }
    [self implementationBlockwithIndex:indexPath.row];
}
#pragma mark -
#pragma mark block setter

- (void)setCancelBlock:(ZDBlock)block
{
    _cancelBlock = [block copy];
}

- (void)setConfirmBlock:(ZDBlock)block
{
    _confirmBlock = [block copy];
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_tableViewFrame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ALERTCELLIDENTIFER];
    }
    return _tableView;
}
#pragma mark - setters and getters
- (UILabel *)headlab
{
    if (!_headlab) {
        _headlab = [[UILabel alloc] init];
        _headlab.text = _titleString;
        _headlab.textAlignment = _contentAlignment;
        _headlab.font = Font_18;
    }
    return _headlab;
}
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        _zd_superView = [[UIView alloc] init];
        _zd_superView.backgroundColor = [UIColor whiteColor];
        _zd_superView.layer.cornerRadius = 3.f;
        _zd_superView.clipsToBounds = YES;
    }
    return _zd_superView;
}
- (UIView *)verticalLineView
{
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(_cancelBtn), 60.6, 0.6, 49.4f)];
        _verticalLineView.backgroundColor = LINECOLOR;
    }
    return _verticalLineView;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        [_sureBtn setTitleColor:KNavigationBarColor forState:0];
        _sureBtn.titleLabel.font = Font_15;
        _sureBtn.tag = 3002;
        _sureBtn.frame = CGRectMake(Orgin_x(_verticalLineView),60.6f,kContentLabelWidth/2.f-0.3f , 49.4f);
        [_sureBtn setTitle:@"确定" forState:0];
        _sureBtn.showsTouchWhenHighlighted = YES;
        [_sureBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = Font_15;
        _cancelBtn.tag = 3001;
        _cancelBtn.frame = CGRectMake(0, 60.6f,kContentLabelWidth/2.f-0.3f , 49.4f);
        [_cancelBtn setTitleColor:KNavigationBarColor forState:0];
        [_cancelBtn setTitle:@"取消" forState:0];
        _cancelBtn.showsTouchWhenHighlighted = YES;
        [_cancelBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UITextField *)nameTextF
{
    if (!_nameTextF)
    {
        _nameTextF =[[UITextField alloc] initWithFrame:CGRectMake(15, 15, kContentLabelWidth - 30, 30)];
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
    return _nameTextF;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
}
#pragma mark -关闭
- (void)zd_Windowclose {
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    self.alpha = 0.0;
    [UIView commitAnimations];
}
#pragma mark -
#pragma mark animation

- (void)bounce0Animation{
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

- (void)bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}
- (void)bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(bounceDidStop)];
    self.zd_superView.transform = [AnimationTools transformForOrientation];
    [UIView commitAnimations];
}

- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(self.zd_superView)
}
#pragma mark -
#pragma mark tools

+ (CGFloat)heightOfString:(NSString *)message withFont:(CGFloat)fontSize
{
    if (message == nil || [message isEqualToString:@""]) {
        return 20.0f;
    }
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        CGSize messageSize = [message boundingRectWithSize:CGSizeMake(kContentLabelWidth,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return messageSize.height+10.0;
}

@end
