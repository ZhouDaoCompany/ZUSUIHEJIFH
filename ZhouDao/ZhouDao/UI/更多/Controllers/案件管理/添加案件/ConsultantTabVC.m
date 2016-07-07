//
//  ConsultantTabVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ConsultantTabVC.h"
#import "ConsultantCell.h"
#import "ZHPickView.h"
#import "ZD_DeleteWindow.h"
#import "ConsultantHeadView.h"
#import "RemarkTabCell.h"
#import "ZD_DeleteWindow.h"

static NSString *const ConsultantIDENTIFER = @"ConsultantIDENTIFER";
static NSString *const CONNOTEIDENTIFER = @"consultantnoteidentifer";

@interface ConsultantTabVC ()<UITextFieldDelegate,UITextViewDelegate,ConsultantHeadViewPro>
{
    UITapGestureRecognizer * _tapGesture;
    NSString *_sign_time;// 合同起始时间
    NSString *_end_time; // 合同到期时间
}
@property (strong, nonatomic) NSMutableArray *basicTitleArrays;//第一区标题
@property (nonatomic, strong) NSMutableArray *moreTilArr;//更多信息标题

@property (nonatomic, strong) NSMutableArray *textBasiArr;//第一区内容
@property (nonatomic, strong) NSMutableArray *textConArr;//更多信息大数组
@property (strong, nonatomic) UIButton *cancelBtn;
@property (nonatomic, strong) UIWebView *callPhoneWebView;
@end

