//
//  LSMessageOperation.m
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSMessageOperation.h"
#import "LSMessage.h"
#import "LSMessageView.h"
#import "NSTimer+NonRetain.h"

const NSTimeInterval kAnimationDuration = 0.2;

@interface LSMessageOperation () {
    
}
// NSOperation
@property (nonatomic,assign,getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));
//@property (nonatomic,assign,getter=isCancelled) BOOL cancelled;
@property (nonatomic,assign,getter=isFinished) BOOL finished;
@property (nonatomic,assign,getter=isExecuting) BOOL executing;


// model
@property (nonatomic,weak)   UIViewController       *attachedViewController;
@property (nonatomic,copy)   NSString               *title;
@property (nonatomic,copy)   NSString               *subtitle;
@property (nonatomic,strong) UIImage                *hintIcon;
@property (nonatomic,assign) LSMessageType          type;
@property (nonatomic,assign) NSTimeInterval         durationSecs;
@property (nonatomic,assign) LSMessagePosition      messagePosition;
@property (nonatomic,strong) NSTimer                *disappearTimer;
@property (nonatomic,weak)   LSMessageView          *currentShowingView;

@property (nonatomic,copy)   void (^calculateToPos)(void);


@end

@implementation LSMessageOperation

@synthesize asynchronous = _asynchronous,finished = _finished,executing = _executing;

- (instancetype _Nonnull)initWithViewController:(UIViewController *_Nonnull)view_controller
                                           title:(NSString *_Nonnull)title
                                        subtitle:(NSString *_Nullable)subtitle
                                           image:(UIImage *_Nullable)image
                                            type:(LSMessageType)type
                                   durationSecs:(NSTimeInterval)duration_secs
                                      atPosition:(LSMessagePosition)messagePosition {
    self = [super init];
    if (self) {
        NSParameterAssert(view_controller);
        _attachedViewController = view_controller;
        _title = [title copy];
        _subtitle = [subtitle copy];
        _hintIcon = image;
        _type = type;
        _durationSecs = duration_secs;
        _messagePosition = messagePosition;
    }
    return self;
}

// 展示当前的messageBox
- (void) start {
    
    NSLog(@"%s ; current thread = %@",__FUNCTION__,[NSThread currentThread]);
    self.executing = YES;
    self.finished = NO;
    // 不要重写，需要return
    if (self.isCancelled) {
        [self taskFinished];
        return;
    }
    // 如果要添加的attachedViewController不存在或者被释放，则直接返回
    if (self.attachedViewController == nil) {
        [self taskFinished];
        return;
    }
    
    // 由于在主队列执行，所以一定会在主线程执行
    [self executeTask];
    
    // 由于Task不一定需要在MainQueue
//    if ([[self class] isMainQueue]) {
//    if ([NSThread isMainThread]) {
//        [self executeTask];
//    }
//    else {
//#warning dispatch_aync is right?
//      dispatch_async(dispatch_get_main_queue(), ^{
//          [self executeTask];
//      });
//    }
}


#pragma mark - Main Function

- (void)executeTask {
    Debug_NSLog(@"%s ; current thread = %@",__FUNCTION__,[NSThread currentThread]);
    
    // 根据LSMessageType生成view合适的view
    // 初始化view
    LSMessageView *messageView = [[LSMessageView alloc] initWithFrame:
                                      CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)
                                                                        title:self.title
                                                                     subtitle:self.subtitle
                                                                        image:self.hintIcon
                                                                         type:self.type];
    

    // 添加事件
    [messageView addTarget:self action:@selector(dismissActiveMessageView) forEvent:LSMessageViewEvent_Tap];
    [messageView addTarget:self action:@selector(dismissActiveMessageView) forEvent:(self.messagePosition == LSMessagePosition_Bottom)?LSMessageViewEvent_Swipe_Down:LSMessageViewEvent_Swipe_Up];
    
    
    // 将view插入到view_controller的view层级中，并根据duration 设置展示时间
    [self addMessageViewAnimated:messageView];
    
    //
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {

    if(self.currentShowingView.superview) {
        self.calculateToPos();
    }
    Debug_NSLog(@"%s",__FUNCTION__);
}

