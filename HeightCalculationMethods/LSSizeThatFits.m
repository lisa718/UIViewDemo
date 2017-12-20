//
//  LSSizeThatFits.m
//  LSMessages
//
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSSizeThatFits.h"
#import "UIView+LayoutMethods.h"

@implementation LSSizeThatFits

- (void)amendBoundsForTextView:(UIView *)text_view {
    CGSize textSize = [text_view sizeThatFits:CGSizeMake(CGRectGetWidth(text_view.bounds), CGFLOAT_MAX)];
    text_view.ct_width = MAX(textSize.width,text_view.ct_width);
    text_view.ct_height = textSize.height;
}


@end
