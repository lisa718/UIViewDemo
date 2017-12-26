//
//  LSNavbarAnimationController.m
//  LSMessages
//
//  Created by baidu on 2017/12/26.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSNavbarAnimationController.h"
#import "UIView+LayoutMethods.h"

@interface LSNavbarAnimationController (){
    CGPoint _firstPoint;
    CGPoint _currentPoint;
}

@property (nonatomic,strong) UIView * topFixedView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIScrollView * bottomScrollView;
@property (nonatomic,strong) UIPanGestureRecognizer *panGes;
@property (nonatomic,assign) BOOL animationing;
@end

@implementation LSNavbarAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.topFixedView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.bottomScrollView];
    self.bottomScrollView.scrollEnabled = NO;
    
    self.topFixedView.frame = CGRectMake(0, 0, self.view.ct_width, 300);
    self.bottomScrollView.ct_top = self.topFixedView.ct_bottom;
    self.bottomScrollView.ct_left = self.topFixedView.ct_left;
    self.bottomScrollView.ct_width = self.topFixedView.ct_width;
    self.bottomScrollView.ct_height = self.view.ct_height - self.topFixedView.ct_height;
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.ct_width, 1000);
    self.maskView.frame = self.topFixedView.frame;
    // 添加手势
    [self.bottomScrollView addGestureRecognizer:self.panGes];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gesture
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint panPoint = [pan translationInView:self.bottomScrollView];
    CGFloat upcenterPointY = (self.topFixedView.ct_height )/2.0 + 64;
    CGFloat downcenterPointY = (self.topFixedView.ct_height )/2.0;


//    NSLog(@"panPoint.y = %f",panPoint.y);
 
    if(pan.state == UIGestureRecognizerStateBegan) {
        self.animationing = NO;
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        
        // 判断边界
        // 如果大于frame或者64，则不能响应手势，return
        if (self.bottomScrollView.ct_top <= 64 && panPoint.y < 0) {
            return;
        }
        if (self.bottomScrollView.ct_top >= self.topFixedView.ct_bottom && panPoint.y > 0) {
            return;
        }
        
        // 可以跟手移动
        CGFloat y = self.bottomScrollView.ct_top + panPoint.y;
        [self.bottomScrollView setFrame:CGRectMake(0, y, self.view.ct_width, self.bottomScrollView.ct_height - panPoint.y)];
        // 因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
        [pan setTranslation:CGPointMake(0, 0) inView:self.bottomScrollView];
        
        CGFloat alpha = (self.topFixedView.ct_bottom-self.bottomScrollView.ct_top)/(upcenterPointY);;
        NSLog(@"alpha = %f",alpha);
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:ABS(alpha)];
        
        // 如果在原来的frame和64之间，往上滚动滚动，滚到/2.0的地方，需要回到64，,如果往下滚动，小于这个地方，滚回到原处，动画,其他都要跟手移动
       
        if (panPoint.y < 0 && self.bottomScrollView.ct_top <= upcenterPointY) {
            [self moveToTopAnimated];
            self.animationing = YES;
            self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
            return;
        }
        if (panPoint.y > 0 && self.bottomScrollView.ct_top > downcenterPointY) {
            [self moveToOriginalAnimated];
            self.animationing = YES;
            self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

            return;
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded) {

        if (self.animationing) {
            self.animationing = NO;
            return ;
        }
        // 停下跟在上面边界判断一样，需要复位
        if (self.bottomScrollView.ct_top <= 64 && panPoint.y < 0) {
            return;
        }
        if (self.bottomScrollView.ct_top >= self.topFixedView.ct_bottom && panPoint.y > 0) {
            return;
        }
        if (self.bottomScrollView.ct_top > upcenterPointY) {
            [self moveToOriginalAnimated];
        }
        else if (self.bottomScrollView.ct_top < downcenterPointY) {
            [self moveToTopAnimated];
        }
    }
}

- (void)moveToTopAnimated {
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        // 动画期间，禁用操作
        self.bottomScrollView.userInteractionEnabled = NO;
        // 设置目标位置
        [self.bottomScrollView setFrame:CGRectMake(0, 64, self.view.ct_width, self.view.ct_height)];
    } completion:^(BOOL finished) {
        // 动画结束，
        self.bottomScrollView.userInteractionEnabled = YES;
        self.bottomScrollView.scrollEnabled = YES;
    }];
    
    self.navigationController.navigationBar.hidden = NO;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;

    
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];


}


- (void)moveToOriginalAnimated {
    // 动画
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        // 动画期间，禁用操作
        self.bottomScrollView.userInteractionEnabled = NO;
        // 设置目标位置
        [self.bottomScrollView setFrame:CGRectMake(0, self.topFixedView.ct_bottom, self.view.ct_width, self.view.ct_height-self.topFixedView.ct_bottom)];
    } completion:^(BOOL finished) {
        // 动画结束，
        self.bottomScrollView.userInteractionEnabled = YES;
        self.bottomScrollView.scrollEnabled = YES;
    }];
    
    self.navigationController.navigationBar.hidden = YES;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.subtype = kCATransitionFromTop;
    [animation setType:kCATransitionReveal];
    
    [self.navigationController.navigationBar.layer addAnimation:animation forKey:nil];
}

#pragma mark - getters & setters
- (UIView *)topFixedView {
    if (_topFixedView == nil) {
        _topFixedView = [UIView new];
        _topFixedView.backgroundColor = [UIColor grayColor];
    }
    return _topFixedView;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (UIScrollView *)bottomScrollView {
    if (_bottomScrollView == nil) {
        _bottomScrollView = [UIScrollView new];
        _bottomScrollView.backgroundColor = [UIColor purpleColor];
    }
    return _bottomScrollView;
}

- (UIPanGestureRecognizer *)panGes {
    if (_panGes == nil) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    }
    return _panGes;
}


@end