- (void)taskFinished {
    
    // 停止计时器,也必须在主线程上，要不然不能停止，没有runloop
//#warning "NSTimer in multithread can not stop appropriately，need change timer"
    [self stopTimer];
    self.executing = NO;
    self.finished = YES;
    self.currentShowingView = nil;
}

- (void)addMessageViewAnimated:(LSMessageView *)message_view {
    
    // 此函数只能在主线程执行
    Debug_NSLog(@"current thread = %@",[NSThread currentThread]);
    
    // 将message_view添加到目标controller.view上，或者finished
    // 传入的attatchViewController可能有容器controller，也可能有topViewcontroller
    // 判断viewcontroller是否可见，是因为如果不可见，那么就可以直接finish，节省时间，动画倒计时等
    // 根据被添加的父亲controller的view的不同,来判断
    __block UIViewController * currentVC;
    __block UINavigationController *currentNav;
    __block UITabBarController *currentTab;
    
    // 计算位置：CurrentVC不空则相对于vc；tab不空则相对于tab
    __block CGPoint toPos = CGPointZero;
    __weak typeof(self) weakSelf = self;
    self.calculateToPos = ^void(){
        __strong typeof(self) strongSelf = weakSelf;
        
        message_view.frame = CGRectMake(message_view.frame.origin.x, message_view.frame.origin.y, [UIScreen mainScreen].bounds.size.width, message_view.bounds.size.height);
        if (currentVC != nil) {
            currentNav = currentVC.navigationController;
            currentTab = currentVC.tabBarController;
        }
        else if (currentTab != nil) {
            // find nav
            currentNav = [[self class] findVisibleNavFromTab:currentTab];
        }
        
        if (self.messagePosition == LSMessagePosition_Top) {
            
            if (currentVC != nil ) {
                toPos.y = -currentVC.view.frame.origin.y;
            }
            // nav
            if ([[strongSelf class] isNavBarInNavigationControllerShowed:currentNav]) {
                toPos.y += CGRectGetMaxY(currentNav.navigationBar.frame);
//                // status
//                if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
//                    toPos.y += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
//                }
            }
            else {
                // status
                if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
                    // 增加message_view的padding
                    message_view.paddingTop += CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
                }
            }
        }
        else if (self.messagePosition == LSMessagePosition_Bottom) {
            
            // 添加到tabbar上面
            if (currentVC.hidesBottomBarWhenPushed == NO && currentTab.tabBar.isHidden == NO) {
                toPos.y = CGRectGetHeight(currentVC.view.frame) - CGRectGetHeight(currentTab.tabBar.frame) - CGRectGetHeight(message_view.frame);
            }
        }
        else {
            if (currentVC != nil ) {
                toPos.y = -currentVC.view.frame.origin.y;
            }
            // status
            if ([UIApplication sharedApplication].isStatusBarHidden == NO) {
                // 增加message_view的padding
                message_view.paddingTop += CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame);
            }
        }
        
        
    };

    // 添加View
    // find prop parent view to show message
    BOOL shouldAddOnCurrentVC = NO;
    if (self.messagePosition == LSMessagePosition_OverNavBar) {
        // 如果overNavBar，那么不考虑传入的attatchedViewController，需要加当前的nav的bar下面或者tabcontroller的view上，都可以盖在上面,不需要判断是否有nav
        // 直接加到keywindow上就行了
//        currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:message_view];
        self.calculateToPos();
    }
    else {
        
        if([self.attachedViewController isKindOfClass:[UITabBarController class]]){
            // 如果传入的是一个containerViewController，说明要全局展示
            if ([[self class] isVisibleViewController:self.attachedViewController]) {
                [self.attachedViewController.view addSubview:message_view];
                currentTab = (UITabBarController *)self.attachedViewController;
                self.calculateToPos();
            }
            else { // 如果当前controller不可见
                currentVC = [[self class] findCurrentViewControllerRecursively];
                shouldAddOnCurrentVC = YES;
            }
        }
        else if([self.attachedViewController isKindOfClass:[UINavigationController class]]){
            
            // 如果传入的是一个containerViewController，说明要全局展示
            if ([[self class] isVisibleViewController:self.attachedViewController]) {
                UINavigationController * nav = (UINavigationController *)self.attachedViewController;
                if ([[self class] isNavBarInNavigationControllerShowed:nav]) {
                    [self.attachedViewController.view insertSubview:message_view belowSubview:nav.navigationBar];
                    currentNav = nav;
                    self.calculateToPos();
                }
                else {
                    [self.attachedViewController.view addSubview:message_view];
                    self.calculateToPos();
                }
                
//                currentVC = nav.visibleViewController;
            }
            else { // 如果当前controller不可见
                currentVC = [[self class] findCurrentViewControllerRecursively];
                shouldAddOnCurrentVC = YES;
            }

        }
        else { // 指定添加到内容viewcontroller，如果vc可见，直接 add 到上面，然后进行位置判断设置
            currentVC = self.attachedViewController;
            shouldAddOnCurrentVC = YES;

        }
        
        if (shouldAddOnCurrentVC) {
            if ([[self class] isVisibleViewController:currentVC]) {
                [currentVC.view addSubview:message_view];
                // 更新位置：需要判断是否有nav和tab
                self.calculateToPos();
            }
            else {
                [self taskFinished];
                return;
            }
        }
        
    
    }
    
    //
    self.currentShowingView = message_view;
    
