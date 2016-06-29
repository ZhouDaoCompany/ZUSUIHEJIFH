//
//  CaseFIViewController.m
//  ZhouDao
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseFIViewController.h"
#import "CollectEmptyView.h"
#import "AddFinanceVC.h"
#import "FinanceDesCell.h"


static NSString * const       ALLFINANCEIDENTIFER       =  @"allFinanceCellIdentifier";

@interface CaseFIViewController ()<UITableViewDataSource,UITableViewDelegate,FinanceDesCellPro>
{
    BOOL _flag[24];//bool 数组
    
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) CollectEmptyView *emptyView;//为空时候
@property (nonatomic,strong)NSMutableArray *dataArrays;//数据源

@end

@implementation CaseFIViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"财务信息"];
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:nil img:@"mine_addNZ"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    self.emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 235.5f, kMainScreenWidth, kMainScreenHeight-235.5f) WithText:@"暂无案件文件"];
    _dataArrays = [NSMutableArray arrayWithObjects:@"携手池边月，开襟竹下风。驱愁知酒力，破睡见茶功。居处东西接，年颜老少同。能来为伴否？伊上作渔翁。",@"岑公相门子，雅望归安石。奕世皆夔龙，中台竟三拆。至人达机兆，高揖九州伯。奈何天地间，而作隐沦客。贵道能全真，潜辉卧幽邻。探元入窅默，观化游无垠。光武有天下，严陵为故人。虽登洛阳殿，不屈巢由身。余亦谢明主，今称偃蹇臣。登高览万古，思与广成邻。蹈海宁受赏，还山非问津。西来一摇扇，共拂元规尘。",@"君生我未生，我生君已老。 君恨我生迟，我恨君生早。君生我未生，我生君已老。 恨不生同时，日日与君好。我生君未生，君生我已老。 我离君天涯，君隔我海角。我生君未生，君生我已老。 化蝶去寻花，夜夜栖芳草。",@"梅尧臣（1002～1060）字圣俞，世称宛陵先生，北宋著名现实主义诗人。汉族，宣州宣城（今属安徽）人。宣城古称宛陵，世称宛陵先生。初试不第，以荫补河南主簿。50岁后，于皇祐三年（1051）始得宋仁宗召试，赐同进士出身，为太常博士。以欧阳修荐，为国子监直讲，累迁尚书都官员外郎，故世称“梅直讲”、“梅都官”。曾参与编撰《新唐书》，并为《孙子兵法》作注，所注为孙子十家著（或十一家著）之一。有《宛陵先生集》60卷，有《四部丛刊》影明刊本等。词存二首。",@"鲁山层峦叠嶂，千峰竞秀，一高一低，蔚为壮观，正好投合我热爱大自然景色的心情",@"在山中走着走着，幽静的秋山，看不到房舍，望不见炊烟，自己也怀疑这山里是不是有人家居住，不禁自问一声，“人家在何许(何处)”",@"携手池边月，开襟竹下风。驱愁知酒力，破睡见茶功。居处东西接，年颜老少同。能来为伴否？伊上作渔翁。",@"岑公相门子，雅望归安石。奕世皆夔龙，中台竟三拆。至人达机兆，高揖九州伯。奈何天地间，而作隐沦客。贵道能全真，潜辉卧幽邻。探元入窅默，观化游无垠。光武有天下，严陵为故人。虽登洛阳殿，不屈巢由身。余亦谢明主，今称偃蹇臣。登高览万古，思与广成邻。蹈海宁受赏，还山非问津。西来一摇扇，共拂元规尘。",@"君生我未生，我生君已老。 君恨我生迟，我恨君生早。君生我未生，我生君已老。 恨不生同时，日日与君好。我生君未生，君生我已老。 我离君天涯，君隔我海角。我生君未生，君生我已老。 化蝶去寻花，夜夜栖芳草。",@"梅尧臣（1002～1060）字圣俞，世称宛陵先生，北宋著名现实主义诗人。汉族，宣州宣城（今属安徽）人。宣城古称宛陵，世称宛陵先生。初试不第，以荫补河南主簿。50岁后，于皇祐三年（1051）始得宋仁宗召试，赐同进士出身，为太常博士。以欧阳修荐，为国子监直讲，累迁尚书都官员外郎，故世称“梅直讲”、“梅都官”。曾参与编撰《新唐书》，并为《孙子兵法》作注，所注为孙子十家著（或十一家著）之一。有《宛陵先生集》60卷，有《四部丛刊》影明刊本等。词存二首。",@"鲁山层峦叠嶂，千峰竞秀，一高一低，蔚为壮观，正好投合我热爱大自然景色的心情",@"在山中走着走着，幽静的秋山，看不到房舍，望不见炊烟，自己也怀疑这山里是不是有人家居住，不禁自问一声，“人家在何许(何处)”", nil];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerClass:[FinanceDesCell class] forCellReuseIdentifier:ALLFINANCEIDENTIFER];

}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FinanceDesCell *cell = (FinanceDesCell *)[tableView dequeueReusableCellWithIdentifier:ALLFINANCEIDENTIFER];
    cell.delegate = self;
    cell.expanded  = _flag[indexPath.row];
    [cell setDesString:_dataArrays[indexPath.row]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinanceDesCell *cell = (FinanceDesCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return  cell.rowHeight;
}
#pragma mark - DesTableViewCellPro
- (void)expandOrClose:(UITableViewCell *)cell{
    
    FinanceDesCell *desCell = (FinanceDesCell *)cell;
    NSIndexPath *indexpath = [_tableView indexPathForCell:desCell];
    _flag[indexpath.row] = !_flag[indexpath.row];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - event response
-(void)rightBtnAction
{
    DLog(@"添加财务管理");
    
    AddFinanceVC *vc = [AddFinanceVC new];
    vc.caseId = _caseId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - private methods

#pragma mark - getters and setters 
- (CollectEmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64.f)
                                                    WithText:@"暂无财务信息"];
    }
    return _emptyView;
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
