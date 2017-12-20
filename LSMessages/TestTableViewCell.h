//
//  TestTableViewCell.h
//  LSMessages
//
//  Created by lisa on 2017/12/10.
//  Copyright © 2017年 lisa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLabel;

+ (CGFloat)cellHeightWithModel:(NSString*)model;

@end
