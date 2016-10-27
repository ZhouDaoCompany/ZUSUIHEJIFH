//
//  VerticalMenuButton.m
//  ZhouDao
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "VerticalMenuButton.h"
#import <pop/POP.h>

static CGFloat   const ChainBtnWidth = 40.0f;
static CGFloat   const ChainBtnSpace = 10.0f;
static NSInteger const ChainBtnTag = 1356;
static CGFloat   const ChainBtnDurationAnimation = 0.35;

@interface VerticalMenuButton ()
{
    BOOL _isClickBtn;
}
@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, assign) CGPoint bottomPosition;
@property (nonatomic, copy) void (^clickBlock)(NSInteger index);
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation VerticalMenuButton

- (instancetype)initWithImageNameArray:(NSArray *)nameArray bottomPosition:(CGPoint)point{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        self.imageNameArray = nameArray;
        self.bottomPosition = point;
    }
    return self;
}
- (void)prepareButtons{WEAKSELF;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self addGestureRecognizer:tap];
    
    self.buttonArray = [NSMutableArray array];
    [self.imageNameArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, ChainBtnWidth, ChainBtnWidth);
        button.center = self.bottomPosition;
        button.tag = ChainBtnTag+idx;
        button.hidden = YES;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:obj] forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [weakSelf.buttonArray addObject:button];
        [weakSelf addSubview:button];
    }];
}
- (void)showButtons{WEAKSELF;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        
        obj.hidden = NO;
        CGPoint toPoint = CGPointMake(weakSelf.bottomPosition.x, weakSelf.bottomPosition.y-(idx+1)*ChainBtnSpace-idx*ChainBtnWidth - 40);
        [weakSelf initailzerAnimationWithToPostion:toPoint formPostion:weakSelf.bottomPosition atView:obj beginTime:0.05];
    }];
}
- (void)hideButtons{WEAKSELF;
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
       
        [UIView animateWithDuration:ChainBtnDurationAnimation delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            obj.center = weakSelf.bottomPosition;
        } completion:^(BOOL finished) {
            obj.hidden = YES;
            if(idx == weakSelf.imageNameArray.count-1){
                
                [weakSelf removeFromSuperview];
            }
        }];
        
    }];
    
    if (!_isClickBtn) {
        if(self.clickBlock){
            self.clickBlock(4237);
        }
    }
    
}
- (void)buttonClicked:(UIButton *)button{
    if(self.clickBlock){
        self.clickBlock(button.tag-ChainBtnTag);
    }
    _isClickBtn = !_isClickBtn;
    [self hideButtons];
}
#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGPoint)toPoint formPostion:(CGPoint)fromPoint atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    springAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture{
    [self hideButtons];
}
+ (instancetype)showWithImageNameArray:(NSArray *)nameArray clickBlock:(void (^)(NSInteger))clickBlock bottomPosition:(CGPoint)point{
    VerticalMenuButton *chainButtons = [[VerticalMenuButton alloc] initWithImageNameArray:nameArray bottomPosition:point];
    chainButtons.clickBlock = clickBlock;
    
    [[UIApplication sharedApplication].keyWindow addSubview:chainButtons];
    
    [chainButtons prepareButtons];
    [chainButtons showButtons];
    
    return chainButtons;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