#warning viewcontroller is not judge full display or not

    // 根据传入的pos添加动画
    [self addShowingAnimationOnMessageView:message_view toPosition:toPos messageShowPositionType:self.messagePosition];
    
    
    // 根据传入的duration 进行时长展示
    // 如果传入stay则，不消失，需要用户手动进行消失
    if (self.durationSecs == LSMessageDuration_Seconds_Stay) {
        return;
    }
    if (self.durationSecs >= LSMessageDuration_Seconds_AutoDisappear_After4) {
        NSTimeInterval d  = self.durationSecs > 0 ? self.durationSecs : 4;
        self.disappearTimer = [NSTimer scheduledNonRetainTimerWithTimeInterval:d target:self selector:@selector(dismissActiveMessageView) userInfo:nil repeats:NO];
        
    }
}

- (void)removeMessageViewAnimated:(LSMessageView *)message_view {
    
    // view已经展示出来，所以只需要从现有fromPos变化到toPos就可以了
    CGPoint fromPos = message_view.frame.origin;
    CGPoint toPos = CGPointZero;
    if (self.messagePosition == LSMessagePosition_Top || self.messagePosition == LSMessagePosition_OverNavBar) {
        toPos.y = fromPos.y - message_view.frame.size.height;
        toPos.x = fromPos.x;
    }
    else {
        toPos.y = fromPos.y + message_view.frame.size.height;
        toPos.x = fromPos.x;
    }
    
    // animation
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        [message_view setFrame:CGRectMake(toPos.x, toPos.y, message_view.frame.size.width, message_view.frame.size.height)];
        
    } completion:^(BOOL finished) {
        // remove
        [message_view removeFromSuperview];
        [self taskFinished];
    }];

}



- (void)dismissActiveMessageView {
    if (self.currentShowingView) {
        [self removeMessageViewAnimated:self.currentShowingView];
    }
    else {
        [self taskFinished];
    }
}

