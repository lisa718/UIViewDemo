//
//  LSMessageView.h
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//
// TODO 根据传入消息类型配色

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LSMessageType);

typedef NS_ENUM(NSInteger,LSMessageViewEvent) {
    LSMessageViewEvent_Tap = 0,
    LSMessageViewEvent_Swipe_Up = 1,
    LSMessageViewEvent_Swipe_Down = 2
};

@interface LSMessageView : UIView

@property (nonatomic,copy,readonly) NSString            * _Nonnull title;
@property (nonatomic,copy,readonly) NSString            * _Nullable subtitle;
@property (nonatomic,strong,readonly) UIImage           * _Nullable image;
@property (nonatomic,assign,readonly) LSMessageType type;

@property (nonatomic,assign)        CGFloat             paddingTop;

// ----------------------users can set appearance from code
@property (nonatomic,strong) UIFont *  _Nullable titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIFont *  _Nullable subtitleFont UI_APPEARANCE_SELECTOR;

// title
@property (nonatomic,strong) UIColor * _Nullable titleSuccessColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable titleFailedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable titleErrorColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable titleMessageColor UI_APPEARANCE_SELECTOR;

// subtitle
@property (nonatomic,strong) UIColor * _Nullable subtitleSuccessColor  UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable subtitleFailedColor  UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable subtitleErrorColor  UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable subtitleMessageColor  UI_APPEARANCE_SELECTOR;

// icon
@property (nonatomic,strong) UIImage * _Nullable successIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIImage * _Nullable failedIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIImage * _Nullable errorIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIImage * _Nullable messageIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIImage * _Nullable closeIcon UI_APPEARANCE_SELECTOR;

// background
@property (nonatomic,strong) UIColor * _Nullable successBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable failedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable errorBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic,strong) UIColor * _Nullable messageBackgroundColor UI_APPEARANCE_SELECTOR;


- (instancetype _Nonnull )initWithFrame:(CGRect)frame
                                  title:(NSString *_Nullable)title
                               subtitle:(NSString *_Nullable)subtitle
                                  image:(UIImage *_Nullable)image
                                   type:(LSMessageType)type;

#warning is there better method?
// 事件,点击和swipe事件
- (void)addTarget:(nonnull id)target
           action:(nonnull SEL)action
        forEvent:(LSMessageViewEvent)event;


@end

