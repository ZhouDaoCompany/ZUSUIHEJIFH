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
#import "LCActionSheet.h"

static NSString *const LITIIDENTIFER = @"litigationidentifer";

@interface LitigationTabVC ()<UITextFieldDelegate,ConsultantHeadViewPro>
{
    UITapGestureRecognizer * _tapGesture;
}
@property (nonatomic, strong) NSMutableArray *basiArr;//基本信息数组
@property (nonatomic, strong) NSMutableArray *textBasiArr;

@property (nonatomic, strong) NSMutableArray *contentTilArr;//审理标题大数组
@property (nonatomic, strong) NSMutableArray *contentArr;//审理信息大数组
@property (nonatomic, strong) NSMutableArray *categoryArr;//存贮类别数组
@property (nonatomic, strong) NSArray *kindsArr;//六种类别
@end

@implementation LitigationTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    _basiArr = [NSMutableArray arrayWithObjects:@"案件号",@"案件名称",@"委托人",@"-委托人联系电话",@"-委托人联系邮箱", @"-委托人联系地址",@"收案日期",@"原告人或公诉机关",@"被告或上诉人",nil];
    _textBasiArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", @"",@"",@"",@"",nil];
    _contentArr = [NSMutableArray array];
    _categoryArr = [NSMutableArray array];
    _kindsArr = @[@"经济仲裁", @"劳动仲裁",@"一审",@"二审",@"再审",@"执行程序"];
    /**
     *  (1经济仲裁 2劳动仲裁) ,(3一审 4二审), 5再审, 6执行程序
     */
    NSArray *arr1 = [NSArray arrayWithObjects:@"审理类别",@"仲裁委员会",@"联系电话",@"联系地址",@"仲裁员联系电话",@"书记员联系电话",@"仲裁结果",@"备注", nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"审理类别",@"法院名称",@"联系电话",@"联系地址",@"主审法官联系电话",@"书记员联系电话",@"审判结果",@"备注", nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"审理类别",@"法院名称",@"联系电话",@"联系地址",@"主审法官联系电话",@"书记员联系电话",@"审判结果",@"收到法律文书时间",@"备注", nil];
    NSArray *arr4 = [NSArray arrayWithObjects:@"审理类别",@"法院名称",@"联系电话",@"联系地址",@"执行法官联系电话",@"书记员联系电话",@"备注", nil];
    _contentTilArr = [NSMutableArray arrayWithObjects:arr1,arr1,arr2,arr2,arr3,arr4, nil];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView registerClass:[LitigationCell class] forCellReuseIdentifier:LITIIDENTIFER];
    self.tableView.tableFooterView = [self creatTabFootView];
    self.tableView.backgroundColor = [UIColor clearColor];
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
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.f;
    [cancelBtn addTarget:self action:@selector(addMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
    [botomView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];;
    sureBtn.titleLabel.font = Font_15;
    sureBtn.frame = CGRectMake(Orgin_x(cancelBtn) +15.f, 20, (width-45)/2.f , 40);
    [sureBtn setTitle:@"提交" forState:0];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 5.f;
    [sureBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [botomView addSubview:sureBtn];
    
    return botomView;
}
#pragma mark -Event Respose
- (void)addMsgEvent:(UIButton *)sender
{
    [_categoryArr addObject:@"0"];
    NSArray *arr = _contentTilArr[0];
    __block NSMutableArray *conArr = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        (idx == 0)?[conArr addObject:@"经济仲裁"]:[conArr addObject:@""];
    }];
    [_contentArr addObject:conArr];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:_contentArr.count] withRowAnimation:UITableViewRowAnimationTop];
}
- (void)commitEvent:(UIButton *)sender
{
    
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
    NSArray *titArr = _contentTilArr[[cateStr intValue]];
    return [titArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    LitigationCell *cell = [tableView dequeueReusableCellWithIdentifier:LITIIDENTIFER forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LitigationCell class]]) {
        LitigationCell *lCell = (LitigationCell *)cell;
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        
        lCell.section = section;
        lCell.rowIndex = row;
        if (section == 0)
        {
            if (_basiArr.count >0) {
                lCell.titleLab.text = _basiArr[row];
                lCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_basiArr[row]];
                lCell.deviceLabel.text = _textBasiArr[row];
                lCell.textField.text = _textBasiArr[row];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:lCell];
            }
        }else{
            if (_categoryArr.count >0){
                NSString *cateStr = _categoryArr[section -1];
                NSArray *titArr = _contentTilArr[[cateStr intValue]];
                NSArray *contentArr = _contentArr[section-1];
                lCell.titleLab.text = titArr[row];
                lCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",titArr[row]];
                lCell.deviceLabel.text = contentArr[row];
                lCell.textField.text = contentArr[row];
            }
        }
        
//        NSDictionary *notiDict = [NSDictionary dictionaryWithObjectsAndKeys:lCell.textField,@"TextField",[NSString stringWithFormat:@"%ld",section],@"section",[NSString stringWithFormat:@"%ld",row],@"row", nil];
        

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        
    }else {
        if (row == 0) {
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:_kindsArr redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                /***********************此处提醒修改后丢失内容***************************************/
                NSLog(@"dijige----%ld",buttonIndex);
                NSString *classIndex = [NSString stringWithFormat:@"%ld",buttonIndex];
                [weakSelf.categoryArr replaceObjectAtIndex:section-1 withObject:classIndex];
                NSArray *arr = weakSelf.contentTilArr[buttonIndex];
                __block NSMutableArray *conArr = [NSMutableArray array];
                NSString *titStr = weakSelf.kindsArr[buttonIndex];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    (idx == 0)?[conArr addObject:titStr]:[conArr addObject:@""];
                }];
                [weakSelf.contentArr replaceObjectAtIndex:section-1 withObject:conArr];
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [sheet show];
        }else {
            
            NSString *cateStr = _categoryArr[section -1];
            NSArray *titArr = _contentTilArr[[cateStr intValue]];

            if ([titArr[row] isEqualToString:@"仲裁结果"]) {
                NSArray *resultsArr = @[@"裁决", @"调解",@"撤回"];
                LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:resultsArr redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                    
                    NSMutableArray *arr = weakSelf.contentArr[section -1];
                    [arr replaceObjectAtIndex:row withObject:resultsArr[buttonIndex]];
                     [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                }];
                [sheet show];
            }
        }
    }
    
//    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//    
//    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f) withSection:section];
    if (section ==0) {
        headView.delBtn.hidden = YES;
        [headView setLabelText:@"基本信息"];
    }else{
        headView.delBtn.hidden = NO;
        headView.delegate = self;
        [headView setLabelText:@"审理信息"];
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}
#pragma mark -ConsultantHeadViewPro
- (void)deleteSectionEventRespose:(NSUInteger)section;
{WEAKSELF;
    NSLog(@"section-----%ld",section);
    [_contentArr removeObjectAtIndex:section-1];
    [UIView animateWithDuration:0.25f animations:^{
         [weakSelf.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
    } completion:^(BOOL finished) {
        [weakSelf.tableView reloadData];
    }];

}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    LitigationCell *cell = (LitigationCell *)noti.object;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    UITextField *textField = cell.textField;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    if (section == 0) {
        [_textBasiArr replaceObjectAtIndex:row withObject:textField.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