- (void)addShowingAnimationOnMessageView:(LSMessageView *)message_view
                              toPosition:(CGPoint)to_position
                 messageShowPositionType:(LSMessagePosition)message_showpostion_type {
    
    // 根据message_showpostion_type设置起点
    if (self.messagePosition == LSMessagePosition_Top || self.messagePosition == LSMessagePosition_OverNavBar) {
        
        [message_view setFrame:CGRectMake(to_position.x,
                                          to_position.y - message_view.frame.size.height,
                                          message_view.frame.size.width,
                                          message_view.frame.size.height)];
        
    }
    else {
        [message_view setFrame:CGRectMake(to_position.x,
                                          to_position.y + message_view.frame.size.height,
                                          message_view.frame.size.width,
                                          message_view.frame.size.height)];
    }
    
    // 动画
    [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        // 动画期间，禁用操作
        message_view.userInteractionEnabled = NO;
        // 设置目标位置
        [message_view setFrame:CGRectMake(to_position.x, to_position.y, message_view.frame.size.width, message_view.frame.size.height)];
    } completion:^(BOOL finished) {
        // 动画结束，
        message_view.userInteractionEnabled = YES;
    }];
    
}

- (void)stopTimer {
    [self.disappearTimer invalidate];
    self.disappearTimer = nil;
}

- (void)cancelInvalidExecutingOperation {
    
    if (!self.isExecuting) {
        return;
    }
    
    if (self.currentShowingView == nil) {
        [self taskFinished];
        return;
    }

    UIResponder *next = [self.currentShowingView nextResponder];
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            if (![[self class] isVisibleViewController:(UIViewController*)next]) {
                [self dismissActiveMessageView];
//                [self cancel];
            }
            break;
        }
        next = [next nextResponder];

    }
}


#pragma mark - Tool Method
+ (BOOL)isMainQueue {
    static const void* mainQueueKey = @"mainQueue";
    static void* mainQueueContext = @"mainQueue";
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
}
#warning why should judge twice,you should see controller & navbar
+ (BOOL)isNavBarInNavigationControllerShowed:(UINavigationController *)navController {

    if (navController == nil){
        return NO;
    }
    if (navController.isNavigationBarHidden) {
        return NO;
    }
    else if (navController.navigationBar.isHidden) {
        return NO;
    }
    return YES;
}

+ (BOOL)isVisibleViewController:(UIViewController *)view_controller {
    
    BOOL isVisible = view_controller.isViewLoaded && view_controller.view.window;
    return isVisible;
    
}

+ (UINavigationController *)findVisibleNavFromTab:(UITabBarController *)tabbar_controller {
    if (tabbar_controller != nil) {
        UIViewController * tmp = tabbar_controller.selectedViewController;
        if ([tmp isKindOfClass:[UINavigationController class]] && [[self class] isVisibleViewController:tmp]) {
            return  (UINavigationController *)tmp;
        }
    }
    return nil;
}
+ (UIViewController *)findCurrentViewControllerRecursively {

    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self findCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)findCurrentVCFrom:(UIViewController *)rootVC {
    
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [[self class] findCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [[self class] findCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark - Object Equal
- (BOOL)isEqual:(id _Nullable )object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToLSMessageOperation:object];
}

- (BOOL)isEqualToLSMessageOperation:(LSMessageOperation*)operation {
    if (operation == nil) {
        return NO;
    }
    
    BOOL isTitleEqualed = (self.title==nil && operation.title==nil) || [self.title isEqualToString:operation.title];
    BOOL isSubtitleEqualed = (self.subtitle==nil && operation.subtitle==nil) || [self.subtitle isEqualToString:operation.subtitle];
    BOOL isTypeEqualed = (self.type == operation.type);
    
    return isTitleEqualed && isSubtitleEqualed && isTypeEqualed;
}

- (NSUInteger)hash {
    return [self.title hash] ^ [self.subtitle hash];
}

#pragma mark - Getters & Setters
- (BOOL)isAsynchronous {
    return NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isMessageShowingNow {
    if (self.currentShowingView) {
        return YES;
    }
    return NO;
}

@end

