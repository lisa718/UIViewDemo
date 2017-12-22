//
//  LSFloatingLabel.m
//  LSMessages
//
//  Created by baidu on 2017/12/21.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSFloatingLabelManager.h"

@interface LSFloatingLabelManager ()

@property (nonatomic,strong) UIWindow * window;
@property (nonatomic,strong) UIViewController * rootVC;
@property (nonatomic,strong) UILabel * label;

@end

@implementation LSFloatingLabelManager

// 单例
+ (instancetype _Nonnull)sharedInstance {
    static dispatch_once_t onceToken;
    static LSFloatingLabelManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [LSFloatingLabelManager new];
    });
    return instance;
}

+ (void)updateTextWith:(NSString *)text {
#ifdef DEBUG
    [[LSFloatingLabelManager sharedInstance] updateTextWith:text];
#endif
}


+ (void)show {
    #ifdef DEBUG
    [[LSFloatingLabelManager sharedInstance] show];
    #endif
}


+ (void)hide {
     #ifdef DEBUG
    [[LSFloatingLabelManager sharedInstance] hide];
     #endif
}

#pragma mark - public

- (void)updateTextWith:(NSString *)text {
    if (_window == nil || _window.hidden) {
        return;
    }
    self.label.text = text;
    CGRect textRect = [self.label.attributedText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height)  options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.window.frame = CGRectMake(self.window.frame.origin.x, self.window.frame.origin.y,textRect.size.width, textRect.size.height);
   // 这里改变了label的bounds
    [self.label sizeToFit];
    [self.window setNeedsDisplay];
}

- (void)show {
    if (_window != nil && !_window.hidden)
        return;
    self.window.rootViewController = self.rootVC;
    [self.rootVC.view addSubview:self.label];
    self.label.text = @"FSxxxx";
    self.label.frame = self.rootVC.view.bounds;
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.hidden = NO;
}

- (void)hide {
    self.label = nil;
    self.rootVC = nil;
    self.window.hidden = YES;
    self.window = nil;
}

#pragma mark - gesture
- (void)pan:(UIPanGestureRecognizer *)ges {
#warning why not keywindow
    //UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [ges locationInView:appWindow];
    
    if(ges.state == UIGestureRecognizerStateBegan) {
    }else if(ges.state == UIGestureRecognizerStateChanged) {
        self.window.center = CGPointMake(panPoint.x, panPoint.y);
    }
}

#pragma mark - getters & setters
- (UIWindow *)window {
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
//        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor colorWithRed:(CGFloat)((random()%256)/255.0) green:(CGFloat)((random()%256)/255.0) blue:(CGFloat)((random()%256)/255.0) alpha:0.8];
        _window.windowLevel = UIWindowLevelAlert-1;
        UIPanGestureRecognizer * ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [_window addGestureRecognizer:ges];
        _window.layer.cornerRadius = 4;
    }
    return _window;
}

- (UIViewController *)rootVC {
    if (_rootVC == nil) {
        _rootVC = [[UIViewController alloc] init];
    }
    return _rootVC;
}

- (UILabel*)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}
@end
