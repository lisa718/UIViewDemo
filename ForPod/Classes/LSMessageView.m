//
//  LSMessageView.m
//  LSMessages
//
//  Created by lisa on 2017/11/26.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSMessageView.h"
#import "LSMessage.h"
#import "HexColors.h"

//#warning iPhone X and status bar not right

NSString * const kTypeKeySuccess = @"success";
NSString * const kTypeKeyError = @"error";
NSString * const kTypeKeyFailed = @"failed";
NSString * const kTypeKeyMessage = @"message";

static NSDictionary *defaultAppearceDictionary = nil;

#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height - 812) ? NO : YES)


@interface LSMessageView ()

// model
@property (nonatomic,copy) NSString            * _Nonnull title;
@property (nonatomic,copy) NSString            * _Nullable subtitle;
@property (nonatomic,strong) UIImage           * _Nullable image;
@property (nonatomic,assign) LSMessageType type;

// view
@property (nonatomic,strong) UILabel            *titleLabel;
@property (nonatomic,strong) UILabel            *subtitleLabel;
@property (nonatomic,strong) UIImageView        *iconImageView;
//@property (nonatomic,strong) UIView             *backgroundView;
@property (nonatomic,strong) UIVisualEffectView *blurBackgroundView;
@property (nonatomic,strong) UIImageView        *closeImageView;

// ges
@property (nonatomic,strong) UITapGestureRecognizer     *tapGes;
@property (nonatomic,strong) UISwipeGestureRecognizer   *swipeGes;

@end

@implementation LSMessageView

+ (void)initialize {
    if (self == [LSMessageView class]) {
        defaultAppearceDictionary = @{
                                      kTypeKeySuccess:@{
                                              @"titleFontSize":@15,
                                              @"subtitleFontSize":@14,
                                              @"textColor":@"#FFFFFF",
                                              @"imageName":@"lsmessage_prompting_succeed",
                                              @"backgroundColor":@"#8FE092",
                                              @"titleDefault":@"请求成功"
                                              },
                                      kTypeKeyFailed:@{
                                              @"titleFontSize":@15,
                                              @"subtitleFontSize":@14,
                                              @"textColor":@"#FFFFFF",
                                              @"imageName":@"lsmessage_prompting_fail",
                                              @"backgroundColor":@"#FF6F6F",
                                              @"titleDefault":@"请求失败"
                                              },
                                      kTypeKeyError:@{
                                              @"titleFontSize":@15,
                                              @"subtitleFontSize":@14,
                                              @"textColor":@"#FFFFFF",
                                              @"imageName":@"lsmessage_prompting_error",
                                              @"backgroundColor":@"#FFC666",
                                              @"titleDefault":@"操作错误"
                                              },
                                      kTypeKeyMessage:@{
                                              @"titleFontSize":@15,
                                              @"subtitleFontSize":@14,
                                              @"textColor":@"#333333",
                                              @"imageName":@"lsmessage_prompting_message",
                                              @"backgroundColor":@"#E5E5E5",
                                              @"titleDefault":@"提示信息"
                                              }
                                      };
    }
}

- (instancetype _Nonnull )initWithFrame:(CGRect)frame
                                  title:(NSString *_Nullable)title
                               subtitle:(NSString *_Nullable)subtitle
                                  image:(UIImage *_Nullable)image
                                   type:(LSMessageType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
        // set model
        _subtitle = [subtitle copy];
        _type = type;
        _paddingTop = 15;
        
        self.backgroundColor = [self defaultBackgroudColor];


        // background
//        [self addSubview:self.backgroundView];
//        self.blurBackgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.blurBackgroundView];
        
        
        // set view
        // titleLabel
        _title = title ? [title copy] : [self defaultTitle];
        self.titleLabel.text = _title;
        [self addSubview:self.titleLabel];
        
        // subtitleLabel
        if (subtitle && ![subtitle isEqualToString:@""]) {
            self.subtitleLabel.text = subtitle;
            [self addSubview:self.subtitleLabel];
        }
        
        // image
        _image = image ? image : [self defaultImage];
        if (_image) {
            [self.iconImageView setImage:_image];
            [self addSubview:self.iconImageView];
        }
        [self addSubview:self.closeImageView];
    
        // 布局
        [self configLayout];
        
    }
    return self;
}


