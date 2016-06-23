//
//  LawSview.m
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawSview.h"
#import "LawsKindView.h"
#define lawWidth     [UIScreen mainScreen].bounds.size.width/4.f
#define searchWidth     [UIScreen mainScreen].bounds.size.width*(270/375.0f)

@interface LawSview()<DPHorizontalScrollViewDelegate>
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)NSMutableArray *imageArrays;
@property (nonatomic,strong) NSMutableArray *titleArrays;
@property (nonatomic,strong) UIView *sectionView;

@end

@implementation LawSview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float width = self.bounds.size.width;
        float height = self.bounds.size.height;
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
        _imgView.image = [UIImage imageNamed:@"laws_lawsSearch"];
        _imgView.userInteractionEnabled = YES;
        [self addSubview:_imgView];
        
        [self initTheSearch];//搜索
        
        UIView *botomView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), width, height-150)];
        botomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:botomView];
        
        _titleArrays = [NSMutableArray arrayWithObjects:@"新法速递",@"常用法规",@"法规库",@"我的收藏", nil];
        _imageArrays = [NSMutableArray arrayWithObjects:@"law_xinfasudi",@"law_changyongfagui",@"law_difangfagui",@"law_wodeshoucang", nil];

        _horizontalScrollView = [[DPHorizontalScrollView alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), width, 110)];
        _horizontalScrollView.scrollViewDelegate = self;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_horizontalScrollView];
        
        _sectionView = [[UIView alloc] initWithFrame: CGRectMake(0, height-10, width, 10)];
        _sectionView.backgroundColor = ViewBackColor;
        [self addSubview:_sectionView];
    }
    return self;
}
#pragma mark - ---------------------- DPHorizontalScrollViewDelegate
- (NSInteger)numberOfColumnsInTableView:(DPHorizontalScrollView *)tableView{
    
    return [_titleArrays count];
}

- (CGFloat)tableView:(DPHorizontalScrollView *)tableView widthForColumnAtIndex:(NSInteger)index{
    return lawWidth;
}

- (UIView *)tableView:(DPHorizontalScrollView *)tableView viewForColumnAtIndex:(NSInteger)index{
    LawsKindView *view = [tableView reusableView];
    if (!view) {
        view = [[LawsKindView alloc] init];
    }
    view.type = LawsFrom;
    if (_imageArrays.count !=0) {
        [view setImgViewImageName:_imageArrays[index] WithLabelText:_titleArrays[index]];
    }
    view.indexBlock = ^(NSInteger count){
        _indexBlock(count);
    };
    return view;
}


#pragma mark-搜索
- (void)initTheSearch
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake((kMainScreenWidth-searchWidth)/2.f, Orgin_y(_imgView) -52.5f, searchWidth, 30);
    [searchBtn addTarget:self action:@selector(gotoSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    [_imgView addSubview:searchBtn];
    searchBtn.backgroundColor=[UIColor whiteColor];
    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 18, 18)];
    [searchBtn addSubview:search];
    search.image = [UIImage imageNamed:@"law_sousuo"];
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, searchBtn.frame.size.width-64, 30)];
    searchLab.text =  @"搜索相关法律法规";
    searchLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    searchLab.font = Font_14;
    [searchBtn addSubview:searchLab];
    
    UIView * lineview = [[UIView alloc] initWithFrame:CGRectMake(searchBtn.frame.size.width-32, 5, .5f, 20)];
    lineview.backgroundColor = lineColor;
    [searchBtn addSubview:lineview];
    
    UIImageView *soundimg =[[UIImageView alloc] initWithFrame:CGRectMake(searchBtn.frame.size.width-25, 5, 13, 19)];
    [searchBtn addSubview:soundimg];
    soundimg.image = [UIImage imageNamed:@"law_yuyin"];
    
}
#pragma mark -UIButtonEvent
- (void)gotoSearchVC:(id)sender
{
    _searchBlock();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



