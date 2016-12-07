//
//  LPCameraFocusView.m
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LPCameraFocusView.h"

@interface LPCameraFocusView()

@property (strong, nonatomic) UIImageView *focus;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LPCameraFocusView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _focus = [[UIImageView alloc]init];
        _focus.image = [UIImage imageNamed:@"camera_focus_pic.png"];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    _focus.frame = CGRectMake(0, 0, 80, 80);
    _focus.center = point;
    [self addSubview:_focus];
    
    [self shakeToShow:_focus];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(hideFocusView) userInfo:nil repeats:YES];
    if ([self.delegate respondsToSelector:@selector(cameraFocusOptionsWithPoint:)]) {
        [self.delegate cameraFocusOptionsWithPoint:point];
    }
}

- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

-(void) hideFocusView {
    
    [_focus removeFromSuperview];
    [_timer invalidate];
}
- (void)dealloc {
    
    TT_INVALIDATE_TIMER(_timer);
    TTVIEW_RELEASE_SAFELY(_focus);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
