//
//  SocialResultViewController.m
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialResultViewController.h"
#import "SocialHeadView.h"
#import "SocialResultCell.h"
#import "ParallaxHeaderView.h"
#import "PlistFileModel.h"
#import "GcNoticeUtil.h"
#import "CaseTextField.h"
#import "TaskModel.h"
#import "ReadViewController.h"

#define MORETANTWO(shuzi)  [NSString stringWithFormat:@"%.2f",shuzi]

static NSString *const RESULTCELLIDENTIFER = @"SocialCellIdentifer";

@interface SocialResultViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CalculateShareDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) NSMutableDictionary *showDictionary;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation SocialResultViewController
- (void)dealloc {
    
    [GcNoticeUtil removeAllNotification:self];
}
- (instancetype)initWithDetailDictionary:(NSMutableDictionary *)showDictionary {
    self = [super init];
    if (self) {
        
        _showDictionary = showDictionary;
    }
    return self;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

#pragma mark - methods
- (void)initUI { WEAKSELF;
    
    [self setupNaviBarWithTitle:@"社保计算器结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    
    NSDictionary *fileDictionary = _showDictionary[@"fileDictionary"];
    NSArray *keyArrays = @[@"yanglaoxian",@"yiliaoxian",@"shiyexian",@"gongshangxian",@"shengyuxian",@"gongjijin"];
    
    [keyArrays enumerateObjectsUsingBlock:^(NSString *objString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *objDictionary = fileDictionary[objString];
        PlistFileModel *model = [[PlistFileModel alloc] initWithDictionary:objDictionary];
        [weakSelf.dataSourceArrays addObject:model];
    }];
    [self.view addSubview:self.tableView];
}
#pragma mark - event response
- (void)rightBtnAction {
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index { WEAKSELF;
    
    if (index == 0) { //分享计算器
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,SOCIALCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"社保计算",@"社保计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
    } else {
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-gongzi",@"type", nil];
        
        __block NSMutableArray *resultArr = [NSMutableArray arrayWithObjects:_showDictionary[@"cityName"],_showDictionary[@"wage"],_showDictionary[@"grjn"],_showDictionary[@"gsjn"], nil];
        [_dataSourceArrays enumerateObjectsUsingBlock:^(PlistFileModel *objModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [resultArr addObject:objModel.gr_ratio];
            [resultArr addObject:objModel.gs_ratio];
        }];
        [resultArr addObject:_showDictionary[@"geshui"]];
        [shareDict setObject:resultArr forKey:@"results"];
        [shareDict setObject:[NSArray arrayWithObjects:@"", nil] forKey:@"conditions"];
        
        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            if (index == 1) {
                
                NSArray *arrays = [NSArray arrayWithObjects:@"社保计算器",@"社保计算结果",urlString,@"", nil];
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];
                
            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"社保计算结果Word%@.docx",idString];
                model.url= wordString;
                model.content = @"社保计算结果Word";
                model.destinationPath=[kCachePath stringByAppendingPathComponent:model.name];
                
                ReadViewController *readVC = [ReadViewController new];
                readVC.model = model;
                readVC.navTitle = @"计算结果";
                readVC.rType = FileNOExist;
                [weakSelf.navigationController pushViewController:readVC animated:YES];
            }
            
        } fail:^{
            
        }];
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [(ParallaxHeaderView*)_tableView.tableHeaderView  layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SocialResultCell *cell = (SocialResultCell *)[tableView dequeueReusableCellWithIdentifier:RESULTCELLIDENTIFER   ];
    NSInteger row = indexPath.row;
    if (_dataSourceArrays.count >0) {
        PlistFileModel *fileModel = _dataSourceArrays[row];
        [cell setShowUIWithDictionary:fileModel withIndexRow:row];
    }
    cell.textField1.delegate = self;
    cell.textField2.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField1];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField2];

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return (section == 0)?[SocialHeadView instanceSocialHeadViewWithDictionary:_showDictionary]:nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField { WEAKSELF;
    
    [_dataSourceArrays enumerateObjectsUsingBlock:^(PlistFileModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (model.gr_ratio.length == 0) {
            model.gr_ratio = @"0";
        }
        if (model.gs_ratio.length == 0) {
            model.gs_ratio = @"0";
        }
    }];
    
    NSString *wageString = _showDictionary[@"wage"];
    CGFloat wage = [wageString floatValue];
    [CalculateManager socialSecurityCalculationResultsPageWithDataSource:_dataSourceArrays withWage:wage Success:^(CGFloat grmoney, CGFloat gsmoney, CGFloat grGJJmoney, CGFloat gsGJJmoney, CGFloat taxMoney) {
        
        CGFloat shgz = wage - grmoney - grGJJmoney - taxMoney;
        CGFloat gr = grmoney + grGJJmoney;
        CGFloat gs = gsmoney + gsGJJmoney;
        [weakSelf.showDictionary setObjectWithNullValidate:MORETANTWO(shgz) forKey:@"shuihou"];
        [weakSelf.showDictionary setObjectWithNullValidate:MORETANTWO(gs) forKey:@"gsjn"];
        [weakSelf.showDictionary setObjectWithNullValidate:MORETANTWO(gr) forKey:@"grjn"];
        [weakSelf.showDictionary setObjectWithNullValidate:MORETANTWO(taxMoney) forKey:@"geshui"];
        weakSelf.bottomLabel.text = [NSString stringWithFormat:@"个人所得税:%@, 国内个税起征点3500元",_showDictionary[@"geshui"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
    }];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self dismissKeyBoard];
    return YES;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    CaseTextField *textField = (CaseTextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger indexRow = textField.row;
    NSInteger section = textField.section - (indexRow + 1) *2000;
    
    PlistFileModel *model = _dataSourceArrays[indexRow];
    
    if (section == 1) {
        //个人
        model.gr_ratio = textField.text;
    } else {
        //公司
        model.gs_ratio = textField.text;
    }
}

#pragma mark - setter and getter
#pragma mark -手势
- (void)dismissKeyBoard {
    
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissKeyBoard];
}
#pragma mark - setter and getter
-(UITableView *)tableView{ WEAKSELF;
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[SocialResultCell class] forCellReuseIdentifier:RESULTCELLIDENTIFER];
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 145)] forSize:CGSizeMake(kMainScreenWidth, 1)];
        _tableView.tableHeaderView = _headerView;
        _tableView.tableFooterView = self.bottomLabel;
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];

    }
    return _tableView;
}
- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {
        
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(999999);
        _bottomLabel.font = Font_12;
        _bottomLabel.text = [NSString stringWithFormat:@"个人所得税:%@, 国内个税起征点3500元",_showDictionary[@"geshui"]];
    }
    return _bottomLabel;
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
