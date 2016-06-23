//
//  AccusingTheTabVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AccusingTheTabVC.h"
#import "AccusingTheCell.h"
#import "ZHPickView.h"

static NSString *const AccusingTheIDENTIFER = @"AccusingTheIDENTIFER";

@interface AccusingTheTabVC ()<UITextFieldDelegate>
{
    UITapGestureRecognizer * _tapGesture;
    NSString *_thytake_time;//收案时间
    NSString *_thyend_time;//结案时间
}
@property (strong, nonatomic) NSMutableArray *titleArrays;//标题
@property (strong, nonatomic) NSMutableArray *textArr;//内容
@property (strong, nonatomic) NSMutableArray *placeHoldArr;

@end

@implementation AccusingTheTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI{
    _placeHoldArr = [NSMutableArray arrayWithObjects:@"请输入案件名称",@"请输入委托人",@"请输入委托人电话",@"请输入委托人邮箱",@"请输入委托人地址",@"",@"",@"请输入结案形式", nil];
    _titleArrays = [NSMutableArray arrayWithObjects:@"案件名称",@"委托人",@"委托人联系电话",@"委托人联系邮箱",@"委托人联系地址",@"收案日期",@"结案日期",@"结案形式", nil];
    if (_accType == AccFromManager) {
    
        _textArr = [NSMutableArray array];
        [_msgArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_textArr addObject:obj];
        }];
        
    }else{
        _textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"", nil];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[AccusingTheCell class] forCellReuseIdentifier:AccusingTheIDENTIFER];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 108)];
    footView.backgroundColor = ViewBackColor;
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = KNavigationBarColor;
    commitBtn.titleLabel.font = Font_15;
    commitBtn.frame = CGRectMake(15.f, 34.f, kMainScreenWidth -30.f , 40);
    [commitBtn setTitle:@"提交" forState:0];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 3.f;
    [commitBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBtn];
    
    self.tableView.tableFooterView = footView;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    AccusingTheCell *cell = (AccusingTheCell *)[tableView dequeueReusableCellWithIdentifier:AccusingTheIDENTIFER];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[AccusingTheCell class]])
    {
        AccusingTheCell *aCell = (AccusingTheCell *)cell;
        NSUInteger row = indexPath.row;
        aCell.rowIndex = row;
        aCell.textField.tag = 7000+row;
        
        if (_titleArrays.count >0) {
            aCell.titleLab.text = _titleArrays[row];
        }
        
        if (row == 5 || row == 6)
        {
            if (_textArr.count >0) {
                aCell.deviceLabel.text = _textArr[row];
            }
            
        }else{
            aCell.textField.delegate = self;
            aCell.textField.placeholder = _placeHoldArr[row];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:aCell.textField];
            if (_textArr.count >0) {
                aCell.textField.text = _textArr[row];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    WEAKSELF;
    switch (row) {
        case 5:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thytake_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:5 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:5 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            
        }
            break;
        case 6:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thyend_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:6 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            
        }
            break;
        default:
            break;
    }
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    
    NSUInteger tag = textField.tag;
    
    [_textArr replaceObjectAtIndex:tag-7000 withObject:textField.text];
    
}
#pragma mark -UIButtonEvent
- (void)commitEvent:(id)sender
{WEAKSELF;
    DLog(@"提交");
    
    __block NSArray *paraArrays = [NSArray arrayWithObjects:@"name",@"client",@"client_phone",@"client_mail",@"client_address",@"thytake_time",@"thyend_time",@"thyend_shape", nil];
   __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"2") forKey:@"type"];

    [_textArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写案件名称"];
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];
        }else if (idx == 5){
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您选择收案日期"];
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(_thytake_time) forKey:@"start_time"];
            [msgDic setObjectWithNullValidate:GET(_thytake_time) forKey:@"thytake_time"];
        }else if (idx == 6){
            [msgDic setObjectWithNullValidate:GET(_thyend_time) forKey:@"end_time"];
            [msgDic setObjectWithNullValidate:GET(_thyend_time) forKey:@"thyend_time"];

            (_thyend_time.length == 0)?[msgDic setObjectWithNullValidate:@"1" forKey:@"state"]:(([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[_thyend_time doubleValue]] withDateFormat:@"yyyy-MM-dd"] ==1)?[msgDic setObjectWithNullValidate:@"2" forKey:@"state"]:[msgDic setObjectWithNullValidate:@"1" forKey:@"state"]);
        }else{
            NSString *keyStr = paraArrays[idx];
            [msgDic setObjectWithNullValidate:GET(obj) forKey:keyStr];
        }
    }];

    if (_accType == AccFromManager) {
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{
            weakSelf.editSuccess(weakSelf.textArr);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }else{
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeAdd] RequestSuccess:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
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
