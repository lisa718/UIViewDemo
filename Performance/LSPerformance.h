//
//  LSPerformanceInfo.h
//  LSMessages
//
//  Created by baidu on 2017/12/22.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, LSPerformanceType) {
    LSPerformance_FS = 1 << 0,
    LSPerformance_CPU = 1 << 1,
    LSPerformance_Runloop = 1 << 2,
};

@interface LSPerformance : NSObject

+ (instancetype _Nonnull)sharedInstance;
+ (void)startMonitorWithPerformaceType:(LSPerformanceType)type;
+ (void)stopMonitor;

@end

