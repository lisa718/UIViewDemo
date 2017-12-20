//
//  LSMessageOperation.h
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class LSMessageModel;
typedef NS_ENUM(NSInteger,LSMessageType);
typedef NS_ENUM(NSInteger,LSMessagePosition);

@interface LSMessageOperation : NSOperation

- (instancetype _Nonnull )initWithViewController:(UIViewController *_Nonnull)view_controller
                                   title:(NSString *_Nonnull)title
                                subtitle:(NSString *_Nullable)subtitle
                                   image:(UIImage *_Nullable)image
                                    type:(LSMessageType)type
                                durationSecs:(NSTimeInterval)duration_secs
                              atPosition:(LSMessagePosition)messagePosition;


- (void)dismissActiveMessageView;
- (BOOL)isEqual:(id _Nullable )object;
- (void)cancelInvalidExecutingOperation;
+ (UIViewController * _Nullable)findCurrentViewControllerRecursively;
//+ (BOOL)isMainQueue;


@property (nonatomic,assign,readonly) BOOL  isMessageShowingNow;


@end



