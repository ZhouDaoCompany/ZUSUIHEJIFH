//
//  AddFinanceVC.m
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddFinanceVC.h"
#import "FinanceTabCell.h"
#import "RemarkTabCell.h"
#import "ZHPickView.h"
#import "ZD_DeleteWindow.h"

static NSString *const FINANCEIDENTIFER = @"financeIdentifer";
static NSString *const FNOTEIDENTIFER = @"fnoteidentifer";

@interface AddFinanceVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    
    UITapGestureRecognizer * _tapGesture;

}

@property (nonatomic, strong) UIView *botomView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *bigtitArr;//标题数组
@property (nonatomic, strong) NSMutableArray *titBasiArr;//标题数组
@property (nonatomic, strong) NSMutableArray *textBasiArr;//存放选取内容数组
@property (nonatomic, strong) NSMutableArray *commitArr;//提交内容数组
@end

@implementation AddFinanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)initUI
{
    [self setupNaviBarWithTitle:@"添加财务信息"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    [self creatDataSource];

    if (_financeType == AddFinance) {
        
        _currentBtnTag = 0;
        
        NSArray *titArr = _titBasiArr[_currentBtnTag];
        [self creatCommitArrWithTitleArr:titArr];

        [self creatAllClassBtn];

        CGRect frame = CGRectMake(0,Orgin_y(_botomView), kMainScreenWidth, kMainScreenHeight - Orgin_y(_botomView));
        [self creatTabViewWithRect:frame];
    }else {
        [self setupNaviBarWithBtn:NaviRightBtn
                            title:nil img:@"case_delete"];
        [_commitArr addObjectsFromArray:_oriArr];
        CGRect frame = CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight - 64);
        [self creatTabViewWithRect:frame];
    }

}
#pragma mark -构建数据
- (void)creatDataSource
{
    _bigtitArr = [NSMutableArray arrayWithObjects:@"律师费(与客户)",@"提成(与律所)",@"差旅费",@"第三方费用",@"自定义", nil];
    _textBasiArr = [NSMutableArray array];
    _titBasiArr  = [NSMutableArray array];
    _commitArr   = [NSMutableArray array];
    //数组内容填充  标题key  字典
    
    /*
     * 律师费(与客户)
     */
    NSArray *arr1 = @[@"收费模式",@"风险代理",@"是否已开发票"];
    NSArray *arr11 = @[@"全部收取",@"一次性收",@"分期收",@"先收固定金额,按结果比例提成"];
    NSArray *arr12 = @[@"全风险",@"半风险"];
    NSArray *arr13 = @[@"是",@"否"];
    
    [_titBasiArr addObject:arr1];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:arr11,@"收费模式",arr12,@"风险代理",arr13,@"是否已开发票", nil];
    [_textBasiArr addObject:dic1];
    
    
    /*
     * 提成(与律所)
     */
    NSArray *arr2 = @[@"总金额",@"提成比例(%)",@"提成金额"];
    [_titBasiArr addObject:arr2];
    [_textBasiArr addObject:[NSDictionary dictionary]];
    
    
    /*
     * 差旅费
     */
    NSArray *arr3 = @[@"模式"];
    [_titBasiArr addObject:arr3];
    NSArray *arr31 = @[@"包干",@"预支后结算"];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:arr31,@"模式", nil];
    [_textBasiArr addObject:dic3];
    
    /*
     * 第三方费用
     */
    NSArray *arr4 = @[@"费用选项",@"状态",@"截止时间"];
    [_titBasiArr addObject:arr4];
    NSArray *arr41 = @[@"拍卖费",@"公告费",@"鉴定费",@"执行费",@"保全费",@"仲裁费",@"诉讼费"];
    NSArray *arr42 = @[@"未交",@"已交"];
    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:arr41,@"费用选项",arr42,@"状态",nil];
    [_textBasiArr addObject:dic4];
    
    /*
     * 自定义
     */
    NSArray *arr5 = @[@"费用项",@"费用"];
    [_titBasiArr addObject:arr5];
    [_textBasiArr addObject:[NSDictionary dictionary]];
    
}
#pragma mark -创建按钮选项
- (void)creatAllClassBtn
{
    UIView *botomView = [[UIView alloc] init];
    botomView.backgroundColor = [UIColor clearColor];
    _botomView = botomView;
    [self.view addSubview:_botomView];
    float hotWidth = (kMainScreenWidth -60.f)/3.f;
    float hotHeight = 0.f;
    //擅长  40
    for (NSUInteger i = 0 ; i < _bigtitArr.count;  i ++)
    {
        NSString *titString = _bigtitArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 4000+i;
        [btn setTitle:titString forState:0];
        btn.frame = CGRectMake( 15 +15.f*(i%3) + hotWidth * (i%3), 15*(i/3 + 1) + 30 *(i/3) , hotWidth, 30);
        btn.titleLabel.font = Font_12;
        [btn setTitleColor:thirdColor forState:0];
        [btn addTarget:self action:@selector(moneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_botomView addSubview:btn];
        if (i == 0) {
            btn.backgroundColor = KNavigationBarColor;
            [btn setTitleColor:[UIColor whiteColor] forState:0];
        }
        if (i == _bigtitArr.count -1) {
            hotHeight = Orgin_y(btn) + 15;
        }
    }
    _botomView.frame = CGRectMake(0, 64, kMainScreenWidth, hotHeight);
}
- (void)creatTabViewWithRect:(CGRect)frame
{
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    _tableView.tableFooterView = [self creatTabFootView];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];

}
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

