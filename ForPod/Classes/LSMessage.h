//
//  LSMessage.h
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#ifdef DEBUG
    #define Debug_NSLog(...) NSLog(__VA_ARGS__)
#else
    #define Debug_NSLog(...) void
#endif


// 消息类型
typedef NS_ENUM(NSInteger,LSMessageType) {
    LSMessageType_Message = 0,// default
    LSMessageType_Success = 1,
    LSMessageType_Failed = 2,
    LSMessageType_Error = 3
    
};

// 消息位置
typedef NS_ENUM(NSInteger,LSMessagePosition) {
    LSMessagePosition_Top = 0,// default
    LSMessagePosition_Bottom = 1,
    LSMessagePosition_OverNavBar = 2 // 不管传入的vc是什么，都会加到keywindow上
};

// 时长，判断是否要自动消失
typedef NS_ENUM(NSInteger,LSMessageDuration_Seconds) {
    LSMessageDuration_Seconds_AutoDisappear_After4 = 0,
    LSMessageDuration_Seconds_Stay = -1
};

@interface LSMessage : NSObject


+ (instancetype _Nonnull)sharedInstance;

// 全局方法，展示消息到TopViewcontroller，当切换viewcontroller，不会展示；当overbar类型，切换viewcontroller会显示
// 调用此方法会产生，一个全局提示框：默认top、自动消失
+ (void)showMessageWithTitle:(NSString * _Nullable)title
                        type:(LSMessageType)type;

+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                        type:(LSMessageType)type;

+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                       image:(UIImage *_Nullable)image
                        type:(LSMessageType)type;

+ (void)showMessageWithTitle:(NSString *_Nullable)title
                    subtitle:(NSString *_Nullable)subtitle
                       image:(UIImage *_Nullable)image
                        type:(LSMessageType)type
                durationSecs:(NSTimeInterval)duration
                  atPosition:(LSMessagePosition)message_position;

//+ (void)showMessageWithTitle:(NSString *_Nullable)title
//                    subtitle:(NSString *_Nullable)subtitle
//                       image:(UIImage *_Nullable)image
//                        type:(LSMessageType)type
//                durationSecs:(NSTimeInterval)duration
//                  atPosition:(LSMessagePosition)message_position;


// 可以在指定的viewcontroller展示，当viewcontroller不可见或者dealloc，触发消息展示，相应的消息队列会不展示此消息
+ (void)showMessageInViewController:(UIViewController *_Nonnull)view_controller
                              title:(NSString *_Nullable)title
                               type:(LSMessageType)type;

+ (void)showMessageInViewController:(UIViewController *_Nonnull)view_controller
                              title:(NSString *_Nullable)title
                           subtitle:(NSString *_Nullable)subtitle
                              image:(UIImage *_Nullable)image
                               type:(LSMessageType)type
                       durationSecs:(NSTimeInterval)duration
                         atPosition:(LSMessagePosition)message_position;



// 让当前展示的消息消失
+ (void)dismissActiveMessage;


#warning with no button?function missing

@end
