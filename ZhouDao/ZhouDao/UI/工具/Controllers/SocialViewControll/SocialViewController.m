//
//  SocialViewController.m
//  ZhouDao
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialViewController.h"
#import "SelectCityViewController.h"
#import "SocialTableViewCell.h"
#import "PlistFileModel.h"
#import "SocialResultViewController.h"

static NSString *const SOCIALCELLIDENTIFER = @"SocialCellIdentifer";
#define MORETANTWO(shuzi)  [NSString stringWithFormat:@"%.2f",shuzi]

@interface SocialViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) NSArray *titleArrays;//标题
@property (nonatomic, strong) UIButton *calculateButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) NSDictionary *fileDictionary;
@end

@implementation SocialViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}

#pragma mark - methods

- (void)initUI {
    
    if ([PublicFunction ShareInstance].locCity.length > 0) {
        NSString *city = [PublicFunction ShareInstance].locCity;
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"SocialSecurity.plist"];
        NSDictionary *tempDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSArray *keysArrays = [tempDictionary allKeys];
        
        for (NSString *keyName in keysArrays) {
            
            if ([QZManager isString:city withContainsStr:keyName]) {
                
                _fileDictionary = tempDictionary[keyName];
                [self.dataSourceArrays replaceObjectAtIndex:0 withObject:keyName];
                break;
            }
        }
    }
    [self setupNaviBarWithTitle:@"社保计算器"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Button Event
- (void)socialSecurityBtnEvent:(UIButton *)btn {
    
    NSInteger index = btn.tag;
    if (index == 3134) {
        //重置
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:@""];
        [_dataSourceArrays replaceObjectAtIndex:1 withObject:@""];
        [_tableView reloadData];
    } else {
        
        NSArray *showArrays = @[@"请您选择地区",@"请您填写工资"];
        for (NSUInteger i = 0; i < [_dataSourceArrays count]; i++) {
            NSString *str = _dataSourceArrays[i];
            if (str.length == 0) {
                [JKPromptView showWithImageName:nil message:showArrays[i]];
                return;
            }
        }
        
        //计算
        [self calculateShow];
    }
}
- (void)calculateShow {
    
    NSString *wageString = _dataSourceArrays[1];
    NSString *cityName = _dataSourceArrays[0];
    CGFloat wage = [wageString floatValue];
    __block NSMutableDictionary *detailDictionary = [NSMutableDictionary dictionary];
    [detailDictionary setObjectWithNullValidate:_fileDictionary forKey:@"fileDictionary"];
    [detailDictionary setObjectWithNullValidate:cityName forKey:@"cityName"];
    [detailDictionary setObjectWithNullValidate:cityName forKey:@"cityName"];
    [detailDictionary setObjectWithNullValidate:wageString forKey:@"wage"];

    [CalculateManager getPersonalSocialSecurity:_fileDictionary withWage:wage Success:^(CGFloat grmoney, CGFloat gsmoney, CGFloat grGJJmoney, CGFloat gsGJJmoney, CGFloat taxMoney) {
        
        CGFloat shgz = wage - grmoney - grGJJmoney - taxMoney;
        CGFloat gr = grmoney + grGJJmoney;
        CGFloat gs = gsmoney + gsGJJmoney;
        [detailDictionary setObjectWithNullValidate:MORETANTWO(shgz) forKey:@"shuihou"];
        [detailDictionary setObjectWithNullValidate:MORETANTWO(gs) forKey:@"gsjn"];
        [detailDictionary setObjectWithNullValidate:MORETANTWO(gr) forKey:@"grjn"];
        [detailDictionary setObjectWithNullValidate:MORETANTWO(taxMoney) forKey:@"geshui"];

    }];

    SocialResultViewController *vc = [[SocialResultViewController alloc] initWithDetailDictionary:detailDictionary];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.titleArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSInteger row = indexPath.row;
    SocialTableViewCell *cell = (SocialTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SOCIALCELLIDENTIFER];
    [cell setUIWithTitle:self.titleArrays[row]
            withShowText:self.dataSourceArrays[row] withIndex:row];
    cell.textField.delegate = self;
    cell.textField.tag = 3000 + indexPath.row;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF;
    NSInteger row = indexPath.row;
    if (row == 0) {
        
        SelectCityViewController *cityVC = [SelectCityViewController new];
        cityVC.type = SocialType;
        cityVC.socialBlock = ^(NSString *name, NSDictionary *fileDictionary) {
            
            [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:name];
            weakSelf.fileDictionary = fileDictionary;
            [weakSelf.tableView reloadData];
        };
        [self presentViewController:cityVC animated:YES completion:^{
            
        }];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *secitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    secitionView.backgroundColor = hexColor(F2F2F2);
    [secitionView addSubview:self.calculateButton];
    [secitionView addSubview:self.resetButton];
    return secitionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 80.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self dismissKeyBoard];
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger row = textField.tag - 3000;
    [self.dataSourceArrays replaceObjectAtIndex:row withObject:textField.text];
}

#pragma mark -手势
- (void)dismissKeyBoard {
    
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    [self dismissKeyBoard];
}
#pragma mark - setter and getter
- (UITableView *)tableView { WEAKSELF;
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[SocialTableViewCell class] forCellReuseIdentifier:SOCIALCELLIDENTIFER];
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];
    }
    return _tableView;
}
- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {
        
        _dataSourceArrays = [NSMutableArray arrayWithObjects:@"",@"", nil];
    }
    return _dataSourceArrays;
}
- (NSArray *)titleArrays {
    
    if (!_titleArrays) {
        
        _titleArrays = [NSArray arrayWithObjects:@"城市",@"税前工资", nil];
    }
    return _titleArrays;
}
- (UIButton *)calculateButton {
    if (!_calculateButton) {
        _calculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _calculateButton.frame = CGRectMake(15 , 20, (kMainScreenWidth - 45)/2.f, 40);
        _calculateButton.layer.masksToBounds = YES;
        _calculateButton.layer.cornerRadius = 3.f;
        _calculateButton.backgroundColor  = hexColor(00c8aa);
        [_calculateButton setTitleColor:[UIColor whiteColor] forState:0];
        [_calculateButton setTitle:@"计算" forState:0];
        _calculateButton.titleLabel.font = Font_15;
        _calculateButton.tag = 3133;
        [_calculateButton addTarget:self action:@selector(socialSecurityBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calculateButton;
}
- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _resetButton.frame = CGRectMake(30 + (kMainScreenWidth - 45)/2.f , 20, (kMainScreenWidth - 45)/2.f, 40);
        _resetButton.layer.masksToBounds = YES;
        _resetButton.layer.cornerRadius = 3.f;
        _resetButton.backgroundColor  = hexColor(C2C2C2);
        [_resetButton setTitleColor:[UIColor whiteColor] forState:0];
        [_resetButton setTitle:@"重置" forState:0];
        _resetButton.titleLabel.font = Font_15;
        _resetButton.tag = 3134;
        [_resetButton addTarget:self action:@selector(socialSecurityBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
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