@implementation ConsultantTabVC
#pragma mark -打电话
- (UIWebView *)callPhoneWebView {
    if (!_callPhoneWebView) {
        _callPhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _callPhoneWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI{

   _basicTitleArrays = [NSMutableArray arrayWithObjects:@"委托人/公司",@"合同起始时间",@"合同到期时间",@"联系人",@"联系人电话",@"联系人邮箱", nil];
    _moreTilArr = [NSMutableArray arrayWithObjects:@"法定代表人",@"公司地址",@"主营业务",@"股东情况",@"", nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    if (_ConType == ConFromManager) {
        WEAKSELF;
        _textConArr  = [NSMutableArray array];
        _textBasiArr = [NSMutableArray array];
        
        [_moreArr enumerateObjectsUsingBlock:^(MoreModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.textConArr addObject:model.content];
        }];
        
        NSString *sign_time = @"";
        if ([_basicModel.sign_time intValue] != 0) {
            sign_time = [QZManager changeTimeMethods:[_basicModel.sign_time doubleValue] withType:@"yyyy-MM-dd"];
        }
        NSString *sign_endtime = @"";
        if ([_basicModel.sign_endtime intValue] !=0) {
            sign_endtime = [QZManager changeTimeMethods:[_basicModel.sign_endtime doubleValue] withType:@"yyyy-MM-dd"];
        }

        _textBasiArr = [NSMutableArray arrayWithObjects:_basicModel.client,sign_time,sign_endtime,_basicModel.contacts,_basicModel.phone,_basicModel.mail, nil];
        
    }else{
        _textBasiArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
        _textConArr = [NSMutableArray array];
        self.tableView.tableFooterView = [self creatTabFootView];;
    }

    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];

}
- (UIView *)creatTabFootView{
    
    UIView *botomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    botomView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    float width = botomView.bounds.size.width;
    
    //按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = Font_15;
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];
    cancelBtn.frame = CGRectMake(15, 20, (width-45)/2.f , 40);
    [cancelBtn setTitle:@"添加更多信息" forState:0];
//    cancelBtn.layer.masksToBounds = YES;
//    cancelBtn.layer.cornerRadius = 5.f;
    [cancelBtn addTarget:self action:@selector(addMoreMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
    if (_ConType == ConFromManager && _isEdit == YES && _textConArr.count >0) {
    
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#B7B7B7"];
        cancelBtn.enabled = NO;
    }
    _cancelBtn = cancelBtn;
    [botomView addSubview:cancelBtn];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];;
    sureBtn.titleLabel.font = Font_15;
    sureBtn.frame = CGRectMake(Orgin_x(cancelBtn) +15.f, 20, (width-45)/2.f , 40);
    [sureBtn setTitle:@"提交" forState:0];
//    sureBtn.layer.masksToBounds = YES;
//    sureBtn.layer.cornerRadius = 5.f;
    [sureBtn addTarget:self action:@selector(commitConsultantEvent:) forControlEvents:UIControlEventTouchUpInside];
    [botomView addSubview:sureBtn];
    
    return botomView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + [_textConArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return  [_basicTitleArrays count];
    }
    return [_moreTilArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (indexPath.section > 0) {
        
        if (_textConArr.count >0) {
            
            NSMutableArray *conArr = _textConArr[indexPath.section -1];
            if (conArr.count -1 == indexPath.row) {
                [self.tableView registerClass:[RemarkTabCell class] forCellReuseIdentifier:CONNOTEIDENTIFER];
                RemarkTabCell *cell = (RemarkTabCell *)[tableView dequeueReusableCellWithIdentifier:CONNOTEIDENTIFER forIndexPath:indexPath];
                return cell;
            }
        }
    }
    
    [self.tableView registerClass:[ConsultantCell class] forCellReuseIdentifier:ConsultantIDENTIFER];
    ConsultantCell *cell = (ConsultantCell *)[tableView dequeueReusableCellWithIdentifier:ConsultantIDENTIFER];
    return cell;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;

    if ([cell isKindOfClass:[ConsultantCell class]])
    {
        ConsultantCell *cCell = (ConsultantCell *)cell;
        cCell.sectionIndex = section;
        cCell.rowIndex = row;
        
        if (section == 0) {
            cCell.titleLab.text = _basicTitleArrays[row];
            
            cCell.deviceLabel.text = _textBasiArr[row];
            cCell.textField.section = section;
            cCell.textField.row = row;
            cCell.textField.delegate = self;
            cCell.textField.text = _textBasiArr[row];
            if (_ConType == ConFromManager && _isEdit == NO) {
                cCell.textField.enabled = NO;
                cCell.isEdit = NO;
            }else{
                cCell.textField.enabled = YES;
                cCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_basicTitleArrays[row]];
                cCell.isEdit = YES;
            }
            [cCell settingFrame];

        }else {
            
            if (indexPath.row <= [_moreTilArr count] -1) {
                
                NSMutableArray *conArr = _textConArr[section -1];
                cCell.titleLab.text = _moreTilArr[row];
                cCell.textField.section = section;
                cCell.textField.row = row;
                cCell.textField.delegate = self;
                if (_ConType == ConFromManager && _isEdit == NO) {
                    
                    cCell.textField.enabled = NO;
                    cCell.isEdit = NO;
                }else{
                    
                    cCell.textField.enabled = YES;
                    cCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_moreTilArr[row]];
                    cCell.isEdit = YES;
                }
                cCell.textField.text = conArr[row];
            }
        }
        
        [cCell settingFrame];
        [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:cCell.textField];

    }else if ([cell isKindOfClass:[RemarkTabCell class]]){
        
        NSMutableArray *conArr = _textConArr[section -1];

        RemarkTabCell *rCell = (RemarkTabCell *)cell;
        rCell.textView.delegate = self;
        rCell.textView.tag = 5000 + section;
        rCell.textView.text = [NSString stringWithFormat:@"%@",[conArr lastObject]];
        if (_ConType == ConFromManager && _isEdit == NO) {
            rCell.textView.editable = NO;
            rCell.placeHoldlab.text = @"";
        }else{
            rCell.textView.editable = YES;
            
            if (rCell.textView.text.length >0) {
                rCell.placeHoldlab.text = @"";
            }else {
                rCell.placeHoldlab.text = @" 写备注...";
            }
        }

//        rCell.placeHoldlab.tag = 8200 + section;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    WEAKSELF;
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;

    if (_ConType == ConFromManager && _isEdit == NO) {
        //非编辑状态不能修改
        [self clickTelPhoneWithSection:section withRow:row];

        return;
    }
    
    UIWindow *windows = [QZManager getWindow];

    if (section ==0 && row == 1){
    
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showWindowPickView:windows];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            _sign_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
            [weakSelf.textBasiArr replaceObjectAtIndex:1 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };

    }else if(section ==0 && row == 2){
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showWindowPickView:windows];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            _end_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
            [weakSelf.textBasiArr replaceObjectAtIndex:2 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f) withSection:section];
    headView.delBtn.hidden = NO;
    if (_ConType == ConFromManager && _isEdit == NO) {
        headView.delBtn.hidden = YES;
    }
    headView.delegate = self;
    [headView setLabelText:@"添加更多信息"];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 45.f;
    }
    return 0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        NSMutableArray *oneArr = _textConArr[indexPath.section -1];
        if (oneArr.count -1 == indexPath.row) {
            return 115.f;
        }
    }
    return 50.f;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    CaseTextField *textField = (CaseTextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger section = textField.section;
    NSInteger row = textField.row;

    if (section == 0) {
        [_textBasiArr replaceObjectAtIndex:row withObject:textField.text];
    }else{
        NSMutableArray *arr = _textConArr[section -1];
        [arr replaceObjectAtIndex:arr.count -1  withObject:textField.text];
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger section = textView.tag - 5000;

    [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *placeHoldlab = (UILabel *)obj;
            if (textView.text.length >0) {
                placeHoldlab.text = @"";
            }else {
                placeHoldlab.text = @" 写备注...";
            }
        }
    }];
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
    if (flag){
        textView.text = [NSString disable_emoji:textView.text];
    }
    
    NSMutableArray *arr = _textConArr[section -1];
    [arr replaceObjectAtIndex:arr.count -1  withObject:textView.text];
}
#pragma mark -ConsultantHeadViewPro
- (void)deleteSectionEventRespose:(NSUInteger)section;
{WEAKSELF;
    ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"确定删除吗?" withType:DelType];
    delWindow.DelBlock = ^(){
        
        DLog(@"section-----%ld",section);
        [weakSelf.textConArr removeObjectAtIndex:section-1];
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
        
        weakSelf.cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];
        weakSelf.cancelBtn.enabled = YES;

    };
    [self.view.superview addSubview:delWindow];
}
#pragma mark - 拨打电话
- (void)clickTelPhoneWithSection:(NSInteger)section withRow:(NSInteger)row
{
    if (section == 0)
    {
        if ([QZManager isString:_basicTitleArrays[row] withContainsStr:@"电话"])
        {
            NSString *phoneStr = _textBasiArr[row];
            if (phoneStr.length >0) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                [self.callPhoneWebView loadRequest:request];
            }
        }
    }
}

