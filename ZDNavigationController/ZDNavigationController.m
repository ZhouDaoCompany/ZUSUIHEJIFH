//
//  ZDNavigationController.m
//  ZhouDao
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view

#import "ZDNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "CYLTabBarController.h"

@interface ZDNavigationController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *lastScreenShotView;
@property (nonatomic, strong) UIImageView *shadowImageView;

@property (nonatomic, strong) NSMutableArray *screenShotsList;

@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) CGPoint startTouch;

@end

@implementation ZDNavigationController

- (void)dealloc {
    
    _screenShotsList = nil;
    TTVIEW_RELEASE_SAFELY(_lastScreenShotView)
    TTVIEW_RELEASE_SAFELY(_backgroundView)
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - methods
- (void)initUI {
    
    
    [self.view addSubview:self.shadowImageView];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
}

- (void)moveViewWithX:(float)x {
    
    x = x>320 ? 320 : x;
    x = x<0 ? 0 : x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/5400)+0.95;
    
//    DLog(@"放大----%f",scale);
    //    float alpha = 0.4 - (x/800);
    
    self.lastScreenShotView.transform = (x == 0) ? CGAffineTransformIdentity : CGAffineTransformMakeScale(scale, scale);
    //    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
}
#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer { WEAKSELF;
    
    if (self.viewControllers.count <= 1 || self.fd_interactivePopDisabled) return;
    
    UIWindow *window = [QZManager getWindow];
    CGPoint touchPoint = [recoginzer locationInView:window];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        _startTouch = touchPoint;
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        self.backgroundView.hidden = NO;

        TTVIEW_RELEASE_SAFELY(_lastScreenShotView)
        [self.backgroundView addSubview:self.lastScreenShotView];
        
    } else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - _startTouch.x > 50) {
            
            [UIView animateWithDuration:0.35 animations:^{
                
                [weakSelf moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [weakSelf popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                weakSelf.view.frame = frame;
                weakSelf.isMoving = NO;
            }];
        } else {
            [UIView animateWithDuration:0.35 animations:^{
                
                [weakSelf moveViewWithX:0];
            } completion:^(BOOL finished) {
                
                weakSelf.isMoving = NO;
                weakSelf.backgroundView.hidden = YES;
            }];
        }
        return;
        
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf moveViewWithX:0];
        } completion:^(BOOL finished) {
            
            weakSelf.isMoving = NO;
            weakSelf.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}

- (UIImage *)captureScreen {
    
    if (TOP_VIEW) {
        
        return [QZManager capture];
    }
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.screenShotsList addObject:[self captureScreen]];
    self.navigationBarHidden = YES;
    [(CYLTabBarController *)self.tabBarController rootWindow].backgroundColor = [UIColor whiteColor];
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}
#pragma mark - setter and getter

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}
- (UIImageView *)lastScreenShotView {
    
    if (!_lastScreenShotView) {
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        _lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        _lastScreenShotView.backgroundColor = [UIColor clearColor];
    }
    return _lastScreenShotView;
}
- (UIImageView *)shadowImageView {
    
    if (!_shadowImageView) {
        
        _shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
        _shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    }
    return _shadowImageView;
}
- (NSMutableArray *)screenShotsList {
    
    if (!_screenShotsList) {
        
        _screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _screenShotsList;
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
