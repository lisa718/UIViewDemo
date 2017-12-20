//
//  LSBoundsRect.m
//  LSMessages
//
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBoundsRect.h"
#import "UIView+LayoutMethods.h"

@implementation LSBoundsRect

// TextView里面都会有attributeString，用这个来计算高度
- (void)amendBoundsForTextView:(UIView *)text_view {
    NSAttributedString * aStr;
    
    if ([text_view isKindOfClass:[UILabel class]]) {
        aStr = ((UILabel *)text_view).attributedText;
    }
    else if ([text_view isKindOfClass:[UITextView class]]) {
        aStr = ((UITextView *)text_view).attributedText;
    }
    else if ([text_view isKindOfClass:[UITextField class]]) {
        aStr = ((UITextField *)text_view).attributedText;
    }
    
    CGRect textRect = [aStr boundingRectWithSize:CGSizeMake(text_view.ct_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    text_view.ct_width = MAX(textRect.size.width,text_view.ct_width);
    text_view.ct_height = textRect.size.height;
}


@end
