//
//  LSMessage.m
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSMessage.h"
#import "LSMessageOperation.h"

@interface LSMessage ()

@property (nonatomic,strong) NSOperationQueue * messageQueueInMainThread;

@end

@implementation LSMessage

// 单例
+ (instancetype _Nonnull)sharedInstance {
    static dispatch_once_t onceToken;
    static LSMessage *instance;
    dispatch_once(&onceToken, ^{
        instance = [LSMessage new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _messageQueueInMainThread = [NSOperationQueue mainQueue];
    }
    return self;
}

// 外部调用方法
// 调用此方法会产生，一个全局提示框：默认top、自动消失,
+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                        type:(LSMessageType)type {
    
    [[self class] showMessageInViewController:[[LSMessageOperation class] findCurrentViewControllerRecursively]
                                        title:title
                                     subtitle:subtitle
                                        image:nil
                                         type:type
                                 durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                   atPosition:LSMessagePosition_Top];
}

+ (void)showMessageWithTitle:(NSString * _Nullable)title
                        type:(LSMessageType)type {
    [[self class] showMessageInViewController:[[LSMessageOperation class] findCurrentViewControllerRecursively]
                                        title:title
                                     subtitle:nil
                                        image:nil
                                         type:type
                                 durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                   atPosition:LSMessagePosition_Top];
}



+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                       image:(UIImage *_Nullable)image
                        type:(LSMessageType)type {
    [[self class] showMessageInViewController:[[LSMessageOperation class] findCurrentViewControllerRecursively]
                                        title:title
                                     subtitle:subtitle
                                        image:image
                                         type:type
                                 durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                   atPosition:LSMessagePosition_Top];
}

+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                       image:(UIImage *_Nullable)image
                        type:(LSMessageType)type
                durationSecs:(NSTimeInterval)duration
                  atPosition:(LSMessagePosition)message_position {
    
    [[self class] showMessageInViewController:[[LSMessageOperation class] findCurrentViewControllerRecursively]//[[self class] defaultViewController]
                                        title:title
                                     subtitle:subtitle
                                        image:image
                                         type:type
                                 durationSecs:duration
                                   atPosition:message_position];
}


// 可以在指定的viewcontroller展示，当viewcontroller不可见或者dealloc，相应的消息队列会不展示此消息
+ (void)showMessageInViewController:(UIViewController *_Nonnull)view_controller
                              title:(NSString *_Nullable)title
                               type:(LSMessageType)type {
    
    [[self class] showMessageInViewController:view_controller
                                        title:title
                                     subtitle:nil
                                        image:nil
                                         type:type
                                 durationSecs:LSMessageDuration_Seconds_AutoDisappear_After4
                                   atPosition:LSMessagePosition_Top];
}

// 最全方法，不支持button和点击反馈
// 生成一个NSOperation，加入队列，给lastObject添加依赖，按顺序展示，让队列开始执行，执行就是生成view，然后展示在对应的viewcontroller中
// NSOpreation
+ (void)showMessageInViewController:(UIViewController *_Nonnull)view_controller
                              title:(NSString *_Nullable)title
                           subtitle:(NSString *_Nullable)subtitle
                              image:(UIImage *_Nullable)image
                               type:(LSMessageType)type
                       durationSecs:(NSTimeInterval)duration
                         atPosition:(LSMessagePosition)message_position {
    
    NSOperationQueue *queue = [LSMessage sharedInstance].messageQueueInMainThread;
    Debug_NSLog(@"operations count = %ld,all operations = %@",queue.operations.count,queue.operations);

    // 取消当前正在执行的任务，其实就是第0个任务
    [queue.operations makeObjectsPerformSelector:@selector(cancelInvalidExecutingOperation)];
    
    // 生成一个NSOpration
    if (view_controller == nil) {
        view_controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    LSMessageOperation * msgOperation = [[LSMessageOperation alloc] initWithViewController:view_controller
                                                                                             title:title
                                                                                          subtitle:subtitle
                                                                                             image:image
                                                                                              type:type
                                                                                          durationSecs:duration
                                                                                        atPosition:message_position];
    
    
    // 避免添加同样的message，正在执行的Opration,或者将要执行的提示
    if ([queue.operations containsObject:msgOperation]) {
        return;
    }
    
    // 加到队列中,保持队列FIFO
    LSMessageOperation * lastOperation = queue.operations.lastObject;
    if (lastOperation) {
        [msgOperation addDependency:lastOperation];
    }
    [queue addOperation:msgOperation];
    msgOperation.completionBlock = ^ {
        Debug_NSLog(@"%@",self);
    };
}

+ (void)dismissActiveMessage {
    // 选出正在执行的operation，也就是第0个
    NSOperationQueue *queue = [LSMessage sharedInstance].messageQueueInMainThread;
    LSMessageOperation * firstOperation = queue.operations.firstObject;
    
//    BOOL hasActiveMessage = NO;
    // 不管有没有展示出来正在显示的view，直接取消任务
    if (firstOperation.isExecuting) {
        
//        [firstOperation cancel];
        Debug_NSLog(@"operations count = %ld",queue.operations.count);
        BOOL hasActiveMessage = [firstOperation isMessageShowingNow];
        if (hasActiveMessage) {
            [firstOperation dismissActiveMessageView];
        }
    }
    
}
#pragma mark - getters & setters

@end