#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    [self configLayout];
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    _paddingTop = _paddingTop?paddingTop:15;
    [self setNeedsLayout];
}
- (void)configLayout {
//    CGFloat paddingTop = self.paddingTop;//35;
    CGFloat paddingBottom = 15;//30;
    CGFloat paddingLeft = 20;//40;
    CGFloat titleSpace = 5;//10;
    
    CGFloat totalHeight = self.paddingTop;
    
    // title can not be nil
    CGFloat titleLeftX = paddingLeft*2;
    CGFloat titleLeftY = self.paddingTop;
    if (self.image) {
        titleLeftX += self.image.size.width;
    }
    
    CGFloat titleWidth = self.bounds.size.width - titleLeftX - paddingLeft*2;
    self.titleLabel.frame = CGRectMake(titleLeftX, titleLeftY, titleWidth, 0);
    [self.titleLabel sizeToFit];
    
    totalHeight += CGRectGetHeight(self.titleLabel.frame) +  paddingBottom;
    
    
    //subtitle
    if (self.subtitle) {
        CGFloat subtitleLeftY = CGRectGetMaxY(self.titleLabel.frame) + titleSpace;
        self.subtitleLabel.frame = CGRectMake(titleLeftX, subtitleLeftY, titleWidth, 0);
        [self.subtitleLabel sizeToFit];
         totalHeight += CGRectGetHeight(self.subtitleLabel.frame) + titleSpace;
    }
    
    
    // image 居中
    if (self.image) {
        
        CGFloat topY = self.bounds.size.height/2.0 - self.image.size.height/2.0;
        if (topY < CGRectGetMinY(self.titleLabel.frame)) {
            topY = CGRectGetMinY(self.titleLabel.frame);
        }
        
        
        self.iconImageView.frame = CGRectMake(paddingLeft,
                                              topY,
                                              self.image.size.width,
                                              self.image.size.height);
    }
    
    // close button
    UIImage * closeImage = self.closeImageView.image;
    self.closeImageView.frame = CGRectMake(self.bounds.size.width - closeImage.size.width - 7,
                                           self.paddingTop,
                                           closeImage.size.width,
                                           closeImage.size.height);
    
    //
    self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, totalHeight);
//    self.backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
//    self.backgroundView.frame = self.bounds;
    self.blurBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.blurBackgroundView.frame = self.bounds;
    
}

- (NSString *)currentTypeKey {
    if (self.type == LSMessageType_Success) {
        return kTypeKeySuccess;
    }
    else if (self.type == LSMessageType_Failed) {
        return kTypeKeyFailed;
    }
    else if (self.type == LSMessageType_Error) {
        return kTypeKeyError;
    }
    else if (self.type == LSMessageType_Message) {
        return kTypeKeyMessage;
    }
    return kTypeKeyMessage;
}
- (NSString *)defaultTitle {
    NSString *key = [self currentTypeKey];
    return defaultAppearceDictionary[key][@"titleDefault"];
}

- (UIImage *)defaultImage {
    
    NSString *key = [self currentTypeKey];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [UIImage imageNamed:defaultAppearceDictionary[key][@"imageName"] inBundle:bundle compatibleWithTraitCollection:nil];
}

- (UIColor *)defaultBackgroudColor {
    NSString *key = [self currentTypeKey];
    return [UIColor colorWithHexString:defaultAppearceDictionary[key][@"backgroundColor"] alpha:0.5];
//    return nil;
}


#pragma mark - events
- (void)addTarget:(nonnull id)target
           action:(nonnull SEL)action
         forEvent:(LSMessageViewEvent)event {
    NSParameterAssert(target);
    NSParameterAssert(action);
    if (event == LSMessageViewEvent_Tap) {
        if (self.tapGes == nil) {
            self.tapGes = [[UITapGestureRecognizer alloc] init];
            [self addGestureRecognizer:self.tapGes];
        }
        [self.tapGes addTarget:target action:action];
    }
    else if (event == LSMessageViewEvent_Swipe_Up || event == LSMessageViewEvent_Swipe_Down) {
        if (self.swipeGes == nil) {
            self.swipeGes = [[UISwipeGestureRecognizer alloc] init];
            [self.swipeGes setDirection:(event == LSMessageViewEvent_Swipe_Up)?UISwipeGestureRecognizerDirectionUp:UISwipeGestureRecognizerDirectionDown];
            [self addGestureRecognizer:self.swipeGes];
        }
        [self.swipeGes addTarget:target action:action];
    }
}
#pragma mark - getters & setters

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithHexString:defaultAppearceDictionary[[self currentTypeKey]][@"textColor"] alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        NSNumber * fontSize = defaultAppearceDictionary[[self currentTypeKey]][@"titleFontSize"];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:[fontSize floatValue]]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor colorWithHexString:defaultAppearceDictionary[[self currentTypeKey]][@"textColor"] alpha:1.0];
        _subtitleLabel.textAlignment = NSTextAlignmentLeft;
        NSNumber * fontSize = defaultAppearceDictionary[[self currentTypeKey]][@"subtitleFontSize"];
        [_subtitleLabel setFont:[UIFont systemFontOfSize:[fontSize floatValue]]];
        [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subtitleLabel;
}

- (UIImageView *)iconImageView {
    if(_iconImageView == nil) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UIImageView *)closeImageView {
    if(_closeImageView == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lsmessage_prompting_close" inBundle:bundle compatibleWithTraitCollection:nil]];
    }
    return _closeImageView;
}

//- (UIView *)backgroundView {
//    if (_backgroundView == nil) {
//        _backgroundView = [UIView new];
//        _backgroundView.backgroundColor = [self defaultBackgroudColor];
//
//    }
//    return _backgroundView;
//}

