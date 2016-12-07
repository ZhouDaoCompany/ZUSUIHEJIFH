//
//  SelectCityViewController.m
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectCityViewController.h"
#import "NSString+SPStr.h"
#import "ConsultantHeadView.h"
#import "SelectProvinceCell.h"

static NSString *const SELECTCELLIDENTIFER = @"SelectCityCellIdentifier";

@interface SelectCityViewController ()<UITableViewDelegate, UITableViewDataSource,SelectProvinceCellPro>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadTitleArrays;//存放获取人名的首字母
@property (nonatomic, strong) NSMutableDictionary *cityDictionary;
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation SelectCityViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI {
    
    if (_type == EconomicType) {
        
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"theaveragesalary.plist"];
        _dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSArray *keysArrays = [_dict allKeys];
        [self.dataSourceArrays addObjectsFromArray:keysArrays];
    }else if (_type == InjuryType){
        
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"gongshang.plist"];
        NSDictionary *tempDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        _dict = tempDictionary[@"name"];
        NSArray *keysArrays = [_dict allKeys];
        for (NSString *province in keysArrays) {
            
            NSDictionary *provinceDictionary = _dict[province];
            NSArray *cityKeyArrays = [provinceDictionary allKeys];
            [self.dataSourceArrays addObjectsFromArray:cityKeyArrays];
        }
    }else if (_type == SocialType) {
        
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"SocialSecurity.plist"];
        _dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSArray *keysArrays = [_dict allKeys];
        [self.dataSourceArrays addObjectsFromArray:keysArrays];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];
    self.statusBarView.backgroundColor = [UIColor whiteColor];
    self.naviBarView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"D7D7D7"];
    [self.view addSubview:lineView];
    
    [self.view addSubview:self.tableView];
    
    [self hanZiToPinYin];
}
- (void)hanZiToPinYin {
    //处理汉字转拼音
    NSRange range;
    range.length = 1;
    range.location =0;
    
    WEAKSELF;
    [self.dataSourceArrays enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *pinyinStr = [NSString HanZiZhuanPinYin:cityName];
        //获取首字母并转化为大写
        NSString *fristChar = [[pinyinStr substringWithRange:range] uppercaseString];
        
        //如果字典里面还没有插入 这个字符开头的 数据
        if (![weakSelf.cityDictionary objectForKey:fristChar]) {
            NSMutableArray *arr = [NSMutableArray arrayWithObject:cityName];
            [weakSelf.cityDictionary setObject:arr forKey:fristChar];
        } else {
            [[weakSelf.cityDictionary objectForKey:fristChar] addObject:cityName];
        }
    }];
    NSArray *titleArrays = [[self.cityDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.cityDictionary setObject:[NSArray array] forKey:@""];
    [self.sectionHeadTitleArrays addObject:@"热门"];
    [self.sectionHeadTitleArrays addObjectsFromArray:titleArrays];
    [self.tableView reloadData];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionHeadTitleArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSString *key = [self.sectionHeadTitleArrays objectAtIndex:section];
    NSArray *arr = [self.cityDictionary objectForKey:key];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SelectProvinceCell *cell = (SelectProvinceCell *)[tableView dequeueReusableCellWithIdentifier:SELECTCELLIDENTIFER];
    cell.delegate = self;
    if (_type == SocialType) {
        
        cell.isCity = NO;
    } else {
        cell.isCity = YES;
    }
    if (indexPath.section == 0) {
        cell.lineView.hidden = YES;
        [cell setOtherCitySelect:@"" wihSection:indexPath.section];
    }else {
        NSString *key = [self.sectionHeadTitleArrays objectAtIndex:indexPath.section];
        NSArray *arr = [self.cityDictionary objectForKey:key];
        NSString *cityName = arr[indexPath.row];
        [cell setOtherCitySelect:cityName wihSection:indexPath.section];
        if (indexPath.row == arr.count -1) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
    }
    return cell;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionHeadTitleArrays;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f) withSection:section];
    headView.label.textColor = hexColor(949494);
    headView.backgroundColor = hexColor(F0F0F0);
    if (section ==0) {
        headView.delBtn.hidden = YES;
        [headView setLabelText:@"热门城市"];
    }else{
        headView.delBtn.hidden = YES;
        [headView setLabelText:[self.sectionHeadTitleArrays objectAtIndex:section]];
    }
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, .1f)];
    views.backgroundColor = [UIColor clearColor];
    return views;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.section == 0)?48.f:44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    DLog(@"indexRow----%ld",indexPath.row);
    if (indexPath.section >0) {
        
        NSString *key = [self.sectionHeadTitleArrays objectAtIndex:indexPath.section];
        NSArray *arr = [self.cityDictionary objectForKey:key];
        NSString *cityName = arr[indexPath.row];

        if (_type == EconomicType) {
            
            NSString *idString = _dict[cityName];
            if (_citySelectBlock) {
                
                _citySelectBlock(cityName,idString);
            }
        }else if (_type == InjuryType){
            
            NSArray *keysArrays = [_dict allKeys];
            NSString *provinceString = @"";
            NSString *idString = @"";
            for (NSString *province in keysArrays) {
                
                NSDictionary *provinceDictionary = _dict[province];
                NSArray *cityKeyArrays = [provinceDictionary allKeys];
                if ([cityKeyArrays containsObject:cityName]) {
                    provinceString = province;
                    idString = provinceDictionary[cityName];
                }
            }
            if (self.provinceCitySelectBlock) {
                
                _provinceCitySelectBlock(provinceString, cityName, idString);
            }
        }else if (_type == SocialType) {
            
            NSDictionary *nameDictionary = _dict[cityName];
            if (self.socialBlock) {
                
                _socialBlock(cityName, nameDictionary);
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}
#pragma mark - SelectProvinceCellPro
- (void)getSeletyCityName:(NSString *)provinceName {
    
    if (_type == EconomicType) {
        
        NSString *idString = _dict[provinceName];
        if (_citySelectBlock) {
            
            _citySelectBlock(provinceName,idString);
        }

    }else if (_type == InjuryType){
        
        NSArray *keysArrays = [_dict allKeys];
        NSString *provinceString = @"";
        NSString *idString = @"";
        for (NSString *province in keysArrays) {
            
            NSDictionary *provinceDictionary = _dict[province];
            NSArray *cityKeyArrays = [provinceDictionary allKeys];
            if ([cityKeyArrays containsObject:provinceName]) {
                provinceString = province;
                idString = provinceDictionary[provinceName];
            }
        }
        if (self.provinceCitySelectBlock) {
            
            _provinceCitySelectBlock(provinceString, provinceName, idString);
        }
    } else if (_type == SocialType) {
        
        NSDictionary *nameDictionary = _dict[provinceName];
        if (self.socialBlock) {

            _socialBlock(provinceName, nameDictionary);
        }
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
}
#pragma mark - event response
- (void)rightBtnAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.6f, kMainScreenWidth, kMainScreenHeight-64.6f) style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[SelectProvinceCell class] forCellReuseIdentifier:SELECTCELLIDENTIFER];
    }
    return _tableView;
}
- (NSMutableArray *)dataSourceArrays {
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (NSMutableArray *)sectionHeadTitleArrays {
    if (!_sectionHeadTitleArrays) {
        _sectionHeadTitleArrays = [NSMutableArray array];
    }
    return _sectionHeadTitleArrays;
}
- (NSMutableDictionary *)cityDictionary {
    if (!_cityDictionary) {
        _cityDictionary = [NSMutableDictionary dictionary];
    }
    return _cityDictionary;
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
