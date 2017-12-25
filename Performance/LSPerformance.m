//
//  LSPerformanceInfo.m
//  LSMessages
//
//  Created by baidu on 2017/12/22.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "LSPerformance.h"
@import QuartzCore;
#import "LSFloatingLabelManager.h"

@interface LSPerformance ()

@property (nonatomic,strong) CADisplayLink * displayLink;
@property (nonatomic, assign)CFTimeInterval lastDisplayCallTimer;
@property (nonatomic,assign)NSInteger count;


@end

@implementation LSPerformance

#pragma mark - public
// 单例
+ (instancetype _Nonnull)sharedInstance {
    static dispatch_once_t onceToken;
    static LSPerformance *instance;
    dispatch_once(&onceToken, ^{
        instance = [LSPerformance new];
    });
    return instance;
}

+ (void)startMonitorWithPerformaceType:(LSPerformanceType)type {
   
    [LSFloatingLabelManager show];
    [[LSPerformance sharedInstance] startMonitorWithPerformaceType:type];
}

+ (void)stopMonitor {
    [LSFloatingLabelManager hide];
    [[LSPerformance sharedInstance] stopMonitor];

}

#pragma mark -
- (void)startMonitorWithPerformaceType:(LSPerformanceType)type {
    
    self.displayLink.paused = NO;
    self.lastDisplayCallTimer = self.displayLink.timestamp;
}

-(void)stopMonitor {
    
    self.displayLink.paused = YES;
}

#pragma mark - FS
- (CADisplayLink *)displayLink {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (void)tick {
#warning should calculate in other thread
    _count++;
    CFTimeInterval space = self.displayLink.timestamp - self.lastDisplayCallTimer;
    if (_count >= 10){
        CGFloat fps = _count / space;
        NSString * text = [NSString stringWithFormat:@"FS:%0.1f",_count/space];
        [LSFloatingLabelManager updateTextWith:text];
        _count = 0;
        self.lastDisplayCallTimer = self.displayLink.timestamp;

    }
   
}

@end
