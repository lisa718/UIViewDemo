//
//  LSFloatingLabel.h
//  LSMessages
//
//  Created by baidu on 2017/12/21.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSFloatingLabelManager : NSObject

+ (void)show;
+ (void)hide;
+ (void)updateTextWith:(NSString *)text;

@end
