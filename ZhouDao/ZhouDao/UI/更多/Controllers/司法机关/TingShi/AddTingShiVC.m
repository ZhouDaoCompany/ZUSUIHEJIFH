//
//  AddTingShiVC.m
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddTingShiVC.h"
#import "TingShiTabViewCell.h"
#import "TingShiHeadView.h"
#import "ZHPickView.h"
#import "Courtroom_linkman.h"

static NSString *const TINGSHICELLIDENTIFER = @"TingShiTabViewCellID";
@interface AddTingShiVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TingShiHeadViewPro> {
    
}
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) UIView *footView;

@property (nonatomic, assign) AddTingShiType tSType;
@property (nonatomic, strong) Courtroom_base *baseModel;
@property (nonatomic, copy) NSString *jidString;//司法机关的ID

@end

@implementation AddTingShiVC

- (instancetype)initWithJidString:(NSString *)jidString withType:(AddTingShiType)type withCourtroom_base:(Courtroom_base *)baseModel {
    
    self = [super init];
    if (self) {
        
        _jidString = jidString;
        if (type == AddTingShi) {
            
            [self.dataSourceArrays addObject:[NSMutableArray arrayWithObjects:@"",@"", nil]];
            [self.dataSourceArrays addObject:[NSMutableArray arrayWithObjects:@"",@"",@"", nil]];
        } else {
            
            [self.dataSourceArrays addObject:[NSMutableArray arrayWithObjects:baseModel.name,baseModel.address, nil]];
            
            for (Courtroom_linkman *linkModel in baseModel.courtroom_linkman) {
                
                NSString *typeString = ([linkModel.type isEqualToString:@"1"]) ? @"法官" : @"书记员";
                [self.dataSourceArrays addObject:[NSMutableArray arrayWithObjects:typeString,linkModel.name,linkModel.phone, nil]];
            }
        }
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

- (void)initUI {
    
    [self setupNaviBarWithTitle:@"庭室信息"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.tableview];
    [_tableview setTableFooterView:self.footView];
}
- (void)addAndCommitBtnEvent:(UIButton *)btn {
    
    NSUInteger btnTag = btn.tag;
    
    if (btnTag == 8989) {
        [self.dataSourceArrays addObject:[NSMutableArray arrayWithObjects:@"",@"",@"", nil]];
        
        [_tableview insertSections:[NSIndexSet indexSetWithIndex:[_dataSourceArrays count] - 1] withRowAnimation:UITableViewRowAnimationNone];
    } else { WEAKSELF;
        //提交
        DLog(@"提交");
        NSMutableArray *oneArr = _dataSourceArrays[0];
        for (NSString *objString in oneArr) {
            
            if (objString.length == 0) {
                
                [JKPromptView showWithImageName:nil message:[NSString stringWithFormat:@"请输入%@",objString]];
                return;
            }
        }
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,ADDTINGSHIMESSAGEURL];
        NSMutableDictionary *paraDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PublicFunction ShareInstance].m_user.data.uid,@"uid",_jidString,@"jid",@"1",@"open", nil];
        
        NSMutableDictionary *oneDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:oneArr[0],@"name",oneArr[1],@"address", nil];
        
        NSArray *tempOneArr = [NSArray arrayWithObject:oneDict];
        NSMutableArray *tempTwoArr = [NSMutableArray array];

        if ([_dataSourceArrays count] > 1) {
            
            for (NSUInteger i = 1; i < [_dataSourceArrays count]; i++) {
                
                NSMutableArray *arr = _dataSourceArrays[1];
                
                NSString *typeString = ([arr[0] isEqualToString:@"法官"]) ? @"1" : @"2";
                NSMutableDictionary *twoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:typeString,@"type",arr[1],@"name",arr[2],@"tel", nil];
                [tempTwoArr addObject:twoDict];
            }
        }
        
        // 转json
        
        NSData *basicData = [QZManager toJSONData:tempOneArr];
        NSString *basicMsg =[[NSString alloc] initWithData:basicData
                                                      encoding:NSUTF8StringEncoding];
        NSData *linkmanData = [QZManager toJSONData:tempOneArr];
        NSString *linkmanMsg =[[NSString alloc] initWithData:linkmanData
                                                  encoding:NSUTF8StringEncoding];

        [paraDictionary setObject:basicMsg forKey:@"basic"];
        [paraDictionary setObject:linkmanMsg forKey:@"linkman"];

        
        [NetWorkMangerTools arrangeAddManagement:paraDictionary withUrl:url RequestSuccess:^{
            // 提交成功
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_dataSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *arr = _dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TingShiTabViewCell *cell = (TingShiTabViewCell *)[tableView dequeueReusableCellWithIdentifier:TINGSHICELLIDENTIFER];
    [cell settingUIWithMutableArrays:_dataSourceArrays
                         withSection:indexPath.section
                        withIndexRow:indexPath.row withEnadled:YES];
    cell.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF;
    
    if (indexPath.section > 0 && indexPath.row == 0) {
        
        __block NSMutableArray *temArr = _dataSourceArrays[indexPath.section];
        NSString *lastString = temArr[indexPath.row];
        ZHPickView *pickView = [[ZHPickView alloc] initWithSelectString:lastString];
        [pickView setDataViewWithItem:@[@"法官",@"书记员"] title:@"联系人类别"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type) {
            
            [temArr replaceObjectAtIndex:indexPath.row withObject:selectedStr];
            [weakSelf.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString * title = (section == 0) ? @"庭室信息" : @"庭室联系人信息";
    TingShiHeadView *headView = [[TingShiHeadView alloc] initTingShiListHeadViewWithTitleString:title withSetion:section withDelegate:self];
    headView.delBtn.hidden = (section > 1) ? NO : YES;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}
#pragma mark - TingShiHeadViewPro
- (void)deleteRedundantTingShiSectionView:(NSUInteger)section {
    
    [_dataSourceArrays removeObjectAtIndex:section];
    [_tableview deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [_tableview reloadData];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self dismissKeyBoard];
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    CaseTextField *textField = (CaseTextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger row = textField.row;
    NSInteger section = textField.section;
    
    NSMutableArray *arr = _dataSourceArrays[section];
    [arr replaceObjectAtIndex:row withObject:textField.text];
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissKeyBoard];
}

#pragma mark - setter and getter
- (UITableView *)tableview { WEAKSELF;
    
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsHorizontalScrollIndicator= NO;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableview registerClass:[TingShiTabViewCell class] forCellReuseIdentifier:TINGSHICELLIDENTIFER];
        [_tableview whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];
    }
    return _tableview;
}
- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {
       
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (UIView *)footView {
    
    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
        _footView.backgroundColor = hexColor(F2F2F2);
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn1.frame = CGRectMake(15 , 20, (kMainScreenWidth - 45)/2.f, 40);
        btn1.layer.masksToBounds = YES;
        btn1.layer.cornerRadius = 3.f;
        btn1.backgroundColor  = hexColor(00c8aa);
        [btn1 setTitleColor:[UIColor whiteColor] forState:0];
        [btn1 setTitle:@"添加法官信息" forState:0];
        btn1.titleLabel.font = Font_15;
        btn1.tag = 8989;
        [btn1 addTarget:self action:@selector(addAndCommitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn1];

        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(30 + (kMainScreenWidth - 45)/2.f , 20, (kMainScreenWidth - 45)/2.f, 40);
        btn2.layer.masksToBounds = YES;
        btn2.layer.cornerRadius = 3.f;
        btn2.backgroundColor  = hexColor(00c8aa);
        [btn2 setTitleColor:[UIColor whiteColor] forState:0];
        [btn2 setTitle:@"提交" forState:0];
        btn2.titleLabel.font = Font_15;
        btn2.tag = 8988;
        [btn2 addTarget:self action:@selector(addAndCommitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn2];
    }
    return _footView;
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
