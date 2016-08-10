//
//  LitigationTabVC.m
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//



#import "LitigationTabVC.h"
#import "LitigationCell.h"
#import "ConsultantHeadView.h"
#import "CaseTextField.h"
#import "RemarkTabCell.h"
#import "DateTimeView.h"
#import "ZHPickView.h"
#import "ZD_DeleteWindow.h"

static NSString *const LITIIDENTIFER = @"litigationidentifer";
static NSString *const NOTEIDENTIFER = @"noteidentifer";

@interface LitigationTabVC ()<UITextFieldDelegate,ConsultantHeadViewPro,UITextViewDelegate>
{
    UITapGestureRecognizer * _tapGesture;
}
@property (nonatomic, strong) NSMutableArray *basiArr;//基本信息数组
@property (nonatomic, strong) NSMutableArray *textBasiArr;

@property (nonatomic, strong) NSMutableArray *contentTilArr;//审理标题大数组
@property (nonatomic, strong) NSMutableArray *contentArr;//审理信息大数组
@property (nonatomic, strong) NSMutableArray *categoryArr;//存贮类别数组  添加 修改 删除
@property (nonatomic, strong) NSArray *kindsArr;//六种类别
@property (nonatomic, strong) UIWebView *callPhoneWebView;

@end
@implementation LitigationTabVC
#pragma mark -打电话
- (UIWebView *)callPhoneWebView {
    if (!_callPhoneWebView) {
        _callPhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _callPhoneWebView;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    WEAKSELF;
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.backgroundColor = [UIColor clearColor];

    _basiArr = [NSMutableArray arrayWithObjects:@"案件号",@"案件名称",@"委托人",@"-联系电话",@"-联系邮箱", @"-联系地址",@"收案日期",@"原告人/上诉人/公诉机关",@"被告/被上诉人",nil];
    _kindsArr = @[@"经济仲裁", @"劳动仲裁",@"一审",@"二审",@"再审",@"执行程序"];
    /**
     *  (1经济仲裁 2劳动仲裁) ,(3一审 4二审), 5再审, 6执行程序
     */
    NSArray *arr1 = [NSArray arrayWithObjects:@"审理类别",@"仲裁委员会",@"联系电话",@"联系地址",@"仲裁员联系电话",@"书记员联系电话",@"仲裁结果",@"备注", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"审理类别",@"法院名称",@"联系电话",@"联系地址",@"主审法官联系电话",@"书记员联系电话",@"审判结果",@"收到法律文书时间",@"备注", nil];
    NSArray *arr4 = [NSArray arrayWithObjects:@"审理类别",@"法院名称",@"联系电话",@"联系地址",@"执行法官联系电话",@"书记员联系电话",@"备注", nil];
    _contentTilArr = [NSMutableArray arrayWithObjects:arr1,arr1,arr2,arr2,arr2,arr4, nil];
    
    if (_litEditType == LitiDetails ) {
        
        if ([_basicModel.thytake_time  integerValue] == 0) {
            _basicModel.thytake_time = @"";
        }
        
        _textBasiArr = [NSMutableArray arrayWithObjects:_basicModel.number,_basicModel.name,_basicModel.client,_basicModel.client_phone,_basicModel.client_mail, _basicModel.client_address,_basicModel.thytake_time,_basicModel.plaintiff,_basicModel.defendant,nil];
        _contentArr = [NSMutableArray array];
        _categoryArr = [NSMutableArray array];
        [_moreArr enumerateObjectsUsingBlock:^(MoreModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.categoryArr addObject:model.type];
            
            [weakSelf.contentArr addObject:model.content];
        }];

    }else {
        
        _textBasiArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", @"",@"",@"",@"",nil];
        _categoryArr = [NSMutableArray array];
        _contentArr = [NSMutableArray array];
        self.tableView.tableFooterView = [self creatTabFootView];
    }
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];
}
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
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
    [cancelBtn setTitle:@"添加审理信息" forState:0];
