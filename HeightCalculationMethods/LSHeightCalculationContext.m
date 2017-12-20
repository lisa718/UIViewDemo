//
//  LSHeightCalculationContext.m
//  LSMessages
//
//  Created by lisa on 2017/12/14.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSHeightCalculationContext.h"

@interface LSHeightCalculationContext ()

@property (nonatomic,strong) id<LSHeightCalculationStrategy> stategy;

@end

@implementation LSHeightCalculationContext

- (void)sizeFitForTextView:(UIView *)text_view {
    [self.stategy amendBoundsForTextView:text_view];
}

- (instancetype)initWithHeightCalculationStrategy:(id<LSHeightCalculationStrategy>)strategy {
    self = [super init];
    if (self) {
        _stategy = strategy;
    }
    return self;

}


@end
