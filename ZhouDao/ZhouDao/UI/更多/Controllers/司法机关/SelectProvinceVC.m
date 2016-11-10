//
//  SelectProvinceVC.m
//  ZhouDao
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectProvinceVC.h"
#import "NSString+SPStr.h"
#import "ConsultantHeadView.h"
#import "SelectProvinceCell.h"

static NSString *const CELLIDENTIFER = @"SelectCellIdentifier";

@interface SelectProvinceVC ()<UITableViewDelegate, UITableViewDataSource,SelectProvinceCellPro>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) NSMutableArray *sectionHeadTitleArrays;//存放获取人名的首字母
@property (nonatomic, strong) NSMutableDictionary *cityDictionary;

@property (nonatomic, assign) BOOL isHaveNoGAT; //包含港澳台
@property (nonatomic, assign) SelectType selectType;
@end

@implementation SelectProvinceVC

- (id)initWithSelectType:(SelectType)selectType withIsHaveNoGAT:(BOOL)isHaveNoGAT {
    
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        _isHaveNoGAT = isHaveNoGAT;
        _selectType  = selectType;
    }
    return self;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];
    self.statusBarView.backgroundColor = [UIColor whiteColor];
    self.naviBarView.backgroundColor = [UIColor whiteColor];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"D7D7D7"];
    
    [self.view addSubview:lineView];
    [self.view addSubview:self.tableView];
    
    
    [self hanZiToPinYin];
}
- (void)hanZiToPinYin { WEAKSELF;
    
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"provincescity.plist"];
    NSDictionary *bigDoctionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *proArrays = bigDoctionary[@"province"];
    [proArrays enumerateObjectsUsingBlock:^(NSDictionary *objDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProvinceModel *proModel = [[ProvinceModel alloc] initWithDictionary:objDictionary];
        [weakSelf.dataSourceArrays addObject:proModel];
    }];
    
    if (_isHaveNoGAT) {//YES
        
        for (NSUInteger i = 0; i < [_dataSourceArrays count]; i++) {
            
            ProvinceModel *proModel = _dataSourceArrays[i];
            if ([QZManager isString:proModel.name withContainsStr:@"香港"] || [QZManager isString:proModel.name withContainsStr:@"台湾"] || [QZManager isString:proModel.name withContainsStr:@"澳门"]) {
                
                [_dataSourceArrays removeObjectAtIndex:i];
            }
        }
    }
    
    //处理汉字转拼音
    NSRange range;
    range.length = 1;
    range.location =0;
    
    [_dataSourceArrays enumerateObjectsUsingBlock:^(ProvinceModel *proModelObj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *pinyinStr = [NSString HanZiZhuanPinYin:proModelObj.name];
        //获取首字母并转化为大写
        NSString *fristChar = [[pinyinStr substringWithRange:range] uppercaseString];
        //如果字典里面还没有插入 这个字符开头的 数据
        if (![weakSelf.cityDictionary objectForKey:fristChar]) {
            NSMutableArray *arr = [NSMutableArray arrayWithObject:proModelObj];
            [weakSelf.cityDictionary setObject:arr forKey:fristChar];
        } else {
            [[weakSelf.cityDictionary objectForKey:fristChar] addObject:proModelObj];
        }
    }];

//    [self.cityDictionary setObject:[NSArray array] forKey:@"热门"];
    NSArray *titleArrays = [[self.cityDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [self.sectionHeadTitleArrays addObject:@""];
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
    SelectProvinceCell *cell = (SelectProvinceCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFER];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.lineView.hidden = YES;
        [cell setOtherCitySelect:@"" wihSection:indexPath.section];
    }else {
        NSString *key = [self.sectionHeadTitleArrays objectAtIndex:indexPath.section];
        NSArray *arr = [self.cityDictionary objectForKey:key];
        ProvinceModel *proModel = arr[indexPath.row];
        NSString *cityName = proModel.name;
        [cell setOtherCitySelect:cityName wihSection:indexPath.section];
        
        cell.lineView.hidden = (indexPath.row == arr.count -1) ? YES : NO;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    DLog(@"indexRow----%ld",indexPath.row);
    if (indexPath.section >0) {
        NSString *key = [self.sectionHeadTitleArrays objectAtIndex:indexPath.section];
        NSArray *arr = [self.cityDictionary objectForKey:key];
        ProvinceModel *proModel = arr[indexPath.row];
        NSString *provinceName = proModel.name;

        if ([QZManager isString:provinceName withContainsStr:@"内蒙古"] || [QZManager isString:provinceName withContainsStr:@"黑龙江"]) {
            provinceName = [provinceName substringToIndex:3];
        }else {
            provinceName = [provinceName substringToIndex:2];
        }
        
        if (_isHaveNoGAT == NO){
            [PublicFunction ShareInstance].locProv = arr[indexPath.row];
        }

        if (_selectBlock) {
            
            _selectBlock(proModel.name);
        }
        if (_provinceBlock) {
            
            _provinceBlock(provinceName, proModel);
        }

        [self dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];

    }
}
#pragma mark - SelectProvinceCellPro
- (void)getSeletyCityName:(NSString *)provinceName {
    
    if (!_isHaveNoGAT){//NO
        
        [PublicFunction ShareInstance].locProv = provinceName;
    }
    if (_selectBlock) {
        
        _selectBlock(provinceName);
    }
    
    if (_provinceBlock) {
        
        __block ProvinceModel *model;
        [_dataSourceArrays enumerateObjectsUsingBlock:^(ProvinceModel *proModelObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([provinceName isEqualToString:proModelObj.name]) {
                
                model = proModelObj;
                *stop = YES;
            }
        }];
        _provinceBlock(provinceName, model);
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
        [_tableView registerClass:[SelectProvinceCell class] forCellReuseIdentifier:CELLIDENTIFER];
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
