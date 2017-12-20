//
//  LSHeightCalculationContext.h
//  LSMessages
//
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "LSHeightCalculationStrategy.h"

@interface LSHeightCalculationContext : NSObject

- (void)sizeFitForTextView:(UIView *)text_view;
- (instancetype)initWithHeightCalculationStrategy:(id<LSHeightCalculationStrategy>)strategy;


@end
