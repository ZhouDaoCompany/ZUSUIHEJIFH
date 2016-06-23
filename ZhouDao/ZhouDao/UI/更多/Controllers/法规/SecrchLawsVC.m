//
//  SecrchLawsVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SecrchLawsVC.h"
#import "VoiceManager.h"
#import "SearchResultsVC.h"

#define xSpace 15
static NSString *const CellIdentifier = @"CellIdentifier";

@interface SecrchLawsVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,VoiceDelegate>
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, strong) NSMutableArray *hotArrays;//热词
@property (nonatomic, strong) NSMutableArray *historyArrays;//历史
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation SecrchLawsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //创建语音听写的对象
    [[VoiceManager shareInstance]setPropertysWithView:self.view];
    [VoiceManager shareInstance].delegate =self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [USER_D setObject:_historyArrays forKey:SearchIdentifer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavBarView];

    [NetWorkMangerTools lawsHotsSearchRequestSuccess:^(NSArray *arr) {
        [_hotArrays addObjectsFromArray:arr];
        [self initUI];
    } fail:^{
        [self initUI];

    }];
}
- (void)initNavBarView
{
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:@"取消"
                          img:nil];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(xSpace, 30, kMainScreenWidth-xSpace-50, 30)];
    searchView.layer.cornerRadius = 2.5f;
    searchView.layer.masksToBounds = YES;
    [self.view addSubview:searchView];
    searchView.backgroundColor=[UIColor whiteColor];
    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    [searchView addSubview:search];
    search.image = [UIImage imageNamed:@"law_sousuo"];
    
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(searchView.frame.size.width-32, 5, .5f, 20)];
    lineview.backgroundColor = lineColor;
    [searchView addSubview:lineview];
    
    UIImageView *soundimg =[[UIImageView alloc] initWithFrame:CGRectMake(searchView.frame.size.width-25, 5, 13, 19)];
    soundimg.image = [UIImage imageNamed:@"law_yuyin"];
    soundimg.userInteractionEnabled = YES;
    [searchView addSubview:soundimg];
    
    UIView *soundView = [[UIView alloc] initWithFrame:CGRectMake(searchView.frame.size.width-30, 0, 30, searchView.frame.size.height)];
    [searchView addSubview:soundView];
    
    WEAKSELF;
    [soundView whenTapped:^{
        [weakSelf OpenTheDictation];
    }];
    
    _searchField =[[UITextField alloc] initWithFrame:CGRectMake(42.5f, 0, searchView.frame.size.width-74.5f, 30)];
    [self.view addSubview:_searchField];
    _searchField.placeholder = @"搜索相关法律法规";
    _searchField.delegate = self;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.returnKeyType = UIReturnKeySearch; //设置按键类型
    [searchView addSubview:_searchField];
    [_searchField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_searchField];
    
    _historyArrays = [NSMutableArray array];
    [_historyArrays addObjectsFromArray:(NSArray *)[USER_D objectForKey:SearchIdentifer]];
    _hotArrays = [NSMutableArray array];
}
- (void)initUI
{
    //热词搜索
    UIView *hotView = [[UIView alloc] init];
    hotView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hotView];
    UILabel *hotSearchLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    hotSearchLab.font = Font_15;
    hotSearchLab.text = @"热词搜索";
    hotSearchLab.textColor = thirdColor;
    [hotView addSubview:hotSearchLab];
    
    float hotWidth = (kMainScreenWidth -72.f)/3.f;
    float hotHeight = 0.f;
    //擅长  40
    for (NSUInteger i = 0 ; i < _hotArrays.count;  i ++)
    {
        NSString *titString = _hotArrays[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 3000+i;
        [btn setTitle:titString forState:0];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        btn.layer.borderWidth = .5f;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.f;
        btn.frame = CGRectMake( 15 +21.5f*(i%3) + hotWidth * (i%3), 40 +14*(i/3 + 1) + 30 *(i/3) , hotWidth, 30);
        btn.titleLabel.font = Font_14;
        [btn setTitleColor:sixColor forState:0];
        [btn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotView addSubview:btn];
        if (i == _hotArrays.count -1) {
            hotHeight = Orgin_y(btn) + 15;
        }
    }
    hotView.frame = CGRectMake(0, 64, kMainScreenWidth, hotHeight);
    
    
    UILabel *historyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 74 + hotHeight, kMainScreenWidth, 45)];
    historyLab.textColor = thirdColor;
    historyLab.text =@"历史搜索";
    [self.view addSubview:historyLab];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5f)];
    lineView.backgroundColor = lineColor;
    [historyLab addSubview:lineView];

    
    //表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,74 +45 + hotHeight, kMainScreenWidth, kMainScreenHeight-74- hotHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    //表脚
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.backgroundColor = [UIColor clearColor];
    [clearBtn setTitle:@"清除历史搜索" forState:0];
    clearBtn.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
    clearBtn.layer.borderWidth = .5f;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.cornerRadius = 5.f;
    clearBtn.center = footView.center;
    clearBtn.bounds = CGRectMake(0, 0, 125, 40);
    clearBtn.titleLabel.font = Font_15;
    [clearBtn setTitleColor:KNavigationBarColor forState:0];
    [clearBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:clearBtn];
    _tableView.tableFooterView = footView;
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSUInteger row = indexPath.row;
    cell.textLabel.textColor = sixColor;
    cell.textLabel.font = Font_15;
    if (_historyArrays.count >0) {
        cell.textLabel.text = _historyArrays[row];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, 0.5f)];
    lineView.backgroundColor = lineColor;
    [cell.contentView addSubview:lineView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = _historyArrays[indexPath.row];
    [self searchKeyText:str];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPat{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_historyArrays removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark -UIButtonEvent
- (void)hotBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
//    NSUInteger index = button.tag;
    [self searchKeyText:button.titleLabel.text];
    DLog(@"标题－－－%@  tag:%ld",button.titleLabel.text,(unsigned long)index);
}
- (void)rightBtnAction
{
    [AnimationTools makeAnimationFade:self.navigationController];
}
- (void)deleteBtnClick:(id)sender
{
    [_historyArrays removeAllObjects];
    [_tableView reloadData];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    DLog(@"去搜索");
    [self searchResultMethods];
    return true;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    
}
#pragma mark -合成语音
- (void)OpenTheDictation
{
    [[VoiceManager shareInstance]startListenning];
}
#pragma 语音输入回调
/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
-(void)sucessReturn:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    _searchField.text = result;
    [[VoiceManager shareInstance]cancel];
    
    DLog(@"去搜索");
    [self searchKeyText:_searchField.text];
}

/** 识别结束回调方法
 @param error 识别错误
 */
-(void)errorReturn:(IFlySpeechError *)error{
    DLog(@"errorCode:%@",[error errorDesc]);
}
-(void)popAction
{
    //    [super popAction];
    [VoiceManager shareInstance].delegate = nil;
    [[VoiceManager shareInstance]clearSelf];
}
#pragma mark -搜索方法
- (void)searchResultMethods{
    if (_searchField.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您输入要搜索的内容!"];
        return;
    }
    if (![_historyArrays containsObject:_searchField.text]) {
        [_historyArrays insertObject:_searchField.text atIndex:0];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self searchKeyText:_searchField.text];
}
- (void)searchKeyText:(NSString *)text
{
    [SVProgressHUD show];
    NSUInteger page = 0;
    [NetWorkMangerTools LawsSearchResultKeyWords:text withPage:page RequestSuccess:^(NSArray *arr) {
        [self.view endEditing:YES];
        SearchResultsVC *vc = [SearchResultsVC new];
        vc.arrays = arr;
        vc.keyStr = _searchField.text;
        vc.resultType = lawResulttype;
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^{
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
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
