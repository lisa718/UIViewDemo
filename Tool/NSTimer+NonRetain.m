//
//  NSTimer+NonRetain.m
//  LSMessages
//
//  Created by baidu on 2017/12/20.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "NSTimer+NonRetain.h"

// --------------------------- Safe Timer -----------------------

@interface ForwardingTarget : NSObject

@property (nonatomic,weak) id realTarget;
@end

@implementation ForwardingTarget

- (instancetype)initWithRealTarget:(id)real_target {
    self = [super init];
    if (self) {
        _realTarget = real_target;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.realTarget;
}


@end

@implementation NSTimer (NonRetain)
+ (NSTimer *)scheduledNonRetainTimerWithTimeInterval:(NSTimeInterval)seconds
                                              target:(id)aTarget
                                            selector:(SEL)aSelector
                                            userInfo:(nullable id)userInfo
                                             repeats:(BOOL)isRepeat {
    
    
    ForwardingTarget *target = [[ForwardingTarget alloc] initWithRealTarget:aTarget];
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:target selector:aSelector userInfo:userInfo repeats:isRepeat];
}
@end