//    cancelBtn.layer.masksToBounds = YES;
//    cancelBtn.layer.cornerRadius = 5.f;
    [cancelBtn addTarget:self action:@selector(addMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
    [botomView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];;
    sureBtn.titleLabel.font = Font_15;
    sureBtn.frame = CGRectMake(Orgin_x(cancelBtn) +15.f, 20, (width-45)/2.f , 40);
    [sureBtn setTitle:@"提交" forState:0];
//    sureBtn.layer.masksToBounds = YES;
//    sureBtn.layer.cornerRadius = 5.f;
    [sureBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [botomView addSubview:sureBtn];
    
    return botomView;
}
- (void)deleteAlertMethods:(NSString *)selectStr withSection:(NSInteger)section
{WEAKSELF;
    
    NSMutableArray *contentArr = _contentArr[section-1];

    __block BOOL isHave = NO;

    [contentArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 0) {
            if(obj.length >0){
                *stop  = YES;
                isHave = YES;
                return ;
            }
        }
    }];
    
    if (isHave == YES) {
        ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"修改后该审理下的信息清空，确定修改?" withType:DelType];
        delWindow.DelBlock = ^(){
            
            [weakSelf delCheckmsg:selectStr withSection:section];
        };
        [self.view.superview addSubview:delWindow];

    }else {
        [self delCheckmsg:selectStr withSection:section];
    }
    
}
- (void)delCheckmsg:(NSString *)selectStr withSection:(NSInteger)section
{WEAKSELF;
    __block NSInteger buttonIndex = 0;
    [weakSelf.kindsArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:selectStr]) {
            buttonIndex = idx;
        }
    }];
    DLog(@"第几个----%ld",(long)buttonIndex);
    NSString *classIndex = [NSString stringWithFormat:@"%ld",buttonIndex + 1];
    [weakSelf.categoryArr replaceObjectAtIndex:section-1 withObject:classIndex];
    NSArray *arr = weakSelf.contentTilArr[buttonIndex];
    __block NSMutableArray *conArr = [NSMutableArray array];
    NSString *titStr = weakSelf.kindsArr[buttonIndex];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        (idx == 0)?[conArr addObject:titStr]:[conArr addObject:@""];
    }];
    [weakSelf.contentArr replaceObjectAtIndex:section-1 withObject:conArr];
    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = 1 + [_contentArr count];
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [_basiArr count];
    }
    NSString *cateStr = _categoryArr[section -1];
    NSArray *titArr = _contentTilArr[[cateStr intValue] -1];
    return [titArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (indexPath.section >0) {
        NSMutableArray *contentArr = _contentArr[indexPath.section - 1];
        if (indexPath.row == contentArr.count - 1) {
            
            [self.tableView registerClass:[RemarkTabCell class] forCellReuseIdentifier:NOTEIDENTIFER];
            RemarkTabCell *cell = (RemarkTabCell *)[tableView dequeueReusableCellWithIdentifier:NOTEIDENTIFER forIndexPath:indexPath];
            return cell;
        }
        [self.tableView registerClass:[LitigationCell class] forCellReuseIdentifier:LITIIDENTIFER];
        LitigationCell *cell = (LitigationCell *)[tableView dequeueReusableCellWithIdentifier:LITIIDENTIFER forIndexPath:indexPath];
        return cell;
    }
    
    [self.tableView registerClass:[LitigationCell class] forCellReuseIdentifier:LITIIDENTIFER];
    LitigationCell *cell = (LitigationCell *)[tableView dequeueReusableCellWithIdentifier:LITIIDENTIFER forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if ([cell isKindOfClass:[LitigationCell class]]) {
        LitigationCell *lCell = (LitigationCell *)cell;
        
        lCell.section = section;
        lCell.rowIndex = row;
        if (section == 0)
        {
            if (_basiArr.count >0)
            {
                
                lCell.titleLab.text = _basiArr[row];
                if (_litEditType == LitiDetails && _isEdit == NO) {
                    lCell.textField.enabled = NO;
                    lCell.isEdit = NO;
                }else{
                    lCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_basiArr[row]];
                    lCell.textField.enabled = YES;
                    lCell.isEdit = YES;
                }
                NSString *text = @"";
                if ([NSString stringWithFormat:@"%@",_textBasiArr[row]].length >0) {
                    if ([_basiArr[row] isEqualToString:@"收案日期"]) {
                        text = [QZManager changeTimeMethods:[_textBasiArr[row] doubleValue] withType:@"yyyy-MM-dd"];
                    }else {
                        text = _textBasiArr[row];
                    }
                }
                
                lCell.deviceLabel.text = text;
                lCell.textField.text = _textBasiArr[row];
                lCell.textField.section = section;
                lCell.textField.row = row;
                
                [lCell settingFrame];
            }
        }else{
            
            if (_categoryArr.count >0){
                
                NSString *cateStr = _categoryArr[section -1];
                NSArray *titArr = _contentTilArr[[cateStr intValue]-1];
                NSMutableArray *contentArr = _contentArr[section-1];
                lCell.titleLab.text = titArr[row];
                
                if (_litEditType == LitiDetails && _isEdit == NO) {
                    lCell.textField.enabled = NO;
                    lCell.isEdit = NO;
                }else{
                    lCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",titArr[row]];
                    lCell.textField.enabled = YES;
                    lCell.isEdit = YES;
                }
                
                NSString *text = @"";
                if ([NSString stringWithFormat:@"%@",contentArr[row]].length >0) {
                    if ([titArr[row] isEqualToString:@"收到法律文书时间"]) {
                        text = [QZManager changeTimeMethods:[contentArr[row] doubleValue] withType:@"yyyy-MM-dd HH:mm"];
                    }else{
                        text = contentArr[row];
                    }
                }

                lCell.deviceLabel.text = text;
                lCell.textField.text = contentArr[row];
                
                lCell.textField.section = section;
                lCell.textField.row = row;
                
                [lCell settingFrame];
            }
        }
        
        [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:lCell.textField];
        
    }else if ([cell isKindOfClass:[RemarkTabCell class]]){
        
        RemarkTabCell *rCell = (RemarkTabCell *)cell;
        NSMutableArray *contentArr = _contentArr[section-1];
        rCell.textView.delegate = self;
        rCell.textView.text = contentArr[row];
        rCell.textView.tag = section + 1000;
//        rCell.placeHoldlab.tag = 8800 +section;
        
        if (_litEditType == LitiDetails && _isEdit == NO) {
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
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (_litEditType == LitiDetails && _isEdit == NO) {
        //编辑状态不能修改
        [self clickTelPhoneWithSection:section withRow:row];
        return;
    }

    
    if (section == 0) {
    
        if (row == 6) {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            UIWindow *windows = [QZManager getWindow];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textBasiArr replaceObjectAtIndex:row withObject:timeStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
    }else {
        if (row == 0) {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:_kindsArr title:@"重复"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [self deleteAlertMethods:selectedStr withSection:section];
            };

        }else {
            
            NSString *cateStr = _categoryArr[section -1];
            NSArray *titArr = _contentTilArr[[cateStr intValue]-1];

            if ([titArr[row] isEqualToString:@"仲裁结果"] || [titArr[row] isEqualToString:@"审判结果"]) {
               __block NSArray *resultsArr = @[@"裁决", @"调解",@"撤回"];
                
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:resultsArr title:@"重复"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    DLog(@"哪一个----%@",selectedStr);
                    NSMutableArray *arr = weakSelf.contentArr[section -1];
                    [arr replaceObjectAtIndex:row withObject:selectedStr];
                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                };

            }
            
            if ([titArr[row] isEqualToString:@"收到法律文书时间"]) {
                
                UIWindow *windows = [QZManager getWindow];
                DateTimeView *timeView = [[DateTimeView alloc] initWithFrame:kMainScreenFrameRect];
                timeView.timeBlock = ^(NSString *timeS,NSString *sjcStr){
                    
                    NSMutableArray *arr = weakSelf.contentArr[section -1];
                    [arr replaceObjectAtIndex:row withObject:sjcStr];
                    [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:section], nil] withRowAnimation:UITableViewRowAnimationNone];
                };
                [windows addSubview:timeView];

            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f) withSection:section];
    if (section ==0) {
        headView.delBtn.hidden = YES;
        [headView setLabelText:@"基本信息"];
    }else{
        if (_litEditType == LitiDetails && _isEdit == NO){
            headView.delBtn.hidden = YES;
        }else{
            headView.delBtn.hidden = NO;
        }
        headView.delegate = self;
        [headView setLabelText:@"审理信息"];
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section >0) {
        NSMutableArray *contentArr = _contentArr[indexPath.section - 1];
        if (indexPath.row == contentArr.count - 1) {
            return 115.f;
        }

        return 50.f;
    }
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}
#pragma mark -ConsultantHeadViewPro
- (void)deleteSectionEventRespose:(NSUInteger)section;
{WEAKSELF;
    ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"确定删除吗?" withType:DelType];
    delWindow.DelBlock = ^(){
        
        DLog(@"section-----%ld",(unsigned long)section);
        [weakSelf.contentArr removeObjectAtIndex:section-1];
        [weakSelf.categoryArr removeObjectAtIndex:section-1];
        [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
    };
    [self.view.superview addSubview:delWindow];

}
#pragma mark - 拨打电话
- (void)clickTelPhoneWithSection:(NSInteger)section withRow:(NSInteger)row
{
    if (section == 0)
    {
        if ([QZManager isString:_basiArr[row] withContainsStr:@"电话"])
        {
            NSString *phoneStr = _textBasiArr[row];
            if (phoneStr.length >0) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                [self.callPhoneWebView loadRequest:request];
            }
        }
    }else {
        
        NSString *cateStr = _categoryArr[section -1];
        NSArray *titArr = _contentTilArr[[cateStr intValue]-1];
        if ([QZManager isString:titArr[row] withContainsStr:@"电话"]){
            
            NSMutableArray *arr = _contentArr[section -1];
            NSString *phoneStr = arr[row];
            if (phoneStr.length >0) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                [self.callPhoneWebView loadRequest:request];
            }
        }
    }
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{

    CaseTextField *textField = (CaseTextField *)noti.object;
    NSInteger section = textField.section;
    NSInteger row = textField.row;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    if (section == 0) {
        [_textBasiArr replaceObjectAtIndex:row withObject:textField.text];
    }else {
        NSMutableArray *arr = _contentArr[section-1];
        [arr replaceObjectAtIndex:row withObject:textField.text];
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger section = textView.tag - 1000;

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
    
    NSMutableArray *arr = _contentArr[section-1];
    [arr replaceObjectAtIndex:arr.count -1  withObject:textView.text];
}
#pragma mark -Event Respose
- (void)addMsgEvent:(UIButton *)sender
{
    [_categoryArr addObject:@"1"];
    NSArray *arr = _contentTilArr[0];
    __block NSMutableArray *conArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        (idx == 0)?[conArr addObject:@"经济仲裁"]:[conArr addObject:@""];
    }];
    [_contentArr addObject:conArr];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:_contentArr.count] withRowAnimation:UITableViewRowAnimationTop];
}
- (void)commitEvent:(UIButton *)sender
{WEAKSELF;
    DLog(@"提交案件");
    __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"1") forKey:@"type"];
    
    NSArray *paraArr = [NSArray arrayWithObjects:@"number",@"name",@"client",@"client_phone",@"client_mail",@"client_address",@"thytake_time",@"plaintiff",@"defendant", nil];
    __block BOOL _isReturn = NO;

    [_textBasiArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写案件名称"];
                _isReturn = YES;
                *stop = YES;
                return ;
            }            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];

        }else {
            [msgDic setObjectWithNullValidate:obj forKey:paraArr[idx]];
        }
    }];
    
    if (_isReturn == YES) {
        return;
    }

    __block NSMutableArray *moreArr = [NSMutableArray array];
    if (_contentArr.count >0) {
        [_contentArr enumerateObjectsUsingBlock:^(NSMutableArray *conArr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableDictionary *moreDic = [[NSMutableDictionary alloc] init];
            [moreDic setObjectWithNullValidate:weakSelf.categoryArr[idx] forKey:@"type"];
            [moreDic setObjectWithNullValidate:conArr forKey:@"content"];
            NSData *weChatdatamsg = [self toJSONData:moreDic];
            NSString *weChatPayMsg =[[NSString alloc] initWithData:weChatdatamsg
                                                          encoding:NSUTF8StringEncoding];
            
            [moreArr addObject:weChatPayMsg];
        }];
    }
    
    [msgDic setObjectWithNullValidate:moreArr forKey:@"more"];
    
    
    if (_litEditType == LitiDetails) {
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{
            
            weakSelf.editSuccess(msgDic[@"name"]);
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
        [self commitEvent:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
