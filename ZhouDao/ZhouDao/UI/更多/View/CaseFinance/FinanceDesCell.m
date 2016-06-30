//
//  FinanceDesCell.m
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FinanceDesCell.h"
#import "GBTagListView.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

static float const DefaultCellHeight = 34;
@interface FinanceDesCell()
{
//    NSArray*strArray;//保存标签数据的数组
    
    NSString *_desString;

}
@property (nonatomic, strong) GBTagListView *TagView;
//@property (nonatomic, assign)  BOOL isExpandable;    // 是否显示"收起"按钮

@end
@implementation FinanceDesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 5.f)];
        headView.backgroundColor = ViewBackColor;
        [self.contentView addSubview:headView];
        
        _titlab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(headView) + 10.f, 140, 20)];
        _titlab.textAlignment = NSTextAlignmentLeft;
        _titlab.text = @"律师(与客户)";
        _titlab.textColor = thirdColor;
        _titlab.font = Font_15;
        [self.contentView addSubview:_titlab];

//        strArray=@[@"收费模式:先收固定金额,按结果比例提成",@"风险代理:半风险",@"是否开具发票:否"];
        
        GBTagListView *tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, Orgin_y(_titlab) + 7, SCREENWIDTH, 0)];
        /**允许点击 */
        tagList.canTouch=NO;
        /**可以控制允许点击的标签数 */
        tagList.canTouchNum = 1;
        /**控制是否是单选模式 */
        tagList.isSingleSelect=YES;
        tagList.signalTagColor=[UIColor whiteColor];
        [tagList setMarginBetweenTagLabel:5.f AndBottomMargin:5.f];

//        [tagList setTagWithTagArray:strArray];
        [tagList setDidselectItemBlock:^(NSArray *arr) {
            
        }];
//        tagList.backgroundColor = [UIColor blackColor];
        _TagView = tagList;
        [self.contentView addSubview:_TagView];

        _rowHeight = 0;
        _lab = [[UILabel alloc] init];
        _lab.numberOfLines = 0;
        _lab.textColor = NINEColor;
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.lineBreakMode =  NSLineBreakByTruncatingTail;;
        
        [self.contentView addSubview:_lab];
        
        _showAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showAllButton setTitleColor:[UIColor blackColor] forState:0];
//        [_showAllButton setTitle:@"显示全部" forState:0];
//        [_showAllButton setBackgroundImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        [_showAllButton setImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        [_showAllButton addTarget:self action:@selector(didClickExpandOrCollapse:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showAllButton];

    }
    return self;
}


- (void)setFinanceModel:(FinanceModel *)financeModel
{
    _financeModel = nil;
    _financeModel = financeModel;
    
    _expanded = _financeModel.isExpanded;
    
    NSInteger index = 0;
    NSArray *titArr = [NSMutableArray arrayWithObjects:@"律师费(与客户)",@"提成(与律所)",@"差旅费",@"第三方费用",@"自定义", nil];

    if ([_financeModel.type isEqualToString:@"9"]) {
        index = 4;
    }else {
        index = [_financeModel.type integerValue] -1;
    }
    
    _titlab.text = titArr[index];
    
    NSData *titData = [_financeModel.title dataUsingEncoding:NSUTF8StringEncoding];
   __block NSMutableArray *jsonTitArr = [NSJSONSerialization JSONObjectWithData:titData options:NSJSONReadingAllowFragments error:nil];
    
    NSData *contentData = [_financeModel.content dataUsingEncoding:NSUTF8StringEncoding];
   __block NSMutableArray *jsonConArr = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
    
   __block NSMutableArray *arr = [NSMutableArray array];
    
    
    [jsonConArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx < jsonConArr.count -1) {
            if (obj.length >0) {
                NSString *str = [NSString stringWithFormat:@"%@:%@",jsonTitArr[idx],jsonConArr[idx]];
                
                [arr addObject:str];
            }
        }
    }];
    
    [_TagView setTagWithTagArray:arr];
    
    NSString *desString = [NSString stringWithFormat:@"%@",[jsonConArr lastObject]];
    
    if (desString.length == 0) {
        _showAllButton.hidden = YES;
        _rowHeight =  Orgin_y(_TagView) + 5.f;
        
    }else{
        _desString = desString;
        _lab.text = _desString;
        DLog(@"88888888------%@",_desString);
        [self calculateLabelHeight:_desString];

    }
    
}
- (void)calculateLabelHeight:(NSString *)desString{
    
    CGFloat labelMaxWidth = SCREENWIDTH-30;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    ziTiSize = [desString boundingRectWithSize:CGSizeMake(labelMaxWidth, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    if (ziTiSize.height  < DefaultCellHeight) {
        
//        _isExpandable = false;//没有收起展开操作
        _showAllButton.hidden = YES;
        _lab.frame = CGRectMake(15,  Orgin_y(_TagView) +5.f, labelMaxWidth, ziTiSize.height );

        _rowHeight =  ziTiSize.height + Orgin_y(_TagView) + 15;

        if ([self.delegate respondsToSelector:@selector(TheRefreshTableCell:)]) {
            [self.delegate TheRefreshTableCell:self];
        }

        
    }else{
        
//        _isExpandable = true;//含有收起展开操作
        _showAllButton.hidden = NO;
        if (_expanded == false) {
            //不展开
            _lab.frame = CGRectMake(15,  Orgin_y(_TagView)-4.f +5.f, labelMaxWidth, DefaultCellHeight);

            _rowHeight = DefaultCellHeight + 45 +  Orgin_y(_TagView);
            if ([self.delegate respondsToSelector:@selector(TheRefreshTableCell:)]) {
                [self.delegate TheRefreshTableCell:self];
            }

        }else{
            //展开
            _lab.frame = CGRectMake(15,  Orgin_y(_TagView) +5.f, labelMaxWidth, ziTiSize.height);

            _rowHeight = ziTiSize.height + 45 +  Orgin_y(_TagView);
            //            [_showAllButton setTitle:@"收起" forState:0];
            [_showAllButton setImage:[UIImage imageNamed:@"case_up"] forState:0];
            if ([self.delegate respondsToSelector:@selector(TheRefreshTableCell:)]) {
                [self.delegate TheRefreshTableCell:self];
            }

            
        }

        _showAllButton.frame = CGRectMake(SCREENWIDTH-45, _rowHeight-35, 30, 30);
        
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self calculateLabelHeight:_desString];

}
#pragma mark -UIButtonEvent
- (void)didClickExpandOrCollapse:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(expandOrClose:)]) {
        
        [self.delegate expandOrClose:self];
    }
    
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