- (UIVisualEffectView *)blurBackgroundView {
    if(_blurBackgroundView == nil) {
        // blur effect
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    }
    return _blurBackgroundView;
}

#pragma mark -  UI_APPEARANCE_SELECTOR
- (void)setTitleFont:(UIFont *)title_font {
    _titleFont = title_font;
    [self.titleLabel setFont:title_font];
}

- (void)setSubtitleFont:(UIFont *)subtitle_font {
    _subtitleFont = subtitle_font;
    [self.subtitleLabel setFont:subtitle_font];
}


- (void)setTitleSuccessColor:(UIColor *)titleColor {
    _titleSuccessColor = titleColor;
     if (self.type == LSMessageType_Success) {
         [self.titleLabel setTextColor:titleColor];
     }
}
- (void)setTitleFaileColor:(UIColor *)titleColor {
    _titleFailedColor = titleColor;
    if (self.type == LSMessageType_Failed) {
        [self.titleLabel setTextColor:titleColor];
    }
}

- (void)setTitleErrorColor:(UIColor *)titleColor {
    _titleErrorColor = titleColor;
    if (self.type == LSMessageType_Error) {
        [self.titleLabel setTextColor:titleColor];
    }
}

- (void)setTitleMessageColor:(UIColor *)titleColor {
    _titleMessageColor = titleColor;
    if (self.type == LSMessageType_Message) {
        [self.titleLabel setTextColor:titleColor];
    }
}

- (void)setSubtitleSuccessColor:(UIColor *)subtitleColor {
    _subtitleSuccessColor = subtitleColor;
     if (self.type == LSMessageType_Success) {
         [self.subtitleLabel setTextColor:subtitleColor];
     }
}
- (void)setSubtitleFailedColor:(UIColor *)subtitleColor {
    _subtitleFailedColor = subtitleColor;
    if (self.type == LSMessageType_Failed) {
        [self.subtitleLabel setTextColor:subtitleColor];
    }
}
- (void)setSubtitleErrorColor:(UIColor *)subtitleColor {
    _subtitleErrorColor = subtitleColor;
    if (self.type == LSMessageType_Error) {
        [self.subtitleLabel setTextColor:subtitleColor];
    }
}
- (void)setSubtitleMessageColor:(UIColor *)subtitleColor {
    _subtitleMessageColor = subtitleColor;
    if (self.type == LSMessageType_Message) {
        [self.subtitleLabel setTextColor:subtitleColor];
    }
}

- (void)setSuccessIcon:(UIImage *)successIcon {
    _successIcon = successIcon;
    if (self.type == LSMessageType_Success) {
        self.image = successIcon?successIcon:[self defaultImage];
        [self.iconImageView setImage:self.image];
    }
}

- (void)setFailedIcon:(UIImage *)failedIcon {
    _failedIcon = failedIcon;
    if (self.type == LSMessageType_Failed) {
        self.image = failedIcon?failedIcon:[self defaultImage];
        [self.iconImageView setImage:self.image];

    }
}

-(void)setErrorIcon:(UIImage *)errorIcon {
    _errorIcon = errorIcon;
    if (self.type == LSMessageType_Error) {
        self.image = errorIcon?errorIcon:[self defaultImage];
        [self.iconImageView setImage:self.image];

    }
}

- (void)setMessageIcon:(UIImage *)messageIcon {
    _messageIcon = messageIcon;
    if (self.type == LSMessageType_Message) {
        self.image = messageIcon?messageIcon:[self defaultImage];
        [self.iconImageView setImage:self.image];
    }
}

- (void)setCloseIcon:(UIImage *)closeIcon {
    _closeIcon = closeIcon;
    [self.closeImageView setImage:closeIcon];
}

- (void)setSuccessBackgroundColor:(UIColor *)successBackgroundColor {
    _successBackgroundColor = successBackgroundColor;
    if (self.type == LSMessageType_Success) {
        self.backgroundColor = successBackgroundColor?successBackgroundColor:[self defaultBackgroudColor];
    }
}

- (void)setErrorBackgroundColor:(UIColor *)errorBackgroundColor {
    _errorBackgroundColor = errorBackgroundColor;
    if (self.type == LSMessageType_Error) {
        self.backgroundColor = errorBackgroundColor?errorBackgroundColor:[self defaultBackgroudColor];
    }
}

- (void)setFailedBackgroundColor:(UIColor *)failedBackgroundColor {
    _failedBackgroundColor = failedBackgroundColor;
    if (self.type == LSMessageType_Failed) {
        self.backgroundColor = failedBackgroundColor?failedBackgroundColor:[self defaultBackgroudColor];
    }
}

- (void)setMessageBackgroundColor:(UIColor *)messageBackgroundColor {
    _messageBackgroundColor = messageBackgroundColor;
    if (self.type == LSMessageType_Message) {
        self.backgroundColor = messageBackgroundColor?messageBackgroundColor:[self defaultBackgroudColor];
    }
}

@end



