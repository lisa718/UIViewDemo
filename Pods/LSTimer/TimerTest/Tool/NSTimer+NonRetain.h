//
//  NSTimer+NonRetain.h
//  LSMessages
//
//  Created by baidu on 2017/12/20.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------Timer-------------
@interface NSTimer (NonRetain)
+ (NSTimer *)scheduledNonRetainTimerWithTimeInterval:(NSTimeInterval)ti
                                              target:(id)aTarget
                                            selector:(SEL)aSelector
                                            userInfo:(nullable id)userInfo
                                             repeats:(BOOL)yesOrNo;
@end

