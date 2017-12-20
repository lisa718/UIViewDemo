//
//  LSBannerEntity.m
//  LSMessages
//
//  Created by lisa on 2017/12/18.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import "LSBannerEntity.h"

@interface LSBannerEntity ()


@end

@implementation LSBannerEntity

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _title = [dic[@"title"] copy];
        _imageName = [dic[@"img"] copy];
    }
    return self;
}

@end
