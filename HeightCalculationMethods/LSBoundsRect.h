//
//  LSBoundsRect.h
//  LSMessages
//
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSHeightCalculationStrategy.h"

@interface LSBoundsRect : NSObject<LSHeightCalculationStrategy>

- (void)amendBoundsForTextView:(UIView *)text_view;


@end
