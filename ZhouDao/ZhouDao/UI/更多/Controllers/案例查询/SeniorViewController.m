//
//  SeniorViewController.m
//  ZhouDao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SeniorViewController.h"
#import "SeniorTabViewCell.h"
#import "MyPickView.h"
#import "ZHPickView.h"
#import "ZD_SelectDateWindow.h"

static NSString *const CELLIDENTIFER = @"SeniorIdentifer";

@interface SeniorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITapGestureRecognizer * _tapGesture;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *titleArrays;//标题
@property (strong, nonatomic) NSMutableArray *textArr;//内容

@end

@implementation SeniorViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
- (void)initUI{
    
    self.fd_interactivePopDisabled = YES;
    [self setupNaviBarWithTitle:@"案例查询"];
//    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"Esearch_SouSuo"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"取消" img:nil];
    self.rightBtn.titleLabel.font = Font_16;
    
    _titleArrays = [NSMutableArray arrayWithObjects:@"案件类型",@"关键词",@"案号",@"案由",@"案件名称",@"法院名称",@"法院层级",@"审判程序",@"文书类型",@"裁判日期",@"审判人员",@"当事人",@"律所",@"律师",@"地区",@"年份", nil];
    _textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    //表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SeniorTabViewCell class] forCellReuseIdentifier:CELLIDENTIFER];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [_tableView addGestureRecognizer:_tapGesture];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 108)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = KNavigationBarColor;
    searchBtn.titleLabel.font = Font_15;
    searchBtn.frame = CGRectMake(15.f, 34.f, kMainScreenWidth -30.f , 40);
    [searchBtn setTitle:@"搜索" forState:0];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 3.f;
    [searchBtn addTarget:self action:@selector(seniorSearchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:searchBtn];
    
    _tableView.tableFooterView = footView;

}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeniorTabViewCell *cell = (SeniorTabViewCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFER];

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SeniorTabViewCell class]])
    {
        SeniorTabViewCell *SeniorCell = (SeniorTabViewCell *)cell;
        NSUInteger row = indexPath.row;
        SeniorCell.rowIndex = row;
        SeniorCell.titleLab.text = _titleArrays[row];
        SeniorCell.textField.tag = 3000+row;
        
        if (row ==0 || row == 6 || row == 7 || row == 8 || row == 9 || row == 14 || row == 15)
        {
            if (_textArr.count >0) {
                SeniorCell.deviceLabel.text = _textArr[row];
            }

        }else{
            SeniorCell.textField.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:SeniorCell.textField];
            if (_textArr.count >0) {
                SeniorCell.textField.text = _textArr[row];
            }
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissKeyBoard];
    
    NSUInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"全部案件",@"刑事案件",@"民事案件",@"行政案件",@"赔偿案件",@"执行案件"] title:@"案件类型"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [_textArr replaceObjectAtIndex:0 withObject:selectedStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                if ([selectedStr isEqualToString:@"刑事案件"]){
                    [_titleArrays addObject:@"涉案罪名"];
                    [_textArr addObject:@""];
                    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:16 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    if (_titleArrays.count>16) {
                        [_titleArrays removeObjectAtIndex:16];
                        [_textArr removeObjectAtIndex:16];
                        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:16 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];

                    }
                }
                
            };

        }
            break;
        case 6:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"全部",@"最高法院",@"高级法院",@"中级法院",@"基层法院"] title:@"法院"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [_textArr replaceObjectAtIndex:6 withObject:selectedStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };

        }
            break;
        case 7:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"一审",@"二审",@"再审",@"非诉执行审查",@"复核",@"刑罚变更",@"其他"] title:@"审判程序"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [_textArr replaceObjectAtIndex:7 withObject:selectedStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:7 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };

        }
            break;
        case 8:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"全部",@"判决书",@"裁定书",@"调解书",@"决定书",@"通知书",@"批复",@"答复",@"函",@"令",@"其他"] title:@"文书类型"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [_textArr replaceObjectAtIndex:8 withObject:selectedStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:8 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };

            
        }
            break;
        case 9:
        {
            ZD_SelectDateWindow * window = [[ZD_SelectDateWindow alloc] initWithFrame:kMainScreenFrameRect];
            window.selectBlock = ^(NSString *starDate,NSString *endDate){
                
                NSString *tempstr = [NSString stringWithFormat:@"%@,%@",starDate,endDate];
                [_textArr replaceObjectAtIndex:9 withObject:tempstr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:9 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.view addSubview:window];
        }
            break;
        case 14:
        {
            UIWindow *windows = [UIApplication sharedApplication].windows[0];
            MyPickView *pickView = [[MyPickView  alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            pickView.pickBlock = ^(NSString *provice,NSString *city,NSString *area){
                DLog(@"地区是－－－%@:%@,%@",provice,city,area);
                NSString *tempStr = [NSString stringWithFormat:@"%@-%@-%@",provice,city,area];
                [_textArr replaceObjectAtIndex:row withObject:tempStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            pickView.blurBlock = ^{
                // [weakSelf configureViewBlurWith:0 scale:1];
            };
            [windows addSubview:pickView];

        }
            break;
        case 15:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008"] title:@"年份"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                [_textArr replaceObjectAtIndex:15 withObject:selectedStr];
                [_tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:15 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };

        }
            break;
            
        default:
            break;
    }
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
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
    
    [_textArr replaceObjectAtIndex:tag-3000 withObject:textField.text];

}

#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    DLog(@"取消");
    [AnimationTools makeAnimationFade:self.navigationController];
}
- (void)seniorSearchEvent:(id)sender
{
    DLog(@"搜索");
    
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
