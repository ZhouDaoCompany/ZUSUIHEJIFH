//
//  FinanceDesCell.m
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FinanceDesCell.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

static float const DefaultCellHeight = 80;

@implementation FinanceDesCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _rowHeight = 0;
        _lab = [[UILabel alloc] init];
        _lab.numberOfLines = 0;
        _lab.textColor = [UIColor grayColor];
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.lineBreakMode =  NSLineBreakByTruncatingTail;;
        
        [self.contentView addSubview:_lab];
        
        _showAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showAllButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showAllButton setTitleColor:[UIColor blackColor] forState:0];
        [_showAllButton setTitle:@"显示全部" forState:0];
        [_showAllButton setImage:[UIImage imageNamed:@"case_jianTou"] forState:0];
        [_showAllButton addTarget:self action:@selector(didClickExpandOrCollapse:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_showAllButton];

    }
    return self;
}

- (void)setDesString:(NSString *)desString{
    _desString = nil;
    _desString = desString;
    CGFloat labelMaxWidth = SCREENWIDTH-30;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    ziTiSize = [_desString boundingRectWithSize:CGSizeMake(labelMaxWidth, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    _lab.text = _desString;
    if (ziTiSize.height< DefaultCellHeight) {
        self.isExpandable = false;//没有收起展开操作
        _showAllButton.hidden = YES;
        _rowHeight = 10+ ziTiSize.height;
        
        _lab.frame = CGRectMake(15, 5, labelMaxWidth, _rowHeight - 10);
        
    }else{
        self.isExpandable = true;//含有收起展开操作
        _showAllButton.hidden = NO;
        if (_expanded == false) {
            //不展开
            _rowHeight = 10+ DefaultCellHeight +40;
        }else{
            //展开
            _rowHeight = 10 + ziTiSize.height +40;
            [_showAllButton setTitle:@"收起" forState:0];
            [_showAllButton setImage:[UIImage imageNamed:@"case_up"] forState:0];
        }
        
        _lab.frame = CGRectMake(15, 5, SCREENWIDTH-30, _rowHeight- 45);
        _showAllButton.frame = CGRectMake(SCREENWIDTH-80, _rowHeight-35, 70, 30);
        
    }
    
}


#pragma mark -UIButtonEvent
- (void)didClickExpandOrCollapse:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(expandOrClose:)]) {
        
        [self.delegate expandOrClose:self];
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