#pragma mark - Event Respose
- (void)addMoreMsgEvent:(id)sender
{
    if (_textConArr.count >0) {
        
        return;
    }
    DLog(@"添加更多信息");
    __block NSMutableArray *conArr = [NSMutableArray array];
    
    [_moreTilArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [conArr addObject:@""];
    }];

    [_textConArr addObject:conArr];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:_textConArr.count] withRowAnimation:UITableViewRowAnimationTop];
    
    UIButton *btn = (UIButton *)sender;
    btn.backgroundColor = [UIColor colorWithHexString:@"#B7B7B7"];
    btn.enabled = NO;
}
#pragma mark -UIButtonEvent
- (void)commitConsultantEvent:(id)sender
{WEAKSELF;
    DLog(@"提交");
    NSArray *paraArr = [NSArray arrayWithObjects:@"client",@"sign_time",@"sign_endtime",@"contacts",@"phone",@"mail", nil];
    __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"3") forKey:@"type"];
    
    __block BOOL _isReturn = NO;
    [_textBasiArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写委托人/公司"];
                _isReturn = YES;
                *stop = YES;;
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"client"];
            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];

        }else if (idx == 1){
            [msgDic setObjectWithNullValidate:GET(_sign_time) forKey:paraArr[idx]];
        }else if (idx == 2){
            [msgDic setObjectWithNullValidate:GET(_end_time) forKey:paraArr[idx]];
        }else {
            [msgDic setObjectWithNullValidate:obj forKey:paraArr[idx]];
        }
    }];
    
    if (_isReturn == YES) {
        return;
    }

    __block NSMutableArray *moreArr = [NSMutableArray array];
    if (_textConArr.count >0) {
        [_textConArr enumerateObjectsUsingBlock:^(NSMutableArray *conArr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *moreDic = [[NSMutableDictionary alloc] init];
            [moreDic setObjectWithNullValidate:@"9" forKey:@"type"];
            [moreDic setObjectWithNullValidate:conArr forKey:@"content"];
            
            NSData *weChatdatamsg = [self toJSONData:moreDic];
            NSString *weChatPayMsg =[[NSString alloc] initWithData:weChatdatamsg
                                                          encoding:NSUTF8StringEncoding];
            
            [moreArr addObject:weChatPayMsg];
        }];
    }
    
    [msgDic setObjectWithNullValidate:moreArr forKey:@"more"];
    
    
    if (_ConType == ConFromManager) {
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{

            weakSelf.editSuccess(msgDic[@"client"]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeAdd] RequestSuccess:^{
            
            weakSelf.addSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }

}

#pragma mark - 是否编辑
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if (_isEdit == YES) {
        self.tableView.tableFooterView = [self creatTabFootView];
        [self.tableView reloadData];
    }else {
        [self commitConsultantEvent:nil];
    }
}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ( error == nil){
        return jsonData;
    }else{
        return nil;
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