#pragma mark -创建空的内容数组 用于填充
- (void)creatCommitArrWithTitleArr:(NSArray *)arr
{WEAKSELF;
    [_commitArr removeAllObjects];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf.commitArr addObject:@""];
    }];
    [_commitArr addObject:@""];
}
- (UIView *)creatTabFootView{
    
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
    return footView;
}

#pragma mark - event response
- (void)rightBtnAction
{WEAKSELF;
   // arrangeFinanceDelWithUrl
    
    ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"确定删除吗?" withType:DelType];
    delWindow.DelBlock = ^(){
        
        NSString *url = [NSString  stringWithFormat:@"%@%@%@&id=%@",kProjectBaseUrl,arrangeFinanceDel,UID,_cwid];
        [NetWorkMangerTools arrangeFinanceDelWithUrl:url RequestSuccess:^{
            
            weakSelf.successBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    };
    
    [self.view addSubview:delWindow];
}
-(void)moneyBtnClick:(UIButton *)btn
{
    DLog(@"更改费用信息");
    
    [_botomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btnObj = (UIButton *)obj;
            btnObj.backgroundColor = [UIColor whiteColor];
            [btnObj setTitleColor:thirdColor forState:0];
        }
        
    }];
    
    btn.backgroundColor = KNavigationBarColor;
    [btn setTitleColor:[UIColor whiteColor] forState:0];

    _currentBtnTag = btn.tag - 4000;
    
    NSArray *titArr = _titBasiArr[_currentBtnTag];
    [self creatCommitArrWithTitleArr:titArr];
    [_tableView reloadData];
}
-(void)commitEvent:(UIButton *)btn
{WEAKSELF;
    
    __block BOOL isCommit = NO;
    [_commitArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.length >0) {
            *stop =  YES;
            isCommit = YES;
        }
    }];
    
    if (isCommit == NO) {
        
        [JKPromptView showWithImageName:nil message:@"请您填写内容"];
        return;
    }
    
    __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(_caseId) forKey:@"aid"];
    
    NSArray *titArr = _titBasiArr[_currentBtnTag];
    NSMutableArray *titMutabArr = [NSMutableArray array];
    [titMutabArr addObjectsFromArray:titArr];
    [titMutabArr addObject:@"备注"];
    NSData *titdatamsg = [self toJSONData:titMutabArr];
    NSString *titMsg =[[NSString alloc] initWithData:titdatamsg
                                            encoding:NSUTF8StringEncoding];

    NSData *weChatdatamsg = [self toJSONData:_commitArr];
    NSString *weChatPayMsg =[[NSString alloc] initWithData:weChatdatamsg
                                                  encoding:NSUTF8StringEncoding];
    [msgDic setObjectWithNullValidate:weChatPayMsg forKey:@"content"];

    if (_currentBtnTag == 4) {
        _currentBtnTag = 8;
    }
    NSString *typestr = [NSString stringWithFormat:@"%ld",_currentBtnTag +1];
    [msgDic setObjectWithNullValidate:GET(typestr) forKey:@"type"];

    [msgDic setObjectWithNullValidate:titMsg forKey:@"title"];
    
    if (_financeType == AddFinance) {
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeFinanceAdd];
        
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:url RequestSuccess:^{
            
            weakSelf.successBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }else{
        
        [msgDic setObjectWithNullValidate:GET(_cwid) forKey:@"id"];

        NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeFinanceEdit];

        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:url RequestSuccess:^{
            
            weakSelf.successBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }

}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titArr = _titBasiArr[_currentBtnTag];
    return [titArr count] +1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray *titArr = _titBasiArr[_currentBtnTag];
    
    if (indexPath.row == titArr.count) {
        [_tableView registerClass:[RemarkTabCell class] forCellReuseIdentifier:FNOTEIDENTIFER];
        RemarkTabCell *cell = (RemarkTabCell *)[tableView dequeueReusableCellWithIdentifier:FNOTEIDENTIFER forIndexPath:indexPath];
        return cell;
    }

    [_tableView registerClass:[FinanceTabCell class] forCellReuseIdentifier:FINANCEIDENTIFER];
    FinanceTabCell *cell = (FinanceTabCell *)[tableView dequeueReusableCellWithIdentifier:FINANCEIDENTIFER];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if ([cell isKindOfClass:[FinanceTabCell class]])
    {
        FinanceTabCell *fCell = (FinanceTabCell *)cell;
        fCell.currentBtnTag = _currentBtnTag;
        fCell.rowIndex = row;
        NSArray *titArr = _titBasiArr[_currentBtnTag];
        fCell.titleLab.text = titArr[row];
        
        if (_currentBtnTag == 1 || _currentBtnTag == 4) {
            fCell.textField.text = _commitArr[row];
            fCell.textField.tag = 5000 + row;
            fCell.textField.delegate = self;
            fCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",titArr[row]];
            fCell.deviceLabel.text = _commitArr[row];
            [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:fCell.textField];
        }else {
            fCell.deviceLabel.text = _commitArr[row];
        }

    }else if ([cell isKindOfClass:[RemarkTabCell class]]){
        RemarkTabCell *rCell = (RemarkTabCell *)cell;
        rCell.textView.delegate = self;
        rCell.textView.text = _commitArr[row];
        rCell.textView.tag = row +6000;
        if (rCell.textView.text.length >0) {
            rCell.placeHoldlab.text = @"";
        }else {
            rCell.placeHoldlab.text = @" 写备注...";
        }
        rCell.placeHoldlab.tag = 8884;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    
    if (_currentBtnTag != 1 && _currentBtnTag != 4) {

        if (_currentBtnTag == 3 && row == 2) {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            UIWindow *windows = [QZManager getWindow];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
//                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.commitArr replaceObjectAtIndex:row withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            
            };
        }else {
            
            NSArray *titArr = _titBasiArr[_currentBtnTag];
            NSDictionary *dict = _textBasiArr[_currentBtnTag];
            NSString *keyStr = titArr[row];
            NSArray *arr = dict[keyStr];
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:arr title:keyStr];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [weakSelf.commitArr replaceObjectAtIndex:row withObject:selectedStr];
                [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titArr = _titBasiArr[_currentBtnTag];
    
    if (indexPath.row == titArr.count) {
        
        return 115.f;
    }
    return 45.f;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (_currentBtnTag == 1) {
        
        NSString *zje = _commitArr[0];
        NSString *bl  = _commitArr[1];
        
        if (zje.length >0 && bl.length >0) {
            
            float tc = [zje floatValue]*[bl floatValue]/100.f;
            
            [_commitArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%.2f",tc]];
            
            [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger index = textField.tag - 5000;
    
    [_commitArr replaceObjectAtIndex:index withObject:textField.text];
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeHoldlab = (UILabel *)[self.view viewWithTag:8884];
    if (textView.text.length >0) {
        placeHoldlab.text = @"";
    }else {
        placeHoldlab.text = @" 写备注...";
    }
    
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
    if (flag){
        textView.text = [NSString disable_emoji:textView.text];
    }
    
    NSInteger row = textView.tag - 6000;
    [_commitArr replaceObjectAtIndex:row withObject:textView.text];
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
