//
//  CaseDetailTabCell.m
//  ZhouDao
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseDetailTabCell.h"

#define BtnWidth [UIScreen mainScreen].bounds.size.width/4.f
//#define leftX    (BtnWidth-20.f)/2.f
#define TopY     13.f

#import "CustomMenuBtn.h"
@interface CaseDetailTabCell()

@property (strong, nonatomic)  CustomMenuBtn *lookBtn;
@property (strong, nonatomic)  CustomMenuBtn *downloadBtn;
@property (strong, nonatomic)  CustomMenuBtn *cmmBtn;
//@property (strong, nonatomic)  CustomMenuBtn *shareBtn;
@property (strong, nonatomic)  CustomMenuBtn *delBtn;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation CaseDetailTabCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        [self indexLabel];
        [self headImgView];
        [self titLab];
        
        //按钮
        UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navBtn.backgroundColor = [UIColor clearColor];
        [navBtn setImage:[UIImage imageNamed:@"case_sandian"] forState:0];
        navBtn.titleLabel.font = Font_15;
        navBtn.frame = CGRectMake(kMainScreenWidth -45, 2.5f, 40 , 40);
        [navBtn addTarget:self action:@selector(pointBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:navBtn];
        
        self.clipsToBounds = YES;
        
        [self initUI];
    }
    return self;
}
- (UILabel *)indexLabel
{
    if (_indexLabel == nil) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 30, 20)];
        [_indexLabel setFont:Font_14];
        _indexLabel.textColor = sixColor;
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}
- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 10, 25, 25)];
        _headImgView.userInteractionEnabled = YES;
        _headImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView  addSubview:_headImgView];
    }
    return _headImgView;
}
- (UILabel *)titLab
{
    if (!_titLab) {
        _titLab = [[UILabel alloc] initWithFrame:CGRectMake(85, 13, 200, 20)];
        _titLab.backgroundColor = [UIColor clearColor];
        [_titLab setFont:Font_15];
        _titLab.textColor = thirdColor;
        [self.contentView addSubview:_titLab];
    }
    return _titLab;
}
- (void)setListModel:(DetaillistModel *)listModel
{
    _listModel = nil;
    _listModel = listModel;
    
    if (_indexRow <10) {
        _indexLabel.text = [NSString stringWithFormat:@"0%ld.",(long)_indexRow];
    }else{
        _indexLabel.text = [NSString stringWithFormat:@"%ld.",(long)_indexRow];
    }
    
    _titLab.text = _listModel.name;
    if ([_listModel.type_file isEqualToString:@"2"]) {
        [_headImgView setImage:[UIImage imageNamed:@"case_wenjainjia"]];
    }else{
        /**
         *  1 word ,2 pdf,3 txt,4 photo
         */
        _headImgView.image = nil;
        NSUInteger indextype = [_listModel.type_format integerValue];
        switch (indextype) {
            case 1:
                [_headImgView setImage:[UIImage imageNamed:@"case_word"]];
                break;
            case 2:
                [_headImgView setImage:[UIImage imageNamed:@"case_pdf"]];
                break;
            case 3:
                [_headImgView setImage:[UIImage imageNamed:@"case_txt"]];
                break;
            case 4:
                [_headImgView setImage:[UIImage imageNamed:@"case_photo"]];
                break;
                
            default:
                break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)initUI {
    [super awakeFromNib];
    // Initialization code
    
    UIView * botomView = [[UIView  alloc] initWithFrame:CGRectMake(0, 45.f, kMainScreenWidth, 70.f)];
    botomView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:botomView];
    
    //按钮
    _lookBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
    _lookBtn.backgroundColor = [UIColor clearColor];
    [_lookBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    _lookBtn.tag = 1001;
    [botomView addSubview:_lookBtn];
    
    _downloadBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
    _downloadBtn.backgroundColor = [UIColor clearColor];
    [_downloadBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    _downloadBtn.tag = 1002;
    [botomView addSubview:_downloadBtn];
    
//    _shareBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
//    _shareBtn.backgroundColor = [UIColor clearColor];
//    [_shareBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
//    _shareBtn.tag = 1003;
//    [botomView addSubview:_shareBtn];

    _cmmBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
    _cmmBtn.backgroundColor = [UIColor clearColor];
    [_cmmBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    _cmmBtn.tag = 1004;
    [botomView addSubview:_cmmBtn];
    
    
    _delBtn = [CustomMenuBtn buttonWithType:UIButtonTypeCustom];
    _delBtn.backgroundColor = [UIColor clearColor];
    [_delBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.tag = 1005;
    [botomView addSubview:_delBtn];
    
    
    float height = 70.f;
    _lookBtn.frame = CGRectMake(0,0, BtnWidth, height);
    [_lookBtn setTitle:@"查看" forState:0];
    [_lookBtn setImage:[UIImage imageNamed:@"case_look"] forState:0];
    
    _downloadBtn.frame = CGRectMake(BtnWidth, 0, BtnWidth, height);
    [_downloadBtn setTitle:@"下载" forState:0];
    [_downloadBtn setImage:[UIImage imageNamed:@"case_download"] forState:0];
    
//    _shareBtn.frame = CGRectMake(2*BtnWidth, 0, BtnWidth, height);
//    [_shareBtn setTitle:@"分享" forState:0];
//    [_shareBtn setImage:[UIImage imageNamed:@"case_share"] forState:0];

    _cmmBtn.frame = CGRectMake(2*BtnWidth, 0, BtnWidth, height);
    [_cmmBtn setTitle:@"重命名" forState:0];
    [_cmmBtn setImage:[UIImage imageNamed:@"case_cmingming"] forState:0];

    _delBtn.frame = CGRectMake(3*BtnWidth, 0, BtnWidth, height);
    [_delBtn setTitle:@"删除" forState:0];
    [_delBtn setImage:[UIImage imageNamed:@"case_delete"] forState:0];
    
  
    
}
- (void)pointBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ExpandOrCloseWithCell:)])
    {
        [self.delegate ExpandOrCloseWithCell:self];
    }
}

- (void)getMoreEvent:(UIButton *)btn
{
    NSUInteger index = btn.tag;
    DLog(@"tag:%ld",(unsigned long)index);
    
    if ([_listModel.type_file isEqualToString:@"2"] && index == 1002) {
        [JKPromptView showWithImageName:nil message:@"文件夹暂不提供下载功能"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(otherEvent:withCell:)])
    {
        [self.delegate otherEvent:index withCell:self];
    }
}

@end
